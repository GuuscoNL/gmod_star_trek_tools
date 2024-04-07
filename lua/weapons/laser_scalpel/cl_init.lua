---------------------------------------
---------------------------------------
--   This file is protected by the   --
--           MIT License.            --
--                                   --
--   See LICENSE for full            --
--   license details.                --
---------------------------------------
---------------------------------------

---------------------------------------
--      laser_scalpel | Client       --
---------------------------------------

include("shared.lua")


SWEP.Author         = "GuuscoNL"
SWEP.Contact        = "Discord: guusconl"
SWEP.Purpose        = "#TODO:"
SWEP.Instructions   = "#TODO:"
SWEP.Category       = "Star Trek (Utilities)"

SWEP.DrawAmmo       = false

-- code from oni_swep_base :)
function SWEP:DrawWorldModel(flags)

    local owner = self:GetOwner()
    if not IsValid(owner) then
        self:DrawModel(flags)

        return
    end

    if not IsValid(self.CustomWorldModelEntity) then
        self.CustomWorldModelEntity = ClientsideModel(self.WorldModel)
        if not IsValid(self.CustomWorldModelEntity) then
            return
        end

        self.CustomWorldModelEntity:SetNoDraw(true)
        self.CustomWorldModelEntity:SetModelScale(self.CustomWorldModelScale)
    end

    local boneId = owner:LookupBone(self.CustomWorldModelBone)
    if boneId == nil then
        return
    end

    local m = owner:GetBoneMatrix(boneId)
    if not m then
        return
    end

    local pos, ang = LocalToWorld(self.CustomWorldModelOffset, self.CustomWorldModelAngle, m:GetTranslation(), m:GetAngles())

    self.CustomWorldModelEntity:SetPos(pos)
    self.CustomWorldModelEntity:SetAngles(ang)

    self.CustomWorldModelEntity:SetSkin(self:GetSkin())
    self.CustomWorldModelEntity:SetBodyGroups(self:GetNWString("bodyGroups"))

    self.CustomWorldModelEntity:DrawModel(flags)

    if isfunction(self.DrawWorldModelCustom) then
        self:DrawWorldModelCustom(flags)
    end
end

function SWEP:PostDrawViewModel(vm, weapon, ply)
    self.IsViewModelRendering = true

    if isstring(self.CustomViewModel) then
        if not IsValid(self.CustomViewModelEntity) then
            self.CustomViewModelEntity = ClientsideModel(self.CustomViewModel)
            if not IsValid(self.CustomViewModelEntity) then
                return
            end

            if istable(self.BoneManip) then
                self:ApplyBoneMod(vm)
            end

            self.CustomViewModelEntity:SetNoDraw(true)
            self.CustomViewModelEntity:SetModelScale(self.CustomViewModelScale)
        end

        local m = vm:GetBoneMatrix(vm:LookupBone(self.CustomViewModelBone))
        if not m then
            return
        end
        local pos, ang = LocalToWorld(self.CustomViewModelOffset, self.CustomViewModelAngle, m:GetTranslation(), m:GetAngles())

        self.CustomViewModelEntity:SetPos(pos)
        self.CustomViewModelEntity:SetAngles(ang)

        self.CustomViewModelEntity:SetSkin(self:GetSkin())
        self.CustomViewModelEntity:SetBodyGroups(self:GetNWString("bodyGroups"))

        self.CustomViewModelEntity:DrawModel()
    end

    if isfunction(self.DrawViewModelCustom) then
        self:DrawViewModelCustom(flags)
    end
end

hook.Add("PostDrawOpaqueRenderables", "laser_scalpel_draw_effects", function()

    handleBeamFPS()

    local ply = LocalPlayer()
    for _, otherPly in player.Iterator() do

        -- if ply is local player and ply is in first person view, skip
        if not ply:ShouldDrawLocalPlayer() and otherPly:EntIndex() == ply:EntIndex() then
            continue
        end

        handleBeam3rd(otherPly)
    end
end)

