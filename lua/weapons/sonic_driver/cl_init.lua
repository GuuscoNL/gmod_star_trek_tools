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
--       sonic driver | Client       --
---------------------------------------

include("shared.lua")


SWEP.Author       = "GuuscoNL"
SWEP.Contact      = "Discord: guusconl"
SWEP.Purpose      = "A sonic driver was a standard tool used in the Federation during the 2360s."
SWEP.Instructions = "Press LMB to toggle."
SWEP.Category     = "Star Trek (Utilities)"

SWEP.DrawAmmo     = false


local SPRITE_MATERIAL = Material("sprites/light_glow02_add")
local SPRITE_COLOUR = Color(39, 39, 39)

hook.Add("PostDrawOpaqueRenderables", "sonic_driver_draw_effects", function()
    local ply = LocalPlayer()

    -- Check if the player is in a first-person view
    local wep = ply:GetActiveWeapon()
    if not ply:ShouldDrawLocalPlayer() and IsValid(wep) and wep:GetClass() == "sonic_driver" and wep:GetNW2Bool("repairing") then
        local vm = ply:GetViewModel()

        if IsValid(vm) then
            local offset = vm:GetBonePosition(vm:LookupBone("ValveBiped.Bip01_R_Hand"))
            local offset1 = Vector(4.8, 0.2, 4)
            offset1:Rotate(ply:GetAngles())

            cam.Start3D()
            render.SetMaterial(SPRITE_MATERIAL)
            render.DrawSprite(offset1 + offset, 10, 10, SPRITE_COLOUR)
            cam.End3D()
        end
    end

    for _, OtherPly in player.Iterator() do
        local index1 = OtherPly:EntIndex()
        local index2 = ply:EntIndex()

        if not ply:ShouldDrawLocalPlayer() and index1 == index2 then
            continue
        end

        wep = OtherPly:GetActiveWeapon()

        if IsValid(wep) and wep:GetClass() == "sonic_driver" and wep:GetNW2Bool("repairing") then
            local bone_matrix = OtherPly:GetBoneMatrix(OtherPly:LookupBone("ValveBiped.Bip01_R_Hand"))

            if bone_matrix == nil then
                continue
            end

            local offset = bone_matrix:GetTranslation()

            local offset1 = Vector(7.5, -1.5, -3.5) --Vector(7, 2.8, -1)
            offset1:Rotate(bone_matrix:GetAngles())

            cam.Start3D()
            render.SetMaterial(SPRITE_MATERIAL)
            render.DrawSprite(offset1 + offset, 10, 10, SPRITE_COLOUR)
            cam.End3D()
        end
    end
end)
