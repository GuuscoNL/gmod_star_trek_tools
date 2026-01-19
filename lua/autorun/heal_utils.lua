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

StarTrekToolsHealUtils = {}

function StarTrekToolsHealUtils:HealThink(wep)
    local owner = wep:GetOwner()
    if not IsFirstTimePredicted() then return end
    if not IsValid(owner) then return end
    if CLIENT then
        StarTrekToolsHealUtils:HandleHealing(wep, owner)
            -- update the delay
        if wep.healDelay > 0 then
            wep.healDelay = wep.healDelay - FrameTime()
        end
        return
    end

    if owner:KeyDown(IN_ATTACK) then
        if not wep:GetNW2Bool("active") then
            wep:TurnOn()
        end
    else
        if wep:GetNW2Bool("active") then
            wep:TurnOff()
        end
    end
end

function StarTrekToolsHealUtils:HandleHealing(wep, owner)
    if wep:GetNW2Bool("active") and wep.healDelay <= 0 then
        local startPos, endPos

        if LocalPlayer():ShouldDrawLocalPlayer() then
            startPos, endPos = StarTrekToolsBeamUtils:getBeamPosses3rd(owner, wep)
        else
            startPos, endPos = StarTrekToolsBeamUtils:getBeamPossesFPS(owner, wep)
        end
        tr = util.TraceLine({
            start = startPos,
            endpos = endPos,
            filter = owner,
        })

        local ply = tr.Entity
        if not IsValid(ply) then return end
        if tr.Hit and (ply:IsPlayer() or ply:IsNPC() or ply:IsNextBot())  then
            if ply:Health() < wep.minHeal * ply:GetMaxHealth() or ply:Health() >= wep.maxHeal * ply:GetMaxHealth() then
                wep:EmitSound("star_trek.healed")
                if ply:Health() >= ply:GetMaxHealth() then
                    net.Start("star_trek.tools.heal_util.remove_decals")
                    net.WriteEntity(ply)
                    net.SendToServer()
                end
                
            else
                -- Tell the server to add health to the player
                net.Start("star_trek.tools.heal_util.add_health")
                net.WriteEntity(ply)
                net.WriteUInt(1, 8)
                net.SendToServer()

                if ply:Health() == ply:GetMaxHealth() then
                    wep:EmitSound("star_trek.healed")
                end
            end
            -- Reset the delay
            wep.healDelay = 1 / wep.healSpeed
        end
    end

    net.Receive("star_trek.tools.heal_util.remove_decals", function()
        local ent = net.ReadEntity()
        if not IsValid(ent) then return end
        ent:RemoveAllDecals()
    end)
end

if SERVER then

    util.AddNetworkString("star_trek.tools.heal_util.add_health")
    net.Receive("star_trek.tools.heal_util.add_health", function()
        local ent = net.ReadEntity()
        local amount = net.ReadUInt(8)
        if not IsValid(ent) then return end
        if not (ent:IsPlayer() or ent:IsNPC() or ent:IsNextBot()) then return end
        
        ent:SetHealth(ent:Health() + amount)
    end)
    
    util.AddNetworkString("star_trek.tools.heal_util.remove_decals")
    net.Receive("star_trek.tools.heal_util.remove_decals", function()
        local ent = net.ReadEntity()
        if not IsValid(ent) then return end
        net.Start("star_trek.tools.heal_util.remove_decals")
        net.WriteEntity(ent)
        net.Broadcast()
    end)

end