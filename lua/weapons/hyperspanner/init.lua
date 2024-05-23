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

function SWEP:Think()
    if not IsFirstTimePredicted() then return end

    local owner = self:GetOwner()
    if not IsValid(owner) then return end

    if owner:KeyDown(IN_ATTACK) then
        if not self:GetNW2Bool("active") then
            self:TurnOn()
        end
    else
        if self:GetNW2Bool("active") then
            self:TurnOff()
        end
    end
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