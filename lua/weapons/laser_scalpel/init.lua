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

function SWEP:OnDrop()
    self:TurnOff()
end

hook.Add("PlayerCanPickupWeapon", "Star_Trek.tools.laser_scalpel_pickup", function(ply, weapon)
    if weapon:GetClass() == "laser_scalpel" and ply:HasWeapon("laser_scalpel") then
        return false
    end
end)