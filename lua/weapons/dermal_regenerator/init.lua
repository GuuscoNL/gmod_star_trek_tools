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
--   dermal_regenerator  | Server    --
---------------------------------------


AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function SWEP:OnRemove()
    self:TurnOff()
end

hook.Add("PlayerDroppedWeapon", "Star_Trek.tools.dermal_regenerator_drop", function(ply, weapon)
    if weapon:GetClass() == "dermal_regenerator" then
        weapon:TurnOff()
    end
end)

hook.Add("PlayerCanPickupWeapon", "Star_Trek.tools.dermal_regenerator_pickup", function(ply, weapon)
    if weapon:GetClass() == "dermal_regenerator" and ply:HasWeapon("dermal_regenerator") then
        return false
    end
end)

hook.Add( "PlayerSwitchWeapon", "Star_Trek.tools.dermal_regenerator_switch", function( ply, oldWeapon, newWeapon )
    if IsValid(oldWeapon) and oldWeapon:GetClass() == "dermal_regenerator" then
        oldWeapon:TurnOff()
    end
end )