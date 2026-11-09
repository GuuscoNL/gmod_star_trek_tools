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
--      hyperspanner | Client        --
---------------------------------------

include("shared.lua")


SWEP.Author       = "GuuscoNL"
SWEP.Contact      = "Discord: guusconl"
SWEP.Purpose      = "Hyperspanner is a tool used to repair the ship's systems."
SWEP.Instructions = "Hold LMB to use. Will hurt players and NPCs."
SWEP.Category     = "Star Trek (Utilities)"

SWEP.DrawAmmo     = false

hook.Add("PostDrawOpaqueRenderables", "hyperspanner_draw_effects", function()
    if StarTrekToolsBeamUtils == nil then return end
    StarTrekToolsBeamUtils:handleBeamEffects("hyperspanner")
end)
