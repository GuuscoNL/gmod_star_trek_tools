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
--      hyperspanner | Shared        --
---------------------------------------

SWEP.Base = "oni_base"

SWEP.PrintName = "Hyperspanner"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Slot = 3
SWEP.SlotPos = 0

SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/crazycanadian/star_trek/tools/hyperspanner/hyperspanner.mdl"

SWEP.HoldType = "slam"

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
    ["ValveBiped.Bip01_R_Hand"] = {
        Ang = Angle(-40, -15, 0)
    },
    ["ValveBiped.Bip01_R_Finger1"] = {
        Ang = Angle(-20, -5, 30)
    },
    ["ValveBiped.Bip01_R_Finger11"] = {
        Ang = Angle(0, -40, 0)
    },
    ["ValveBiped.Bip01_R_Forearm"] = {
        Pos = Vector(-3, 1, -1),
        Ang = Angle(-5, 30, 0)
    },
    ["ValveBiped.Bip01_R_Clavicle"] = {
        Pos = Vector(-1, 0, 0),
        Ang = Angle(5, 0, 15)
    },
}

SWEP.CustomViewModel = "models/crazycanadian/star_trek/tools/hyperspanner/hyperspanner.mdl"
SWEP.CustomViewModelBone = "ValveBiped.Bip01_R_Hand"
SWEP.CustomViewModelOffset = Vector(3.6, -1.5, 2)
SWEP.CustomViewModelAngle = Angle(-103, -10, -90)
SWEP.CustomViewModelScale = 1

SWEP.CustomDrawWorldModel = true
SWEP.CustomWorldModelBone = "ValveBiped.Bip01_R_Hand"
SWEP.CustomWorldModelOffset = Vector(0, -1.3, 1)
SWEP.CustomWorldModelAngle = Angle(-143, -10, -90)
SWEP.CustomWorldModelScale = 1


SWEP.active = false

SWEP.SPRITE_MATERIAL = Material("sprites/light_glow02_add")
SWEP.BEAM_MATERIAL = Material("sprites/tp_beam001")
SWEP.active = false

SWEP.SECOND_BEAM = true

SWEP.SPARKS = true
SWEP.SPARKS_DELAY = 0.05
SWEP.SPARK_LOOP_ID = nil
SWEP.SPARKS_LAST_SPARK = 0

SWEP.SPRITE_COLOUR = Color(28, 137, 255)
SWEP.BEAM_COLOUR = Color(0, 64, 255)

SWEP.MIN_BEAM_WIDTH = 2
SWEP.MAX_BEAM_WIDTH = 3
SWEP.BEAM_TEXTURE_STRETCH = 1

SWEP.MIN_SPRITE_SIZE = 20
SWEP.MAX_SPRITE_SIZE = 25

SWEP.BEAM_FPS_START_OFFSET = Vector(-3, 6, 4.5)
SWEP.BEAM_FPS_ANGLE = Angle(77, -10, 0)
SWEP.BEAM_FPS_LENGTH = 30

SWEP.BEAM_3RD_START_OFFSET = Vector(10.5, -3, -7)
SWEP.BEAM_3RD_ANGLE = Angle(37, -10, 0)
SWEP.BEAM_3RD_LENGTH = 25

SWEP.USE_DECAL = false

SWEP.IS_WELDING = false

function SWEP:InitializeCustom()
    self:SetDeploySpeed(20)
    self:SetNW2Bool("active", false)
end

function SWEP:TurnOn()
    self.LoopId = self:StartLoopingSound("star_trek.laser_scalpel_loop")
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