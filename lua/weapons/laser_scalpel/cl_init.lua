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
SWEP.Purpose      = "A specialized medical instrument used to create incisions in various tissues."
SWEP.Instructions = "Hold LMB to use. Will slightly hurt players and NPCs."
SWEP.Category     = "Star Trek (Utilities)"

SWEP.DrawAmmo     = false

function SWEP:DrawWorldModelCustom(flags)
    self.CustomWorldModelEntity:SetBodyGroups(self:GetNWString("bodyGroups"))
end

function SWEP:DrawViewModelCustom(vm, weapon, ply)
    self.CustomViewModelEntity:SetBodyGroups(self:GetNWString("bodyGroups"))
end

hook.Add("PostDrawOpaqueRenderables", "laser_scalpel_draw_effects", function()
    if StarTrekToolsBeamUtils == nil then return end
    StarTrekToolsBeamUtils:handleBeamEffects("laser_scalpel")
end)
