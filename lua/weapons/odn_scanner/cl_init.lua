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
--       odn_scanner | Client        --
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
local SPRITE_COLOUR = Color(110, 8, 8)

hook.Add("PostDrawOpaqueRenderables", "odn_scanner_draw_effects", function()
    local ply = LocalPlayer()
    local wep = ply:GetActiveWeapon()

    -- Check if the player is in a first-person view
    if not ply:ShouldDrawLocalPlayer() and IsValid(wep) and wep:GetClass() == "odn_scanner" and wep:GetNW2Bool("active") then

        local vm = ply:GetViewModel()

        if IsValid(vm) then
            local offset = vm:GetBonePosition(vm:LookupBone("ValveBiped.Bip01_R_Finger01"))
            local offset1 = Vector(0, 1, 1)
            offset1:Rotate(ply:GetAngles())

            cam.Start3D()
                render.SetMaterial(SPRITE_MATERIAL)
                render.DrawSprite(offset1 + offset, 10, 10, SPRITE_COLOUR)
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

        if IsValid(wep) and wep:GetClass() == "odn_scanner" and wep:GetNW2Bool("active") then
            local bone_matrix = otherPly:GetBoneMatrix(otherPly:LookupBone("ValveBiped.Bip01_R_Finger01"))
            local offset = bone_matrix:GetTranslation()

            local offset1 = Vector(7.5, 2, -1)
            offset1:Rotate(bone_matrix:GetAngles())

            cam.Start3D()
                render.SetMaterial(SPRITE_MATERIAL)
                render.DrawSprite(offset1 + offset, 10, 10, SPRITE_COLOUR)
            cam.End3D()
        end
    end

end)
