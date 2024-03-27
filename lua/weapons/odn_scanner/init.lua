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
--       odn_scanner | Server        --
---------------------------------------


AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function SWEP:OnRemove()
    self:TurnOff()
end

hook.Add("PlayerDroppedWeapon", "Star_Trek.tools.odn_scanner_drop", function(ply, weapon)
    if weapon:GetClass() == "odn_scanner" then
        weapon:TurnOff()
    end
end)

hook.Add("PlayerCanPickupWeapon", "Star_Trek.tools.odn_scanner_pickup", function(ply, weapon)
    if weapon:GetClass() == "odn_scanner" and ply:HasWeapon("odn_scanner") then
        return false
    end
end)

hook.Add( "PlayerSwitchWeapon", "Star_Trek.tools.odn_scanner_switch", function( ply, oldWeapon, newWeapon )
    if IsValid(oldWeapon) and oldWeapon:GetClass() == "odn_scanner" then
        oldWeapon:TurnOff()
    end
end )