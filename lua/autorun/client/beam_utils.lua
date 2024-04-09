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
--       beam_utils | client         --
---------------------------------------

function handleBeamEffects(className)
    handleBeamFPS(className)

    local ply = LocalPlayer()
    for _, otherPly in player.Iterator() do

        -- if ply is local player and ply is in first person view, skip
        if not ply:ShouldDrawLocalPlayer() and otherPly:EntIndex() == ply:EntIndex() then
            continue
        end

        handleBeam3rd(className, otherPly)
    end
end

function handleBeamFPS(className)
    local ply = LocalPlayer()
    local wep = ply:GetActiveWeapon()

    -- Check if the player is in a first-person view
    if ply:ShouldDrawLocalPlayer() then
        return
    end

    if not IsValid(wep) or not (wep:GetClass() == className and wep:GetNW2Bool("active")) then
        return
    end

    local vm = ply:GetViewModel()

    if IsValid(vm) then
        local offset = vm:GetBonePosition(vm:LookupBone("ValveBiped.Bip01_R_Finger01"))
        local offset1 = Vector(-0.70, 1.7, 1.7)
        offset1:Rotate(ply:GetAngles())
        local startPos = offset1 + offset
        local endPos = startPos + ply:GetAimVector() * 30

        renderBeam(startPos, endPos, ply, wep)
    end
end

function handleBeam3rd(className, otherPly)
    local wep = otherPly:GetActiveWeapon()

    if not IsValid(wep) or not wep:GetClass() == className or not wep:GetNW2Bool("active") then
        return
    end

    local bone_matrix = otherPly:GetBoneMatrix(otherPly:LookupBone("ValveBiped.Bip01_R_Finger01"))
    if bone_matrix == nil then
        return
    end

    local offset = bone_matrix:GetTranslation()

    local offset1 = Vector(5.6, 0.6, -4)
    offset1:Rotate(bone_matrix:GetAngles())

    local startPos = offset1 + offset

    local direction = Vector(1, 0, 0)
    direction:Rotate(Angle(30, 13, 20))
    direction:Rotate(bone_matrix:GetAngles())

    local endPos = startPos + direction * 20

    renderBeam(startPos, endPos, ply, wep)
end



function renderBeam(startPos, endPos, filter, wep)

    local tr = util.TraceLine({
        start = startPos,
        endpos = endPos,
        filter = filter,
    })

    local spriteWidth = math.random(wep.MIN_SPRITE_SIZE, wep.MAX_SPRITE_SIZE)
    local beamWidth = math.Rand(wep.MIN_BEAM_WIDTH, wep.MAX_BEAM_WIDTH)

    cam.Start3D()
        render.SetMaterial(wep.SPRITE_MATERIAL)
        render.DrawSprite(startPos, spriteWidth, spriteWidth, wep.SPRITE_COLOUR)

        if tr.Hit then
            local pos = tr.HitPos
            render.SetMaterial(wep.BEAM_MATERIAL)
            render.DrawBeam(startPos, pos, beamWidth, 0, 1, wep.BEAM_COLOUR)
            render.SetMaterial(wep.SPRITE_MATERIAL)
            render.DrawSprite(pos + tr.HitNormal * 0.2, spriteWidth, spriteWidth, wep.SPRITE_COLOUR)

            if wep.lastDecal < CurTime() then
                wep.lastDecal = CurTime() + wep.DECAL_DELAY
                local ent = tr.Entity

                if IsValid(ent) and (ent:IsNPC() or ent:IsPlayer()) then
                    util.DecalEx(wep.FLESH_DECAL, ent, tr.HitPos, tr.HitNormal, wep.DECAL_COLOUR, wep.DECAL_SIZE, wep.DECAL_SIZE)
                else
                    util.DecalEx(wep.SCORCH_DECAL, ent, tr.HitPos, tr.HitNormal, wep.DECAL_COLOUR, wep.DECAL_SIZE, wep.DECAL_SIZE)
                end
            end
        else
            render.SetMaterial(wep.BEAM_MATERIAL)
            render.DrawBeam(startPos, endPos, beamWidth, 0, 1, wep.BEAM_COLOUR)
        end
    cam.End3D()
end

print("Loaded")