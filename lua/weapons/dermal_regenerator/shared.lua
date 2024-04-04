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
        Pos = Vector(-10, 0, 0),
    },
    ["ValveBiped.Bip01_R_Clavicle"] = {
        Pos = Vector(-1, 0, 0),
        Ang = Angle(0, 0, 15)
    },
}

SWEP.CustomViewModel = "models/crazycanadian/star_trek/tools/dermal_regenerator/dermal_regenerator.mdl"
SWEP.CustomViewModelBone = "ValveBiped.Bip01_R_Hand"
SWEP.CustomViewModelOffset = Vector(4.4, -1.8, 0.3)
SWEP.CustomViewModelAngle = Angle(-85, -10, -90)
SWEP.CustomViewModelScale = 0.6

SWEP.CustomDrawWorldModel = true
SWEP.CustomWorldModelBone = "ValveBiped.Bip01_R_Hand"
SWEP.CustomWorldModelOffset = Vector(4, -1.8, 0.3)
SWEP.CustomWorldModelAngle = Angle(-80, -10, -90)
SWEP.CustomWorldModelScale = 0.6

SWEP.healSpeed = 2 -- Health points per second
SWEP.minHeal = .75
SWEP.maxHeal = 1

SWEP.active = false
SWEP.healDelay = 0

-- sound.Add({
--     name = "star_trek.odn_scanner_loop",
--     channel = CHAN_AUTO,
--     volume = 1,
--     level = 70,
--     pitch = 100,
--     sound = "guusconl/startrek/tng_fed_engidevice_loop_02.wav",
-- })

function SWEP:InitializeCustom()
    self:SetDeploySpeed(20)
    self:SetNWString("bodyGroups", "00")
end

function SWEP:Think()
    local owner = self:GetOwner()
    if not IsValid(owner) then return end

    if owner:KeyDown(IN_ATTACK) then
        if not self.active then
            self:TurnOn()
        end
    else
        if self.active then
            self:TurnOff()
        end
    end

    if self.active and self.healDelay <= 0 then
        local trace = owner:GetEyeTrace()
        local ply = trace.Entity

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
    self.active = true
end

function SWEP:TurnOff()
    if isnumber(self.LoopId) then
        self:StopLoopingSound(self.LoopId)
        self:EmitSound("guusconl/startrek/tng_fed_laserscalpel_end.mp3")
        self.LoopId = nil
    end
    self.active = false
end