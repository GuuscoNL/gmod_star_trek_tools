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
--      laser_scalpel | Server       --
---------------------------------------


AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function SWEP:OnRemove()
    self:TurnOff()
end

-- A hook becuase the SWEP:Holster() function doesn't turn off the laser scalpel
hook.Add( "PlayerSwitchWeapon", "Star_Trek.tools.laser_scalpel_switch", function( ply, oldWeapon, newWeapon )
    if IsValid(oldWeapon) and oldWeapon:GetClass() == "laser_scalpel" then
        oldWeapon:TurnOff()
    end
end )

hook.Add("PlayerDroppedWeapon", "Star_Trek.tools.laser_scalpel_drop", function(ply, weapon)
    if weapon:GetClass() == "laser_scalpel" then
        weapon:TurnOff()
    end
end)

hook.Add("PlayerCanPickupWeapon", "Star_Trek.tools.laser_scalpel_pickup", function(ply, weapon)
    if weapon:GetClass() == "laser_scalpel" and ply:HasWeapon("laser_scalpel") then
        return false
    end
end)

util.AddNetworkString("star_trek.tools.laser_scalpel.take_damage")
net.Receive("star_trek.tools.laser_scalpel.take_damage", function()
    local attacker = net.ReadPlayer()
    local weapon = net.ReadEntity()
    local entityHit = net.ReadEntity()
    local hitPos = net.ReadVector()


    if not IsValid(entityHit) or not entityHit:IsPlayer() then return end
    
    local damInfo = DamageInfo()
    damInfo:SetAttacker(attacker)
    damInfo:SetInflictor(weapon)
    damInfo:SetDamage(weapon.playerDamage)
    damInfo:SetDamageType(DMG_ENERGYBEAM)
    damInfo:SetDamagePosition(hitPos)
    
    entityHit:TakeDamageInfo(damInfo)
end)