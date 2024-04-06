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

local SPRITE_MATERIAL = Material("sprites/light_glow02_add")
local BEAM_MATERIAL = Material("sprites/rollermine_shock")
local SPRITE_COLOUR = Color(110, 8, 8)
local BEAM_COLOUR = Color(255, 0, 0)

hook.Add("PostDrawOpaqueRenderables", "laser_scalpel_draw_effects", function()
    local ply = LocalPlayer()

    -- Check if the player is in a first-person view
    local wep = ply:GetActiveWeapon()
    if not ply:ShouldDrawLocalPlayer() and IsValid(wep) and wep:GetClass() == "laser_scalpel" and wep:GetNW2Bool("active") then
        if not IsValid(wep) or not (wep:GetClass() == "laser_scalpel" and wep:GetNW2Bool("active")) then
            return
        end

        local vm = ply:GetViewModel()

        if IsValid(vm) then
            local offset = vm:GetBonePosition(vm:LookupBone("ValveBiped.Bip01_R_Finger01"))
            local offset1 = Vector(-0.70, 1.7, 1.7)
            offset1:Rotate(ply:GetAngles())
            local startPos = offset1 + offset
            local endPos = startPos + ply:GetAimVector() * 40

            local tr = util.TraceLine({
                start = startPos,
                endpos = endPos,
                filter = ply,
            })

            cam.Start3D()
                render.SetMaterial(SPRITE_MATERIAL)
                render.DrawSprite(startPos, 10, 10, SPRITE_COLOUR)
                if tr.Hit then
                    local pos = tr.HitPos - ply:GetAimVector() * 2
                    render.SetMaterial(BEAM_MATERIAL)
                    render.DrawBeam(startPos, pos, TimedSin(0.5, 0.8, 1.3, 0), 0, 0.5, BEAM_COLOUR)
                    render.SetMaterial(SPRITE_MATERIAL)
                    render.DrawSprite(pos, 10, 10, SPRITE_COLOUR)
                else
                    render.SetMaterial(BEAM_MATERIAL)
                    render.DrawBeam(startPos, endPos, TimedSin(0.5, 0.8, 1.3, 0), 0, 0.5, BEAM_COLOUR)
                end
            cam.End3D()
        end
    end

    for _, otherPly in player.Iterator() do

        local index1 = otherPly:EntIndex()
        local index2 = ply:EntIndex()

        if not ply:ShouldDrawLocalPlayer() and index1 == index2 then
            continue
        end

        wep = otherPly:GetActiveWeapon()

        if IsValid(wep) and wep:GetClass() == "laser_scalpel" and wep:GetNW2Bool("active") then
            local bone_matrix = otherPly:GetBoneMatrix(otherPly:LookupBone("ValveBiped.Bip01_R_Finger01"))
            if bone_matrix == nil then
                continue
            end

            local offset = bone_matrix:GetTranslation()

            local offset1 = Vector(5.6, 0.6, -4)
            offset1:Rotate(bone_matrix:GetAngles())

            local startPos = offset1 + offset
            local temp = Vector(1, 0, 0)
            temp:Rotate(bone_matrix:GetAngles() + Angle(-21, -25, 26))
            local endPos = startPos + temp * 20

            local tr = util.TraceLine({
                start = startPos,
                endpos = endPos,
            })

            cam.Start3D()
                render.SetMaterial(SPRITE_MATERIAL)
                render.DrawSprite(startPos, 10, 10, SPRITE_COLOUR)
                if tr.Hit then
                    local pos = tr.HitPos - temp * 2
                    render.SetMaterial(BEAM_MATERIAL)
                    render.DrawBeam(startPos, pos, TimedSin(0.5, 0.8, 1.3, 0), 0, 1, BEAM_COLOUR)
                    render.SetMaterial(SPRITE_MATERIAL)
                    render.DrawSprite(pos, 10, 10, SPRITE_COLOUR)
                else
                    render.SetMaterial(BEAM_MATERIAL)
                    render.DrawBeam(startPos, endPos, TimedSin(0.5, 0.8, 1.3, 0), 0, 1, BEAM_COLOUR)
                end
            cam.End3D()
        end
    end
end)
