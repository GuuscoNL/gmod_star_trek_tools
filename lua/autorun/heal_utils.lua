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
    local owner = wep:GetOwner()
    if not IsValid(owner) then return end
    -- if CLIENT then
    --     -- #TODO: Local sound!!!!!!!!!!!!!!!
    --     return
    -- end

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
        -- #BUG: Beam does weird shit when `beamUtils:getBeamPossesFPS` is called in CLIENT
        local startPos, endPos = beamUtils:getBeamPossesFPS(owner, wep)
        tr = util.TraceLine({
            start = startPos,
            endpos = endPos,
            filter = owner,
        })

        if tr.Hit and tr.Entity:IsPlayer() then
            local ply = tr.Entity
            if ply:Health() < wep.minHeal * ply:GetMaxHealth() or ply:Health() >= wep.maxHeal * ply:GetMaxHealth() then
                wep:EmitSound("star_trek.healed")
                ply:RemoveAllDecals()
            else
                if IsValid(ply) and ply:IsPlayer() then
                    ply:SetHealth(ply:Health() + 1)
                    if ply:Health() == ply:GetMaxHealth() then
                        wep:EmitSound("star_trek.healed")
                    end
                end
            end
            -- Reset the delay
            wep.healDelay = 1 / wep.healSpeed
        end
    end
end

print("Updated")