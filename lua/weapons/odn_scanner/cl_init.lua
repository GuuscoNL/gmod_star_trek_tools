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
--       odn_scanner | Client        --
---------------------------------------

include("shared.lua")


SWEP.Author       = "GuuscoNL"
SWEP.Contact      = "Discord: guusconl"
SWEP.Purpose      = "A High tech instrument used to diagnose, calibrate and repair circuits."
SWEP.Instructions = "Press LMB to toggle scanner."
SWEP.Category     = "Star Trek (Utilities)"

SWEP.DrawAmmo     = false


local SPRITE_MATERIAL = Material("sprites/light_glow02_add")
local SPRITE_COLOUR = Color(110, 8, 8)

hook.Add("PostDrawOpaqueRenderables", "odn_scanner_draw_effects", function()
    local ply = LocalPlayer()
    local wep = ply:GetActiveWeapon()

    -- Check if the player is in a first-person view
    if not ply:ShouldDrawLocalPlayer() and IsValid(wep) and wep:GetClass() == "odn_scanner" and wep:GetNW2Bool("active") then
        local vm = ply:GetViewModel()

        if IsValid(vm) then
            local offset = vm:GetBonePosition(vm:LookupBone("ValveBiped.Bip01_R_Finger01"))
            local offset1 = Vector(0, 1, 1)
            offset1:Rotate(ply:GetAngles())

            cam.Start3D()
            render.SetMaterial(SPRITE_MATERIAL)
            render.DrawSprite(offset1 + offset, 10, 10, SPRITE_COLOUR)
            cam.End3D()
        end
    end

    for _, otherPly in player.Iterator() do
        local index1 = otherPly:EntIndex()
        local index2 = ply:EntIndex()

        if not ply:ShouldDrawLocalPlayer() and index1 == index2 then
            continue
        end

        wep = otherPly:GetActiveWeapon()

        if IsValid(wep) and wep:GetClass() == "odn_scanner" and wep:GetNW2Bool("active") then
            local bone_matrix = otherPly:GetBoneMatrix(otherPly:LookupBone("ValveBiped.Bip01_R_Finger01"))
            local offset = bone_matrix:GetTranslation()

            local offset1 = Vector(7.5, 2, -1)
            offset1:Rotate(bone_matrix:GetAngles())

            cam.Start3D()
            render.SetMaterial(SPRITE_MATERIAL)
            render.DrawSprite(offset1 + offset, 10, 10, SPRITE_COLOUR)
            cam.End3D()
        end
    end
end)
