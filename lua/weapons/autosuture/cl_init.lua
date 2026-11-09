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
--      laser_scalpel | Client       --
---------------------------------------

include("shared.lua")


SWEP.Author       = "GuuscoNL"
SWEP.Contact      = "Discord: guusconl"
SWEP.Purpose      = "Seal wounds and promote healing."
SWEP.Instructions =
"Hold LMB to use. Will only heal from 25% to 75% health. Will give an error sound if not within range. Will not heal NPCs."
SWEP.Category     = "Star Trek (Utilities)"

SWEP.DrawAmmo     = false

function SWEP:DrawWorldModelCustom(flags)
    self.CustomWorldModelEntity:SetBodyGroups(self:GetNWString("bodyGroups"))
end

function SWEP:DrawViewModelCustom(vm, weapon, ply)
    self.CustomViewModelEntity:SetBodyGroups(self:GetNWString("bodyGroups"))
end

hook.Add("PostDrawOpaqueRenderables", "autosuture_draw_effects", function()
    if StarTrekToolsBeamUtils == nil then return end
    StarTrekToolsBeamUtils:handleBeamEffects("autosuture")
end)
