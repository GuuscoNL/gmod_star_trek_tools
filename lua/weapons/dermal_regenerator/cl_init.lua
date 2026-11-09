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
--   dermal_regenerator  | Client    --
---------------------------------------

include("shared.lua")


SWEP.Author       = "GuuscoNL"
SWEP.Contact      = "Discord: guusconl"
SWEP.Purpose      = "Heals minor skin wounds, such as cuts and burns."
SWEP.Instructions =
"Hold LMB to use. Will only heal from 75% to 100% health. Will give an error sound if not within range. Will not heal NPCs."
SWEP.Category     = "Star Trek (Utilities)"

SWEP.DrawAmmo     = false


hook.Add("PostDrawOpaqueRenderables", "dermal_regenerator_draw_effects", function()
    if StarTrekToolsBeamUtils == nil then return end
    StarTrekToolsBeamUtils:handleBeamEffects("dermal_regenerator")
end)
