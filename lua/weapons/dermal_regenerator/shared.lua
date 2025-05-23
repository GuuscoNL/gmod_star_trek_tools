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
--   dermal_regenerator  | Shared    --
---------------------------------------

SWEP.Base = "oni_base"

SWEP.PrintName = "Dermal Regenerator"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Slot = 3
SWEP.SlotPos = 0

SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/crazycanadian/startrek/tools/dermal_regenerator.mdl"

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

SWEP.CustomViewModel = "models/crazycanadian/startrek/tools/dermal_regenerator.mdl"
SWEP.CustomViewModelBone = "ValveBiped.Bip01_R_Hand"
SWEP.CustomViewModelOffset = Vector(4.4, -1.5, 0.7)
SWEP.CustomViewModelAngle = Angle(-100, -10, -90)
SWEP.CustomViewModelScale = 1

SWEP.CustomDrawWorldModel = true
SWEP.CustomWorldModelBone = "ValveBiped.Bip01_R_Hand"
SWEP.CustomWorldModelOffset = Vector(4, -1.8, 0.3)
SWEP.CustomWorldModelAngle = Angle(-80, -10, -90)
SWEP.CustomWorldModelScale = 1

SWEP.healSpeed = 2 -- Health points per second
SWEP.minHeal = .75
SWEP.maxHeal = 1

SWEP.active = false
SWEP.healDelay = 0

SWEP.SPRITE_MATERIAL = Material("sprites/light_glow02_add")
SWEP.BEAM_MATERIAL = Material("sprites/tp_beam001")
SWEP.active = false

SWEP.SPRITE_COLOUR = Color(125, 0, 0)
SWEP.BEAM_COLOUR = Color(255, 0, 0)

SWEP.MIN_BEAM_WIDTH = 1
SWEP.MAX_BEAM_WIDTH = 1.5
SWEP.BEAM_TEXTURE_STRETCH = 1

SWEP.MIN_SPRITE_SIZE = 18
SWEP.MAX_SPRITE_SIZE = 20

SWEP.BEAM_FPS_START_OFFSET = Vector(-0.7, 2, 4.7)
SWEP.BEAM_FPS_ANGLE = Angle(-14, -10, 0)
SWEP.BEAM_FPS_LENGTH = 32

SWEP.BEAM_3RD_START_OFFSET = Vector(6.0, -1.7, -4)
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
    self.LoopId = self:StartLoopingSound("star_trek.dermal_regenerator_loop")
    self:SetNW2Bool("active", true)
end

function SWEP:TurnOff()
    if isnumber(self.LoopId) then
        self:StopLoopingSound(self.LoopId)
        self:EmitSound("guusconl/startrek/tng_fed_laserscalpel_end.mp3")
        self.LoopId = nil
    end
    self:SetNW2Bool("active", false)
end