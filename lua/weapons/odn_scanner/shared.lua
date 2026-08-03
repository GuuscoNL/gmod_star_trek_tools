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
--       odn_scanner | Shared        --
---------------------------------------

SWEP.Base = "oni_base"

SWEP.PrintName = "Odn Scanner"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Slot = 3
SWEP.SlotPos = 0

SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/crazycanadian/startrek/tools/odn_scanner.mdl"

SWEP.HoldType = "pistol"

SWEP.BoneManip = {
    ["ValveBiped.Bip01_R_Finger1"] = {
        Ang = Angle(-60, -20, 0)
    },
    ["ValveBiped.Bip01_R_Forearm"] = {
        Pos = Vector(-10, 0, 0),
    },
    ["ValveBiped.Bip01_R_Clavicle"] = {
        Pos = Vector(-1, 0, 0),
        Ang = Angle(0, 0, 15)
    },
}

SWEP.CustomViewModel = "models/crazycanadian/startrek/tools/odn_scanner.mdl"
SWEP.CustomViewModelBone = "ValveBiped.Bip01_R_Hand"
SWEP.CustomViewModelOffset = Vector(4, -2.1, -0.5)
SWEP.CustomViewModelAngle = Angle(200, 0, 50)
SWEP.CustomViewModelScale = 1

SWEP.CustomDrawWorldModel = true
SWEP.CustomWorldModelBone = "ValveBiped.Bip01_R_Hand"
SWEP.CustomWorldModelOffset = Vector(5, -2, -1.5)
SWEP.CustomWorldModelAngle = Angle(-20, 180, 190)
SWEP.CustomWorldModelScale = 1

SWEP.LastTurnedOff = 0
SWEP.delay = 1.7

function SWEP:InitializeCustom()
    self:SetDeploySpeed(2)

    self:SetNW2Bool("active", false)
end

function SWEP:Think()
    if not IsFirstTimePredicted() then return end

    local owner = self:GetOwner()
    if not IsValid(owner) then return end

    if owner:KeyDown(IN_ATTACK) then
        if (self.LastTurnedOff + self.delay < CurTime()) and not self:GetNW2Bool("active") then
            self:TurnOn()
        end
    else
        if self:GetNW2Bool("active") then
            self:TurnOff()
        end
    end
end

function SWEP:TurnOn()
    self.LoopId = self:StartLoopingSound("star_trek.odn_scanner_loop")
    self:SetSkin(1)
    self:SetNW2Bool("active", true)
end

function SWEP:TurnOff()
    if isnumber(self.LoopId) then
        self:StopLoopingSound(self.LoopId)
        self:EmitSound("guusconl/startrek/tng_fed_engidevice_end_02.mp3")
        self.LoopId = nil
    end
    self:SetSkin(0)
    self:SetNW2Bool("active", false)
    self.LastTurnedOff = CurTime()
end