function handleBeamFPS()
    local ply = LocalPlayer()
    local wep = ply:GetActiveWeapon()

    -- Check if the player is in a first-person view
    if ply:ShouldDrawLocalPlayer() then
        return
    end

    if not IsValid(wep) or not (wep:GetClass() == "laser_scalpel" and wep:GetNW2Bool("active")) then
        return
    end

    local vm = ply:GetViewModel()

    if IsValid(vm) then
        local offset = vm:GetBonePosition(vm:LookupBone("ValveBiped.Bip01_R_Finger01"))
        local offset1 = Vector(-0.70, 1.7, 1.7)
        offset1:Rotate(ply:GetAngles())
        local startPos = offset1 + offset
        local endPos = startPos + ply:GetAimVector() * 30

        renderBeam(startPos, endPos, ply:GetAimVector(), ply)
    end
end

function handleBeam3rd(otherPly)
    local wep = otherPly:GetActiveWeapon()

    if not IsValid(wep) or not wep:GetClass() == "laser_scalpel" or not wep:GetNW2Bool("active") then
        return
    end

    local bone_matrix = otherPly:GetBoneMatrix(otherPly:LookupBone("ValveBiped.Bip01_R_Finger01"))
    if bone_matrix == nil then
        return
    end

    local offset = bone_matrix:GetTranslation()

    local offset1 = Vector(5.6, 0.6, -4)
    offset1:Rotate(bone_matrix:GetAngles())

    local startPos = offset1 + offset

    -- #BUG: The direction is not correct
    local direction = Vector(1, 0, 0)
    local temp = bone_matrix:GetForward()
    -- temp:Rotate(Angle(-21, -25, 26))

    local endPos = startPos + temp * 20

    renderBeam(startPos, endPos, direction, ply)
end

local SPRITE_MATERIAL = Material("sprites/light_glow02_add")
local BEAM_MATERIAL = Material("sprites/rollermine_shock")
local SPRITE_COLOUR = Color(110, 8, 8)
local BEAM_COLOUR = Color(255, 0, 0)

local FLESH_DECAL = Material(util.DecalMaterial("Impact.Flesh"))
local SCORCH_DECAL = Material(util.DecalMaterial("FadingScorch"))
local DECAL_COLOUR = Color(0, 0, 0)
local DECAL_SIZE = 0.1
local DECAL_DELAY = 0.08

local lastDecal = 0

function renderBeam(startPos, endPos, direction, filter)

    local tr = util.TraceLine({
        start = startPos,
        endpos = endPos,
        filter = filter,
    })

    local spriteWidth = math.random(8, 12)
    local beamWidth = math.Rand(0.7, 1.4)

    cam.Start3D()
        render.SetMaterial(SPRITE_MATERIAL)
        render.DrawSprite(startPos, spriteWidth, spriteWidth, SPRITE_COLOUR)
        if tr.Hit then
            local pos = tr.HitPos - direction * 2
            render.SetMaterial(BEAM_MATERIAL)
            render.DrawBeam(startPos, pos, beamWidth, 0, 1, BEAM_COLOUR)
            render.SetMaterial(SPRITE_MATERIAL)
            render.DrawSprite(pos, spriteWidth, spriteWidth, SPRITE_COLOUR)
            if lastDecal < CurTime() then
                lastDecal = CurTime() + DECAL_DELAY
                local ent = tr.Entity
                if IsValid(ent) and (ent:IsNPC() or ent:IsPlayer()) then
                    util.DecalEx(FLESH_DECAL, ent, tr.HitPos, tr.HitNormal, DECAL_COLOUR, DECAL_SIZE, DECAL_SIZE)
                else
                    util.DecalEx(SCORCH_DECAL, ent, tr.HitPos, tr.HitNormal, DECAL_COLOUR, DECAL_SIZE, DECAL_SIZE)
                end
            end
        else
            render.SetMaterial(BEAM_MATERIAL)
            render.DrawBeam(startPos, endPos, beamWidth, 0, 1, BEAM_COLOUR)
        end
    cam.End3D()
end
