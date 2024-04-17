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
--        hypospray  | Server        --
---------------------------------------


AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")


local DOSIS_STRENGTH = 10
local DOSIS_DELAY_THRESHOLD = 20
local DOSIS_DECAY_RATE = 0.1 -- per second
local DOSIS_DELAY_LOW = 1.5
local DOSIS_DELAY_HIGH = 5

function SWEP:PrimaryAttack()

    if self.lastDelay + self.maxDelay < CurTime() then
        self:Heal()
        self.lastDelay = CurTime()
    end
end

function SWEP:Heal()
    self:SendWeaponAnim(ACT_VM_RECOIL1)
    local owner = self:GetOwner()
    if not IsValid(owner) then return end

    local tr = owner:GetEyeTrace()
    local ply = tr.Entity

    if not tr.Hit or not IsValid(ply) or not ply:IsPlayer() or tr.HitPos:Distance(owner:GetShootPos()) > 60 then return end
    -- Trace is successful

    -- owner plays sound because the sound is not played on the client when playing it on the SWEP
    owner:EmitSound("player/suit_sprint.wav", 75, 100, 0.8, CHAN_AUTO)
    owner:ViewPunch(Angle(-0.3, 0, 0))

    if ply.healData == nil then
        ply.healData = {}
    end

    ply.healData.hypo_dose = (ply.healData.hypo_dose or 0) + DOSIS_STRENGTH
    print(ply.healData.hypo_dose)
    ply.healData.startTime = CurTime()
end

function SWEP:SecondaryAttack()
    if self.lastDelay + self.maxDelay < CurTime() then
        self:Revive()
        self.lastDelay = CurTime()
    end
end

function SWEP:Revive()
    self:SendWeaponAnim(ACT_VM_RECOIL1)
    local owner = self:GetOwner()
    if not IsValid(owner) then return end

    local tr = owner:GetEyeTrace()
    if not tr.Hit or not IsValid(tr.Entity) then return end
    hook.Run("star_trek.tools.hypospray.revive", owner, tr.Entity)
end

hook.Add("PlayerCanPickupWeapon", "Star_Trek.tools.hypospray_pickup", function(ply, weapon)
    if weapon:GetClass() == "hypospray" and ply:HasWeapon("hypospray") then
        return false
    end
end)

hook.Add("Think", "Star_Trek.tools.hypospray_heal", function()
    for _, ply in ipairs(player.GetAll()) do
        local healData = ply.healData

        if healData == nil or not IsValid(ply) or healData.hypo_dose <= 0 then
            continue
        end

        healData.hypo_dose = healData.hypo_dose - (FrameTime() * DOSIS_DECAY_RATE)

        if healData.hypo_dose <= 0 then
            ply.healData = nil
        end

        if ply:Health() >= ply:GetMaxHealth() then
            continue
        end

        local delay = DOSIS_DELAY_LOW
        if ply:Health() >= DOSIS_DELAY_THRESHOLD then
            delay = DOSIS_DELAY_HIGH
        end

        if healData.startTime + delay <= CurTime()  then
            ply:SetHealth(math.min(ply:Health() + 1, ply:GetMaxHealth()))
            healData.startTime = CurTime()
        end

    end
end)

hook.Add("PostPlayerDeath", "Star_Trek.tools.hypospray_death", function(ply)
    ply.healData = nil
end)

hook.Add("Star_Trek.Sensors.ScanPlayer", "Star_Trek.tools.hypospray_scan", function(ply, scanData)
    if ply.healData != nil then
        scanData.hypo_dose = math.Round(ply.healData.hypo_dose, 2)
    end
end)

hook.Add("Star_Trek.Tricorder.AnalyseScanData", "Star_Trek.tools.hypospray_scan", function(tricorder, owner, scanData)

    if scanData.hypo_dose != nil then
        Star_Trek.Logs:AddEntry(tricorder, owner, "Current dosis:", Star_Trek.LCARS.White, TEXT_ALIGN_LEFT)

        if scanData.hypo_dose >= 40 then
            -- #TODO: add sound?
            Star_Trek.Logs:AddEntry(tricorder, owner, scanData.hypo_dose .. "mL", Star_Trek.LCARS.ColorRed, TEXT_ALIGN_RIGHT)
        elseif scanData.hypo_dose >= 20 then
            Star_Trek.Logs:AddEntry(tricorder, owner, scanData.hypo_dose .. "mL", Star_Trek.LCARS.ColorOrange, TEXT_ALIGN_RIGHT)
        else
            Star_Trek.Logs:AddEntry(tricorder, owner, scanData.hypo_dose .. "mL", Star_Trek.LCARS.ColorGreen, TEXT_ALIGN_RIGHT)
        end
    end
end)