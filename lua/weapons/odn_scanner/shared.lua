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

SWEP.PrintName = "odn scanner"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Slot = 3
SWEP.SlotPos = 0

SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/crazycanadian/star_trek/tools/odn_scanner/odn_scanner.mdl"

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

SWEP.CustomViewModel = "models/crazycanadian/star_trek/tools/odn_scanner/odn_scanner.mdl"
SWEP.CustomViewModelBone = "ValveBiped.Bip01_R_Hand"
SWEP.CustomViewModelOffset = Vector(4, -2, -0.5)
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
    self:SetDeploySpeed(20)

    self:SetNW2Bool("active", false)
end

function SWEP:PrimaryAttack()
    if not IsFirstTimePredicted() then return end

    if self:GetNW2Bool("active") then
        self:TurnOff()
    else
        if self.LastTurnedOff + self.delay < CurTime() then
            self:TurnOn()
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