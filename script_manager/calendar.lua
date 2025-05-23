require ('moonloader')
local inicfg = require 'inicfg'
math.randomseed(os.clock())
local json_timer = os.time()
local mainini = inicfg.load({   
    launcher =
    {
        banner = true
    }
	}, "banner")
inicfg.save(mainini, 'banner2.ini') 
if not doesFileExist('moonloader/config/banner2.ini') then
	inicfg.save(mainini,'banner2.ini')
end

local banner = mainini.launcher.banner

addEventHandler('onReceivePacket', function (id, bs)
    if banner == true then
        if id == 220 then
            raknetBitStreamIgnoreBits(bs, 8)
            if (raknetBitStreamReadInt8(bs) == 17) then
                raknetBitStreamIgnoreBits(bs, 32)
                local length = raknetBitStreamReadInt16(bs)
                local encoded = raknetBitStreamReadInt8(bs)
                local str = (encoded ~= 0) and raknetBitStreamDecodeString(bs, length + encoded) or raknetBitStreamReadString(bs, length)
                if str ~= nil then
                    if str:find('event.setActiveView') and str:find('RewardsNewYear') then
                        AFKMessage('��������� ��� �����. ��������� ���� ������� - /calendar')
                        sendCEF('rewardsNewYear.exit')
                    end
                end
            end
        end
    end
end)

function main()
    while not isSampAvailable() do wait(222) end
    AFKMessage('AutoCloseCalendar by Freym loaded. CMDS: /calendar',-1)
	sampRegisterChatCommand('calendar',function()
        banner = not banner
        AFKMessage(tostring(banner))
        mainini.launcher.banner = banner
        inicfg.save(mainini, "banner2.ini")
	end)
    while true do wait(-1) end
end

sendCEF = function(str)
    local bs = raknetNewBitStream()
    raknetBitStreamWriteInt8(bs, 220)
    raknetBitStreamWriteInt8(bs, 18)
    raknetBitStreamWriteInt16(bs, #str)
    raknetBitStreamWriteString(bs, str)
    raknetBitStreamWriteInt32(bs, 0)
    raknetSendBitStream(bs)
    raknetDeleteBitStream(bs)
end

AFKMessage = function(text) 
	sampAddChatMessage('[Freym-tech] {ffffff}'..text,0xFF4141) 
end