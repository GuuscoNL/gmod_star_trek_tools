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

SWEP.lastDelay = 0
SWEP.maxDelay = 0.5

local DOSIS_DELAY_THRESHOLD = 20
local DOSIS_DECAY_RATE = 0.1 -- per second
local DOSIS_DELAY_LOW = 1.5
local DOSIS_DELAY_HIGH = 5

local DOSIS_STRENGTH = 10

function SWEP:PrimaryAttack()
    if not IsFirstTimePredicted() then return end
    if self.lastDelay + self.maxDelay < CurTime() then
        self:Heal()
        self.lastDelay = CurTime()
    end
end

function SWEP:Heal(healOwner)
    local owner = self:GetOwner()
    if not IsValid(owner) then return end
    local ply

    if healOwner then
        ply = owner

    else
        local tr = owner:GetEyeTrace()
        ply = tr.Entity

        if not tr.Hit or not IsValid(ply) or not ply:IsPlayer() or tr.HitPos:Distance(owner:GetShootPos()) > 60 then return end
    end
    -- Trace is successful

    ply:ViewPunch(Angle(-0.3, 0, 0))
    if healOwner then
        self:Animate(false, true)
    else
        self:Animate(false, false)
    end

    if ply.healData == nil then
        ply.healData = {}
        ply.healData.hypo_dose = 0
    end

    -- Heal 1 HP if first time dosing
    if ply:Health() < ply:GetMaxHealth() and ply.healData.hypo_dose == 0 then
        ply:SetHealth(math.min(ply:Health() + 1, ply:GetMaxHealth()))
    end

    ply.healData.hypo_dose = (ply.healData.hypo_dose or 0) + DOSIS_STRENGTH
    ply.healData.startTime = CurTime()

end

function SWEP:SecondaryAttack()
    if not IsFirstTimePredicted() then return end
    if self.lastDelay + self.maxDelay < CurTime() then
        self:Revive()
        self.lastDelay = CurTime()
    end
end

function SWEP:Reload()
    if not IsFirstTimePredicted() then return end
    if self.lastDelay + self.maxDelay < CurTime() then
        self:Heal(true)
        self.lastDelay = CurTime()
    end
end

function SWEP:Revive()
    local owner = self:GetOwner()
    if not IsValid(owner) then return end

    local tr = owner:GetEyeTrace()
    if not tr.Hit or not IsValid(tr.Entity) then return end

    if hook.Run("star_trek.tools.hypospray.revive", owner, tr.Entity) then
        self:Animate(true)
    end
end

util.AddNetworkString("star_trek.tools.hypospray.animation")
function SWEP:Animate(revive, selfHeal)
    local owner = self:GetOwner()
    if not IsValid(owner) then return end

    owner:ViewPunch(Angle(-0.3, 0, 0))
    selfHeal = selfHeal or false
    if selfHeal then
        self:SendWeaponAnim(ACT_VM_DRAW)
    else
        self:SendWeaponAnim(ACT_VM_RECOIL1)
    end

    net.Start("star_trek.tools.hypospray.animation")
    net.WriteEntity(self)
    net.WriteBool(revive)
    net.Broadcast()
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

    if isnumber(scanData.Health) and scanData.Health != 100 then

        Star_Trek.Logs:AddEntry(tricorder, owner, "Medical attention: ", Star_Trek.LCARS.White, TEXT_ALIGN_LEFT)

        if scanData.Health >= 75 then
            Star_Trek.Logs:AddEntry(tricorder, owner, "Minor Dermal Abrasions", Star_Trek.LCARS.ColorGreen, TEXT_ALIGN_RIGHT)
        elseif scanData.Health >= 20 then
            Star_Trek.Logs:AddEntry(tricorder, owner, "Heavy Laceration", Star_Trek.LCARS.ColorOrange, TEXT_ALIGN_RIGHT)
        else
            Star_Trek.Logs:AddEntry(tricorder, owner, "Organ Damage", Star_Trek.LCARS.ColorRed, TEXT_ALIGN_RIGHT)
        end
    end


    if scanData.hypo_dose != nil then
        Star_Trek.Logs:AddEntry(tricorder, owner, "Current dosis:", Star_Trek.LCARS.White, TEXT_ALIGN_LEFT)

        if scanData.hypo_dose >= 40 then
            -- #TODO: warning sound?
            Star_Trek.Logs:AddEntry(tricorder, owner, scanData.hypo_dose .. "mL", Star_Trek.LCARS.ColorRed, TEXT_ALIGN_RIGHT)
        elseif scanData.hypo_dose >= 20 then
            Star_Trek.Logs:AddEntry(tricorder, owner, scanData.hypo_dose .. "mL", Star_Trek.LCARS.ColorOrange, TEXT_ALIGN_RIGHT)
        else
            Star_Trek.Logs:AddEntry(tricorder, owner, scanData.hypo_dose .. "mL", Star_Trek.LCARS.ColorGreen, TEXT_ALIGN_RIGHT)
        end
    end
end)