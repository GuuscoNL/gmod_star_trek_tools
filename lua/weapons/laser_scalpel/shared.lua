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

SWEP.PrintName = "Laser Scalpel"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Slot = 3
SWEP.SlotPos = 0

SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/crazycanadian/startrek/tools/laserscalpel.mdl"

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

SWEP.CustomViewModel = "models/crazycanadian/startrek/tools/laserscalpel.mdl"
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
SWEP.DamageSpeed = 2 -- per second
SWEP.DamageDelay = 0

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

function SWEP:Think()
    if not IsFirstTimePredicted() then return end
    local owner = self:GetOwner()
    if not IsValid(owner) then return end

    if owner:KeyDown(IN_ATTACK) then
        if not self:GetNW2Bool("active") then
            self:TurnOn()
        end
    else
        if self:GetNW2Bool("active") then
            self:TurnOff()
        end
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

function SWEP:Think()
    if not IsFirstTimePredicted() then return end

    local owner = self:GetOwner()
    if not IsValid(owner) then return end

    if CLIENT then
        if self:GetNW2Bool("active") and self.DamageDelay <= 0 then

            local startPos, endPos
            if LocalPlayer():ShouldDrawLocalPlayer() then
                startPos, endPos = beamUtils:getBeamPosses3rd(owner, self)
            else
                startPos, endPos = beamUtils:getBeamPossesFPS(owner, self)
            end


            -- draw debug balls
            -- debugoverlay.Sphere(startPos, 1, 0.2, Color(255, 0, 0), false)
            -- debugoverlay.Sphere(endPos, 1, 0.2 , Color(0, 255, 0), false)

            tr = util.TraceLine({
                start = startPos,
                endpos = endPos,
                filter = owner,
            })

            if tr.Hit and tr.Entity:IsPlayer() then
                net.Start("star_trek.tools.hyperspanner.take_damage")
                net.WritePlayer(owner)
                net.WriteEntity(self)
                net.WritePlayer(tr.Entity)
                net.WriteUInt(1, 8)
                net.SendToServer()
            end

            self.DamageDelay = 1 / self.DamageSpeed
        end

        if self.DamageDelay > 0 then
            self.DamageDelay = self.DamageDelay - FrameTime()
        end
        return
    elseif SERVER then
        if owner:KeyDown(IN_ATTACK) then
            if not self:GetNW2Bool("active") then
                self:TurnOn()
            end
        else
            if self:GetNW2Bool("active") then
                self:TurnOff()
            end
        end
    end
end