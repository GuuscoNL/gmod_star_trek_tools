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
SWEP.Purpose        = "Hyperspray is a medical device used to deliver medication or other substances into the body without the use of needles."
SWEP.Instructions   = "Press LMB to use.\nPress R to inject yourself.\nPress RMB to revive player (If implemented by gamemode)\n\nWill slowly heal players over time. If they are below 20% health, it will heal faster. Use the tricorder to see how much ml poeple have in their system.\n\nWill not heal NPCs."
SWEP.Category       = "Star Trek (Utilities)"

SWEP.DrawAmmo       = false

net.Receive("star_trek.tools.hypospray.animation", function()
    local wep = net.ReadEntity()
    if not IsValid(wep) then return end

    local owner = wep:GetOwner()
    if not IsValid(owner) then return end

    local revive = net.ReadBool()

    owner:SetAnimation(PLAYER_ATTACK1)
    if revive then
        wep:EmitSound("star_trek.hypospray_revive")
    else
        wep:EmitSound("star_trek.hypospray_dose")
    end
end)