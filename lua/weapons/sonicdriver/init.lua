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

hook.Add("PlayerDroppedWeapon", "Star_Trek.tools.sonicdriver_drop", function(ply, weapon)
    if weapon:GetClass() == "sonicdriver" then
        weapon:TurnOff()
    end
end)

hook.Add("PlayerCanPickupWeapon", "Star_Trek.tools.sonicdriver_pickup", function(ply, weapon)
    if weapon:GetClass() == "sonicdriver" and ply:HasWeapon("sonicdriver") then
        return false
    end
end)

hook.Add( "PlayerSwitchWeapon", "Star_Trek.tools.sonicdriver_switch", function( ply, oldWeapon, newWeapon )
    if IsValid(oldWeapon) and oldWeapon:GetClass() == "sonicdriver" then
        oldWeapon:TurnOff()
    end
end )