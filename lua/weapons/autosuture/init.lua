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

hook.Add("PlayerDroppedWeapon", "Star_Trek.tools.autosuture_drop", function(ply, weapon)
    if weapon:GetClass() == "autosuture" then
        weapon:TurnOff()
    end
end)

hook.Add("PlayerCanPickupWeapon", "Star_Trek.tools.autosuture_pickup", function(ply, weapon)
    if weapon:GetClass() == "autosuture" and ply:HasWeapon("autosuture") then
        return false
    end
end)

hook.Add( "PlayerSwitchWeapon", "Star_Trek.tools.autosuture_switch", function( ply, oldWeapon, newWeapon )
    if IsValid(oldWeapon) and oldWeapon:GetClass() == "autosuture" then
        oldWeapon:TurnOff()
    end
end )