local canJump = true

CreateThread(function()
        NetworkSessionVoiceLeave()
        while true do
                Wait(1)
                local ped = PlayerPedId()
                if IsPedJumping(ped) then
                        if canJump then
                                Wait(1000)
                                canJump = false
                                Wait(3000)
                                canJump = true
                        else
                                SetPedToRagdoll(ped, 1, 1000, 0, 0, 0, 0)
                        end
                end
        end
end)