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
--      laser_scalpel | Shared       --
---------------------------------------

SWEP.Base = "oni_base"

SWEP.PrintName = "autosuture"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Slot = 3
SWEP.SlotPos = 0

SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/crazycanadian/star_trek/tools/autosuture/autosuture.mdl"

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
        Ang = Angle(-0, 0, 0)
    },
    ["ValveBiped.Bip01_R_Finger1"] = {
        Ang = Angle(-20, -5, 30)
    },
    ["ValveBiped.Bip01_R_Finger11"] = {
        Ang = Angle(0, -40, 0)
    },
    ["ValveBiped.Bip01_R_Forearm"] = {
        Pos = Vector(-10, 0, 0),
    },
    ["ValveBiped.Bip01_R_Clavicle"] = {
        Pos = Vector(-1, 0, 0),
        Ang = Angle(0, 0, 15)
    },
}

SWEP.CustomViewModel = "models/crazycanadian/star_trek/tools/autosuture/autosuture.mdl"
SWEP.CustomViewModelBone = "ValveBiped.Bip01_R_Hand"
SWEP.CustomViewModelOffset = Vector(5, -2, -2.5)
SWEP.CustomViewModelAngle = Angle(-85, -10, -90)
SWEP.CustomViewModelScale = 1

SWEP.CustomDrawWorldModel = true
SWEP.CustomWorldModelBone = "ValveBiped.Bip01_R_Hand"
SWEP.CustomWorldModelOffset = Vector(5, -2, -2.5)
SWEP.CustomWorldModelAngle = Angle(-80, -10, -90)
SWEP.CustomWorldModelScale = 1

SWEP.active = false


sound.Add({
    name = "star_trek.odn_scanner_loop",
    channel = CHAN_AUTO,
    volume = 1,
    level = 70,
    pitch = 100,
    sound = "guusconl/startrek/tng_fed_engidevice_loop_02.wav",
})

function SWEP:Initialize()
    self:SetDeploySpeed(20)
    self:SetNWString("bodyGroups", "00")

end

function SWEP:PrimaryAttack()
    if not IsFirstTimePredicted() then return end

    if self.active then
        self:TurnOff()
    else
        self:TurnOn()
    end
end

function SWEP:TurnOn()
    self.LoopId = self:StartLoopingSound("star_trek.laser_scalpel_loop")
    self:SetNWString("bodyGroups", "01")
    self.active = true
end

function SWEP:TurnOff()
    if isnumber(self.LoopId) then
        self:StopLoopingSound(self.LoopId)
        self:EmitSound("guusconl/startrek/tng_fed_laserscalpel_end.mp3")
        self.LoopId = nil
    end
    self:SetNWString("bodyGroups", "00")
    self.active = false
end