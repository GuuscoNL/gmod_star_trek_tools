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
--       sonic driver | Server       --
---------------------------------------


AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function SWEP:OnRemove()
    self:TurnOff()
end

hook.Add("PlayerDroppedWeapon", "Star_Trek.tools.sonic_driver_drop", function(ply, weapon)
    if weapon:GetClass() == "sonic_driver" then
        weapon:TurnOff()
    end
end)

hook.Add("PlayerCanPickupWeapon", "Star_Trek.tools.sonic_driver_pickup", function(ply, weapon)
    if weapon:GetClass() == "sonic_driver" and ply:HasWeapon("sonic_driver") then
        return false
    end
end)

hook.Add( "PlayerSwitchWeapon", "Star_Trek.tools.sonic_driver_switch", function( ply, oldWeapon, newWeapon )
    if IsValid(oldWeapon) and oldWeapon:GetClass() == "sonic_driver" then
        oldWeapon:TurnOff()
    end
end )