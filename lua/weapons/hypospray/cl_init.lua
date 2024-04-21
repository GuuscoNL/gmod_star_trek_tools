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
--        hypospray  | Client        --
---------------------------------------

include("shared.lua")


SWEP.Author         = "GuuscoNL"
SWEP.Contact        = "Discord: guusconl"
SWEP.Purpose        = "#TODO:"
SWEP.Instructions   = "#TODO:"
SWEP.Category       = "Star Trek (Utilities)"

SWEP.DrawAmmo       = false

net.Receive("star_trek.tools.hypospray.animation", function()
    local wep = net.ReadEntity()
    if not IsValid(wep) then return end

    local owner = wep:GetOwner()
    if not IsValid(owner) then return end

    owner:SetAnimation(PLAYER_ATTACK1)
    wep:EmitSound("hl1/fvox/hiss.wav", 75,130, 0.9, CHAN_AUTO)

end)