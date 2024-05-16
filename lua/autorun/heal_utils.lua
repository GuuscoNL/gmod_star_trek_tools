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
--       heal_utils | shared         --
---------------------------------------

HealUtils = {}

function HealUtils:HealThink(wep)
    if CLIENT then return end
    local owner = wep:GetOwner()
    if not IsValid(owner) then return end

    if owner:KeyDown(IN_ATTACK) then
        if not wep:GetNW2Bool("active") then
            wep:TurnOn()
        end
    else
        if wep:GetNW2Bool("active") then
            wep:TurnOff()
        end
    end

    HealUtils:HandleHealing(wep, owner)

    -- update the delay
    if wep.healDelay > 0 then
        wep.healDelay = wep.healDelay - FrameTime()
    end
end

function HealUtils:HandleHealing(wep, owner)
    if wep:GetNW2Bool("active") and wep.healDelay <= 0 then
        local startPos, endPos = beamUtils:getBeamPossesFPS(owner, wep)
        tr = util.TraceLine({
            start = startPos,
            endpos = endPos,
            filter = owner,
        })

        if tr.Hit and tr.Entity:IsPlayer() then
            local ply = tr.Entity
            if ply:Health() < wep.minHeal * ply:GetMaxHealth() or ply:Health() >= wep.maxHeal * ply:GetMaxHealth() then
                HealUtils:PlayHealSound(owner)
                if ply:Health() >= ply:GetMaxHealth() then
                    HealUtils:RemoveDecals(ply)
                end
            else
                if IsValid(ply) and ply:IsPlayer() then
                    ply:SetHealth(ply:Health() + 1)
                    if ply:Health() == ply:GetMaxHealth() then
                        HealUtils:PlayHealSound(owner)
                    end
                end
            end
            -- Reset the delay
            wep.healDelay = 1 / wep.healSpeed
        end
    end
end

if CLIENT then
    net.Receive("star_trek.tools.heal_util.heal_sound", function()
        local wep = LocalPlayer():GetActiveWeapon()
        if not IsValid(wep) then return end
        wep:EmitSound("star_trek.healed")
    end)

    net.Receive("star_trek.tools.heal_util.remove_decals", function()
        local ply = net.ReadPlayer()
        if not IsValid(ply) then return end
        ply:RemoveAllDecals()
    end)
end

if SERVER then
    util.AddNetworkString("star_trek.tools.heal_util.heal_sound")
    function HealUtils:PlayHealSound(ply)
        net.Start("star_trek.tools.heal_util.heal_sound")
        net.Send(ply)
    end

    util.AddNetworkString("star_trek.tools.heal_util.remove_decals")
    function HealUtils:RemoveDecals(ply)
        net.Start("star_trek.tools.heal_util.remove_decals")
        net.WritePlayer(ply)
        net.Broadcast()
    end
end