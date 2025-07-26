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
--       sonic driver | Shared       --
---------------------------------------

SWEP.Base = "oni_base"

SWEP.PrintName = "Sonic Driver"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Slot = 3
SWEP.SlotPos = 0

SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/crazycanadian/startrek/tools/sonicdriver.mdl"

SWEP.HoldType = "pistol"

SWEP.BoneManip = {
    ["ValveBiped.clip"] = {
        Pos = Vector(-100, 0, 0),
    },
    ["ValveBiped.base"] = {
        Pos = Vector(-100, 0, 0),
    },
    ["ValveBiped.square"] = {
        Pos = Vector(-100, 0, 0),
    },
    ["ValveBiped.hammer"] = {
        Pos = Vector(-100, 0, 0),
    },
    ["ValveBiped.Bip01_R_Finger01"] = {
        Ang = Angle(-50, 0, 0)
    },
    ["ValveBiped.Bip01_R_Finger1"] = {
        Ang = Angle(-20, -20, 0)
    },
    ["ValveBiped.Bip01_R_Forearm"] = {
        Pos = Vector(-10, 0, 0),
    },
    ["ValveBiped.Bip01_R_Clavicle"] = {
        Pos = Vector(-1, 0, 0),
        Ang = Angle(0, 0, 15)
    },
}

SWEP.CustomViewModel = "models/crazycanadian/startrek/tools/sonicdriver.mdl"
SWEP.CustomViewModelBone = "ValveBiped.Bip01_R_Hand"
SWEP.CustomViewModelOffset = Vector(4, -2, -0.7)
SWEP.CustomViewModelAngle = Angle(-20, 180, -140)
SWEP.CustomViewModelScale = 1

SWEP.CustomDrawWorldModel = true
SWEP.CustomWorldModelBone = "ValveBiped.Bip01_R_Hand"
SWEP.CustomWorldModelOffset = Vector(4.5, -1.5, -1.1)
SWEP.CustomWorldModelAngle = Angle(-40, 180, 180)
SWEP.CustomWorldModelScale = 1

SWEP.active = false
SWEP.lastReload = 0
SWEP.Range = 55
SWEP.IsRepairing = false

function SWEP:InitializeCustom()
    self:SetDeploySpeed(20)
    self:SetNW2Bool("repairing", false)
end

function SWEP:StartRepairing()
    self.LoopId = self:StartLoopingSound("star_trek.sonic_driver_loop")
    self:SetSkin(2)
    self.IsRepairing = true
    self:SetNW2Bool("repairing", true)
end

function SWEP:StopRepairing()
    if isnumber(self.LoopId) then
        self:StopLoopingSound(self.LoopId)
        self:EmitSound("guusconl/startrek/tng_fed_engidevice_end_01.mp3")
        self.LoopId = nil
    end
    self.IsRepairing = false
    self:SetSkin(1)
    self:SetNW2Bool("repairing", false)
end

function SWEP:TurnOn()
    self:SetSkin(1)
    self.active = true
end

function SWEP:TurnOff()
    self.active = false
    self:StopRepairing()
    self:SetSkin(0)
end

function SWEP:Think()
    if SERVER then

        local owner = self:GetOwner()
        if self.active then

            local tr = util.TraceLine({
                start = owner:GetShootPos(),
                endpos = owner:GetShootPos() + owner:GetAimVector() * self.Range,
                filter = owner,
            })
            local repairing = false
            if tr.Hit and tr.Entity:IsValid() then
                repairing = hook.Run("Star_Trek.tools.sonic_driver.trace_hit", owner, self, tr.Entity, tr.HitPos)
            end
            repairing = repairing or false
            if self.IsRepairing ~= repairing then
                if self.IsRepairing == false then
                    self:StartRepairing()
                else
                    self:StopRepairing()
                end
            end
        end


print(self.active)
        if owner:KeyDown(IN_ATTACK) then
            if not self.active then
                self:TurnOn()
            end
        else
            if self.active then
                self:TurnOff()
            end
        end
    end
end