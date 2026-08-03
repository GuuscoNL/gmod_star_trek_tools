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
--        hypospray  | Client        --
---------------------------------------

include("shared.lua")


SWEP.Author       = "GuuscoNL"
SWEP.Contact      = "Discord: guusconl"
SWEP.Purpose      =
"Hyporspray is a medical device used to deliver medication or other substances into the body without the use of needles."
SWEP.Instructions =
"Press LMB to use.\nPress R to inject yourself.\nPress RMB to revive player (If implemented by gamemode)\n\nWill slowly heal players over time. If they are below 20% health, it will heal faster. Use the tricorder to see how much ml people have in their system.\n\nWill not heal NPCs."
SWEP.Category     = "Star Trek (Utilities)"

SWEP.DrawAmmo     = false

net.Receive("star_trek.tools.hypospray.animation", function()
    local wep = net.ReadEntity()
    if not IsValid(wep) then return end

    local owner = wep:GetOwner()
    if not IsValid(owner) then return end

    local revive = net.ReadBool()

    owner:SetAnimation(PLAYER_ATTACK1)
    if revive then
        wep:EmitSound("star_trek.hypospray_revive")
    else
        wep:EmitSound("star_trek.hypospray_dose")
    end
end)

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

    local pos, ang = LocalToWorld(self.CustomWorldModelOffset, self.CustomWorldModelAngle, m:GetTranslation(),
        m:GetAngles())

    self.CustomWorldModelEntity:SetPos(pos)
    self.CustomWorldModelEntity:SetAngles(ang)

    self.CustomWorldModelEntity:SetSkin(self:GetSkin())
    self.CustomWorldModelEntity:SetBodyGroups(self:GetNWString("bodyGroups"))

    self.CustomWorldModelEntity:DrawModel(flags)

    if isfunction(self.DrawWorldModelCustom) then
        self:DrawWorldModelCustom(flags)
    end
end

function SWEP:CleanupViewModel()
    local owner = LocalPlayer()
    if not IsValid(owner) then
        return
    end

    local vm = owner:GetViewModel()
    if not IsValid(vm) then
        return
    end

    if istable(self.BoneManip) then
        self:ResetBoneMod(vm)
    end

    if IsValid(self.CustomViewModelEntity) then
        self.CustomViewModelEntity:Remove()
    end
    vm:SetMaterial("")
end

function SWEP:PostDrawViewModel(vm, weapon, ply)
    self.IsViewModelRendering = true

    vm:SetMaterial("debug/debugvertexcolor")

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
        local pos, ang = LocalToWorld(self.CustomViewModelOffset, self.CustomViewModelAngle, m:GetTranslation(),
            m:GetAngles())

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
