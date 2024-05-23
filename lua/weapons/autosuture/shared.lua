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

SWEP.PrintName = "Autosuture"

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
        Pos = Vector(-3, 1, 0),
    },
    ["ValveBiped.Bip01_R_Clavicle"] = {
        Pos = Vector(-1, 0, 0),
        Ang = Angle(5, 0, 15)
    },
}

SWEP.CustomViewModel = "models/crazycanadian/star_trek/tools/autosuture/autosuture.mdl"
SWEP.CustomViewModelBone = "ValveBiped.Bip01_R_Hand"
SWEP.CustomViewModelOffset = Vector(5, -2, -1.6)
SWEP.CustomViewModelAngle = Angle(-103, -10, -90)
SWEP.CustomViewModelScale = 1

SWEP.CustomDrawWorldModel = true
SWEP.CustomWorldModelBone = "ValveBiped.Bip01_R_Hand"
SWEP.CustomWorldModelOffset = Vector(5, -2, -2.5)
SWEP.CustomWorldModelAngle = Angle(-80, -10, -90)
SWEP.CustomWorldModelScale = 1

SWEP.healSpeed = 4 -- Health points per second
SWEP.minHeal = .20
SWEP.maxHeal = .75

SWEP.active = false
SWEP.healDelay = 0

SWEP.SPRITE_MATERIAL = Material("sprites/light_glow02_add")
SWEP.BEAM_MATERIAL = Material("sprites/tp_beam001")
SWEP.active = false

SWEP.SPRITE_COLOUR = Color(125, 0, 0)
SWEP.BEAM_COLOUR = Color(255, 0, 0)

SWEP.MIN_BEAM_WIDTH = 0.8
SWEP.MAX_BEAM_WIDTH = 1.2
SWEP.BEAM_TEXTURE_STRETCH = 1

SWEP.MIN_SPRITE_SIZE = 8
SWEP.MAX_SPRITE_SIZE = 12

SWEP.BEAM_FPS_START_OFFSET = Vector(-1.5, 3.7, 4.4)
SWEP.BEAM_FPS_ANGLE = Angle(-13, -8, 0)
SWEP.BEAM_FPS_LENGTH = 20

SWEP.BEAM_3RD_START_OFFSET = Vector(6.0, -2, -3.8)
SWEP.BEAM_3RD_ANGLE = Angle(10, -10, 0)
SWEP.BEAM_3RD_LENGTH = 15

SWEP.USE_DECAL = false

function SWEP:InitializeCustom()
    self:SetDeploySpeed(20)
    self:SetNWString("bodyGroups", "00")
    self:SetNW2Bool("active", false)
end

function SWEP:Think()
    if not IsFirstTimePredicted() then return end
    HealUtils:HealThink(self)
end

function SWEP:TurnOn()
    self.LoopId = self:StartLoopingSound("star_trek.laser_scalpel_loop")
    self:SetNWString("bodyGroups", "01")
    self:SetNW2Bool("active", true)
end

function SWEP:TurnOff()
    if isnumber(self.LoopId) then
        self:StopLoopingSound(self.LoopId)
        self:EmitSound("guusconl/startrek/tng_fed_laserscalpel_end.mp3")
        self.LoopId = nil
    end
    self:SetNWString("bodyGroups", "00")
    self:SetNW2Bool("active", false)
end