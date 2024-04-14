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

SWEP.PrintName = "Laser scalpel"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Slot = 3
SWEP.SlotPos = 0

SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/crazycanadian/star_trek/tools/laser_scalpel/laser_scalpel.mdl"

SWEP.HoldType = "revolver"

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
        Ang = Angle(0, 0, 0)
    },
    ["ValveBiped.Bip01_R_Finger1"] = {
        Ang = Angle(-20, 00, 0)
    },
    ["ValveBiped.Bip01_R_Finger11"] = {
        Ang = Angle(0, -20, 30)
    },
    ["ValveBiped.Bip01_R_Forearm"] = {
        Pos = Vector(-3, 1, 0),
    },
    ["ValveBiped.Bip01_R_Clavicle"] = {
        Pos = Vector(-1, 0, 0),
        Ang = Angle(5, 0, 15)
    },
}

SWEP.CustomViewModel = "models/crazycanadian/star_trek/tools/laser_scalpel/laser_scalpel.mdl"
SWEP.CustomViewModelBone = "ValveBiped.Bip01_R_Hand"
SWEP.CustomViewModelOffset = Vector(4, -2, -0.5)
SWEP.CustomViewModelAngle = Angle(-85, -10, -90)
SWEP.CustomViewModelScale = 1

SWEP.CustomDrawWorldModel = true
SWEP.CustomWorldModelBone = "ValveBiped.Bip01_R_Hand"
SWEP.CustomWorldModelOffset = Vector(4, -1.5, -0.5)
SWEP.CustomWorldModelAngle = Angle(-65, 0, -90)
SWEP.CustomWorldModelScale = 1


SWEP.SPRITE_MATERIAL = Material("sprites/light_glow02_add")
SWEP.BEAM_MATERIAL = Material("sprites/rollermine_shock")
SWEP.active = false

SWEP.SPRITE_COLOUR = Color(110, 8, 8)
SWEP.BEAM_COLOUR = Color(255, 0, 0)

SWEP.MIN_BEAM_WIDTH = 0.7
SWEP.MAX_BEAM_WIDTH = 1.4
SWEP.BEAM_TEXTURE_STRETCH = 1

SWEP.MIN_SPRITE_SIZE = 8
SWEP.MAX_SPRITE_SIZE = 12

SWEP.BEAM_FPS_START_OFFSET = Vector(0, 3.3, 4)
SWEP.BEAM_FPS_ANGLE = Angle(-14.5, -5, 0)
SWEP.BEAM_FPS_LENGTH = 30

SWEP.BEAM_3RD_START_OFFSET = Vector(9, -1.5, -3.3)
SWEP.BEAM_3RD_ANGLE = Angle(7, 0, 0)
SWEP.BEAM_3RD_LENGTH = 20

SWEP.USE_DECAL = true

SWEP.FLESH_DECAL = Material("decals/flesh/blood1_subrect")
SWEP.FLESH_DECAL_SIZE = 0.2
SWEP.SCORCH_DECAL = Material("decals/scorchfade_subrect")
SWEP.SCORCH_DECAL_SIZE = 0.1
SWEP.DECAL_COLOUR = Color(0, 0, 0)
SWEP.DECAL_DELAY = 0.08

SWEP.lastDecal = 0


function SWEP:InitializeCustom()
    self:SetDeploySpeed(20)
    self:SetNW2Bool("active", false)
end

function SWEP:PrimaryAttack()
    if not IsFirstTimePredicted() then return end

    if self:GetNW2Bool("active") then
        self:TurnOff()
    else
        self:TurnOn()
    end
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