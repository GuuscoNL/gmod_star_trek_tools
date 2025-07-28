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
--      hyperspanner | Server        --
---------------------------------------


AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function SWEP:OnRemove()
    self:TurnOff()
end

hook.Add("PlayerDroppedWeapon", "Star_Trek.tools.hyperspanner_drop", function(ply, weapon)
    if weapon:GetClass() == "hyperspanner" then
        weapon:TurnOff()
    end
end)

hook.Add("PlayerCanPickupWeapon", "Star_Trek.tools.hyperspanner_pickup", function(ply, weapon)
    if weapon:GetClass() == "hyperspanner" and ply:HasWeapon("hyperspanner") then
        return false
    end
end)

hook.Add( "PlayerSwitchWeapon", "Star_Trek.tools.hyperspanner_switch", function( ply, oldWeapon, newWeapon )
    if IsValid(oldWeapon) and oldWeapon:GetClass() == "hyperspanner" then
        oldWeapon:TurnOff()
    end
end )

util.AddNetworkString("star_trek.tools.hyperspanner.trace_hit")
net.Receive("star_trek.tools.hyperspanner.trace_hit", function()
    local attacker = net.ReadPlayer()
    local weapon = net.ReadEntity()
    local entityHit = net.ReadEntity()
    local hitPos = net.ReadVector()

    if not IsValid(entityHit) then return end

    if not hook.Run("Star_Trek.tools.hyperspanner.trace_hit", attacker, weapon, entityHit, hitPos) then
        local damInfo = DamageInfo()
        damInfo:SetAttacker(attacker)
        damInfo:SetInflictor(weapon)
        damInfo:SetDamage(weapon.playerDamage)
        damInfo:SetDamageType(DMG_ENERGYBEAM)
        damInfo:SetDamagePosition(hitPos)
        
        entityHit:TakeDamageInfo(damInfo)
    end

end)