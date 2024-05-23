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
SWEP.WorldModel = "models/crazycanadian/star_trek/tools/sonicdriver/sonicdriver.mdl"

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

SWEP.CustomViewModel = "models/crazycanadian/star_trek/tools/sonicdriver/sonicdriver.mdl"
SWEP.CustomViewModelBone = "ValveBiped.Bip01_R_Hand"
SWEP.CustomViewModelOffset = Vector(4, -2, -0.7)
SWEP.CustomViewModelAngle = Angle(20, 0, 140)
SWEP.CustomViewModelScale = 1

SWEP.CustomDrawWorldModel = true
SWEP.CustomWorldModelBone = "ValveBiped.Bip01_R_Hand"
SWEP.CustomWorldModelOffset = Vector(4.5, -1.5, -1.1)
SWEP.CustomWorldModelAngle = Angle(40, 0, 180)
SWEP.CustomWorldModelScale = 1

SWEP.active = false
SWEP.scanning = false
SWEP.lastReload = 0

function SWEP:InitializeCustom()
    self:SetDeploySpeed(20)
    self:SetNW2Bool("scanning", false)
end

function SWEP:PrimaryAttack()
    if not IsFirstTimePredicted() then return end
    print(self.active)
    if not self.active then return end

    if self:GetNW2Bool("scanning") then
        self:ScanOff()
    else
        self:ScanOn()
    end
end

function SWEP:Reload()
    if not IsFirstTimePredicted() then return end
    if self.lastReload + 0.2 > CurTime() then return end
    self.lastReload = CurTime()

    if self.active then
        self:TurnOff()
    else
        self:TurnOn()
    end
end

function SWEP:TurnOn()
    self:SetSkin(1)
    self.active = true
end

function SWEP:TurnOff()
    self:ScanOff()
    self:SetSkin(0)
    self.active = false
end

function SWEP:ScanOn()
    self.LoopId = self:StartLoopingSound("star_trek.sonic_driver_loop")
    self:SetSkin(2)
    self:SetNW2Bool("scanning", true)
end

function SWEP:ScanOff()
    if isnumber(self.LoopId) then
        self:StopLoopingSound(self.LoopId)
        self:EmitSound("guusconl/startrek/tng_fed_engidevice_end_01.mp3")
        self.LoopId = nil
    end
    self:SetSkin(1)
    self:SetNW2Bool("scanning", false)
end