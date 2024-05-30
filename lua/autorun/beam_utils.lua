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
--       beam_utils | shared         --
---------------------------------------

if CLIENT then
    beamUtils = {}

    function beamUtils:handleBeamEffects(className)
        beamUtils:handleBeamFPS(className)

        local ply = LocalPlayer()
        for _, otherPly in player.Iterator() do

            -- if ply is local player and ply is in first person view, skip
            if not ply:ShouldDrawLocalPlayer() and otherPly:EntIndex() == ply:EntIndex() then
                continue
            end

            beamUtils:handleBeam3rd(className, otherPly)
        end
    end

    function beamUtils:handleBeamFPS(className)
        local ply = LocalPlayer()
        local wep = ply:GetActiveWeapon()

        -- Check if the player is in a third person view if so, skip
        if ply:ShouldDrawLocalPlayer() then
            return
        end

        if not IsValid(wep) or wep:GetClass() != className or not wep:GetNW2Bool("active") then
            return
        end

        local startPos, endPos = beamUtils:getBeamPossesFPS(ply, wep)

        if startPos == nil or endPos == nil then
            return
        end
        beamUtils:renderBeam(startPos, endPos, ply, wep)

    end

    function beamUtils:getBeamPossesFPS(ply, wep)
        local vm = ply:GetViewModel()

        if not IsValid(vm) then return nil, nil end

        local boneMatrix = vm:GetBoneMatrix(vm:LookupBone(wep.CustomViewModelBone))
        if boneMatrix == nil then
            return nil, nil
        end

        local offset = Vector()

        offset:Set(wep.BEAM_FPS_START_OFFSET)
        offset:Rotate(ply:GetAngles())
        local startPos = boneMatrix:GetTranslation() + offset


        local direction = Vector(1, 0, 0)
        direction:Rotate(wep.BEAM_FPS_ANGLE)
        direction:Rotate(boneMatrix:GetAngles())
        local endPos = startPos + direction * wep.BEAM_FPS_LENGTH

        return startPos, endPos
    end

    function beamUtils:getBeamPosses3rd(ply, wep)
        local boneMatrix = ply:GetBoneMatrix(ply:LookupBone(wep.CustomWorldModelBone))
        if boneMatrix == nil then
            return
        end

        local bonePos = boneMatrix:GetTranslation()

        local offset = Vector()
        offset:Set(wep.BEAM_3RD_START_OFFSET)
        offset:Rotate(boneMatrix:GetAngles())

        local startPos = bonePos + offset

        local direction = Vector(1, 0, 0)
        direction:Rotate(wep.BEAM_3RD_ANGLE)
        direction:Rotate(boneMatrix:GetAngles())

        local endPos = startPos + direction * wep.BEAM_3RD_LENGTH

        return startPos, endPos
    end

    function beamUtils:handleBeam3rd(className, otherPly)
        local wep = otherPly:GetActiveWeapon()

        if not IsValid(wep) or wep:GetClass() != className or not wep:GetNW2Bool("active") then
            return
        end


        local startPos, endPos = beamUtils:getBeamPosses3rd(otherPly, wep)
        beamUtils:renderBeam(startPos, endPos, ply, wep)
    end

    function beamUtils:renderBeam(startPos, endPos, filter, wep)

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
                render.DrawBeam(startPos, pos, beamWidth, 0, wep.BEAM_TEXTURE_STRETCH * tr.Fraction, wep.BEAM_COLOUR)
                if wep.SECOND_BEAM then
                    render.DrawBeam(startPos, pos, beamWidth, 0, wep.BEAM_TEXTURE_STRETCH / 2 * tr.Fraction, Color(255, 255, 255, 100))
                end

                render.SetMaterial(wep.SPRITE_MATERIAL)
                render.DrawSprite(pos + tr.HitNormal * 0.2, spriteWidth, spriteWidth, wep.SPRITE_COLOUR)

                if wep.USE_DECAL and wep.lastDecal < CurTime() then
                    wep.lastDecal = CurTime() + wep.DECAL_DELAY
                    local ent = tr.Entity

                    if IsValid(ent) and (ent:IsNPC() or ent:IsPlayer()) then
                        util.DecalEx(wep.FLESH_DECAL, ent, tr.HitPos, tr.HitNormal, wep.DECAL_COLOUR, wep.FLESH_DECAL_SIZE, wep.FLESH_DECAL_SIZE)
                    else
                        util.DecalEx(wep.SCORCH_DECAL, ent, tr.HitPos, tr.HitNormal, wep.DECAL_COLOUR, wep.SCORCH_DECAL_SIZE, wep.SCORCH_DECAL_SIZE)
                    end
                end

                if wep.SPARKS and wep.SPARKS_LAST_SPARK < CurTime() then
                    wep.SPARKS_LAST_SPARK = CurTime() + wep.SPARKS_DELAY

                    -- impact effect
                    local effectData = EffectData()
                    effectData:SetOrigin(tr.HitPos)
                    effectData:SetNormal(tr.HitNormal)
                    util.Effect("AR2Impact", effectData)

                    -- sparks
                    effectData = EffectData()
                    effectData:SetOrigin(tr.HitPos)
                    effectData:SetNormal(tr.HitNormal)
                    util.Effect("MetalSpark", effectData)

                    if wep.SPARK_LOOP_ID == nil then
                        wep.SPARK_LOOP_ID = wep:StartLoopingSound("ambient/energy/electric_loop.wav")
                    end
                end

            else
                render.SetMaterial(wep.BEAM_MATERIAL)
                render.DrawBeam(startPos, endPos, beamWidth, 0, wep.BEAM_TEXTURE_STRETCH, wep.BEAM_COLOUR)
                if wep.SECOND_BEAM then
                    render.DrawBeam(startPos, endPos, beamWidth, 0, wep.BEAM_TEXTURE_STRETCH / 2, Color(255, 255, 255, 100))
                end

                if wep.SPARK_LOOP_ID then
                    wep:StopLoopingSound(wep.SPARK_LOOP_ID)
                    wep.SPARK_LOOP_ID = nil
                end
            end
        cam.End3D()
    end

    net.Receive("star_trek.tools.beam_util.disable_spark_looping_sound", function()
        local wep = net.ReadEntity()
        if not IsValid(wep) then return end

        if wep.SPARK_LOOP_ID then
            wep:StopLoopingSound(wep.SPARK_LOOP_ID)
            wep.SPARK_LOOP_ID = nil
        end
    end)
end

if SERVER then
    util.AddNetworkString("star_trek.tools.beam_util.disable_spark_looping_sound")
end