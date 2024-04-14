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

SWEP.PrintName = "Dermal regenerator"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Slot = 3
SWEP.SlotPos = 0

SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/crazycanadian/star_trek/tools/dermal_regenerator/dermal_regenerator.mdl"

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

SWEP.CustomViewModel = "models/crazycanadian/star_trek/tools/dermal_regenerator/dermal_regenerator.mdl"
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

SWEP.MIN_BEAM_WIDTH = 1.5
SWEP.MAX_BEAM_WIDTH = 2
SWEP.BEAM_TEXTURE_STRETCH = 1

SWEP.MIN_SPRITE_SIZE = 8
SWEP.MAX_SPRITE_SIZE = 12

SWEP.BEAM_FPS_START_OFFSET = Vector(-0.7, 2, 4.7)
SWEP.BEAM_FPS_ANGLE = Angle(-14, -10, 0)
SWEP.BEAM_FPS_LENGTH = 20

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

    if self:GetNW2Bool("active") and self.healDelay <= 0 then
        local trace = owner:GetEyeTrace()
        local ply = trace.Entity

        if owner:GetPos():DistToSqr(ply:GetPos()) > 75 * 75 then return end

        if ply:Health() < self.minHeal * ply:GetMaxHealth() or ply:Health() >= self.maxHeal * ply:GetMaxHealth() then
            self:EmitSound("star_trek.healed")
        else
            if IsValid(ply) and ply:IsPlayer() then
                ply:SetHealth(ply:Health() + 1)
            end
        end
        -- Reset the delay
        self.healDelay = 1 / self.healSpeed
    end

    -- update the delay
    if self.healDelay > 0 then
        self.healDelay = self.healDelay - FrameTime()
    end
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