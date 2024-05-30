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

util.AddNetworkString("star_trek.tools.hyperspanner.take_damage")
net.Receive("star_trek.tools.hyperspanner.take_damage", function()
    local attacker = net.ReadPlayer()
    local weapon = net.ReadEntity()
    local victim = net.ReadPlayer()
    local amount = net.ReadUInt(8)

    if not IsValid(victim) then return end

    local damInfo = DamageInfo()
    damInfo:SetAttacker(attacker)
    damInfo:SetInflictor(weapon)
    damInfo:SetDamage(amount)
    damInfo:SetDamageType(DMG_ENERGYBEAM)

    victim:TakeDamageInfo(damInfo)
end)