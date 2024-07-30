
script_properties("work-in-pause")
local mimgui_blur = require('mimgui_blur')
local imgui = require('mimgui')
local ti = require('tabler_icons')
local encoding = require('encoding')
encoding.default = 'CP1251'
local vector3d = require("vector3d")
local u8 = require('encoding').UTF8
local show_menu = false
local renderWindow = imgui.new.bool(show_menu)
local menu = 1
local logMenu = 0
local new = imgui.new
--=======================================
-- // TODO inventory_slots


local servers = {
    ['185.169.134.3'] = 1,
    ['185.169.134.4'] = 2,
    ['185.169.134.43'] = 3,
    ['185.169.134.44'] = 4,
    ['185.169.134.45'] = 5,
    ['185.169.134.5'] = 6,
    ['185.169.134.59'] = 7,
    ['185.169.134.61'] = 8,
    ['185.169.134.107'] = 9,
    ['185.169.134.109'] = 10,
    ['185.169.134.166'] = 11,
    ['185.169.134.171'] = 12,
    ['185.169.134.172'] = 13,
    ['185.169.134.173'] = 14,
    ['185.169.134.174'] = 15,
    ['80.66.82.191'] = 16,
    ['80.66.82.190'] = 17,
    ['80.66.82.188'] = 18,
    ['80.66.82.168'] = 19,
    ['80.66.82.159'] = 20,
    ['80.66.82.200'] = 21,
    ['80.66.82.144'] = 22,
    ['80.66.82.132'] = 23,
    ['80.66.82.128'] = 24,
    ['80.66.82.113'] = 25,
    ['80.66.82.82'] = 26,
    ['80.66.82.87'] = 27,
    ['80.66.82.54'] = 28,
    ['80.66.82.39'] = 29,
    ['80.66.82.33'] = 30,
    ['80.66.82.147'] = 0,
    ['213.239.204.104'] = -1,
}

local scriptPngPage = {}

local inventory_slots = { 
    ["325, 164.74285888672"] = 0,
    ["351.5, 164.74285888672"] = 1,
    ["378, 164.74285888672"] = 2,
    ["404.5, 164.74285888672"] = 3,
    ["431, 164.74285888672"] = 4,
    ["457.5, 164.74285888672"] = 5,
    ["325, 195.24285888672"] = 6,
    ["351.5, 195.24285888672"] = 7,
    ["378, 195.24285888672"] = 8,
    ["404.5, 195.24285888672"] = 9,
    ["431, 195.24285888672"] = 10,
    ["457.5, 195.24285888672"] = 11,
    ["325, 225.74285888672"] = 12,
    ["351.5, 225.74285888672"] = 13,
    ["378, 225.74285888672"] = 14,
    ["404.5, 225.74285888672"] = 15,
    ["431, 225.74285888672"] = 16,
    ["457.5, 225.74285888672"] = 17,
    ["325, 256.24285888672"] = 18,
    ["351.5, 256.24285888672"] = 19,
    ["378, 256.24285888672"] = 20,
    ["404.5, 256.24285888672"] = 21,
    ["431, 256.24285888672"] = 22,
    ["457.5, 256.24285888672"] = 23,
    ["325, 286.74285888672"] = 24,
    ["351.5, 286.74285888672"] = 25,
    ["378, 286.74285888672"] = 26,
    ["404.5, 286.74285888672"] = 27,
    ["431, 286.74285888672"] = 28,
    ["457.5, 286.74285888672"] = 29,
    ["325, 317.24285888672"] = 30,
    ["351.5, 317.24285888672"] = 31,
    ["378, 317.24285888672"] = 32,
    ["404.5, 317.24285888672"] = 33,
    ["431, 317.24285888672"] = 34,
    ["457.5, 317.24285888672"] = 35,
}

local scan_slots = {
    ["184.5, 164.74285888672"] = 0,
    ["211, 164.74285888672"] = 1,
    ["237.5, 164.74285888672"] = 2,
    ["264, 164.74285888672"] = 3,
    ["290.5, 164.74285888672"] = 4,
    ["184.5, 195.24285888672"] = 5,
    ["211, 195.24285888672"] = 6,
    ["237.5, 195.24285888672"] = 7,
    ["264, 195.24285888672"] = 8,
    ["290.5, 195.24285888672"] = 9,
    ["184.5, 225.74285888672"] = 10,
    ["211, 225.74285888672"] = 11,
    ["237.5, 225.74285888672"] = 12,
    ["264, 225.74285888672"] = 13,
    ["290.5, 225.74285888672"] = 14,
    ["184.5, 256.24285888672"] = 15,
    ["211, 256.24285888672"] = 16,
    ["237.5, 256.24285888672"] = 17,
    ["264, 256.24285888672"] = 18,
    ["290.5, 256.24285888672"] = 19,
    ["184.5, 286.74285888672"] = 20,
    ["211, 286.74285888672"] = 21,
    ["237.5, 286.74285888672"] = 22,
    ["264, 286.74285888672"] = 23,
    ["290.5, 286.74285888672"] = 24,
    ["184.5, 317.24285888672"] = 25,
    ["211, 317.24285888672"] = 26,
    ["237.5, 317.24285888672"] = 27,
    ["264, 317.24285888672"] = 28,
    ["290.5, 317.24285888672"] = 29,
}


local balanced_price, balanced_price_vc, buying_price, buying_price_vc = {}, {}, {}, {}
local full_dialog = {}
local online_price = {
    ['sell_'] = {},
    ['buy_'] = {},
    ['sell_vc'] = {},
    ['buy_vc'] = {},
}

local cjson = require("cjson")

function readJsonFile(filePath)
    local file = io.open(filePath, "r")
    if file then
        local content = file:read("*a")
        file:close()
        return cjson.decode(content)
    else
        return nil
    end
end

function writeJsonFile(data, path)
    local file = io.open(path, "w")
    if file then
        local jsonStr = cjson.encode(data)
        file:write(jsonStr)
        file:close()
        return true
    else
        return false
    end
end

local ffi = require("ffi")
local lfs = require("lfs")
local fa = require("fAwesome6")
local items_buy = "moonloader/ArzMarket/buy.json"
local items_sell = "moonloader/ArzMarket/sell.json"
local json_timer = {
    [1] = os.time(),
    [2] = os.time(),
    [3] = os.time(),
    [4] = os.time(),
    [5] = nil,
    [6] = os.time() - 10,
    [7] = os.time() - 10,
} 
local nalog_txt = {}
-- local json_timer_sell = os.time()
local last_stranica = 1

local effilCheck, effil = pcall(require, "effil")
local sampev = require("samp.events")
local inicfg = require("inicfg")
local txd_id = {}
local islauncher, clear_stream = false, false
local marketShop = {}
local num_of_page, delay_for_eat, eat_perc = 4, 0, 110
local window, separator, scan_button, emule_dialog, bot_helper, cancel_sellorbuy, mobile_jostik, auto_full_button, sell_filter, trade_chat, replace_logger = new.bool(), new.bool(), new.bool(), new.bool(), new.bool(), new.bool(), new.bool(), new.bool(), new.bool(), new.bool(), new.bool(), new.bool()
local separatorChar = {buy = new.char[32]('0'), countBuy = '0', sell = new.char[32]('0'), countSell = '0', page = 0}
local current_theme = {}
local scan, scan_sell, create_config = false, false, {}
local hook_sell = {nick = '', item = '', count = '', money = ''}
local hook_buy = {nick = '', item = '', count = '', money = ''}
-- local current_cfg = {buy = '', sell = ''}
local font, items, item_list, sell_list, item_tab = {}, {}, {}, {}, {}
local tosave = {buy = '', sell = ''}
local item_v = {price = 10, count = 1}
local item_sell = {price = 10, count = 1}
local display = {buy = false, sell = false, score = 0, score_from = 0}
-- local buttons = {{name = '������', change_number_to = 0}, {name = '�������', change_number_to = 1}, {name = '�������', change_number_to = 2}, {name = '���������', change_number_to = 3}, {name = 'Changelog', change_number_to = 4}, {name = '��������������', change_number_to = 5}}
local scan_info = {}
local mobile_jostik_buttons = {
    list = {u8('ESC'), u8('Help'), u8('C'), u8('V'), u8('N'), u8('F'), u8('G'), u8('H'), u8('Y'), u8('Alt'), u8('F6'), u8('2')},
    keys = {0x1B, 0, 0x43, 0x56, 0x4E, 0x46, 0x47, 0x48, 0x59, 0xA4, 0x75, 0x32}
}

local buttons = {
    {
        title = u8('��������'), 
        list = {u8('�������'), u8('������'), u8('���������')}
    },
    {
        title = u8('�������'),
        list = {u8('���'),  u8('�������'), u8('�������'), u8('����')}
    },
}

local alpha_s = new.float(0.8)
local speed_s = new.float(2.0)
local rgb_width = new.float(3)
local RadioButton_s = {new.int(333),333,false} 

local input = {sell = {}, buy = {}}
local list_for_search = {buy = {}, sell = {}}
local messages = {}
local messages_vc = {}
--=======================================

local directIni = '/ArzMarket/ArzMarket.ini'
local ini = inicfg.load({
    cfg = {
        rgb_window = true,
        border_side = false,
        help_message = false,
        telegram_notf = false,
        replace_window = false,
        auto_name_lavka = false,
        Always_convert = false,
        Always_convert_block = false,
        left_menu_blur = true,
        right_menu_blur = true,
        blur_rgb_window = true,
        background_blure = false,
        telegram_notification = false,
        tg_notf_market = true,
        own_server = false,
        tg_notf_kick = false,
        tg_notf_damage = false,
        telegram_chatid = '',
        telegram_token = '',
        dialog_wait = 350,
        lavka_helper = false,
        controller_sell_buy = false,
        trader_bool = false,
        dialog_list_wait_bool = false,
        dialog_wait_list = 150,
        auto_eat = false,
        auto_eat_percent = 25,
        auto_eat_foodid = 0,
        color_select = 0,
        auto_catcher = false,
        auto_name = 'name',
        delete_players = false,
        clear_chat = false,
        load_config_sell = '',
        load_config_buy = '',
        sort_mode = true,
        lavka_name = '',
        button_style = false,
        button_duration = 1.0,
        active_lavka = -1,
        dbug_info = true,
        buy_vc = '1',
        sell_vc = '1',
        vice_city_mode = false,
        alpha_menuS = true,
        filter_one = true,
        filter_two = true,
    },
    tg_setting = {
        notf_buysell = false,
        lavka_status = false,
        stats = false,
        death_notf = false,
        admin_message = false,
        connect_message = false,
        nalog_message = false,
        token = '',
        chat_id = '',
    }
}, directIni)
if not doesFileExist('moonloader/config/ArzMarket/ArzMarket.ini') then inicfg.save(ini, directIni) end
--
local telegram_custom = {
    notf_buysell = new.bool(ini.tg_setting.notf_buysell),
    lavka_status = new.bool(ini.tg_setting.lavka_status),
    stats = new.bool(ini.tg_setting.stats),
    death_notf = new.bool(ini.tg_setting.death_notf),
    admin_message = new.bool(ini.tg_setting.admin_message),
    connect_message = new.bool(ini.tg_setting.connect_message),
    nalog_message = new.bool(ini.tg_setting.nalog_message),
    token = new.char[256](''..ini.tg_setting.token),
    chat_id = new.char[256](''..ini.tg_setting.chat_id),
}
local replace_loggerS = {}
local color_theme = 'moonloader/ArzMarket/js/theme.json'
if readJsonFile(color_theme) then
    replace_loggerS = readJsonFile(color_theme)
else
    replace_loggerS = {
		marketSize = {x = 600, y = 250},
		marketColor = {text = {1.0, 1.0, 1.0, 1.1}, window = {0.072, 0.091, 0.207, 0.784}},
		log_windowFont = 1.0,
		marketPos = {x = -1, y = -1},
		LogsPos = {x = -1, y = -1}
    }
end

local log_windowFont = new.float(replace_loggerS.log_windowFont)
local active_lavka = ini.cfg.active_lavka
local marketColor = {text = new.float[4](replace_loggerS.marketColor.text), window = new.float[4](replace_loggerS.marketColor.window)}
local marketPos = imgui.ImVec2(replace_loggerS.marketPos.x, replace_loggerS.marketPos.y)
local LogsPos = imgui.ImVec2(replace_loggerS.LogsPos.x, replace_loggerS.LogsPos.y)
local marketSize = {x = new.int(replace_loggerS.marketSize.x), y = new.int(replace_loggerS.marketSize.y)}
local trader_bool = new.bool(ini.cfg.trader_bool)
local filter_one = new.bool(ini.cfg.filter_one) 
local filter_two = new.bool(ini.cfg.filter_two)
local controller_sell_buy = new.bool(ini.cfg.controller_sell_buy)
local help_message = new.bool(ini.cfg.help_message)
local border_side = new.bool(ini.cfg.border_side)
local alpha_menuS = new.bool(ini.cfg.alpha_menuS)
local telegram_notf = new.bool(ini.cfg.telegram_notf)
local own_server = new.bool(ini.cfg.own_server)
local button_style = new.bool(ini.cfg.button_style)
local telegram_notification_bool = new.bool(ini.cfg.telegram_notification)
local tg_notf_market_bool = new.bool(ini.cfg.tg_notf_market)
local tg_notf_kick_bool = new.bool(ini.cfg.tg_notf_kick)
local tg_notf_damage_bool = new.bool(ini.cfg.tg_notf_damage)
local telegram_chatid_bool = new.char[256](''..ini.cfg.telegram_chatid)
local telegram_token_bool = new.char[256](''..ini.cfg.telegram_token)
local dialog_wait = new.int(ini.cfg.dialog_wait) 
local dialog_wait_list = new.int(ini.cfg.dialog_wait_list)
local button_duration = new.float(ini.cfg.button_duration)
local dialog_list_wait_bool = new.bool(ini.cfg.dialog_list_wait_bool)
local auto_eat_bool = new.bool(ini.cfg.auto_eat)
local auto_eat_percent_bool = new.int(ini.cfg.auto_eat_percent)
local auto_eat_foodid = new.int(ini.cfg.auto_eat_foodid)
local color_select = new.int(ini.cfg.color_select)
local auto_catcher_bool = new.bool(ini.cfg.auto_catcher)
local auto_catcher_bool = new.bool(ini.cfg.auto_catcher)
local auto_name = u8(''..ini.cfg.auto_name)
local load_config_sell = u8(''..ini.cfg.load_config_sell)
local load_config_buy = u8(''..ini.cfg.load_config_buy)
local delete_players_bool = new.bool(ini.cfg.delete_players)
local left_menu_blur = new.bool(ini.cfg.left_menu_blur)
local auto_name_lavka = new.bool(ini.cfg.auto_name_lavka)
local Always_convert = new.bool(ini.cfg.Always_convert)
local Always_convert_block = new.bool(ini.cfg.Always_convert_block)
local right_menu_blur = new.bool(ini.cfg.right_menu_blur)
local blur_rgb_window = new.bool(ini.cfg.blur_rgb_window)
local background_blure = new.bool(ini.cfg.background_blure)
local rgb_window = new.bool(ini.cfg.rgb_window)
local sort_mode = new.bool(ini.cfg.sort_mode)
local vice_city_mode = new.bool(ini.cfg.vice_city_mode)
local lavka_helper = new.bool(ini.cfg.lavka_helper)
local dbug_info = new.bool(ini.cfg.dbug_info)
local replace_window = new.bool(ini.cfg.replace_window)
local search, search_sell, search_cfg_buy, send_irc_msg, search_cfg_sell, price_inp, count_inp, cfgSelect, script_name, lavka_name, sell_vc, buy_vc, trade_message = new.char[256](), new.char[256](), new.char[256](), new.char[256](), new.char[256](), new.char[256](), new.char[256](), imgui.new.int(1), new.char[256]('ARZMARKET'), new.char[256](''..ini.cfg.lavka_name), new.char[256](''..ini.cfg.sell_vc), new.char[256](''..ini.cfg.buy_vc), new.char[256]()
-- sampAddChatMessage(tostring(auto_name)..' ?',-1)
--rgb_width
-- window = {0.03, 0.02, 0.04, 0.5}, 0.086, 0.098, 0.173, 0.784 || 0.029, 0.035, 0.09, 0.97 || 0.092, 0.106, 0.192, 0.784
current_theme = {
    color_text_market = {1, 1, 1},
    text = {1, 1, 1, 1},
    rgb_window = {0.516, 0.505, 0.977, 0.4},
    help_hint = {0.516, 0.505, 0.977, 0.4},
    window = {0.072, 0.091, 0.207, 0.784}, -- 0.015, 0.029, 0.115, 0.784
    Border = {0.516, 0.505, 0.977, 0.4},
    button = {0.08, 0.09, 0.19, 0.246},
    button_hovered = {1, 1, 1, 0.05},
    button_active = {0.41, 0.41, 0.41, 0.7},
    input = {1, 1, 1, 0.04},
    separator = {0.516, 0.505, 0.977, 0.4},
    left_menu = {0.072, 0.091, 0.207, 0.784},-- (0.000f, 0.013f, 0.133f, 1.000f) 0.08, 0.09, 0.19, 0.5 (0.000f, 0.197f, 1.000f, 0.000f) ..... (0.004f, 0.013f, 0.069f, 0.784f) (0.072f, 0.091f, 0.207f, 0.784f)
    slider = {0.516, 0.505, 0.977, 0.5}, -- 0.08, 0.09, 0.19, 1
    active_selector_color = {0.11, 0.12, 0.24, 0.5},
    active_toggle_button = {0.516, 0.505, 0.977},
    deactive_toggle_button = {0.190, 0.188, 0.272},
}
local slider = new.float[4](current_theme.slider)
local color_window = new.float[4](current_theme.window)
local rgb_windowC = new.float[4](current_theme.rgb_window)
local color_separator = new.float[4](current_theme.separator)
local color_button = new.float[4](current_theme.button)
local color_text = new.float[4](current_theme.text)
local active_selector_color = new.float[4](current_theme.active_selector_color)
local left_menu = new.float[4](current_theme.left_menu)
local menu_list = new.int(1)
local blur_count = new.int(1) 
local active_toggle_button = new.float[3](current_theme.active_toggle_button)
local deactive_toggle_button = new.float[3](current_theme.deactive_toggle_button)
local color_text_market = new.float[3](current_theme.color_text_market)

local telegram_notification_bool = new.bool(ini.cfg.telegram_notification)
--=================================IRC
checker_names = {}
local zaderzhka_mainfunc = 50
local zaderzhka_mainfunc_odin = 150 -- // TODO zaderzhka_mainfunc_odin

local wait_dialog_d = {}
local kapibara_s = {}
local auto_full_dialog = false
local scan_items_s = {nil, false}
connected = false

if doesFileExist('moonloader/lib/luaircv2.lua') then
	-- broadcaster = import('lib/luaircv2.lua')
	require "luaircv2" 
	sleep = require "socket".sleep
	s = irc.new{nick = 'nil'}
else
	dont_have_lib = true
end


function main()
    while not isSampAvailable() do wait(0) end
    -- wait(3888)
    -- while not sampIsLocalPlayerSpawned() do wait(0) end
    if not doesDirectoryExist('moonloader/ArzMarket') then lfs.mkdir((getWorkingDirectory()..'/ArzMarket')) end
    if not doesDirectoryExist('moonloader/ArzMarket/resource') then lfs.mkdir((getWorkingDirectory()..'/ArzMarket/resource')) end
    if not doesDirectoryExist('moonloader/ArzMarket/sell-cfg') then lfs.mkdir((getWorkingDirectory()..'/ArzMarket/sell-cfg')) end
    if not doesDirectoryExist('moonloader/ArzMarket/buy-cfg') then lfs.mkdir(getWorkingDirectory()..'/ArzMarket/buy-cfg') end
    -- checkUpdate()
    -- checkFont()
    updateList()
    
    jsonLog = readJsonFile('moonloader\\ArzMarket\\Log.json') if jsonLog == nil then jsonLog = {} end
    
    -- AFKMessage(tostring(jsonLog))
    -- load_script_lvl()
    if replace_window[0] and active_lavka ~= -1 then
        replace_logger[0] = true
    end
	if dont_have_lib == nil then
		-- s:hook("OnKick", onIRCKick)
		s:hook("OnJoin", onIRCJoin)
		-- s:hook("OnPart", onIRCPart)
		-- s:hook("OnQuit", onIRCQuit)
		s:hook("OnChat", onIRCMessage)
		s:hook("OnRaw", onIRCRaw)
        s:hook("OnModeChange", onIRCModeChange)
        injected = true
        -- AFKMessage('WFIONAFUOIAWBFUBAWFIUWABFUIAWBUIF_______??')
	end
    AFKMessage('+ load ArzMarket222')
    
    sampRegisterChatCommand('faz', function()

        local budget = 14000000
        local resources = {
            {name = "stone", price = 10000},
            {name = "metal", price = 8500},
            {name = "gold", price = 230000}
        }
        
        print("�������� ������:", budget)
        
        local total_resources = #resources
        local even_budget_per_resource = budget / total_resources
        local bytes = 0
        for _, resource in ipairs(resources) do
            local quantity = math.floor(even_budget_per_resource / resource.price)
            local total_cost = quantity * resource.price
            bytes = bytes + total_cost
            print("������������ ����������", resource.name, "������� ����� ������:", quantity)
        end
        
        AFKMessage(14000000 - bytes)

        -- AFKMessage( / 248500)

        -- local budget = 14000000
        -- local resources = {
        --     {name = "stone", price = 10000},
        --     {name = "metal", price = 8500},
        --     {name = "obsidian", price = 230000}
        -- }

        -- print("�������� ������:", budget)

        -- -- ������� �������� ����� ��������� ���� ��������
        -- local total_cost = 0
        -- for _, resource in ipairs(resources) do
            
        -- -- AFKMessage(total_cost)
        --     total_cost = total_cost + resource.price
        -- end
        -- AFKMessage(total_cost)

        -- -- ����������� ������ ���������� ����� ����� ���������
        -- for _, resource in ipairs(resources) do
        --     local quantity = math.floor(budget / total_cost)
        --     local cost = quantity * resource.price
        --     budget = budget - cost
        --     print("������������ ����������", resource.name, "������� �� ����� ������:", quantity)
        -- end
        -- AFKMessage(budget)
        -- GetMoneyLimit()
    end)
    sampRegisterChatCommand('fixz', function()
        resetIO();
    end)
    sampRegisterChatCommand('crr', function()
        kifir = 1.00
        show_menu = not show_menu
        renderWindow[0] = show_menu
        if replace_window[0] then
            bot_helper[0] = not bot_helper[0]
        end
        if show_menu == true then
            -- resetIO();
            zzztime = os.clock()
        end
        
        -- if faCheck and mimguiCheck and mblurCheck and effilCheck then
        --     window[0] = not window[0]
        -- else
        --     AFKMessage('{ff3535}[Error]:{ffffff} �� ��������� �������, ������ ��� ��������, ���������� ��� �����������.')
        --     checkLibs()
        --     thisScript():unload()
        -- end
    end)

    sampRegisterChatCommand('grass', function()
        lua_thread.create(function()
            setVirtualKeyDown(0x1B, true)
            wait(1)
            setVirtualKeyDown(0x1B, false)
        end)
    end)
    sampRegisterChatCommand('getping', function(arg) -- arg ������ ���� ���� ������
        ping = sampGetPlayerPing(arg)
        sampAddChatMessage('���� ������ '..sampGetPlayerNickname(arg)..' - '..ping..' set to>> '..ping*3, -1) 
    end)
    sampRegisterChatCommand('za', function(arg) -- arg ������ ���� ���� ������
        
    end)
    sampRegisterChatCommand('sec', function(arg)
        if tostring(arg) ~= 'nil' then
            zaderzhka_mainfunc = tonumber(arg)
            AFKMessage(arg..' << zaderzhka_mainfunc set to')
        end
    end)
    sampRegisterChatCommand('secc', function(arg)
        if tostring(arg) ~= 'nil' then
            zaderzhka_mainfunc_odin = tonumber(arg)
            AFKMessage(arg..' << zaderzhka_mainfunc_odin set to')
        end
    end)
    sampRegisterChatCommand('seccc', function(arg)
        if tostring(arg) ~= 'nil' then
            dialog_wait = tonumber(arg)
            AFKMessage(arg..' << dialog_wait[sell] set to')
        end
    end)
    sampRegisterChatCommand('ccc', function()
        s:sendChat('#Freym_tech', ':Lynx.MindForge.org 353 [0][-1]Freym1 = #Freym_tech :[0][-1]Freym1 ~@+Freym ')
    end)
    
    
    sampRegisterChatCommand('jaba', function()
        
        local str = "(22)Azuki_Jeezly"

        local result = str:match("%(%d+%)%s*(%S+)")
        
        if result then
            print(result)  -- Azuki_Jeezly
        else
        end
        -- local currentTime = os.time()
        -- local path = os.getenv("USERPROFILE") .. "\\Documents\\GTA San Andreas User Files\\SAMP\\chatlog.txt"
        -- for line in io.lines(path) do
        --     local timestamp, text = string.match(line, "^%[(%d+:%d+:%d+)%] (.+)")
        --     if timestamp and text then
        --         local status = checkMessageTime('['..timestamp..'] '..text)
        --         if status ~= false then
        --             print(status)
        --         end
        --     end
        -- end
    

        -- local file = io.open(os.getenv("USERPROFILE") .. "\\Documents\\GTA San Andreas User Files\\SAMP\\chatlog.txt", "r")
        -- if file then
        --     local content = file:read("*a")
        --     -- AFKMessage(tostring(content))
        --     print(content)
        --     -- for i in magiclines(content) do
        --     --     print(i)
        --     --     -- print(timeStringToTimestamp(i)..i)
        --     --     -- if timeStringToTimestamp(i) < os.time() then
        --     --     --     AFKMessage(i)
        --     --     -- end
        --     -- end
        --     file:close()
        -- end
        -- s:jaba('jaba', 'jabka', 'jabwka') 
    end)
    sampRegisterChatCommand('gag', function()
        local scripts = {
            ["AutoCloseBanner"] = {png = 'https://imgur.com/e4zwNGo', description = '����� ��������� ������ ��������\n��������� �������� �� ����.', link = 'https://raw.githubusercontent.com/FREYM1337/forumnick/main/lib/inflate-bit32.lua'},
            ["AcsHelper"] = {png = 'https://imgur.com/21pySOA', description = '����� ��������� �� ������ ������ �����\n��� ����� �������� ������� ���', link = 'https://raw.githubusercontent.com/FREYM1337/forumnick/main/lib/inflate-bit32.lua'},
        }
        writeJsonFile(scripts, "moonloader/ArzMarket/resource/scripts_list1.json")
    end)
    
    sampRegisterChatCommand('vlad', function()
        -- scan_sell = true
        
        -- item_tab = {}
        -- -- window[0] = false
        -- sampSendChat('/stats')
        ready_send_message = false
        s:prepart('#Freym_tech')
        lua_thread.terminate(room_upd_irc_en)
        -- AFKMessage("����������� � IRC irc.mindforge.org")
        
        AFKMessage("����������� � IRC")
        s:join("#Freym_tech")
        -- irc_name = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))..os.time()
        room_upd_irc_en = lua_thread.create(room_upd_irc) 
        -- table.insert(messages, '�����������������������')
    end)
    sampRegisterChatCommand('enb', function()
        blur_rgb_window[0] = false
        right_menu_blur[0] = false
        left_menu_blur[0] = false
        ini.cfg.left_menu_blur = left_menu_blur[0]
        ini.cfg.right_menu_blur = right_menu_blur[0]
        ini.cfg.blur_rgb_window = blur_rgb_window[0]
        save_all()
        AFKMessage('+enb')
    end)
    
    sampRegisterChatCommand('past', function()
        mobile_jostik[0] = not mobile_jostik[0]
        -- replace_logger[0] = not replace_logger[0]
        -- trade_chatM = {}

        -- -- lua_thread.create(function()
        -- trade_chat[0] = true
        -- -- end)
        -- local path = os.getenv("USERPROFILE") .. "\\Documents\\GTA San Andreas User Files\\SAMP\\chatlog.txt"
        -- for line in io.lines(path) do
        --     local timestamp, text = string.match(line, "^%[(%d+:%d+:%d+)%] (.+)")
        --     if timestamp and text then
        --         local status = checkMessageTime('['..timestamp..'] '..text)
        --         if status ~= false then
        --             local name, id, color, message = status:match('([^%s]+)%[(%d+)%]%s+�������:%s*{([^}]+)}%s+(.*)')
        --             if name == trader_name and color == 'B7AFAF' and message ~= nil then
        --                 table.insert(trade_chatM, name..'['..id..'] �������: {B7AFAF}'..message)
        --             end
        --         end
        --     end
        -- end
        -- aboba()
        -- trade_chatM = {}
        -- trade_chat[0] = not trade_chat[0]
        
        -- local path = os.getenv("USERPROFILE") .. "\\Documents\\GTA San Andreas User Files\\SAMP\\chatlog.txt"
        -- for line in io.lines(path) do
        --     local timestamp, text = string.match(line, "^%[(%d+:%d+:%d+)%] (.+)")
        --     if timestamp and text then
        --         local status = checkMessageTime('['..timestamp..'] '..text)
        --         if status ~= false then
        --             print(status)
        --             local name, id, color, message = status:match('([^%s]+)%[(%d+)%]%s+�������:%s*{([^}]+)}%s+(.*)')
        --             if name then
        --                 AFKMessage(name..' '..color..' '..message)
        --             end
        --             if name == 'Freym_' and color == 'B7AFAF' and message ~= nil then
        --                 table.insert(trade_chatM, name..'['..id..'] �������: {B7AFAF}'..message)
        --             end
        --         end
        --     end
        -- end
    
    end)
    sampRegisterChatCommand('lavka', function()
        local can_place = true
		for j=0, 2048 do
			if sampIs3dTextDefined(j) then
				local x2,y2,z2 = getCharCoordinates(PLAYER_PED)
				local text, color, posX, posY, posZ, distance, ignoreWalls, playerId, vehicleId = sampGet3dTextInfoById(j)
				if text:find('���������� ��������.') then
                    if getDistanceBetweenCoords3d(posX, posY, posZ, x2, y2, z2) >= 5  then
                    else
                        can_place = false
                        AFKMessage('�� ���� ���������')
                    end
				end
				if text:find('����� �������') then
                    if getDistanceBetweenCoords3d(posX, posY, posZ, x2, y2, z2) < 25 then
                        can_place = false
                    end
                end
			end
		end
        if can_place == true then
            sampSendChat('/lavka')
        end
    end)
   
    sampRegisterChatCommand('cs', function()
        local exp = 92
        local expNeeded = 4
        local playerLevel = 1

        while exp >= expNeeded do
            playerLevel = playerLevel + 1
            exp = exp - expNeeded
            expNeeded = expNeeded * 2
        end
        AFKMessage("��� �������: " .. playerLevel)
        AFKMessage("���� �� ���������� ������: " .. (expNeeded - exp))
    end)
    sampRegisterChatCommand('kk', function(arg)
        -- if tonumber(arg) ~= nil then
        --     kapibara(tonumber(arg))
        -- end
        lets_gooooo = false
        -- AFKMessage(GetSlot_IdByName('������',3))
        -- AFKMessage(tostring(item_list[0].name))
    end)
    
    while true do
    wait(0) -- //TODO main func
    
        -- if turn_left == true then
        --     setGameKeyState(0, -128)
        --     -- turn_left = false
        -- end
        -- press_gas()
        if lets_go == true then
            lets_go = nil
            wait_dialog_d[1]:terminate()
            wait_dialog_d = {}
        end
        if lets_goo == true then
            lets_goo = nil
            wait_dialog_d[1] = lua_thread.create(wait_dialog)
        end
        if lets_gooo == true then
            lets_gooo = nil
            sell_alitems_d = lua_thread.create(sell_alitems)
        elseif lets_gooo == false then
            lets_gooo = nil
            sell_alitems_d:terminate()
            -- wait_end = false
            if wait_dialog_d[1] ~= nil then
                lets_go = true
            end
            if kapibara_s[1] ~= nil then
                lets_goooo = false
            end
            sell_alitems_d = nil
        end
        if lets_goooo == true then
            lets_goooo = nil
            kapibara_s[1] = lua_thread.create(kapibara)
        elseif lets_goooo == false then
            kapibara_s[1]:terminate()
            lets_goooo = nil
            kapibara_s = {}
        end
        if lets_gooooo == true then
            lets_gooooo = nil
            scan_items_s[1], scan_items_s[2] = lua_thread.create(scan_items), true
        elseif lets_gooooo == false then
            lets_gooooo = nil
            scan_items_s[1]:terminate()
            AFKMessage('terminate')
            scan_items_s[1], scan_items_s[2] = nil, false
        end
        if lavka_helper[0] then
            for j=0, 2048 do
                if sampIs3dTextDefined(j) then
                    local x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    local text, color, posX, posY, posZ, distance, ignoreWalls, playerId, vehicleId = sampGet3dTextInfoById(j)
                    if text:find('���������� ��������.') then
                        drawCircleIn3d(posX, posY, posZ,5,40,getDistanceBetweenCoords3d(posX, posY, posZ, x2, y2, z2) < 5 and 10 or 0.5,getDistanceBetweenCoords3d(posX, posY, posZ, x2, y2, z2) < 5 and 0xfff70000 or 0xFFFFFFFF)
                    end
                    if text:find('����� �������') then
                        drawCircleIn3d(posX, posY, posZ-1,25,40,getDistanceBetweenCoords3d(posX, posY, posZ, x2, y2, z2) < 25 and 10 or 0.5,getDistanceBetweenCoords3d(posX, posY, posZ, x2, y2, z2) < 25 and 0xfff70000 or 0xFFFFFFFF)
                    end
                end
            end
        end
    end
end


function drawCircleIn3d(x, y, z, radius, polygons,width,color)
    local step = math.floor(360 / (polygons or 36))
    local sX_old, sY_old
    for angle = 0, 360, step do
        local lX = radius * math.cos(math.rad(angle)) + x
        local lY = radius * math.sin(math.rad(angle)) + y
        local lZ = z
        local _, sX, sY, sZ, _, _ = convert3DCoordsToScreenEx(lX, lY, lZ)
        if sZ > 1 then
            if sX_old and sY_old then
                renderDrawLine(sX, sY, sX_old, sY_old, width, color)
            end
            sX_old, sY_old = sX, sY
        end
    end
end

function aboba()
    -- trade_chat[0] = true
    print('+')
end

function scan_items()
    while true do
        wait(0)
        AFKMessage('scan_items()')
        if txd_id[scan_info[3] + 1] == nil and scan_busy == false then
            AFKMessage('nil?? off')
            lets_gooooo = false
            wait(100)
        end
        if scan_info[1] ~= nil and scan_busy == false and txd_id[scan_info[3] + 1] ~= nil then
            -- scan_busy = true
            -- txd_id[0]
            -- AFKMessage('wait???')
            AFKMessage(txd_id[scan_info[3]+1][1])
            -- if txd_id[scan_info[3]][1]
            wait(0)
            AFKMessage('wait end')
            for i, k in pairs(txd_id) do
                if tonumber(scan_info[3]) == k[2] then
                    AFKMessage('find slot '..k[1]..' '..k[2])
                    if k[3] == 0 then
                        AFKMessage('error! item blocked by server, skip.')
                        break
                    end
                    AFKMessage('click on >>')
                    -- sampSendClickTextdraw(k[1])
                    scan_busy = true
                    wait_dialog_d[2] = k[1]
                    lets_goo = true
                end
            end
            AFKMessage('scan_info[3] = scan_info[3] + 1')
            scan_info[3] = scan_info[3] + 1 


        end
        
        -- wait(1)
    end
end




function sell_alitems()
    while true do
        wait(0) -- //TODO sell_alitems
    -- AFKMessage('FF??F?F?F')
        -- AFKMessage(tostring(sell_busy)..' sell_busy << '..tostring(is_invent_open)..' '..tostring(display.sell))
        if (is_invent_open ~= nil) and (display.sell and (display.score <= display.score_from)) and sell_busy == false then -- 
            -- AFKMessage(tostring(display.score)..' <<>> '.. tostring(display.score_from))

            -- if tonumber(item_sell.count) <= tonumber(data.all_count) then 
            AFKMessage('++ poka 4to 1000, nado izmenit na 100 [main func]')
            
            --     local data = {name = data.item, price = item_sell.price, count = item_sell.count, slot_id = data.slot_id, all_count = data.all_count}
            --     addToData(data, sell_list)
            -- else
            --     AFKMessage('+22+')
            --     local data = {name = data.item, price = item_sell.price, count = data.count, slot_id = data.slot_id, all_count = data.all_count}
            --     addToData(data, sell_list)
            -- end
            -- local data = {name = data.item, price = item_sell.price, count = item_sell.count, slot_id = data.slot_id, all_count = data.all_count}
            -- item_list[display.score].count..','..item_list[display.score].price
            ::next::
            if display.score ~= 0 then
                if need_to_sell > 0 then
                    AFKMessage(need_to_sell..' NEED TO SELL!')
                    next_stage = false
                else
                    AFKMessage('next_stage_check???')
                    next_stage = true
                end
            else
                AFKMessage('CHECK1')
                next_stage = true
            end
            AFKMessage('wtf?')
            -- AFKMessage(display.score)
            if next_stage == true then
                AFKMessage("NEXT STAGE")
                display.score = display.score + 1
                if (display.score > display.score_from) and display.sell then
                    last_stranica = 1
                    cancel_sellorbuy[0] = false
                    AFKMessage('����������� ������� ���������.')
                    display = {sell = false, score = 1, score_from = 1}
                    AFKMessage('goto skips')
                    lets_gooo = false
                    goto skips
                end
                need_to_sell = sell_list[display.score].maximum and 999999 or tonumber(sell_list[display.score].count) -- tonumber(sell_list[display.score].count)
                AFKMessage('need to sell >> '..tostring(need_to_sell))
                need_slot = 1
            end
            AFKMessage('check SKIP>> sell_list[display.score].enabled '..tostring(sell_list[display.score].enabled))
            if sell_list[display.score].enabled == false then
                AFKMessage('check skip>> next_stage. '..tostring(sell_list[display.score].name))
                need_to_sell = 0
                sell_busy = false
                -- next_stage = true
                AFKMessage('goto next')
                goto next
            end
            
            -- for i = 1, 5 do
                -- sell_list[display.score].count // BUG DBUG 
                -- if sell_list[display.score].slot_id[need_slot] then
                --     AFKMessage('ne nil')
                -- else
                --     AFKMessage('nil-')
                -- end
                AFKMessage('COUNT?? '..tostring(sell_list[display.score].slot_count[need_slot])..' need_slot '..tostring(need_slot)..' display.score '..tostring(display.score))
                AFKMessage('NEED TO SELL:['..tostring(sell_list[display.score].name)..']|slotid '..tostring(sell_list[display.score].slot_id[need_slot])..'('..tostring(sell_list[display.score].slot_count[need_slot])..')|all_count: '..tostring(sell_list[display.score].all_count))
                -- sell_list[display.score].count = sell_list[display.score].count - sell_list[display.score].slot_count[need_slot]
            -- end
            AFKMessage(tostring(sell_list[display.score].slot_count[need_slot])..' >??>>?>? sell_list[display.score].slot_count[need_slot]')
            -- if sell_list[display.score].slot_count[need_slot] == nil then
            --     AFKMessage('check on missing slot? ok, skip.')
            --     AFKMessage('goto skips')
            --     need_to_sell = 0
            --     sell_busy = false
            --     goto skips
            -- end
            sell_list[display.score].slot_count[need_slot] = GetItemCountByName(sell_list[display.score].name, need_slot)
            AFKMessage('now sell_list[display.score].slot_count[need_slot] >> '..tostring(sell_list[display.score].slot_count[need_slot]))
            do
                local slot_id = GetSlot_IdByName(sell_list[display.score].name, need_slot);
                AFKMessage('slotid???? >?> '..tostring(slot_id))
                if slot_id == nil then
                    AFKMessage('slot_id missing... SKIP!')
                    need_to_sell = 0
                    sell_busy = false
                    AFKMessage('goto next')
                    goto next
                end
                sell_busy = true
                wait(zaderzhka_mainfunc_odin)
                if (tonumber(slot_id) > 35 and tonumber(slot_id) < 72) and (last_stranica ~= 2) then 
                    tblid = 36
                    txd_id = {}
                    last_stranica = 2
                    sampSendClickTextdraw(buttons_id + 3) -- ������ 2
                    wait(zaderzhka_mainfunc)
                elseif (tonumber(slot_id) > 71 and tonumber(slot_id) < 108) and (last_stranica ~= 3) then 
                    tblid = 72
                    txd_id = {}
                    last_stranica = 3
                    sampSendClickTextdraw(buttons_id + 4) -- ������ 3
                    wait(zaderzhka_mainfunc)
                elseif (tonumber(slot_id) > 107 and tonumber(slot_id) < 144) and (last_stranica ~= 4) then 
                    tblid = 108
                    txd_id = {}
                    last_stranica = 4
                    sampSendClickTextdraw(buttons_id + 5) -- ������ 4
                    wait(zaderzhka_mainfunc)
                elseif (tonumber(slot_id) > 143 and tonumber(slot_id) < 180) and (last_stranica ~= 5) then 
                    tblid = 144
                    txd_id = {}
                    last_stranica = 5
                    sampSendClickTextdraw(buttons_id + 6) -- ������ 5
                    wait(zaderzhka_mainfunc)
                elseif (tonumber(slot_id) < 36) and (last_stranica ~= 1) then 
                    tblid = 0
                    txd_id = {}
                    last_stranica = 1
                    sampSendClickTextdraw(buttons_id + 2) -- ������ 1
                    wait(zaderzhka_mainfunc)
                end
                AFKMessage('kapibara(slot_id) '..sell_list[display.score].name)
                
                -- printString('~Y~'..tostring(sell_list[display.score].name), 6000)
                -- kapibara(slot_id)
                kapibara_s[2] = slot_id
                lets_goooo = true
            end
            -- AFKMessage(tostring(slot_id)..' WFWIFNAWUIOFNAWIUFNAWIFNWA')
            -- AFKMessage(tostring(sell_list[display.score].slot_id[1]))
            AFKMessage('pered ::skips::')
            -- ::skip::
            ::skips::
            AFKMessage('POSLE ::skips::')
            -- AFKMessage(sell_list[display.score].price..' '..sell_list[display.score].name..' >> '..sell_list[display.score].slot_id[need_slot])
        end
    end
end


function kapibara() -- // TODO kapibara(kapibara_s[2])
    -- local wait_end = true
    AFKMessage('try click? >> '..tostring(kapibara_s[2]))
    print('pered>> '..kapibara_s[2])
    -- lua_thread.create(function()
        while true do
            AFKMessage('wait some sec...')
            for i, k in pairs(txd_id) do
                if tonumber(kapibara_s[2]) == k[2] then
                    print('[PERED_CLICK] ['..tostring(k[1])..'] ['..tostring(k[2])..'] >>> need to pick '..tostring(kapibara_s[2]))
                    if k[3] == 0 then
                        sell_busy = false
                        -- need_to_sell = 0
                        need_slot = need_slot + 1
                        AFKMessage('error! item blocked by server, skip.')
                        print('[blocked] ['..tostring(k[1])..'] ['..tostring(k[2])..'] >>> need to pick '..tostring(kapibara_s[2]))
                        -- wait_end = false
                        lets_goooo = false
                        AFKMessage('pered return false')
                        break
                    end
                    AFKMessage('posle return false')
                    -- wait_end = false
                    lets_goooo = false
                    -- sampSendClickTextdraw(k[1])
                    AFKMessage('click o4ered >> '..tostring(k[1]))
                    wait_dialog_d[2] = k[1]
                    lets_goo = true
                    -- last_sound_id = nil
                    print('[CLICK] txd?: ['..tostring(k[1])..'] ['..tostring(k[2])..'] >>> need to pick '..tostring(kapibara_s[2]))
                    -- return false
                    
                end 
                -- sampSendClickTextdraw(k)
                -- msg(k[1]..' '..k[2])
                print('txd?: ['..tostring(k[1])..'] ['..tostring(k[2])..'] >>> need to pick '..tostring(kapibara_s[2]))
                -- sampAddChatMessage(tostring(k[1]),-1)
                -- table.remove(txd_id, i)
                -- wait(1500)
            end
            print('posle>> '..kapibara_s[2])
            wait(100)
        end
    -- end)
end


imgui.OnInitialize(function()
    
    -- show_menu = not show_menu
    -- renderWindow = imgui.new.bool(show_menu)
    fonts = loadFonts({17,24,27,19,18}) -- // TODO imgui.OnInitialize
    arizona = imgui.CreateTextureFromFile(u8(getWorkingDirectory() .. '/logo.png'))
    banner = imgui.CreateTextureFromFile(u8(getWorkingDirectory() .. '/banner.png'))
    -- arizonas = imgui.CreateTextureFromFile(u8(getWorkingDirectory() .. '/v2.png'))
    sampAddChatMessage('+',-1)
    print('+')
    auto_load_config()
    imgui.GetIO().IniFilename = nil
    imgui.FrameTheme()
    -- theme()
end)

function Get_AllCountByName(name)
    for j, data_v in pairs(json_vlads) do
        -- AFKMessage(data_v.item..' '..name)
        if data_v.item == name then
            return tonumber(data_v.all_count)
        end
    end
    return 0
end

function GetSlot_IdByName(name, slot)
    if readJsonFile(items_sell) ~= nil then
        for k, data in pairs(readJsonFile(items_sell)) do
            if data.item == name then
                AFKMessage('dbu1g '..data.item..' >><< '..name)
                return data.slot_id[slot]
            end
            -- AFKMessage(tostring(data.item)..' '..tostring(data.slot_id[1]))
        end
    end
end

function GetItemCountByName(name, slot)
    if readJsonFile(items_sell) ~= nil then
        for k, data in pairs(readJsonFile(items_sell)) do
            if data.item == name then
                AFKMessage('G_dbu1gG data.count '..data.item..' >><< '..name.. ' '..tostring(data.count[slot]))
                return data.count[slot]
            end
            -- AFKMessage(tostring(data.item)..' '..tostring(data.slot_id[1]))
        end
    end
end

function rainbow(speed, alpha)
    local clock = os.clock()
    local r = math.floor(math.sin(clock * speed) * 127 + 128)
    local g = math.floor(math.sin(clock * speed + 2) * 127 + 128)
    local b = math.floor(math.sin(clock * speed + 4) * 127 + 128)
    return {r / 255, g / 255, b / 255, alpha}
end

function run()
    lua_thread.create(function()
        wait(0)
        setGameKeyState(1, -255)
    end)
end

function go_back()
    lua_thread.create(function()
        wait(0)
        setGameKeyState(1, 255)
    end)
end

function enter()
    lua_thread.create(function()
        wait(0)
        setGameKeyState(15, 255)
    end)
end

function turn_right()
    lua_thread.create(function()
        wait(0)
        setGameKeyState(0, 128)
    end)
end

function go_right()
    lua_thread.create(function()
        wait(0)
        setGameKeyState(0,1024)
    end)
end

function go_left()
    lua_thread.create(function()
        wait(0)
        setGameKeyState(0,-1024)
    end)
end

function turn_left()
    lua_thread.create(function()
        wait(0)
        setGameKeyState(0, -128)
    end)
end

function press_gas()
    lua_thread.create(function()
        wait(0)
        writeMemory(0xB73458 + 0x20, 1, 255, false)
    end)
end

function press_brake()
    lua_thread.create(function()
        wait(0)
	    writeMemory(0xB73458 + 0x20, 2, -255, false)
    end)
end

function press_any_key(key)
    lua_thread.create(function()
        wait(0)
        setVirtualKeyDown(key, true)
        wait(100)
        setVirtualKeyDown(key, false)
    end)
end


-- // TODO imgui.OnFrame(
local newFrame = imgui.OnFrame(

    function() return (renderWindow[0] or scan_button[0] or auto_full_button[0] or emule_dialog[0] or cancel_sellorbuy[0] or mobile_jostik[0] or sell_filter[0] or trade_chat[0]) end,
    function(player)
        if trade_chat[0] and trade_menu ~= nil and not renderWindow[0] then
            local resolutionX, resolutionY = getScreenResolution()
            local p = imgui.GetCursorScreenPos()
            if imgui.IsMouseDown(1) then
                player.HideCursor = true
            end
            local sizeXX, sizeYY = 400, 250
            
            imgui.SetNextWindowPos(imgui.ImVec2(trade_menu.x, trade_menu.y),imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.SetNextWindowSize(imgui.ImVec2(sizeXX, sizeYY), imgui.Cond.Always)
            imgui.Begin('wwww', trade_chat, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoBackground)
            local clr = imgui.Col
            imgui.PushStyleColor(clr.WindowBg, imgui.ImVec4(current_theme.window[1], current_theme.window[2], current_theme.window[3], current_theme.window[4] + 0.1))
            imgui.PushStyleColor(clr.ChildBg, imgui.ImVec4(current_theme.window[1], current_theme.window[2], current_theme.window[3], current_theme.window[4] - 0.1))
            imgui.PushStyleColor(clr.PopupBg, imgui.ImVec4(current_theme.window[1], current_theme.window[2], current_theme.window[3], current_theme.window[4] + 0.1))
            mimgui_blur.apply(imgui.GetWindowDrawList(), 15)
            
            imgui.BeginChild('wwwww')
            local p = imgui.GetCursorScreenPos() 
            
            imgui.CustomInvisibleChild('chatMAIN', imgui.ImVec2(sizeXX, sizeYY), false, imgui.WindowFlags.NoScrollbar)
            imgui.PushFont(fonts[17])
            imgui.SetCursorPosY(imgui.GetCursorPos().y + 5)
            imgui.CenterText(u8'��� � ���������.')
            imgui.CustomSeparator(imgui.GetWindowWidth())
            
            imgui.SetCursorPosX(imgui.GetCursorPos().x + 5)
            round_text(1)
            imgui.CustomInvisibleChild('ChatPage', imgui.ImVec2(sizeXX - 10, sizeYY - 80), true)
            round_text(0)
            
            imgui.SetCursorPosY(imgui.GetCursorPos().y + 5)
            if (trade_chatM and #trade_chatM ~= 0) then
                local messages = trade_chatM
                local clipper = imgui.ImGuiListClipper(#messages)
                while clipper:Step() do
                    for i = clipper.DisplayStart + 1, clipper.DisplayEnd do
                        if messages[i] ~= nil then
                            imgui.SetCursorPosX(imgui.GetCursorPos().x + 5)
                            imgui.TextColoredRGB(messages[i])
                            if #messages -1 == i then
                                imgui.SetScrollY(imgui.GetScrollMaxY())
                            end
                        end
                    end
                end
            else
                imgui.SetCursorPosX(imgui.GetCursorPos().x + 5)
                imgui.TextDisabled(u8'������� ��������� �����.')
            end

            imgui.EndCustomInvisibleChild()
            imgui.SetCursorPosY(imgui.GetCursorPos().y + 5)
            imgui.SetCursorPosX(imgui.GetCursorPos().x + 10)
            imgui.PushItemWidth(300)
            if imgui.InputTextWithHintD("##trade_message", u8"������� ���������", trade_message, ffi.sizeof(trade_message), imgui.InputTextFlags.EnterReturnsTrue) then
                imgui.SetKeyboardFocusHere()
                local message = u8:decode(ffi.string(trade_message))
                sampSendChat(message)
                -- table.insert(trade_chatM, '[��] �������: '..message)
                imgui.StrCopy(trade_message, '')
            end
            imgui.SameLine()
            imgui.GetStyle().FrameBorderSize = border_side[0] and 1 or 0
            if imgui.Button(u8"���������") then
                local message = u8:decode(ffi.string(trade_message))
                sampSendChat(message)
                -- table.insert(trade_chatM, '[��] �������: '..message)
                imgui.StrCopy(trade_message, '')
            end
            imgui.GetStyle().FrameBorderSize = 0
            imgui.PopFont()
            imgui.EndCustomInvisibleChild()
            imgui.GetWindowDrawList():AddRect(p, imgui.ImVec2(p.x + sizeXX, p.y + sizeYY), imgui.GetColorU32Vec4(imgui.ImVec4(current_theme.Border[1], current_theme.Border[2], current_theme.Border[3], current_theme.Border[4])), 5, 0, rgb_width[0])
            imgui.EndChild()
            imgui.PopStyleColor(3)
            imgui.End()
        end
        if mobile_jostik[0] then
            -- player.HideCursor = true
            
            local resX, resY = getScreenResolution()
            local sizeX, sizeY = resX, 150
            imgui.SetNextWindowPos(imgui.ImVec2(resX , resY / 14.4), imgui.Cond.FirstUseEver, imgui.ImVec2(1, 0.5))
            imgui.SetNextWindowSize(imgui.ImVec2(sizeX, sizeY), imgui.Cond.FirstUseEver)
            imgui.Begin('mobile_jostik_knopki', renderWindow, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoBackground)
            -- local dl = imgui.GetWindowDrawList()
            local p = imgui.GetCursorScreenPos()
            local dl = imgui.GetWindowDrawList()
            
            if left_menu_blur[0] == true then
                mimgui_blur.apply(imgui.GetWindowDrawList(), blur_count[0])
                -- AFKMessage('mimgui_blur_1')
            end
            imgui.CustomInvisibleChild('mobile_jostik_knopki_ch', imgui.ImVec2(sizeX, sizeY), true, imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse)

            imgui.PushFont(fonts[24])
            for k, v in pairs(mobile_jostik_buttons.list) do
                if imgui.Button(v, imgui.ImVec2(resX / 12.3, sizeY)) then
                    press_any_key(mobile_jostik_buttons.keys[k])
                end
                imgui.SameLine()
            end
            imgui.PopFont()
            dl:AddRectFilled(imgui.ImVec2(p.x, p.y), imgui.ImVec2(p.x + sizeX, p.y + sizeY+2.6), imgui.GetColorU32Vec4(imgui.ImVec4(color_window[0], color_window[1], color_window[2], color_window[3])), 5, 0)
            imgui.GetWindowDrawList():AddRect(p, imgui.ImVec2(p.x + sizeX, p.y + sizeY), imgui.GetColorU32Vec4(imgui.ImVec4(current_theme.Border[1], current_theme.Border[2], current_theme.Border[3], current_theme.Border[4])), 5, 0, rgb_width[0])
            imgui.EndCustomInvisibleChild()
            imgui.End()

            if is_invent_open_mobile == nil then
                local resX, resY = getScreenResolution()
                local sizeX, sizeY = 800, 500
                imgui.SetNextWindowPos(imgui.ImVec2(resX / 1.01, resY / 1.5), imgui.Cond.FirstUseEver, imgui.ImVec2(1, 0.5))
                imgui.SetNextWindowSize(imgui.ImVec2(sizeX, sizeY), imgui.Cond.FirstUseEver)
                imgui.Begin('mobile_jostik', renderWindow, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoBackground)
                -- local dl = imgui.GetWindowDrawList()
                local sizeX, sizeY = 800, isCharInAnyCar(PLAYER_PED) and 200 or 500
                local p = imgui.GetCursorScreenPos()
                local dl = imgui.GetWindowDrawList()
                local px, py
                -- if left_menu_blur[0] == true then
                --     mimgui_blur.apply(imgui.GetWindowDrawList(), blur_count[0])
                -- end
                -- dl:AddRectFilled(imgui.ImVec2(p.x, p.y), imgui.ImVec2(p.x + sizeX, p.y + sizeY+2.6), imgui.GetColorU32Vec4(imgui.ImVec4(color_window[0], color_window[1], color_window[2], color_window[3])), 5, 0)
                -- imgui.SetCursorPosX(imgui.GetCursorPos().x + 10)
                -- imgui.SetCursorPosY(imgui.GetCursorPos().y + 10) 
                if imgui.IsMouseDown(0) then
                    px, py = getCursorPos()
                    if (px < p.x or px > p.x + sizeX) or (py < p.y or py > p.y + sizeY) then else
                        if last_px ~= nil and last_py ~= nil then
                            shiftCameraByPixelsOffset((px - last_px) * 4 , isCharInAnyCar(PLAYER_PED) and 0 or (py - last_py) * 4 )
                        end
                        last_px, last_py = px, py
                        -- run()
                    end
                else
                    last_px = nil
                end
                
                imgui.CustomInvisibleChild('mobile_jostik_Child', imgui.ImVec2(sizeX, sizeY), true, imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse)
                if px ~= nil and py ~= nil then
                    imgui.GetWindowDrawList():AddCircle(imgui.ImVec2(px , py ), 125.5, imgui.GetColorU32Vec4(imgui.ImVec4(current_theme.Border[1], current_theme.Border[2], current_theme.Border[3], current_theme.Border[4])), 50, 1)
                    imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(px , py ), 125.5, imgui.GetColorU32Vec4(imgui.ImVec4(0.08, 0.09, 0.19, 0.6)), 50, 2)
                end
                imgui.GetWindowDrawList():AddRect(p, imgui.ImVec2(p.x + sizeX, p.y + sizeY), imgui.GetColorU32Vec4(imgui.ImVec4(current_theme.Border[1], current_theme.Border[2], current_theme.Border[3], current_theme.Border[4])), 5, 0, rgb_width[0])
                imgui.EndCustomInvisibleChild()
                if isCharInAnyCar(PLAYER_PED) then
                    imgui.CustomInvisibleChild('mobile_jostik_Child_leftRight', imgui.ImVec2(sizeX, sizeY), true, imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse)
                    local dl = imgui.GetWindowDrawList()
                    local p = imgui.GetCursorScreenPos()
                    -- dl:AddCircle(imgui.ImVec2(p.x + 240, p.y + 100), 95, imgui.GetColorU32Vec4(imgui.ImVec4(current_theme.Border[1], current_theme.Border[2], current_theme.Border[3], current_theme.Border[4])), 50, 1)
                    dl:AddCircleFilled(imgui.ImVec2(p.x + 240, p.y + 100 ), 95, imgui.GetColorU32Vec4(imgui.ImVec4(0.08, 0.09, 0.19, 0.3)), 50, 1)
                    imgui.SetCursorPos(imgui.ImVec2(imgui.GetWindowWidth() / 5.3, 10))
                    imgui.PushFont(fonts[24])
                    imgui.CustomOnlyBorderButton(u8'BRAKE', imgui.ImVec2(180, 180))
                    
                    if imgui.IsItemHovered() and imgui.IsMouseDown(0) then
                        press_brake()
                    end
                    if isKeyDown(0x25) then
                        turn_left()
                    elseif isKeyDown(0x27) then
                        turn_right()
                    end
                    -- dl:AddCircle(imgui.ImVec2(p.x + 540, p.y + 100), 95, imgui.GetColorU32Vec4(imgui.ImVec4(current_theme.Border[1], current_theme.Border[2], current_theme.Border[3], current_theme.Border[4])), 50, 1)
                    dl:AddCircleFilled(imgui.ImVec2(p.x + 540, p.y + 100), 95, imgui.GetColorU32Vec4(imgui.ImVec4(0.08, 0.09, 0.19, 0.3)), 50, 1)
                    imgui.SetCursorPos(imgui.ImVec2(imgui.GetWindowWidth() / 1.78, 10))
                    imgui.CustomOnlyBorderButton(u8'GAS', imgui.ImVec2(180, 180))
                    if imgui.IsItemHovered() and imgui.IsMouseDown(0) then
                        press_gas()
                    end
                    imgui.PopFont()
                    imgui.EndCustomInvisibleChild()
                else
                    if isKeyDown(0x25) then
                        go_left()
                    elseif isKeyDown(0x27) then
                        go_right()
                    elseif isKeyDown(0x28) then 
                        go_back()
                    elseif isKeyDown(0x26) then 
                        run()
                    end
                end
                imgui.End()
                local sizeX, sizeY = 300, 150
                imgui.SetNextWindowPos(imgui.ImVec2(resX, resY / 2.7), imgui.Cond.FirstUseEver, imgui.ImVec2(1, 0.5))
                imgui.SetNextWindowSize(imgui.ImVec2(sizeX, sizeY), imgui.Cond.FirstUseEver)
                imgui.Begin('mobile_jostik_car', renderWindow, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoBackground)
                local dl = imgui.GetWindowDrawList()
                local p = imgui.GetCursorScreenPos()
                local dl = imgui.GetWindowDrawList()

                dl:AddCircle(imgui.ImVec2(p.x + 73, p.y + 73), 55.5, imgui.GetColorU32Vec4(imgui.ImVec4(current_theme.Border[1], current_theme.Border[2], current_theme.Border[3], current_theme.Border[4])), 50, 1)
                dl:AddCircleFilled(imgui.ImVec2(p.x + 73, p.y + 73 ), 55, imgui.GetColorU32Vec4(imgui.ImVec4(0.08, 0.09, 0.19, 0.3)), 50, 1)

                imgui.SetCursorPos(imgui.ImVec2(imgui.GetWindowWidth() / 35, 14))
                imgui.PushFont(fonts[24])
                if imgui.CustomOnlyBorderButton('/lock', imgui.ImVec2(130, 120)) then
                    sampSendChat('/lock')
                end
                imgui.PopFont()

                dl:AddCircle(imgui.ImVec2(p.x + 230, p.y + 73), 55.5, imgui.GetColorU32Vec4(imgui.ImVec4(current_theme.Border[1], current_theme.Border[2], current_theme.Border[3], current_theme.Border[4])), 50, 1)
                dl:AddCircleFilled(imgui.ImVec2(p.x + 230, p.y + 73 ), 55, imgui.GetColorU32Vec4(imgui.ImVec4(0.08, 0.09, 0.19, 0.3)), 50, 1)
                -- dl:AddCircleFilled(imgui.ImVec2(px , py ), 125.5, imgui.GetColorU32Vec4(imgui.ImVec4(0.08, 0.09, 0.19, 0.6)), 50, 2)
                -- dl:AddRectFilled(imgui.ImVec2(p.x, p.y), imgui.ImVec2(p.x + sizeX, p.y + sizeY+2.6), imgui.GetColorU32Vec4(imgui.ImVec4(color_window[0], color_window[1], color_window[2], color_window[3])), 5, 0)
                -- imgui.SetCursorPosX(imgui.GetCursorPos().x + 10)
                -- imgui.SetCursorPosY(imgui.GetCursorPos().y + 10) 
                imgui.SetCursorPos(imgui.ImVec2(imgui.GetWindowWidth() / 1.7999, 14))
                imgui.PushFont(fonts[25])
                if imgui.CustomOnlyBorderButton(isCharInAnyCar(PLAYER_PED) and u8'����� �� ������' or u8'����� � ������', imgui.ImVec2(130, 120)) then
                    enter()
                end
                imgui.PopFont()
                imgui.End()
            end
        end
        if cancel_sellorbuy[0] then
            local resX, resY = getScreenResolution()
            local sizeX, sizeY = 150, 150
            imgui.SetNextWindowPos(imgui.ImVec2(resX, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(1, 0.5))
            imgui.SetNextWindowSize(imgui.ImVec2(sizeX, sizeY), imgui.Cond.FirstUseEver)
            imgui.Begin('cancel_sellorbuy', renderWindow, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoBackground)
            local dl = imgui.GetWindowDrawList()
            local p = imgui.GetCursorScreenPos()
            local dl = imgui.GetWindowDrawList()
            if left_menu_blur[0] == true then
                mimgui_blur.apply(imgui.GetWindowDrawList(), blur_count[0])
                -- AFKMessage('mimgui_blur_2')
            end
            dl:AddRectFilled(imgui.ImVec2(p.x, p.y), imgui.ImVec2(p.x + sizeX, p.y + sizeY+2.6), imgui.GetColorU32Vec4(imgui.ImVec4(color_window[0], color_window[1], color_window[2], color_window[3])), 5, 0)
            imgui.SetCursorPosX(imgui.GetCursorPos().x + 10)
            imgui.SetCursorPosY(imgui.GetCursorPos().y + 10) 
            if imgui.Button(u8'��������', imgui.ImVec2(130, 130)) then
                off_sell_buy();
            end
            imgui.End()
        end
        if replace_window[0] and renderWindow[0] then
            -- round_text(1)
            -- player.HideCursor = true
            local resX, resY = getScreenResolution()
            local sizeX, sizeY = 650, 285
            
		    local position = LogsPos.x ~= -1 and LogsPos or imgui.ImVec2(resX / 2.950, resY / 2) 
            imgui.SetNextWindowPos(position, imgui.Cond.Always, imgui.ImVec2(1, 0.5))
            imgui.SetNextWindowSize(imgui.ImVec2(sizeX, sizeY), imgui.Cond.Always)
            imgui.Begin('bot_helper', renderWindow, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoBackground)
            local dl = imgui.GetWindowDrawList()
            local p = imgui.GetCursorScreenPos()
            local dl = imgui.GetWindowDrawList()
            -- imgui.SetCursorPos(imgui.ImVec2((150 - 100) / 2, 60))
            if left_menu_blur[0] == true then
                mimgui_blur.apply(imgui.GetWindowDrawList(), blur_count[0])
                -- AFKMessage('mimgui_blur_3')
            end
            -- local p = imgui.GetCursorScreenPos()
            -- AFKMessage(alpha_s[0])
            -- local rainbow = rainbow(speed_s[0], alpha_s[0])
            dl:AddRectFilled(imgui.ImVec2(p.x, p.y), imgui.ImVec2(p.x + sizeX, p.y + sizeY+2.6), imgui.GetColorU32Vec4(imgui.ImVec4(color_window[0], color_window[1], color_window[2], color_window[3])), 5, 0)
            -- if full_dialog[1] ~= nil then
                
            imgui.SetCursorPosY(imgui.GetCursorPos().y + 5) -- CustomOnlyBorder
            imgui.PushItemWidth(649)
            -- sampAddChatMessage(search_sell[1],-1)
            imgui.NewInput(u8'                                                        ����� �� ����', search, 444)
                if imgui.Button(u8'���', imgui.ImVec2((imgui.GetWindowWidth() / 3) - 10, 27)) then
                    logMenu = 0
                end
                imgui.SameLine()
                if imgui.Button(u8'������� ����', imgui.ImVec2((imgui.GetWindowWidth() / 3) - 10, 27)) then
                    imgui.OpenPopup(u8('����� ����'))
                    
                end; changeDate()
                imgui.SameLine()
                if imgui.Button(u8'��������', imgui.ImVec2((imgui.GetWindowWidth() / 2.78) - 10, 27)) then
                    logMenu = 1
                end
                imgui.SetCursorPosX(imgui.GetCursorPos().x + 5)
                -- imgui.SetCursorPosY(imgui.GetCursorPos().y + 45) -- CustomOnlyBorder
                imgui.CustomInvisibleChild('botHelper', imgui.ImVec2(imgui.GetWindowWidth(), sizeY), true, imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse)
                imgui.PushFont(fonts[18])
                -- imgui.TextColoredRGB('{"07.07.2024":[["[01:07:54] Freym_ ����� \"���������� ������� (2 ��.)\" �� $4.268"],4268,0,0,0]}', 100)
                -- imgui.TextColoredRGB('[01:07:54] Freym_Freym ����� "���������� ������� (2 ��.)" �� $4268', 100)
                if logMenu == 0 then
                    if jsonLog ~= nil and date_select ~= nil then
                        for i = #jsonLog[date_select][1], 1, -1 do
                            imgui.SetCursorPosX(2)
                            if u8:decode(ffi.string(search)) ~= 0 and string.find(string.nlower(jsonLog[date_select][1][i]), string.nlower(u8:decode(ffi.string(search))), nil, true) then
                                imgui.TextColoredRGB(jsonLog[date_select][1][i], 100)
                            end
                        end
                    end
                else
                    if jsonLog ~= nil and date_select ~= nil then
                        local arr = {}
                        for k, v in ipairs(jsonLog[date_select][1]) do
                            local fullString = v:find('������') and v:match('������ "(.+)" ��') or v:match('"(.+)" ��')
                            local count = fullString:find('%(%d+ ��%.%)$') and fullString:match('%((%d+) ��%.%)$') or 1
                            local item = fullString:find('%(%d+ ��%.%)$') and fullString:gsub('%(%d+ ��%.%)$', '') or fullString	
                            if not arr[item] then arr[item] = {['buy'] = 0, ['sell'] = 0} end
                            arr[item][v:find('������') and 'buy' or 'sell'] = arr[item][v:find('������') and 'buy' or 'sell'] + count
                        end

                        for k, v in pairs(arr) do
                            imgui.SetCursorPosX(2)
                            imgui.TextColoredRGB(('{808080} %s {ffffff}| ������ � ����:{808080} %s {ffffff}| ������� ���:{808080} %s {ffffff}'):format(k:gsub(' $', ''), v.sell, v.buy))
                        end
                    end
                end
                imgui.PopFont()
                imgui.EndCustomInvisibleChild()
            -- end
            imgui.End()
        end
        if emule_dialog[0] then
            
            local resX, resY = getScreenResolution()
            local sizeX, sizeY = 425, 285
            imgui.SetNextWindowPos(imgui.ImVec2(resX, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(1, 0.5))
            imgui.SetNextWindowSize(imgui.ImVec2(sizeX, sizeY), imgui.Cond.FirstUseEver)
            imgui.Begin('emule_dialog', renderWindow, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoBackground)
            local dl = imgui.GetWindowDrawList()
            local p = imgui.GetCursorScreenPos()
            local dl = imgui.GetWindowDrawList()
            -- imgui.SetCursorPos(imgui.ImVec2((150 - 100) / 2, 60))
            
            if left_menu_blur[0] == true then
                mimgui_blur.apply(imgui.GetWindowDrawList(), blur_count[0])
                -- AFKMessage('mimgui_blur_4')
            end
            -- local p = imgui.GetCursorScreenPos()
            -- AFKMessage(alpha_s[0])
            -- local rainbow = rainbow(speed_s[0], alpha_s[0])
            dl:AddRectFilled(imgui.ImVec2(p.x, p.y), imgui.ImVec2(p.x + sizeX, p.y + sizeY+2.6), imgui.GetColorU32Vec4(imgui.ImVec4(color_window[0], color_window[1], color_window[2], color_window[3])), 5, 0)
            if full_dialog[1] ~= nil then
                imgui.SetCursorPosX(imgui.GetCursorPos().x + 20)
                imgui.SetCursorPosY(imgui.GetCursorPos().y + 20) -- CustomOnlyBorder
                
                imgui.CustomInvisibleChild('cfgBlockFirsts', imgui.ImVec2(imgui.GetWindowWidth(), sizeY), false, imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse)
                -- if balanced_price ~= nil then
                    imgui.Text(u8(full_dialog[1]))
                    -- imgui.Separator()
                    show_prices(full_dialog[1], 1)
                -- end
                imgui.EndCustomInvisibleChild()
            end
            imgui.End()
        end
        if scan_button[0] and not sampIsDialogActive() and not renderWindow[0] and kvadratX ~= nil and kvadraty ~= nil then
            if imgui.IsMouseDown(1) then
                player.HideCursor = true
            end
            local sw, sh = getScreenResolution()
            imgui.SetNextWindowPos(imgui.ImVec2(kvadratX,kvadraty),imgui.Cond.FirstUseEver,imgui.ImVec2(0,0)) 
            imgui.SetNextWindowSize(imgui.ImVec2(50, 50),imgui.Cond.FirstUseEver)
            imgui.Begin('scan_button', scan_button, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoBackground) --  
            imgui.PushFont(font[20])
                imgui.TextColoredRGB('{ffffff}Scan', 35)
                imgui.SameLine(1)
                imgui.SetCursorPosX(imgui.GetCursorPos().x + 25)
                imgui.SetCursorPosY(imgui.GetCursorPos().y - 6) -- CustomOnlyBorder
                if imgui.CustomOnlyBorderButton(scan_items_s[2] and fa('TOGGLE_ON') or fa('TOGGLE_OFF'),imgui.ImVec2(30, 30)) then 
                    if scan_items_s[2] then
                        if last_dialog_id ~= nil then
                            sampSendDialogResponse(last_dialog_id, 0, 0)
                        end
                        lets_gooooo = false
                        if wait_dialog_d[1] ~= nil then
                            lets_go = true
                        end
                    else
                        AFKMessage('click on')
                        lets_gooooo = true
                        scan_info[3] = 0
                        scan_busy = false
                    end
                end
                imgui.Hint('scan_items_s', u8'����� ��������� ���� ������� �� ������������� ��� �����\n��� �������� ����� ���������� � ������ ��� ������� � ����������� ������� �������� ��� ��������.', false)
            imgui.PopFont()
            imgui.End()
        end
        if auto_full_button[0] and not sampIsDialogActive() and not renderWindow[0] and wkafY ~= nil and wkafX ~= nil then
            if imgui.IsMouseDown(1) then
                player.HideCursor = true
            end
            local sw, sh = getScreenResolution()
            imgui.SetNextWindowPos(imgui.ImVec2(wkafX,wkafY),imgui.Cond.FirstUseEver,imgui.ImVec2(0,0)) 
            imgui.SetNextWindowSize(imgui.ImVec2(50, 50),imgui.Cond.FirstUseEver)
            imgui.Begin('scan_button', scan_button, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoBackground) --  
            imgui.PushFont(font[18])
                imgui.TextColoredRGB('{ffffff}Auto', 35)
                imgui.SameLine(1)
                imgui.SetCursorPosX(imgui.GetCursorPos().x + 25)
                imgui.SetCursorPosY(imgui.GetCursorPos().y - 6) -- CustomOnlyBorder
                if imgui.CustomOnlyBorderButton(auto_full_dialog and fa('TOGGLE_ON') or fa('TOGGLE_OFF'),imgui.ImVec2(30, 30)) then 
                    auto_full_dialog = not auto_full_dialog 
                end
                imgui.Hint('auto_full_dialog', u8'����� ��������� ���� ������� �� ������ ��������� ������ ���� ��������.', false)
            imgui.PopFont()
            imgui.End()
        end
        if renderWindow[0] then
            alpha_z = 1.00
            if alpha_menuS[0] and zzztime ~= nil then
                alpha_z = bringFloatTo(0, 1, zzztime, 0.5)
            end
            imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, alpha_z)
            local resX, resY = getScreenResolution()
            sizeX, sizeY = 830, 500
            
            imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.SetNextWindowSize(imgui.ImVec2(sizeX, sizeY), imgui.Cond.FirstUseEver)
            imgui.Begin('Window', renderWindow, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoBackground)
            dl = imgui.GetWindowDrawList()
            p = imgui.GetCursorScreenPos()
            menuWP = imgui.GetWindowPos()
            -- local dl = imgui.GetWindowDrawList()
            -- local p = imgui.GetCursorScreenPos()
            -- AFKMessage(alpha_s[0])
            local rainbow = rainbow(speed_s[0], alpha_s[0])
            
            -- not blurMode and imgui.GetWindowDrawList() or imgui.GetBackgroundDrawList()
            -- mimgui_blur.apply(imgui.GetWindowDrawList(), 85,-1,5,10)
            -- mimgui_blur.apply(imgui.GetWindowDrawList(), 15)
            imgui.BeginChild('left', imgui.ImVec2(150, 700))
            if left_menu_blur[0] == true then
                mimgui_blur.apply(imgui.GetWindowDrawList(), blur_count[0])
                -- AFKMessage('mimgui_blur_5')
            end
            -- imgui.PushStyleColor(imgui.Col.ChildBg, imgui.ImVec4(current_theme.window[1], current_theme.window[2], current_theme.window[3], current_theme.window[4]))
            -- local clr = imgui.Col
            -- imgui.PushStyleColor(clr.WindowBg,imgui.ImVec4(current_theme.window[1], current_theme.window[2], current_theme.window[3], current_theme.window[4] - 0.3))
            -- mimgui_blur.apply(imgui.GetWindowDrawList(), 10) -- not blurMode and imgui.GetWindowDrawList() or imgui.GetBackgroundDrawList()
                imgui.SetCursorPos(imgui.ImVec2((150 - 100) / 2, 60))
                -- imgui.Image(arizona, imgui.ImVec2(75, 75))
                
            -- local max, min = 145, 26
            -- -- imgui.Image(arizonass, imgui.ImVec2(max, min))
            -- imgui.SetCursorPos(imgui.ImVec2((150 - 100)- 50, 20))
            -- -- imgui.Image(arizonas, imgui.ImVec2(max, min))
            --     imgui.PushFont(fonts[36])
            -- local ColorU32 = function(color) return imgui.GetColorU32Vec4(imgui.GetStyle().Colors[imgui.Col[color]]) end
            -- dl:AddText(imgui.ImVec2(p.x + 5, p.y), ColorU32('Text'), 'NEVERLOSE')
                local tmenu = 0 -- �������

                -- imgui.SetCursorPosX(20)
                imgui.PushFont(fonts[18])
                
                    -- for k1, v1 in pairs(buttons) do
                    --     imgui.PushFont(fonts[18])
                    --         imgui.SetCursorPosX(20)
                    --         imgui.TextColored(imgui.ImVec4(0.4, 0.4, 0.4, 1), v1.title)
                    --     imgui.PopFont()
                    --     for k2, v2 in pairs(v1.list) do
                    --         tmenu = tmenu + 1 -- �������
                    --         imgui.SetCursorPosX((150 - 120) / 2)
                    --         if imgui.AnimButton(v2, imgui.ImVec2(120)) then
                    --             menu = tmenu -- �������
                    --         end
                    --     end
                    -- end
                    -- if menu_blur[0] == true then
                    -- end
                    imgui.SetCursorPosX((150 - 100) / 2)
                    -- AFKMessage(tmenu)
                    imgui.CreateLeftMenu(buttons, imgui.ImVec2(100, 200), tmenu, rainbow, alpha)
                    -- imgui.logo(rainbow,dl,p)
                    -- for k1, v1 in pairs(buttons) do
                    --     imgui.PushFont(fonts[13])
                    --         imgui.SetCursorPosX(20)
                    --         imgui.TextColored(imgui.ImVec4(0.4, 0.4, 0.4, 1), v1.title)
                    --     imgui.PopFont()
                    --     for k2, v2 in pairs(v1.list) do
                    --         tmenu = tmenu + 1 -- �������
                    --         imgui.SetCursorPosX((150 - 120) / 2)
                            
                    --         if imgui.AnimButton(v2, imgui.ImVec2(120), tmenu, rainbow) then
                    --             menu = tmenu -- �������
                    --         end
                    --     end
                    -- end

                imgui.PopFont()
                
                imgui.GetWindowDrawList():AddText(imgui.ImVec2(p.x + 10, p.y+21), imgui.GetColorU32Vec4(imgui.ImVec4(1.000, 1.000, 1.000, 0.75)), script_name)-- (1.000f, 1.000f, 1.000f, 0.500f)
                
                imgui.SetCursorPosY(570)
                imgui.SetCursorPosX((imgui.GetWindowWidth() - 95) / 2)
                -- imgui.TextColored(imgui.ImVec4(0.4, 0.4, 0.4, 1), '_______________------------------')

                -- imgui.PushItemWidth(5)       
                -- imgui.Separator()
                -- imgui.SetCursorPos(imgui.ImVec2(-100, 340))
                -- imgui.NormalSeparator()
            -- imgui.PushStyleColor(imgui.Col.ChildBg, imgui.ImVec4(0.03, 0.02, 0.04, 0))
            -- imgui.CustomSeparator(95)
            
            if blur_rgb_window[0] == false then
                local q = imgui.ImVec2(p.x + ((150 - 75) / 2), p.y + sizeY - 95)
                
                imgui.GetWindowDrawList():AddRect(p, imgui.ImVec2(p.x + 800, p.y + sizeY), imgui.GetColorU32Vec4(rgb_window[0] and imgui.ImVec4(rainbow[1], rainbow[2], rainbow[3], rainbow[4]) or imgui.ImVec4(current_theme.rgb_window[1], current_theme.rgb_window[2], current_theme.rgb_window[3], current_theme.rgb_window[4])), 5, 0, rgb_width[0])
            end
            imgui.EndChild()

            imgui.SameLine(150)

            imgui.BeginChild('right', imgui.ImVec2(680, 700))
            
            if right_menu_blur[0] == true then
                mimgui_blur.apply(imgui.GetWindowDrawList(), blur_count[0])
                -- AFKMessage('mimgui_blur_6')
            end
            -- imgui.PushStyleColor(imgui.Col.ChildBg, imgui.ImVec4(0.03, 0.02, 0.04, 50/100))
            -- imgui.PushStyleColor(imgui.Col.ChildBg, imgui.ImVec4(0.07, 0.08, 0.14, 1))
            -- AFKMessage(menu)
                imgui.SetCursorPos(imgui.ImVec2(5, 5))
                imgui.BeginGroup()
                imgui.PushFont(fonts[13])
                    -- imgui.BeginChild('test', imgui.ImVec2(100, 100))
                    -- AFKMessage(menu)
                    -- round_text(1)
                    -- local alpha = 1
                    -- if UI_ANIM_BUTTON and (os.clock() - UI_ANIM_BUTTON.time <= UI_ANIM_BUTTON.duration) then
                    --     local alphaCheck = ((os.clock() - UI_ANIM_BUTTON.time) <= (UI_ANIM_BUTTON.duration / 2)) and {0, 1} or {1, 0}
                    --     local startTime = ((os.clock() - UI_ANIM_BUTTON.time) <= (UI_ANIM_BUTTON.duration / 2)) and UI_ANIM_BUTTON.time or UI_ANIM_BUTTON.time + UI_ANIM_BUTTON.duration / 2
                    --     local alpha = bringFloatTo(alphaCheck[1], alphaCheck[2], startTime, UI_ANIM_BUTTON.duration / 2)
                    --     imgui.GetWindowDrawList():AddRectFilled(imgui.ImVec2(p.x + 150, p.y + 2), imgui.ImVec2(p.x + sizeX - 2, p.y + sizeY - 2), imgui.GetColorU32Vec4(imgui.ImVec4(0.05, 0.06, 0.1, alpha)), 5, 10)
                    -- end
                    if (alpha_menuS[0]) and (UI_ANIM_BUTTON and (os.clock() - UI_ANIM_BUTTON.time <= UI_ANIM_BUTTON.duration)) then
                        local alphaCheck = ((os.clock() - UI_ANIM_BUTTON.time) <= (UI_ANIM_BUTTON.duration / 2)) and {1, 0} or {0, 1}
                        local startTime = ((os.clock() - UI_ANIM_BUTTON.time) <= (UI_ANIM_BUTTON.duration / 2)) and UI_ANIM_BUTTON.time or UI_ANIM_BUTTON.time + UI_ANIM_BUTTON.duration / 2
                        kifir = bringFloatTo(alphaCheck[1], alphaCheck[2], startTime, UI_ANIM_BUTTON.duration / 2)
                        -- AFKMessage('++')
                    end
                    imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8.00, 8.00))
                    imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, kifir)
                    if menu == 1 then
                        -- imgui.Text('Aimbot2')
                        
                        sell()
                        
                    elseif menu == 0 then
                        nextpage()
                        helpWithScan()
                    elseif menu == 2 then
                        -- nextpage()
                        buy()
                        
                    elseif menu == 3 then
                        -- nextpage()
                        cfg_menu()
                        -- if imgui.ColorEdit4(u8'���� ����', color_window) then
                        --     current_theme.window[1], current_theme.window[2], current_theme.window[3], current_theme.window[4] = color_window[0], color_window[1], color_window[2], color_window[3]
                        --     -- writeJsonFile(current_theme, 'moonloader/config/ArzMarket/theme.json')
                        --     -- theme() 
                        -- end
                    elseif menu == 4 then
                        -- nextpage()
                        -- chat_page()
                        -- AFKMessage(tostring(ready_send_message))
                        if ready_send_message ~= true then
                            imgui.SetCursorPos(imgui.ImVec2((imgui.GetWindowWidth() - 155) /2, (sizeY/2)-65))
                            imgui.SetCursorPosY(imgui.GetCursorPos().y)
                            imgui.Spinner("##spinner", 45, 2, imgui.GetColorU32Vec4(imgui.ImVec4(rainbow[1], rainbow[2], rainbow[3], rainbow[4])))
                            if imgui.IsItemHovered() then
                                imgui.BeginTooltip()
                                imgui.Text(u8'    ������� ��� ��� �� ������� � ��������� ����.   ')
                                if imgui.IsMouseClicked(0) then
                                    os.execute("explorer https://t.me/ArzMarketAuth_Bot")
                                end
                                -- if balanced_price ~= nil then
                                    -- AFKMessage('++_+')
                                -- end
                                imgui.EndTooltip()
                            end
                            -- imgui.PushFont(fonts[18])
                            -- imgui.SetCursorPosY(imgui.GetCursorPos().y+15)
                            -- imgui.SetCursorPosX(-825)
                            if full_irc_connect == true then
                                imgui.SetCursorPos(imgui.ImVec2(110,340))
                                imgui.TextDisabled(u8'��� ������ �� ��������� ������� ��������������, ��������...')
                                if imgui.IsItemHovered() then
                                    imgui.BeginTooltip()
                                    imgui.Text(u8'    ������� ��� ��� �� ����������� ���� ���������� ���-����.   ')
                                    if imgui.IsMouseClicked(0) then
                                        -- s:send('whois '..irc_name)
                                        if irc_fullnickname ~= nil then
                                            setClipboardText('/access '..irc_fullnickname)
                                            AFKMessage('��� ��� ���� ����������, �������� �� ��������, ��������� � ���� � ����������� ������.')
                                            AFKMessage('� ���� ��� ����� ��������� ������� /access � �������� ����� ������� � ��� ��� ����������.')
                                            AFKMessage('� ��� ������ ���������� ��������� � ����: /access '..irc_fullnickname)
                                        else
                                            AFKMessage('��������� ������. ���������� ��� ��� ����� 5 - 10 ������.')
                                        end
                                    end
                                    -- if balanced_price ~= nil then
                                        -- AFKMessage('++_+')
                                    -- end
                                    imgui.EndTooltip()
                                end
                            else
                                imgui.SetCursorPos(imgui.ImVec2(180,340))
                                imgui.TextDisabled(u8'����������� ����������� � �������...')
                            end
                            
                            if dont_have_lib == nil then
                                if injected == true then
                                    injected = false
                                    if disconnect_button == true then
                                        disconnect_button = false
                                        -- AFKMessage("����������� � IRC")
                                        s:join("#Freym_tech")
                                    else
                                        AFKMessage("����������� � IRC irc.mindforge.org")
                                        s:connect("irc.mindforge.org") 
                                    end
                                    local ip, _ = sampGetCurrentServerAddress()
                                    if servers[ip] then
                                        irc_name = servers[ip] ~= 0 and '[0]['..servers[ip]..']'..sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) or '[0]'..sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
                                        -- irc_name = '[0]['..servers[ip]..']'..nickname --..os.time()
                                        AFKMessage('irc name now>> '..tostring(irc_name))
                                        room_upd_irc_en = lua_thread.create(room_upd_irc) 
                                    end
                                end
                            end
                        end
                        if ready_send_message == true then
                            chat_page()
                        end
                        -- imgui.PopFont()
                        -- imgui.Text('Player')
                        -- imgui.Text('Player2')
                    elseif menu == 5 then
                        -- nextpage()
                        -- script_Page()
                        
                        if download_scripts == nil then
                            download_scripts = false
                            script_Manager()
                        end
                        if type(download_scripts) == 'table' then
                            -- AFKMessage('+++++')
                            script_Page()
                        else
                            imgui.SetCursorPos(imgui.ImVec2((imgui.GetWindowWidth() - 155) /2, (sizeY/2)-65))
                            imgui.Spinner("##spinner", 45, 2, imgui.GetColorU32Vec4(imgui.ImVec4(rainbow[1], rainbow[2], rainbow[3], rainbow[4])))
                            imgui.SetCursorPos(imgui.ImVec2((imgui.GetWindowWidth() - 335) /2,340))
                            imgui.TextDisabled(u8'�������� ����������. ���������� ���������...')
                        end
                        -- round_text(1)
                        -- imgui.PopFont()
                        -- imgui.Text('Vehicle')
                        -- imgui.Text('Vehicle2')
                    -- elseif menu == 6 then
                    --     nextpage()
                    --     imgui.PushFont(fonts[18])
                    --     imgui.SetCursorPos(imgui.ImVec2(1, 325))
                    --     imgui.SetCursorPosY(imgui.GetCursorPos().y)
                    --     imgui.CenterText(u8'�������� �� �������� �������')
                    --     imgui.PopFont()
                        -- imgui.Text('House')
                        -- imgui.Text('House2')
                    elseif menu == 6 then
                        -- nextpage()
                        -- imgui.PushFont(fonts[18])
                        -- imgui.SetCursorPos(imgui.ImVec2(1, 325))
                        -- imgui.SetCursorPosY(imgui.GetCursorPos().y)
                        -- imgui.CenterText(u8'�������� �� ������2�� �������')
                        -- imgui.PopFont()
                        list_ArzMarket()
                        -- imgui.Text('Business')
                        -- imgui.Text('Business2')
                    elseif menu == 7 then
                        -- nextpage()
                        menu_settings()
                        
                        -- imgui.NewInput(u8'Script Name', script_name, 255)
                        -- imgui.SameLine()
                        -- imgui.Text('Script Name')
                        -- imgui.Text('Author2')
                    elseif menu == 9 then
                        nextpage()
                    end
                    
                    imgui.PopStyleVar(2)
            -- if UI_ANIM_BUTTON and (os.clock() - UI_ANIM_BUTTON.time <= UI_ANIM_BUTTON.duration) then
            --     local alphaCheck = ((os.clock() - UI_ANIM_BUTTON.time) <= (UI_ANIM_BUTTON.duration / 2)) and {0, 1} or {1, 0}
            --     local startTime = ((os.clock() - UI_ANIM_BUTTON.time) <= (UI_ANIM_BUTTON.duration / 2)) and UI_ANIM_BUTTON.time or UI_ANIM_BUTTON.time + UI_ANIM_BUTTON.duration / 2
            --     local alpha = bringFloatTo(alphaCheck[1], alphaCheck[2], startTime, UI_ANIM_BUTTON.duration / 2)
            --     imgui.GetWindowDrawList():AddRectFilled(imgui.ImVec2(p.x + 150, p.y + 2), imgui.ImVec2(p.x + sizeX - 2, p.y + sizeY - 2), imgui.GetColorU32Vec4(imgui.ImVec4(0.05, 0.06, 0.1, alpha)), 5, 10)
            -- end
                    -- imgui.EndChild()
                imgui.EndGroup()
                if blur_rgb_window[0] == false then
                    local q = imgui.ImVec2(p.x + ((150 - 75) / 2), p.y + sizeY - 95)
                    imgui.GetWindowDrawList():AddRect(p, imgui.ImVec2(p.x + sizeX, p.y + sizeY), imgui.GetColorU32Vec4(rgb_window[0] and imgui.ImVec4(rainbow[1], rainbow[2], rainbow[3], rainbow[4]) or imgui.ImVec4(current_theme.rgb_window[1], current_theme.rgb_window[2], current_theme.rgb_window[3], current_theme.rgb_window[4])), 5, 0, rgb_width[0])
                end
            imgui.EndChild()
            q = imgui.ImVec2(p.x + ((150 - 75) / 2), p.y + sizeY - 150)
        
            dl:AddRectFilled(imgui.ImVec2(p.x + 150, p.y), imgui.ImVec2(p.x + sizeX, p.y + sizeY+2.6), imgui.GetColorU32Vec4(imgui.ImVec4(color_window[0], color_window[1], color_window[2], color_window[3])), 5, 0)
            dl:AddRectFilled(p, imgui.ImVec2(p.x + 150, p.y + sizeY), imgui.GetColorU32Vec4(imgui.ImVec4(current_theme.left_menu[1], current_theme.left_menu[2], current_theme.left_menu[3], current_theme.left_menu[4])), 5, 0)
            
            if background_blure[0] and right_menu_blur[0] and zzztime ~= nil then
                local alpha = alpha_menuS[0] and bringFloatTo(0, blur_count[0], zzztime, 1.5) or 1
                mimgui_blur.apply(imgui.GetBackgroundDrawList(), alpha)
            end

            imgui.PushFont(fonts[27])
            dl:AddText(imgui.ImVec2(p.x + 10, p.y+21), imgui.GetColorU32Vec4(imgui.ImVec4(rainbow[1], rainbow[2], rainbow[3], 1)), script_name)


            
            if sell_filter[0] then
                local resolutionX, resolutionY = getScreenResolution()
                local dl = imgui.GetWindowDrawList()
                local p = imgui.GetCursorScreenPos()
                
                local sizeXX, sizeYY = 300, 150
                
                imgui.SetNextWindowPos(imgui.ImVec2(menuWP.x + 240, menuWP.y - 80),imgui.Cond.Always + imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
                imgui.SetNextWindowSize(imgui.ImVec2(sizeXX, sizeYY), imgui.Cond.Always)
                imgui.Begin('kakawki2', sell_filter, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoBackground)
                local clr = imgui.Col
                imgui.PushStyleColor(clr.WindowBg, imgui.ImVec4(current_theme.window[1], current_theme.window[2], current_theme.window[3], current_theme.window[4] + 0.1))
                imgui.PushStyleColor(clr.ChildBg, imgui.ImVec4(current_theme.window[1], current_theme.window[2], current_theme.window[3], current_theme.window[4] - 0.1))
                imgui.PushStyleColor(clr.PopupBg, imgui.ImVec4(current_theme.window[1], current_theme.window[2], current_theme.window[3], current_theme.window[4] + 0.1))
                mimgui_blur.apply(imgui.GetWindowDrawList(), 15)
                
                imgui.BeginChild('secondImguiMenu')
                local p = imgui.GetCursorScreenPos() 
                imgui.CustomInvisibleChild('razpred', imgui.ImVec2(sizeXX, sizeYY), false, imgui.WindowFlags.NoScrollbar)
                imgui.PushFont(fonts[17])
                imgui.SetCursorPosY(imgui.GetCursorPos().y + 5)
                imgui.CenterText(u8'���������� ���������.')
                imgui.CustomSeparator(imgui.GetWindowWidth())
                imgui.SetCursorPosY(imgui.GetCursorPos().y + 5)
                imgui.SetCursorPosX(imgui.GetCursorPos().x + 10)
                if imgui.ToggleButton(u8('��������� ��� ���� ��� � ���������.'), filter_one) then
                    ini.cfg.filter_one = filter_one[0]
                    save_all()
                end
                imgui.SetCursorPosY(imgui.GetCursorPos().y + 5)
                imgui.SetCursorPosX(imgui.GetCursorPos().x + 10)
                if imgui.ToggleButton(u8('��� ����������� ����������� ����.'), filter_two) then
                    ini.cfg.filter_two = filter_two[0]
                    save_all()
                end
                -- imgui.SameLine()
                -- imgui.PushItemWidth(100)
                -- imgui.SetCursorPosY(imgui.GetCursorPos().y - 3)
                
                -- imgui.PushStyleVarVec2(imgui.StyleVar.FramePadding, imgui.ImVec2(3,3))
                -- imgui.InputTextD(vice_city_mode and " SA$" or " VC$", separatorChar.buy, 32, imgui.InputTextFlags.CharsDecimal)
                -- imgui.PopStyleVar()
                -- -- imgui.NewInput(u8' ����� ���������', separatorChar.buy, 255�)
                -- imgui.SetCursorPosX(imgui.GetCursorPos().x + 35)
                -- imgui.CenterText(u8'���-�� ��������� - ' .. #item_list)
                imgui.SetCursorPosY(imgui.GetCursorPos().y + 20)
                imgui.SetCursorPosX(imgui.GetCursorPos().x + 5)
                
                imgui.GetStyle().FrameBorderSize = border_side[0] and 1 or 0
                if imgui.Button(u8'��������� ����������', imgui.ImVec2(imgui.GetWindowWidth() - 10)) then
                    if #sell_list > 0 then
                        for i = 1, #sell_list do
                            for k, v in pairs(sell_list) do
                                if sell_list[k].all_count == 0 and filter_one[0] then
                                    sell_list[k].enabled = false
                                end
                                if sell_list[k].enabled == false and filter_two[0] then
                                    local swich_save = sell_list[k]
                                    table.remove(sell_list, k)
                                    table.insert(sell_list, #sell_list + 1, swich_save)
                                end
                            end
                        end
                    end
                    AFKMessage('���������� ���������.')
                    sell_filter[0] = not sell_filter[0]
                end
                imgui.GetStyle().FrameBorderSize = 0
                -- imgui.PopItemWidth()
                imgui.PopFont()
                imgui.EndCustomInvisibleChild()
                imgui.GetWindowDrawList():AddRect(p, imgui.ImVec2(p.x + sizeXX, p.y + sizeYY), imgui.GetColorU32Vec4(imgui.ImVec4(current_theme.Border[1], current_theme.Border[2], current_theme.Border[3], current_theme.Border[4])), 5, 0, rgb_width[0])
                imgui.EndChild()
                imgui.PopStyleColor(3)
                imgui.End()
            end

            

            if separator[0] then
                local resolutionX, resolutionY = getScreenResolution()
                local dl = imgui.GetWindowDrawList()
                local p = imgui.GetCursorScreenPos()
                
                local sizeXX, sizeYY = 300, 150
                
                imgui.SetNextWindowPos(imgui.ImVec2(menuWP.x + (sizeX + 155), menuWP.y + sizeY),imgui.Cond.Always + imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
                imgui.SetNextWindowSize(imgui.ImVec2(sizeXX, sizeYY), imgui.Cond.Always)
                imgui.Begin('kakawki', separator, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoBackground)
                local clr = imgui.Col
                imgui.PushStyleColor(clr.WindowBg, imgui.ImVec4(current_theme.window[1], current_theme.window[2], current_theme.window[3], current_theme.window[4] + 0.1))
                imgui.PushStyleColor(clr.ChildBg, imgui.ImVec4(current_theme.window[1], current_theme.window[2], current_theme.window[3], current_theme.window[4] - 0.1))
                imgui.PushStyleColor(clr.PopupBg, imgui.ImVec4(current_theme.window[1], current_theme.window[2], current_theme.window[3], current_theme.window[4] + 0.1))
                mimgui_blur.apply(imgui.GetWindowDrawList(), 15)
                
                imgui.BeginChild('secondImguiMenu')
                local p = imgui.GetCursorScreenPos() 
                imgui.CustomInvisibleChild('razpred', imgui.ImVec2(sizeXX, sizeYY), false, imgui.WindowFlags.NoScrollbar)
                imgui.PushFont(fonts[17])
                imgui.SetCursorPosY(imgui.GetCursorPos().y + 5)
                imgui.CenterText(ffi.string(separatorChar.buy) >= '0' and u8'��������� ������� �����: ' ..  moneySeparator(GetMoneyLimit()) or u8'������� ���-�� ����')
                imgui.CustomSeparator(imgui.GetWindowWidth())
                imgui.SetCursorPosY(imgui.GetCursorPos().y + 5)
                imgui.SetCursorPosX(imgui.GetCursorPos().x + 10)
                imgui.Text(u8'���-�� ���� �� ���� -')
                imgui.SameLine()
                imgui.PushItemWidth(100)
                imgui.SetCursorPosY(imgui.GetCursorPos().y - 3)
                
                imgui.PushStyleVarVec2(imgui.StyleVar.FramePadding, imgui.ImVec2(3,3))
                imgui.InputTextD(vice_city_mode and " SA$" or " VC$", separatorChar.buy, 32, imgui.InputTextFlags.CharsDecimal)
                imgui.PopStyleVar()
                -- imgui.NewInput(u8' ����� ���������', separatorChar.buy, 255�)
                imgui.SetCursorPosX(imgui.GetCursorPos().x + 35)
                imgui.CenterText(u8'���-�� ��������� - ' .. #item_list)
                imgui.SetCursorPosY(imgui.GetCursorPos().y + 27)
                imgui.SetCursorPosX(imgui.GetCursorPos().x + 5)
                
                imgui.GetStyle().FrameBorderSize = border_side[0] and 1 or 0
                if imgui.Button(u8'������������', imgui.ImVec2(imgui.GetWindowWidth() - 10)) then
                    local budget = math.floor(tonumber(ffi.string(separatorChar.buy)))
                    local even_budget_per_resource = budget / #item_list
                    for k, v in pairs(item_list) do
                        local dynamic_price = vice_city_mode and v.price or v.price_vc
                        -- 
                        if dynamic_price ~= 0 then
                            local quantity = math.floor(even_budget_per_resource / dynamic_price)
                            local total_cost = quantity * dynamic_price
                            v.count = math.floor(quantity)
                        end
                        -- v.price = math.floor(tonumber(ffi.string(separatorChar.buy)) / #item_list)
                    end
                    AFKMessage('������������� ���������. ��������� ������� - {505050}' .. moneySeparator(GetMoneyLimit()))
                    -- separator[0] = not separator[0]
                    separatorChar.page = 0
                    separator[0] = not separator[0]
                end
                imgui.GetStyle().FrameBorderSize = 0
                imgui.PopItemWidth()
                imgui.PopFont()
                imgui.EndCustomInvisibleChild()
                imgui.GetWindowDrawList():AddRect(p, imgui.ImVec2(p.x + sizeXX, p.y + sizeYY), imgui.GetColorU32Vec4(imgui.ImVec4(current_theme.Border[1], current_theme.Border[2], current_theme.Border[3], current_theme.Border[4])), 5, 0, rgb_width[0])
                imgui.EndChild()
                imgui.PopStyleColor(3)
                imgui.End()
            end


            if blur_rgb_window[0] == true then
                local q = imgui.ImVec2(p.x + ((150 - 75) / 2), p.y + sizeY - 95)
                imgui.GetWindowDrawList():AddRect(p, imgui.ImVec2(p.x + sizeX, p.y + sizeY), imgui.GetColorU32Vec4(rgb_window[0] and imgui.ImVec4(rainbow[1], rainbow[2], rainbow[3], rainbow[4]) or imgui.ImVec4(current_theme.rgb_window[1], current_theme.rgb_window[2], current_theme.rgb_window[3], current_theme.rgb_window[4])), 5, 0, rgb_width[0])
            end
            imgui.End()
            imgui.PopStyleVar()
            
            
        end
        
    end
)

local marketFrame = imgui.OnFrame(
	function() return replace_logger[0] and replace_window[0] and not isPauseMenuActive() end, -- and not sampIsScoreboardOpen() 
	function(player)
		player.HideCursor = true
		local sx, sy = getScreenResolution()
		local position = marketPos.x ~= -1 and marketPos or imgui.ImVec2((sx - marketSize.x[0]) / 2, sy - marketSize.y[0] - sy * 0.01) 
		imgui.SetNextWindowPos(position, imgui.Cond.Always)
		imgui.SetNextWindowSize(imgui.ImVec2(marketSize.x[0], marketSize.y[0]), imgui.Cond.Always)
		imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(marketColor.text[0], marketColor.text[1], marketColor.text[2], marketColor.text[3]))
		imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(marketColor.window[0], marketColor.window[1], marketColor.window[2], marketColor.window[3]))
			imgui.Begin('replace_logger', replace_logger, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar)
            local p = imgui.GetCursorScreenPos() 
            imgui.SetCursorPosY(imgui.GetCursorPos().y + 5)
            imgui.PushFont(fonts[18])
            imgui.SetWindowFontScale(log_windowFont[0])
				for i = #marketShop, 1, -1 do
                    imgui.SetCursorPosX(imgui.GetCursorPos().x + 6)
					imgui.Text(u8(marketShop[i]))
				end
            imgui.PopFont()
            imgui.GetWindowDrawList():AddRect(p, imgui.ImVec2(p.x + marketSize.x[0], p.y + marketSize.y[0]), imgui.GetColorU32Vec4(imgui.ImVec4(current_theme.Border[1], current_theme.Border[2], current_theme.Border[3], current_theme.Border[4])), 5, 0, rgb_width[0])
			imgui.End()
		imgui.PopStyleColor(2)
	end
)

function GetMoneyLimit()
    local budget = math.floor(tonumber(ffi.string(separatorChar.buy)))
    local even_budget_per_resource = budget / #item_list
    local bytes = 0
    for k, v in pairs(item_list) do
        local quantity = math.floor(even_budget_per_resource / v.price)
        local total_cost = quantity * v.price
        bytes = bytes + total_cost
    end
    bytes = getPlayerMoney() - bytes
    return bytes
end


function imgui.logo(rainbow,dl,p)
    -- AFKMessage(p.x..' do '..p.y)
    local dl = imgui.GetWindowDrawList()
    local p = imgui.GetCursorScreenPos()
    -- AFKMessage(p.x..' posle '..p.y)
     
    imgui.PushFont(fonts[27]) -- // TODO MENU
    local ColorU32 = function(color) return imgui.GetColorU32Vec4(imgui.GetStyle().Colors[imgui.Col[color]]) end
    
        -- imgui.Text("Blured")
    -- local test_number = 0
    -- if menu_blur[0] == true then
    --     mimgui_blur.apply(imgui.GetWindowDrawList(), 1)
    -- end
    -- imgui.PushFont(fonts[27]) 
    dl:AddText(imgui.ImVec2(p.x + 11, (p.y+22)-401), imgui.GetColorU32Vec4(imgui.ImVec4(1.000, 1.000, 1.000, 0.75)), 'PLACEMENT')-- (1.000f, 1.000f, 1.000f, 0.500f)
end

function tg_settings()
    imgui.PushFont(fonts[44]) -- // TODO MENU
    local clr = imgui.Col
    imgui.PushStyleColor(clr.PopupBg, imgui.ImVec4(0.05, 0.06, 0.1, 1.00))
    imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(0, 0))
	if imgui.BeginPopupModal(u8('[TG] ���������'), _, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse ) then
		imgui.SetWindowSizeVec2(imgui.ImVec2(300, 305))

        imgui.SetCursorPosX(imgui.GetCursorPos().x + 5)
        imgui.SetCursorPosY(imgui.GetCursorPos().y + 5)
		imgui.BeginChild('tg_settings', imgui.ImVec2(-1, imgui.GetWindowWidth() - 70), true)

        if imgui.ToggleButton(u8('����������� � �������/�������'), telegram_custom["notf_buysell"]) then
            ini.tg_setting.notf_buysell = telegram_custom["notf_buysell"][0]
            save_all()
        end
        if telegram_custom["notf_buysell"][0] then
            if imgui.ToggleButton(u8('��������� ����������� �� ����'), telegram_custom["stats"]) then 
                ini.tg_setting.stats = telegram_custom["stats"][0]
                save_all()
            end
            imgui.CustomSeparator(imgui.GetWindowWidth())
        end
        if imgui.ToggleButton(u8('����������� � ��������� �����'), telegram_custom["lavka_status"]) then
            ini.tg_setting.lavka_status = telegram_custom["lavka_status"][0]
            save_all()
        end
        if imgui.ToggleButton(u8('����������� � ������ ���������'), telegram_custom["death_notf"]) then
            ini.tg_setting.death_notf = telegram_custom["death_notf"][0]
            save_all()
        end
        if imgui.ToggleButton(u8('����������� � ��������� � /pm'), telegram_custom["admin_message"]) then
            ini.tg_setting.admin_message = telegram_custom["admin_message"][0]
            save_all()
        end
        if imgui.ToggleButton(u8('����������� � ���/������'), telegram_custom["connect_message"]) then
            ini.tg_setting.connect_message = telegram_custom["connect_message"][0]
            save_all()
        end
        if imgui.ToggleButton(u8('����������� � ������ ����� �������'), telegram_custom["nalog_message"]) then
            ini.tg_setting.nalog_message = telegram_custom["nalog_message"][0]
            save_all()
        end
        
        imgui.CustomSeparator(imgui.GetWindowWidth())
        
        if imgui.InputTextWithHintD(u8'������� Token', u8'������� Token', telegram_custom["token"], ffi.sizeof(telegram_custom["token"])) then
            ini.tg_setting.token = ffi.string(telegram_custom["token"])
            save_all()
        end
        if imgui.InputTextWithHintD(u8'������� ChatID', u8'������� ChatID', telegram_custom["chat_id"], ffi.sizeof(telegram_custom["chat_id"])) then
            ini.tg_setting.chat_id = ffi.string(telegram_custom["chat_id"])
            save_all()
        end
        imgui.CustomSeparator(imgui.GetWindowWidth())
        imgui.SetCursorPosX(imgui.GetCursorPos().x - 5)
		if imgui.Button(u8('��������� ����������'), imgui.ImVec2(imgui.GetWindowWidth(), 30)) then
			sendTelegramNotification('�������� ���������� ������ �������!')
		end

		imgui.EndChild()

		if imgui.Button(u8('�������'), imgui.ImVec2(imgui.GetWindowWidth(), 30)) then
			imgui.CloseCurrentPopup()
		end
		imgui.EndPopup()
	end
    imgui.PopStyleVar()
    imgui.PopStyleColor()
    imgui.PopFont()
end

function changeDate()
	if imgui.BeginPopupModal(u8('����� ����'), _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
		imgui.SetWindowSizeVec2(imgui.ImVec2(300, 305))

		imgui.BeginChild('changeDate', imgui.ImVec2(-1, imgui.GetWindowWidth() - 70), true)

			local temp_table = {}
			for k, v in pairs(jsonLog) do
				local d, m, y = k:match('(%d+)%.(%d+)%.(%d+)')
				table.insert(temp_table, {key = k, date = tonumber(y .. m .. d)})
			end
			table.sort(temp_table, function(a, b) return a.date > b.date end)

			for k, v in ipairs(temp_table) do
				if imgui.Button(v.key, imgui.ImVec2(-1)) then date_select = v.key; imgui.CloseCurrentPopup() end
			end

		imgui.EndChild()

		if imgui.Button(u8('�������'), imgui.ImVec2(-1, 30)) then
			imgui.CloseCurrentPopup()
		end

		imgui.EndPopup()
	end
end

function imgui.Hint(str_id, hint_text, no_center)
    if help_message[0] == false then return false end
    color = imgui.ImVec4(current_theme.Border[1], current_theme.Border[2], current_theme.Border[3], current_theme.Border[4])
    local p_orig = imgui.GetCursorPos()
    local hovered = imgui.IsItemHovered()
    imgui.SameLine(nil, 0)

    local animTime = 0.09
    local show = true

    if not POOL_HINTS then POOL_HINTS = {} end
    if not POOL_HINTS[str_id] then
        POOL_HINTS[str_id] = {
            status = false,
            timer = 0
        }
    end

    if hovered then
        for k, v in pairs(POOL_HINTS) do
            if k ~= str_id and os.clock() - v.timer <= animTime  then
                show = false
            end
        end
    end

    if show and POOL_HINTS[str_id].status ~= hovered then
        POOL_HINTS[str_id].status = hovered
        POOL_HINTS[str_id].timer = os.clock()
    end

    local getContrastColor = function(col)
        local luminance = 1 - (0.299 * col.x + 0.587 * col.y + 0.114 * col.z)
        return luminance < 0.5 and imgui.ImVec4(0, 0, 0, 1) or imgui.ImVec4(1, 1, 1, 1)
    end

    local rend_window = function(alpha)
        local size = imgui.GetItemRectSize()
        local scrPos = imgui.GetCursorScreenPos()
        local DL = imgui.GetWindowDrawList()
        local center = imgui.ImVec2( scrPos.x - (size.x / 2), scrPos.y + (size.y / 2) - (alpha * 4) + 10 )
        local a = imgui.ImVec2( center.x - 7, center.y - size.y - 3 )
        local b = imgui.ImVec2( center.x + 7, center.y - size.y - 3)
        local c = imgui.ImVec2( center.x, center.y - size.y + 3 )
        local col = imgui.ColorConvertFloat4ToU32(imgui.ImVec4(color.x, color.y, color.z, alpha))

        -- DL:AddTriangleFilled(a, b, c, col)
        imgui.SetNextWindowPos(imgui.ImVec2(center.x, center.y - size.y - 3), imgui.Cond.Always, imgui.ImVec2(0.5, 1.0))
        imgui.PushStyleColor(imgui.Col.PopupBg, color)
        imgui.PushStyleColor(imgui.Col.Border, color)
        imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(current_theme.input[1], current_theme.input[2], current_theme.input[3], 0.7))
        imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
        imgui.PushStyleVarFloat(imgui.StyleVar.WindowRounding, 6)
        imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, alpha)

        local max_width = function(text)
            local result = 0
            for line in text:gmatch('[^\n]+') do
                local len = imgui.CalcTextSize(line).x
                if len > result then
                    result = len
                end
            end
            return result
        end

        local hint_width = (max_width(hint_text) + (imgui.GetStyle().WindowPadding.x * 2)) * 1.3
        imgui.SetNextWindowSize(imgui.ImVec2(hint_width , -1), imgui.Cond.Always)
        imgui.Begin('##' .. str_id, _, imgui.WindowFlags.Tooltip + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoTitleBar)
        imgui.PushFont(fonts[18])
        for line in hint_text:gmatch('[^\n]+') do
            if no_center then
                imgui.Text(line)
            else
                imgui.SetCursorPosX((hint_width - imgui.CalcTextSize(line).x) / 2)
                imgui.Text(line)
            end
        end
        imgui.PopFont()
        imgui.End()

        imgui.PopStyleVar(3)
        imgui.PopStyleColor(3)
    end

    if show then
        local between = os.clock() - POOL_HINTS[str_id].timer
        if between <= animTime then
            local s = function(f)
                return f < 0.0 and 0.0 or (f > 1.0 and 1.0 or f)
            end
            local alpha = hovered and s(between / animTime) or s(1.00 - between / animTime)
            rend_window(alpha)
        elseif hovered then
            rend_window(1.00)
        end
    end

    imgui.SetCursorPos(p_orig)
    
end

function imgui.Spinner(label, radius, thickness, color)
    local style = imgui.GetStyle()
    local pos = imgui.GetCursorScreenPos()
    local size = imgui.ImVec2(radius * 2, (radius + style.FramePadding.y) * 2)
    
    imgui.Dummy(imgui.ImVec2(size.x + style.ItemSpacing.x, size.y))

    local DrawList = imgui.GetWindowDrawList()
    DrawList:PathClear()
    
    local num_segments = 30
    local start = math.abs(math.sin(imgui.GetTime() * 1.8) * (num_segments - 5))
    
    local a_min = 3.14 * 2.0 * start / num_segments
    local a_max = 3.14 * 2.0 * (num_segments - 3) / num_segments

    local centre = imgui.ImVec2(pos.x + radius, pos.y + radius + style.FramePadding.y)
    
    for i = 0, num_segments do
        local a = a_min + (i / num_segments) * (a_max - a_min)
        DrawList:PathLineTo(imgui.ImVec2(centre.x + math.cos(a + imgui.GetTime() * 8) * radius, centre.y + math.sin(a + imgui.GetTime() * 8) * radius))
    end

    DrawList:PathStroke(color, false, thickness)
    return true
end


function imgui.BufferingBar(label, value, size_arg, bg_col, fg_col)
    local style = imgui.GetStyle()
    local size = size_arg;

    local DrawList = imgui.GetWindowDrawList()
    size.x = size.x - (style.FramePadding.x * 2);

    local pos = imgui.GetCursorScreenPos()

    imgui.Dummy(imgui.ImVec2(size.x, size.y))
    
    local circleStart = size.x * 0.85;
    local circleEnd = size.x;
    local circleWidth = circleEnd - circleStart;
    
    DrawList:AddRectFilled(pos, imgui.ImVec2(pos.x + circleStart, pos.y + size.y), bg_col)
    DrawList:AddRectFilled(pos, imgui.ImVec2(pos.x + circleStart * value, pos.y + size.y), fg_col)
    
    -- local t = imgui.GetTime()
    -- local r = size.y / 2;
    -- local speed = 1.5;
    
    -- local a = speed * 0;
    -- local b = speed * 0.333;
    -- local c = speed * 0.666;

    -- local o1 = (circleWidth+r) * (t+a - speed * math.floor((t+a) / speed)) / speed;
    -- local o2 = (circleWidth+r) * (t+b - speed * math.floor((t+b) / speed)) / speed;
    -- local o3 = (circleWidth+r) * (t+c - speed * math.floor((t+c) / speed)) / speed;
    
    -- DrawList:AddCircleFilled(imgui.ImVec2(pos.x + circleEnd - o1, pos.y + r), r, bg_col);
    -- DrawList:AddCircleFilled(imgui.ImVec2(pos.x + circleEnd - o2, pos.y + r), r, bg_col);
    -- DrawList:AddCircleFilled(imgui.ImVec2(pos.x + circleEnd - o3, pos.y + r), r, bg_col);
    return true
end

function imgui.CreateLeadersMenu(label, players, size)
    local SETTINGS = {
        ROUNDING = 5,
        TEXT_COLOR = imgui.GetStyle().Colors[imgui.Col.Text],
        HEADER_COLOR = imgui.ImVec4(current_theme.input[1], current_theme.input[2], current_theme.input[3], 0.02),
        NUMBER_BUTTON_COLOR = imgui.ImVec4(current_theme.input[1], current_theme.input[2], current_theme.input[3], 0.02),
        SIZE_NUMBER_BUTTON = 26,
        SIZE_BOX_CHILD = 39
    }

    imgui.BeginChild(label, size, true, imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoScrollbar)

        imgui.PushStyleColor(imgui.Col.ChildBg, imgui.ImVec4(SETTINGS.HEADER_COLOR))
            imgui.BeginChild(label .. 'start', imgui.ImVec2(-1, imgui.CalcTextSize().y * 1.5), false, imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoScrollbar)
                local dl = imgui.GetWindowDrawList()
                local p = imgui.GetCursorScreenPos()
                dl:AddText(imgui.ImVec2(p.x + 10, p.y + (imgui.CalcTextSize().y * 1.5 - imgui.CalcTextSize(u8('�����')).y) / 2), imgui.GetColorU32Vec4(SETTINGS.TEXT_COLOR), u8('�����'))
                dl:AddText(imgui.ImVec2(p.x + 100, p.y + (imgui.CalcTextSize().y * 1.5 - imgui.CalcTextSize(u8('���')).y) / 2), imgui.GetColorU32Vec4(SETTINGS.TEXT_COLOR), u8('���'))
                dl:AddText(imgui.ImVec2(p.x + 305, p.y + (imgui.CalcTextSize().y * 1.5 - imgui.CalcTextSize(u8('����')).y) / 2), imgui.GetColorU32Vec4(SETTINGS.TEXT_COLOR), u8('����'))
                dl:AddText(imgui.ImVec2(p.x + size.x - imgui.CalcTextSize(u8('�������')).x - 10 - 10, p.y + (imgui.CalcTextSize().y * 1.5 - imgui.CalcTextSize(u8('�������')).y) / 2), imgui.GetColorU32Vec4(SETTINGS.TEXT_COLOR), u8('�������'))
            imgui.EndChild()
        imgui.PopStyleColor()

        imgui.BeginChild(label .. 'list', imgui.ImVec2(-1, -1), false, imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoScrollbar)
            imgui.PushStyleColor(imgui.Col.ChildBg, imgui.ImVec4(current_theme.input[1], current_theme.input[2], current_theme.input[3], 0.02))
                for k, v in pairs(players) do
                    imgui.BeginChild(label .. tostring(k), imgui.ImVec2(-1, SETTINGS.SIZE_BOX_CHILD), false, imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoScrollbar)
                        local dl = imgui.GetWindowDrawList()
                        local p = imgui.GetCursorScreenPos()
                        local renderRect = imgui.ImVec2(p.x + 10 + imgui.CalcTextSize(u8('�����')).x / 2 - SETTINGS.SIZE_NUMBER_BUTTON / 2, p.y + (SETTINGS.SIZE_BOX_CHILD - SETTINGS.SIZE_NUMBER_BUTTON) / 2)

                        dl:AddRectFilled(renderRect, imgui.ImVec2(renderRect.x + SETTINGS.SIZE_NUMBER_BUTTON, renderRect.y + SETTINGS.SIZE_NUMBER_BUTTON), imgui.GetColorU32Vec4(SETTINGS.NUMBER_BUTTON_COLOR), SETTINGS.ROUNDING)
                        dl:AddText(imgui.ImVec2(renderRect.x + (SETTINGS.SIZE_NUMBER_BUTTON - imgui.CalcTextSize(tostring(k)).x) / 2, renderRect.y + (SETTINGS.SIZE_NUMBER_BUTTON - imgui.CalcTextSize(tostring(k)).y) / 2) , imgui.GetColorU32Vec4(SETTINGS.TEXT_COLOR), tostring(k))

                        dl:AddText(imgui.ImVec2(p.x + 100, p.y + (SETTINGS.SIZE_BOX_CHILD - imgui.CalcTextSize(v.name).y) / 2), imgui.GetColorU32Vec4(imgui.GetStyle().Colors[imgui.Col.Text]), v.name)
                        dl:AddText(imgui.ImVec2(p.x + 305 + (imgui.CalcTextSize(tostring(u8('����'))).x - imgui.CalcTextSize(tostring(v.exp)).x) / 2, p.y + (SETTINGS.SIZE_BOX_CHILD - imgui.CalcTextSize(tostring(v.exp)).y) / 2), imgui.GetColorU32Vec4(SETTINGS.TEXT_COLOR), tostring(v.exp))
                        dl:AddText(imgui.ImVec2(p.x + size.x - imgui.CalcTextSize(u8('�������')).x - 10 - 10 + imgui.CalcTextSize(u8('�������')).x / 2 - imgui.CalcTextSize(tostring(v.lvl)).x / 2, p.y + (SETTINGS.SIZE_BOX_CHILD - imgui.CalcTextSize(tostring(v.lvl)).y) / 2), imgui.GetColorU32Vec4(SETTINGS.TEXT_COLOR), tostring(v.lvl))
                    imgui.EndChild()
                end
            imgui.PopStyleColor()
        imgui.EndChild()

    imgui.EndChild()
end

function imgui_blure()
    -- imgui.BeginChild('Name', imgui.ImVec2(160, 60), true)
    imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, 0)
    local dl = imgui.GetWindowDrawList()
    local q = imgui.ImVec2(p.x + ((150 - 75) / 2), p.y + sizeY - 150)
    -- imgui.GetWindowDrawList():AddCircle(imgui.ImVec2(q.x + 37.5, q.y + 37.5), 37.5, imgui.GetColorU32Vec4(imgui.ImVec4(rainbow[1], rainbow[2], rainbow[3], rainbow[4])), 50, 1)
    imgui.GetWindowDrawList():AddImageRounded(arizona, q, imgui.ImVec2(q.x + 75, q.y + 75), imgui.ImVec2(0, 0), imgui.ImVec2(1, 1), 0xFFFFFFFF, 60)
    -- imgui.GetWindowDrawList():AddCircle(imgui.ImVec2(q.x + 37.5, q.y + 37.5), 37.5, imgui.GetColorU32Vec4(imgui.ImVec4(rainbow[1], rainbow[2], rainbow[3], 0.6)), 50, 2)
    imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(q.x + 37.5, q.y + 37.5), 37.5, imgui.GetColorU32Vec4(imgui.ImVec4(current_theme.left_menu[1], current_theme.left_menu[2], current_theme.left_menu[3], 0.4)), 50, 2) -- 0.08, 0.09, 0.19, 0.6
    imgui.SetCursorPosY(imgui.GetCursorPos().y - 300)
    imgui.CustomInvisibleChild('cfgBlowckFirst', imgui.ImVec2(-1, -1), false, imgui.WindowFlags.NoScrollbar)
    if left_menu_blur[0] then
        mimgui_blur.apply(imgui.GetWindowDrawList(), 1)
        -- AFKMessage('mimgui_blur_7')
    end
    imgui.EndCustomInvisibleChild()
    imgui.PopStyleVar()
    -- imgui.EndChild()
end

function imgui.CreateLeftMenu(buttons, size, tmenu, rainbow, alpha) -- // TODO imgui.CreateLeftMenu
    -- AFKMessage(buttons[1].list[2])
    -- local q = imgui.ImVec2(p.x + ((150 - 75) / 2), p.y + sizeY - 150)
    -- imgui.GetWindowDrawList():AddCircle(imgui.ImVec2(q.x + 37.5, q.y + 37.5), 37.5, imgui.GetColorU32Vec4(imgui.ImVec4(rainbow[1], rainbow[2], rainbow[3], rainbow[4])), 50, 1)
    -- imgui.GetWindowDrawList():AddImageRounded(arizona, q, imgui.ImVec2(q.x + 75, q.y + 75), imgui.ImVec2(0, 0), imgui.ImVec2(1, 1), 0xFFFFFFFF, 60)
    -- imgui.GetWindowDrawList():AddCircle(imgui.ImVec2(q.x + 37.5, q.y + 37.5), 37.5, imgui.GetColorU32Vec4(imgui.ImVec4(rainbow[1], rainbow[2], rainbow[3], 0.6)), 50, 2)
    -- imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(q.x + 37.5, q.y + 37.5), 37.5, imgui.GetColorU32Vec4(imgui.ImVec4(current_theme.left_menu[1], current_theme.left_menu[2], current_theme.left_menu[3], 0.4)), 50, 2) -- 0.08, 0.09, 0.19, 0.6
    -- if left_menu_blur[0] then
    --     mimgui_blur.apply(imgui.GetWindowDrawList(), 1)
    -- end
    local nextPos = 0
    local tmenu = tmenu
    local buttonSize = (imgui.GetStyle().FramePadding.y * 2 + 17)
    local dl = imgui.GetWindowDrawList()
    local p = imgui.GetCursorScreenPos()
    SelectMenuVertical = p.y
    if UI_ANIM_BUTTON == nil then UI_ANIM_BUTTON = {label = buttons[1].list[1], time = 0, duration = 0.4, pos = {['current'] = 0, ['last'] = 0, ['next'] = 0}} end
    local ColorU32 = function(color) return imgui.GetColorU32Vec4(imgui.GetStyle().Colors[imgui.Col[color]]) end
    local colorList = {
        ['default'] = imgui.ImVec4(0.00, 0.00, 0.00, 0.00),
        ['active'] = imgui.ImVec4(current_theme.active_selector_color[1], current_theme.active_selector_color[2], current_theme.active_selector_color[3], current_theme.active_selector_color[4]),
        ['side'] = imgui.ImVec4(1, 1, 1, 0),
        ['hovered'] = imgui.ImVec4(0.08, 0.09, 0.19, 0)
    }

    for k1, v1 in pairs(buttons) do
        nextPos = nextPos + 13 + 5
        for k2, v2 in pairs(v1.list) do
            tmenu = tmenu + 1
            local px, py = getCursorPos()
            local buttonHovered = ((px >= p.x) and (px <= (p.x + size.x)) and (py >= (p.y + nextPos)) and (py <= (p.y + nextPos + buttonSize)))

            if buttonHovered and imgui.IsMouseClicked(0) and not (tmenu == menu) then
                -- tmenu = 2
                RadioButton_s = {new.int(333),333,false} 
                UI_ANIM_BUTTON.label = v2
                UI_ANIM_BUTTON.time = os.clock()
                UI_ANIM_BUTTON.pos.last = UI_ANIM_BUTTON.pos.current
                UI_ANIM_BUTTON.pos.next = p.y + nextPos
                lua_thread.create(function() local ltmenu = tmenu; wait(UI_ANIM_BUTTON.duration / 2 * 1000); menu = ltmenu end)
            end
            

            dl:AddRectFilled(imgui.ImVec2(p.x, p.y + nextPos), imgui.ImVec2(p.x + size.x, p.y + nextPos + buttonSize), imgui.GetColorU32Vec4(colorList[((os.clock() - UI_ANIM_BUTTON.time <= UI_ANIM_BUTTON.duration) and 'default' or ((tmenu == menu) and 'active' or (buttonHovered and 'hovered' or 'default')))]), 5)

            if UI_ANIM_BUTTON.label == v2 then
                if os.clock() - UI_ANIM_BUTTON.time <= UI_ANIM_BUTTON.duration then
                    UI_ANIM_BUTTON.pos.current = bringIntTo(UI_ANIM_BUTTON.pos.last, UI_ANIM_BUTTON.pos.next, UI_ANIM_BUTTON.time, UI_ANIM_BUTTON.duration)
                    imgui.GetWindowDrawList():AddRectFilled(imgui.ImVec2(p.x, UI_ANIM_BUTTON.pos.current), imgui.ImVec2(p.x + size.x, UI_ANIM_BUTTON.pos.current + buttonSize), imgui.GetColorU32Vec4(colorList['active']), 5)
                else
                    UI_ANIM_BUTTON.pos.current = p.y + nextPos
                end
                if tmenu and colorList ~= nil and rainbow ~= nil then --imgui.ImVec4(rainbow[1], rainbow[2], rainbow[3], 0.6)
                    -- mimgui_blur.apply(imgui.GetWindowDrawList(), 0)
                    imgui.GetWindowDrawList():AddRectFilled(imgui.ImVec2(p.x + size.x - 5, UI_ANIM_BUTTON.pos.current), imgui.ImVec2(p.x + size.x, UI_ANIM_BUTTON.pos.current + buttonSize), imgui.GetColorU32Vec4(imgui.ImVec4(rainbow[1], rainbow[2], rainbow[3], 0.2)), 5, 10)
                    
                    -- mimgui_blur.apply(imgui.GetWindowDrawList(), 1)    
                    -- imgui.GetWindowDrawList():AddRectFilled(imgui.ImVec2(p.x + size.x - 5, UI_ANIM_BUTTON.pos.current), imgui.ImVec2(p.x + size.x, UI_ANIM_BUTTON.pos.current + buttonSize), imgui.GetColorU32Vec4(colorList['side']), 5, 10)
                end
            end

            nextPos = nextPos + 17 + 10 + 5
        end
    end

    -- // ��� ����� ������, �� �� �������
    nextPos = 0
    imgui.PushFont(fonts[18])
    for k1, v1 in pairs(buttons) do
        imgui.PushFont(fonts[18])
        dl:AddText(imgui.ImVec2(p.x, p.y + nextPos), ColorU32('TextDisabled'), v1.title )
        imgui.PopFont()
        nextPos = nextPos + 13 + 5
        for k2, v2 in pairs(v1.list) do
            -- dl:AddText(imgui.ImVec2(p.x + 5, p.y + nextPos + ((buttonSize - 17) / 2) + 0.5), ColorU32('TextDisabled'), fa('CART_CIRCLE_PLUS'))
            dl:AddText(imgui.ImVec2(p.x + 5, p.y + nextPos + ((buttonSize - 17) / 2) + 0.8), ColorU32('Text'), v2)
            nextPos = nextPos + 17 + 10 + 5
        end
    end
    imgui.PopFont()
    
    if (json_timer[3] + 5 <= os.time()) or (current_lvl == nil) then
        json_timer[3] = os.time()
        current_lvl = readJsonFile('moonloader\\ArzMarket\\UsersInfo\\info_users_SelfInfo.json')
        if current_lvl ~= nil then
            local exp = current_lvl.exp
            local expNeeded = 4
            local playerLevel = 1

            while exp >= expNeeded do
                playerLevel = playerLevel + 1
                exp = exp - expNeeded
                expNeeded = expNeeded * 2
            end
            current_lvl.expNeeded = expNeeded
            current_lvl.virtual_exp = exp
            current_lvl.virtual_lvl = playerLevel
        end
        -- AFKMessage("��� �������: " .. playerLevel)
        -- AFKMessage("���� �� ���������� ������: " .. (expNeeded - exp))
    end


    if current_lvl ~= nil then
        imgui.SetCursorPosY(imgui.GetCursorPos().y + 422)
        imgui.SetCursorPosX(imgui.GetCursorPos().x - 1) -- // TODO EXP BAR
        imgui.BufferingBar("##buffer_bar", calculateProgress(current_lvl.virtual_exp, current_lvl.expNeeded), imgui.ImVec2(135, 3), imgui.GetColorU32Vec4(imgui.ImVec4(0.137, 0.137, 0.137, 1)), imgui.GetColorU32Vec4(imgui.ImVec4(0.137, 0.475, 0.365, 0.582)));
        
        imgui.SetCursorPosY(imgui.GetCursorPos().y - 30)
        imgui.SetCursorPosX(imgui.GetCursorPos().x + 48.5) -- // TODO EXP BAR
        imgui.CenterText('  '..current_lvl.virtual_exp..' / '..current_lvl.expNeeded..' EXP', true)
        imgui.SetCursorPosY(imgui.GetCursorPos().y - 40)
        imgui.CenterText('LVL: '..current_lvl.virtual_lvl, true)

    end
        -- end
    -- imgui.ImColor(35, 35, 35, 255):GetVec4()(0.137f, 0.475f, 0.365f, 0.682f)
    -- // ��� ��������� �������� "����" ��� ����������
    -- dl:AddRect(p, imgui.ImVec2(p.x + size.x, p.y + nextPos - 5), ColorU32('Text'))
    -- print('sizeChild', nextPos - 5)

    -- imgui.Dummy(imgui.ImVec2(size.x, nextPos - 5))
    -- for i = 0.01, 5 do
    --     AFKMessage(i)
    -- end
    
    local zzzz, ffff = 90, 90
    
    imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, 1)
    imgui.SetCursorPos(imgui.ImVec2((imgui.GetWindowWidth()) / 5, 343))
    imgui.CustomInvisibleChild('cfgBlowckFirst', imgui.ImVec2(zzzz, ffff), false, imgui.WindowFlags.NoScrollbar)
    local p = imgui.GetCursorScreenPos()
    -- imgui.GetWindowDrawList():AddRect(p, imgui.ImVec2(p.x + zzzz, p.y + ffff), imgui.GetColorU32Vec4(imgui.ImVec4(current_theme.Border[1], current_theme.Border[2], current_theme.Border[3], current_theme.Border[4])), 5, 0, rgb_width[0])
            
    local q = imgui.ImVec2(p.x + ((18) / 2), p.y + ffff - 83)
    imgui.GetWindowDrawList():AddCircle(imgui.ImVec2(q.x + 37.5, q.y + 37.5), 37.5, imgui.GetColorU32Vec4(imgui.ImVec4(rainbow[1], rainbow[2], rainbow[3], rainbow[4])), 50, 1)
    imgui.GetWindowDrawList():AddImageRounded(arizona, q, imgui.ImVec2(q.x + 75, q.y + 75), imgui.ImVec2(0, 0), imgui.ImVec2(1, 1), 0xFFFFFFFF, 60)
    imgui.GetWindowDrawList():AddCircle(imgui.ImVec2(q.x + 37.5, q.y + 37.5), 37.5, imgui.GetColorU32Vec4(imgui.ImVec4(rainbow[1], rainbow[2], rainbow[3], 0.6)), 50, 2)
    imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(q.x + 37.5, q.y + 37.5), 37.5, imgui.GetColorU32Vec4(imgui.ImVec4(current_theme.left_menu[1], current_theme.left_menu[2], current_theme.left_menu[3], 0.4)), 50, 2) -- 0.08, 0.09, 0.19, 0.6
    if left_menu_blur[0] then
        mimgui_blur.apply(imgui.GetWindowDrawList(), 1)
        -- AFKMessage('mimgui_blur_8')
    end
    imgui.EndCustomInvisibleChild()
    imgui.PopStyleVar()
end

function calculateProgress(currentExp, maxExp)
    local minProgress = 0.0
    local maxProgress = 1.0
    
    local progress = (currentExp / maxExp) * (1 - minProgress) + minProgress
    return math.min(maxProgress, math.max(minProgress, progress))
end

function imgui.SelectMenu(buttons, key)
    RadioButton_s = {new.int(333),333,false} 
    local current, nextPos = 0, 0
    for k1, v1 in pairs(buttons) do
        nextPos = nextPos + 13 + 5
        AFKMessage(tostring(v1))
        for k2, v2 in pairs(v1.list) do
            current = current + 1
            if current == key then
                UI_ANIM_BUTTON.label = v2
                UI_ANIM_BUTTON.time = os.clock()
                UI_ANIM_BUTTON.pos.last = UI_ANIM_BUTTON.pos.current
                UI_ANIM_BUTTON.pos.next = SelectMenuVertical + nextPos
                lua_thread.create(function() local ltmenu = current; wait(UI_ANIM_BUTTON.duration / 2 * 1000); menu = ltmenu end)
                return
            end
            nextPos = nextPos + 17 + 10 + 5
        end
    end
end



function imgui.CustomSeparator(width)
    local width = (width and width - 2 or imgui.GetWindowWidth() - 10)
    local p = imgui.GetCursorScreenPos()
    imgui.Dummy(imgui.ImVec2(width, 2))
    imgui.GetWindowDrawList():AddRectFilled(p, imgui.ImVec2(p.x + width, p.y + 1.4), imgui.GetColorU32Vec4(imgui.ImVec4(color_separator[0], color_separator[1], color_separator[2], color_separator[3])), 5)
end



function imgui.ToggleButton(str_id, value)
    local duration = button_duration[0]
    local p = imgui.GetCursorScreenPos()
      local DL = imgui.GetWindowDrawList()
    local size = imgui.ImVec2(40, 20)
      local title = str_id:gsub('##.*$', '')
      local ts = imgui.CalcTextSize(title)
      local cols = {
        enable = imgui.ImVec4(active_toggle_button[0], active_toggle_button[1], active_toggle_button[2], kifir),-- imgui.GetStyle().Colors[imgui.Col.CheckMark],
        disable = imgui.ImVec4(deactive_toggle_button[0], deactive_toggle_button[1], deactive_toggle_button[2], kifir)  -- imgui.GetStyle().Colors[imgui.Col.Button]  
      }
      local radius = 5
      local o = {
        x = 4,
        y = p.y + (size.y / 2)
      }
      local A = imgui.ImVec2(p.x + radius + o.x, o.y)
      local B = imgui.ImVec2(p.x + size.x - radius - o.x, o.y)
    --   AFKMessage(A)
      if AI_TOGGLE == nil then AI_TOGGLE = {} end
      if AI_TOGGLE[str_id] == nil then
          AI_TOGGLE[str_id] = {
            clock = nil,
            color = value[0] and cols.enable or cols.disable,
            pos = value[0] and B or A
          }
      end
      local pool = AI_TOGGLE[str_id]
      
      imgui.BeginGroup()
        local pos = imgui.GetCursorPos()
        local result = imgui.InvisibleButton(str_id, imgui.ImVec2(size.x, size.y))
        if result then
            value[0] = not value[0]
            pool.clock = os.clock()
        end
        if #title > 0 then
          local spc = imgui.GetStyle().ItemSpacing
          imgui.SetCursorPos(imgui.ImVec2(pos.x + size.x + spc.x, pos.y + ((size.y - ts.y) / 2)))
          imgui.Text(title)
        end
      imgui.EndGroup()
  
     if pool.clock and os.clock() - pool.clock <= duration then
          pool.color = bringVec4To(
              imgui.ImVec4(pool.color),
              value[0] and cols.enable or cols.disable,
              pool.clock,
              duration
          )
  
          pool.pos = bringVec2To(
            imgui.ImVec2(pool.pos),
            value[0] and B or A,
            pool.clock,
              duration
          )
      else
          pool.color = value[0] and cols.enable or cols.disable
          pool.pos = value[0] and B or A
      end
    DL:AddRect(p, imgui.ImVec2(p.x + size.x, p.y + size.y), imgui.ColorConvertFloat4ToU32(pool.color), 10, button_style[0] and 15 or 0, 1.5)
    if button_style[0] == true then
        DL:AddCircleFilled(pool.pos, radius, imgui.ColorConvertFloat4ToU32(pool.color))
    else
        -- DL:AddCircleFilled(pool.pos, radius, imgui.ColorConvertFloat4ToU32(pool.color))
        DL:AddRectFilled(imgui.ImVec2(p.x + 5 + (pool.pos.x - A.x) , p.y + 5), imgui.ImVec2(((p.x + size.x) - size.x / 1.5) + (pool.pos.x - A.x) , p.y + size.y - 5), imgui.ColorConvertFloat4ToU32(pool.color), 1)
    end
    
    return result
end


function onWindowMessage(msg, wparam, lparam)
	if msg == 0x100 or msg == 0x101 then
		if (wparam == 0x1B and show_menu) and not isPauseMenuActive() then
			consumeWindowMessage(true, false)
			if msg == 0x101 then
                show_menu = false
                renderWindow[0] = show_menu
			end
		end
	end
end


function onScriptTerminate(scr,qgame) --eror destroy script
	if scr == thisScript() then
        if full_irc_connect == true then
            s:prepart('#Freym_tech')
            print('destroy s:prepart')
            lua_thread.terminate(room_upd_irc_en)
        end
        if wait_dialog_d[1] ~= nil then
            print('destroy wait_dialog_d[1]')
            wait_dialog_d[1]:terminate()
        end
        if sell_alitems_d ~= nil then
            print('destroy sell_alitems_d')
            sell_alitems_d:terminate()
        end
        if kapibara_s[1] ~= nil then
            print('destroy kapibara_s[1]')
            kapibara_s[1]:terminate()
        end
        if scan_items_s[1] ~= nil then
            print('destroy scan_items_s[1]')
            scan_items_s[1]:terminate()
        end
    end
end
-- local newFrames = imgui.OnFrame(function() return separator[0] end, function()
--     resolutionX, resolutionY = getScreenResolution()
--     -- local dls = imgui.GetWindowDrawList()
--     -- local ps = imgui.GetCursorScreenPos()
    
--     local sizeX, sizeY = 400, 128
--     imgui.SetNextWindowPos(imgui.ImVec2(resolutionX / 2, resolutionY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
--     imgui.SetNextWindowSize(imgui.ImVec2(400, 128), imgui.Cond.Always)
--     imgui.Begin('Window Two', separator, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoBackground)
--     local clr = imgui.Col
--     imgui.PushStyleColor(clr.WindowBg, imgui.ImVec4(current_theme.window[1], current_theme.window[2], current_theme.window[3], current_theme.window[4] + 0.1))
--     imgui.PushStyleColor(clr.ChildBg, imgui.ImVec4(current_theme.window[1], current_theme.window[2], current_theme.window[3], 0))
--     imgui.PushStyleColor(clr.PopupBg, imgui.ImVec4(current_theme.window[1], current_theme.window[2], current_theme.window[3], current_theme.window[4] + 0.1))
    
--     local rainbow = rainbow(speed_s[0], alpha_s[0])
--     mimgui_blur.apply(imgui.GetWindowDrawList(), 15)
--     imgui.BeginChild('secondImguiMenu')
--     if separatorChar.page == 0 then
        
--         imgui.PushFont(font[20])
--         imgui.CenterText(ffi.string(separatorChar.buy) >= '0' and u8'��������� ������� ������: ' ..  moneySeparator(math.floor(tonumber(ffi.string(separatorChar.buy)) / #item_list)) or u8'������� ���-�� ����')
--         imgui.Separator()
--         imgui.Text(u8'���-�� ���� -')
--         imgui.SameLine()
--         imgui.PushItemWidth(150)
--         imgui.SetCursorPosY(imgui.GetCursorPosY() - 3)
--         imgui.InputText('##3', separatorChar.buy, 32, imgui.InputTextFlags.CharsDecimal)
--         imgui.Text(u8'���-�� ��������� - ' .. #item_list)
--         if imgui.CustomOnlyBorderButton(u8'������������', imgui.ImVec2(imgui.GetWindowWidth() - 1)) then
--             for k, v in pairs(item_list) do
--                 v.price = math.floor(tonumber(ffi.string(separatorChar.buy)) / #item_list)
--             end
--             AFKMessage('������������� ���������. ��������� ������� ������ - {505050}' .. moneySeparator(math.floor(tonumber(ffi.string(separatorChar.buy)) / #item_list)))
--             separator[0] = not separator[0]
--         end
--         imgui.PopItemWidth()
--         imgui.PopFont()
--     else
--         imgui.PushFont(font[20])
--         imgui.CenterText(ffi.string(separatorChar.sell) >= '0' and u8'��������� ������� ������: ' ..  moneySeparator(math.floor(tonumber(ffi.string(separatorChar.sell)) / #sell_list)) or u8'������� ���-�� ����')
--         imgui.Separator()
--         imgui.Text(u8'���-�� ���� -')
--         imgui.SameLine()
--         imgui.PushItemWidth(150)
--         imgui.SetCursorPosY( imgui.GetCursorPosY() - 3)
--         imgui.InputText('##3', separatorChar.sell, 32, imgui.InputTextFlags.CharsDecimal)
--         imgui.Text(u8'���-�� ��������� - ' .. #sell_list)
--         if imgui.CustomOnlyBorderButton(u8'������������##1', imgui.ImVec2(imgui.GetWindowWidth() - 1)) then
--             for k, v in pairs(sell_list) do
--                 v.price = math.floor(tonumber(ffi.string(separatorChar.sell)) / #sell_list)
--             end
--             AFKMessage('������������� ���������. ��������� ������� ������ - {505050}' .. moneySeparator(math.floor(tonumber(ffi.string(separatorChar.sell)) / #sell_list)))
--             separator[0] = not separator[0]
--         end
--         imgui.PopItemWidth()
--         imgui.PopFont()
--     end
--     imgui.EndChild()
--     imgui.PopStyleColor(3)
--     imgui.End()
--     -- local p = imgui.GetCursorScreenPos()
--     -- imgui.GetWindowDrawList()
--     -- q = imgui.ImVec2(p.x + ((150 - 75) / 2), p.y + 590)
--     -- dl:AddRectFilled(imgui.ImVec2(p.x + 150, p.y), imgui.ImVec2(p.x + sizeX, p.y + sizeY), imgui.GetColorU32Vec4(imgui.ImVec4(color_window[0], color_window[1], color_window[2], color_window[3])), 5, 10)
--     -- dl:AddImageRounded(arizona, q, imgui.ImVec2(q.x + 75, q.y + 75), imgui.ImVec2(0, 0), imgui.ImVec2(1, 1), 0xFFFFFFFF, 50)
--     -- dl:AddCircle(imgui.ImVec2(q.x + 37.5, q.y + 37.5), 37.5, imgui.GetColorU32Vec4(imgui.ImVec4(rainbow[1], rainbow[2], rainbow[3], rainbow[4])), 50, 2)
--     -- dl:AddRectFilled(p, imgui.ImVec2(p.x + 150, p.y + 700), imgui.GetColorU32Vec4(imgui.ImVec4(0.08, 0.09, 0.19, 0.5)), 5, 5)

--     -- dl:AddRectFilled(p, imgui.ImVec2(p.x + 150, p.y + 700), imgui.GetColorU32Vec4(imgui.ImVec4(0.08, 0.09, 0.19, 0.5)), 5, 5)
--     -- local p = imgui.GetCursorScreenPos()
--     -- imgui.GetWindowDrawList():AddRect(p, imgui.ImVec2(1, 1), imgui.GetColorU32Vec4(imgui.ImVec4(rainbow[1], rainbow[2], rainbow[3], rainbow[4])), 5, 15, 2)
--     -- imgui.GetWindowDrawList():AddCircle(imgui.ImVec2(1,1), 1.5, imgui.GetColorU32Vec4(imgui.ImVec4(rainbow[1], rainbow[2], rainbow[3], rainbow[4])), 50, 2)

-- end)

function nextpage()

    if imgui.CustomOnlyBorderButton(u8'<##0', imgui.ImVec2((imgui.GetWindowWidth() / 2) - 300, 27)) then
        menu = menu - 1
        
        imgui.SelectMenu(buttons, menu)
        -- select_tab = true
    end
    imgui.SameLine(600)
    if imgui.CustomOnlyBorderButton(u8'>##0', imgui.ImVec2(35, 27)) then
        menu = menu + 1
        imgui.SelectMenu(buttons, menu)
    end
end

local AI_ANIMBUT = {}
-- function imgui.AnimButton(label, size, duration)
--     if type(duration) ~= 'table' then
-- 		duration = { 1.0, 0.3 }
-- 	end

--     local cols = {
--         default = imgui.ImVec4(0.08, 0.09, 0.19, 0.00),
--         hovered = imgui.ImVec4(0.08, 0.09, 0.19, 1.00),
--         active  = imgui.ImVec4(0.08, 0.09, 0.19, 1.00)
--     }

--     if not AI_ANIMBUT[label] then
--         AI_ANIMBUT[label] = {
--             color = cols.default,
--             clicked = { nil, nil },
--             hovered = {
--                 cur = false,
--                 old = false,
--                 clock = nil,
--             }
--         }
--     end
--     local pool = AI_ANIMBUT[label]

--     if pool['clicked'][1] and pool['clicked'][2] then
--         if os.clock() - pool['clicked'][1] <= duration[2] then
--             pool['color'] = bringVec4To(
--                 pool['color'],
--                 cols.active,
--                 pool['clicked'][1],
--                 duration[2]
--             )
--             goto no_hovered
--         end

--         if os.clock() - pool['clicked'][2] <= duration[2] then
--             pool['color'] = bringVec4To(
--                 pool['color'],
--                 pool['hovered']['cur'] and cols.hovered or cols.default,
--                 pool['clicked'][2],
--                 duration[2]
--             )
--             goto no_hovered
--         end
--     end

--     if pool['hovered']['clock'] ~= nil then
--         if os.clock() - pool['hovered']['clock'] <= duration[1] then
--             pool['color'] = bringVec4To(
--                 pool['color'],
--                 pool['hovered']['cur'] and cols.hovered or cols.default,
--                 pool['hovered']['clock'],
--                 duration[1]
--             )
--         else
--             pool['color'] = pool['hovered']['cur'] and cols.hovered or cols.default
--         end
--     end

--     ::no_hovered::

--     imgui.PushStyleVarVec2(imgui.StyleVar.ButtonTextAlign, imgui.ImVec2(0, 0.5))
--     imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(pool['color']))
--     imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(pool['color']))
--     imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(pool['color']))
--     local result = imgui.Button(label, size or imgui.ImVec2(0, 0))
--     imgui.PopStyleVar(1)
--     imgui.PopStyleColor(3)

--     if result then
--         pool['clicked'] = {
--             os.clock(),
--             os.clock() + duration[2]
--         }
--     end

--     pool['hovered']['cur'] = imgui.IsItemHovered()
--     if pool['hovered']['old'] ~= pool['hovered']['cur'] then
--         pool['hovered']['old'] = pool['hovered']['cur']
--         pool['hovered']['clock'] = os.clock()
--     end

--     return result
-- end
function imgui.AnimButton(label, size, tmenu, rainbow)-- // TODO AnimButton
    
    local p = imgui.GetCursorScreenPos()
    local sizeX = (size and size.x > 0) and size.x or (imgui.GetStyle().FramePadding.y * 2 + imgui.CalcTextSize(label).x + 5)
    local sizeY = (size and size.y > 0) and size.y or (imgui.GetStyle().FramePadding.y * 2 + imgui.CalcTextSize(label).y)
    local tmenu = (tmenu and tmenu == menu)
    local colorList = {
        ['default'] = imgui.ImVec4(0.00, 0.00, 0.00, 0.00),
        ['active'] = imgui.ImVec4(0.11, 0.12, 0.24, 0.40),
        ['side'] = imgui.ImVec4(0.28, 0.3, 0.5, 1.00),
        ['hovered'] = imgui.ImVec4(0.08, 0.09, 0.19, 1.00)
    }

    imgui.PushStyleVarVec2(imgui.StyleVar.ButtonTextAlign, imgui.ImVec2(0, 0.5))
    imgui.PushStyleColor(imgui.Col.Button, colorList[(tmenu and 'active' or 'default')])
    imgui.PushStyleColor(imgui.Col.ButtonHovered, colorList[(tmenu and 'active' or 'hovered')])
    imgui.PushStyleColor(imgui.Col.ButtonActive, colorList[(tmenu and 'active' or 'hovered')])
    local result = imgui.Button(label, imgui.ImVec2(sizeX, sizeY))
    imgui.PopStyleVar(1)
    imgui.PopStyleColor(3)

    if tmenu and colorList ~= nil and rainbow ~= nil then --imgui.ImVec4(rainbow[1], rainbow[2], rainbow[3], 0.6)
        -- mimgui_blur.apply(imgui.GetWindowDrawList(), 0)
        imgui.GetWindowDrawList():AddRectFilled(imgui.ImVec2(p.x + sizeX - 5, p.y), imgui.ImVec2(p.x + sizeX, p.y + sizeY), imgui.GetColorU32Vec4(imgui.ImVec4(imgui.ImVec4(rainbow[1], rainbow[2], rainbow[3], 0.1))), 5, 10)
        
        -- mimgui_blur.apply(imgui.GetWindowDrawList(), 1)
        
    end
    
        -- mimgui_blur.apply(imgui.GetWindowDrawList(), 0)
    
    -- dl:AddRectFilled(imgui.ImVec2(p.x + 150.1, p.y), imgui.ImVec2(p.x + sizeX, p.y + sizeY), imgui.GetColorU32Vec4(imgui.ImVec4(color_window[0], color_window[1], color_window[2], color_window[3])), 5, 10)

    return result
end


function bringVec4To(from, to, start_time, duration)
    local timer = os.clock() - start_time
    if timer >= 0.00 and timer <= duration then
        local count = timer / (duration / 100)
        return imgui.ImVec4(
            from.x + (count * (to.x - from.x) / 100),
            from.y + (count * (to.y - from.y) / 100),
            from.z + (count * (to.z - from.z) / 100),
            from.w + (count * (to.w - from.w) / 100)
        ), true
    end
    return (timer > duration) and to or from, false
end

function bringVec2To(from, to, start_time, duration)
    local timer = os.clock() - start_time
    if timer >= 0.00 and timer <= duration then
        local count = timer / (duration / 100)
        return imgui.ImVec2(
            from.x + (count * (to.x - from.x) / 100),
            from.y + (count * (to.y - from.y) / 100)
        ), true
    end
    return (timer > duration) and to or from, false
end


function helpWithScan()
    imgui.PushFont(fonts[18])
    imgui.SetCursorPos(imgui.ImVec2(1, 325))
    imgui.SetCursorPosY(imgui.GetCursorPos().y)
    imgui.CenterText(u8'Welcome to '..tostring(thisScript().name))
    imgui.PopFont()
end



function addToTable(text, arr)
    AFKMessage("WFWAFWAF")
    local iscopy = false
  
    for _, value in ipairs(arr) do
        if value == text then
            iscopy = true
            break
        end
    end
  
    if not iscopy then
        table.insert(arr, text)
    end
end

function addToData(text, arr, slot)
    if slot == nil then 
        table.insert(arr, text) 
    else
        table.insert(arr, slot, text)
        return true
    end
end

function loadFonts(sizes)
    local fonts = {}
    local config = imgui.ImFontConfig()
    config.MergeMode = true
    config.PixelSnapH = true
    local iconRanges = imgui.new.ImWchar[3](fa.min_range, fa.max_range, 0)
    imgui.GetIO().Fonts:AddFontFromMemoryCompressedBase85TTF(fa.get_font_data_base85(), 16, config, iconRanges) -- �����������
    for i, v in ipairs(sizes) do
        -- sampAddChatMessage(tostring(v),-1)
        if v ~= 18 and v ~= 24 and v ~= 17 then
            fonts[v] = imgui.GetIO().Fonts:AddFontFromFileTTF(getWorkingDirectory() .. '/ArzMarket/MuseoSansCyrl-900.ttf', v, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
        else
            fonts[v] = imgui.GetIO().Fonts:AddFontFromFileTTF(getWorkingDirectory() .. '/ArzMarket/EagleSans-Regular.ttf', v, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
        end
    end
    imgui.GetIO().Fonts:AddFontFromMemoryCompressedBase85TTF(fa.get_font_data_base85(), 16, config, iconRanges) -- �����������
    return fonts
end

-- function readJsonFile(filePath)
--     local file = io.open(filePath, "r")
--     if file then
--         local content = file:read("*a")
--         file:close()
--         return cjson.decode(content)
--     else
--         return nil
--     end
-- end

function imgui.NewInput(name, charBuf, bufSize)
    
    imgui.GetStyle().FrameBorderSize = border_side[0] and 1 or 0
    local dl = imgui.GetWindowDrawList()
    local p = imgui.GetCursorScreenPos()
    if #(u8:decode(ffi.string(charBuf))) == 0 then
        dl:AddText(imgui.ImVec2(p.x + ((imgui.GetWindowWidth() - 220) / 6), p.y + 5), imgui.GetColorU32Vec4(imgui.ImVec4(current_theme.text[1], current_theme.text[2], current_theme.text[3], current_theme.text[4] - 0.5)), name)
    end
    local result = imgui.InputText('##'..name, charBuf, bufSize)
    imgui.GetStyle().FrameBorderSize = 0

    return result
end

function CloseButton()
    imgui.SetCursorPos(imgui.ImVec2(imgui.GetWindowWidth() - 55, 6))
    if imgui.Button(fa('xmark'), imgui.ImVec2((imgui.GetWindowWidth() / 2) - 300, 27)) then
        window[0] = false
    end
end

function imgui.CustomInvisibleChild(...)
    local clr = imgui.Col
    imgui.PushStyleColor(clr.WindowBg, imgui.ImVec4(0, 0, 0, 0))
    imgui.PushStyleColor(clr.ChildBg, imgui.ImVec4(0, 0, 0, 0))
    imgui.PushStyleColor(clr.PopupBg, imgui.ImVec4(0.08, 0.08, 0.08, 0.94))
    -- imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, alpha_z)
    -- imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8.00, 8.00))
    -- imgui.PopStyleVar(1)
    imgui.BeginChild(...)
end


function imgui.InputTextD(name, buf, leg, settings)
    
    imgui.GetStyle().FrameBorderSize = border_side[0] and 1 or 0
    local result = imgui.InputText(name, buf, leg, settings)
    imgui.GetStyle().FrameBorderSize = 0
    return result
end


function imgui.InputTextWithHintD(...)
    imgui.GetStyle().FrameBorderSize = border_side[0] and 1 or 0
    -- if imgui.InputTextWithHint("##InputMessage", u8"������� ���������", send_irc_msg, ffi.sizeof(send_irc_msg),imgui.InputTextFlags.EnterReturnsTrue) then
    -- local result = imgui.InputText(name, buf, leg, settings)
    local result = imgui.InputTextWithHint(...)
    imgui.GetStyle().FrameBorderSize = 0
    return result
end


function imgui.EndCustomInvisibleChild()
    imgui.EndChild()
    -- imgui.PopStyleVar()
    imgui.PopStyleColor(3)
end


function removeTrash(str)
    if str:gsub('%D', '') ~= '' then
        return str:gsub('%D', '')
    else
        return '0'
    end
end

function changeExtraSim(input, max_len)
    local max_length = max_len
    if #input > max_length then
        return string.sub(input, 1, max_length - 3) .. "..."
    else
        return input
    end
end

function moneySeparator(number)
    local formattedNumber = tostring(number)
    local minusSign = ""
    
    if string.sub(formattedNumber, 1, 1) == "-" then
        minusSign = "-"
        formattedNumber = string.sub(formattedNumber, 2)
    end

    local length = string.len(formattedNumber)
    local result = ""
    
    for i = length, 1, -3 do
        local chunk = string.sub(formattedNumber, math.max(i - 2, 1), i)
        result = chunk .. (result == "" and "" or "." .. result)
    end
    
    return minusSign .. result
end


function imgui.CenterText(text, is_disabled, max_count)
    local width = imgui.GetWindowWidth()
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    if is_disabled == nil then if max_count == nil then imgui.Text(text) else changeExtraSim(text, max_count)  end else imgui.TextDisabled(u8(text)) end
end

function bringIntTo(from, to, start_time, duration)
    local timer = os.clock() - start_time
    if timer >= 0.00 and timer <= duration then
        local count = math.ceil(timer / (duration / 100))
        return from + (count * (to - from) / 100), true
    end
    return (timer > duration) and to or from, false
end

function bringFloatTo(from, to, start_time, duration)
    local timer = os.clock() - start_time
    if timer >= 0.00 and timer <= duration then
        local count = timer / (duration / 100)
        return from + (count * (to - from) / 100), true
    end
    return (timer > duration) and to or from, false
end

function ImVec3ToHEX(imVec)
    local r = math.floor(imVec[1] * 255)
    local g = math.floor(imVec[2] * 255)
    local b = math.floor(imVec[3] * 255)

    return string.format("{%02X%02X%02X}", r, g, b)
end

function imgui.TextColoredRGB(text)
    
    -- if UI_ANIM_BUTTON and (os.clock() - UI_ANIM_BUTTON.time <= UI_ANIM_BUTTON.duration) then
    --     local alphaCheck = ((os.clock() - UI_ANIM_BUTTON.time) <= (UI_ANIM_BUTTON.duration / 2)) and {0, 1} or {1, 0}
    --     local startTime = ((os.clock() - UI_ANIM_BUTTON.time) <= (UI_ANIM_BUTTON.duration / 2)) and UI_ANIM_BUTTON.time or UI_ANIM_BUTTON.time + UI_ANIM_BUTTON.duration / 2
    --     alpha_slider = bringFloatTo(alphaCheck[1], alphaCheck[2], startTime, UI_ANIM_BUTTON.duration / 2)
    --     -- imgui.GetWindowDrawList():AddRectFilled(imgui.ImVec2(p.x + 150, p.y + 2), imgui.ImVec2(p.x + sizeX - 2, p.y + sizeY - 2), imgui.GetColorU32Vec4(imgui.ImVec4(0.05, 0.06, 0.1, alpha)), 5, 10)
    -- end
    local style = imgui.GetStyle()
    local colors = style.Colors
    local ImVec4 = imgui.ImVec4
    local explode_argb = function(argb)
        local a = bit.band(bit.rshift(argb, 24), 0xFF)
        local r = bit.band(bit.rshift(argb, 16), 0xFF)
        local g = bit.band(bit.rshift(argb, 8), 0xFF)
        local b = bit.band(argb, 0xFF)
        return a, r, g, b
    end
    local getcolor = function(color)
        if color:sub(1, 6):upper() == 'SSSSSS' then
            local r, g, b = colors[1].x, colors[1].y, colors[1].z
            local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
            return ImVec4(r, g, b, a / 255)
        end
        local color = type(color) == 'string' and tonumber(color, 16) or color
        if type(color) ~= 'number' then return end
        local r, g, b, a = explode_argb(color)
        -- if alpha_slider ~= nil then
        --     alpha_slider = alpha_slider
        -- else
        --     alpha_slider = a/255
        -- end
        return imgui.ImVec4(r/255, g/255, b/255, a/255)
    end
    local render_text = function(text_)
        for w in text_:gmatch('[^\r\n]+') do
            local text, colors_, m = {}, {}, 1
            w = w:gsub('{(......)}', '{%1FF}')
            while w:find('{........}') do
                local n, k = w:find('{........}')
                local color = getcolor(w:sub(n + 1, k - 1))
                if color then
                    text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
                    colors_[#colors_ + 1] = color
                    m = n
                end
                w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
            end
            if text[0] then
                for i = 0, #text do
                    imgui.TextColored(colors_[i] or colors[1], u8(text[i]))
                    imgui.SameLine(nil, 0)
                end
                imgui.NewLine()
            else imgui.Text(u8(w)) end
        end
    end
    render_text(text)
end

function imgui.VerticalSeparator()
    local p = imgui.GetCursorScreenPos()
    imgui.GetWindowDrawList():AddLine(imgui.ImVec2(p.x, p.y), imgui.ImVec2(p.x - 1, p.y + (imgui.GetContentRegionMax().y - 540)), imgui.GetColorU32Vec4(imgui.ImVec4(current_theme.separator[1], current_theme.separator[2], current_theme.separator[3], current_theme.separator[4])));
end

-- function imgui.NormalSeparator()
--     local p = imgui.GetCursorScreenPos()
    
--     imgui.GetWindowDrawList():AddLine(imgui.ImVec2(p.x+60000, p.y), imgui.ImVec2(p.x - 5000000, p.y + (imgui.GetContentRegionMax().y - 540)), imgui.GetColorU32Vec4(imgui.GetStyle().Colors[imgui.Col.Separator]))
-- end
-- function imgui.CustomSeparator(width)
--     local width = (width and width - 2 or imgui.GetWindowWidth() - 12)
--     local p = imgui.GetCursorScreenPos()
--     imgui.Dummy(imgui.ImVec2(width, 2))
--     imgui.GetWindowDrawList():AddRectFilled(p, imgui.ImVec2(p.x + width, p.y + 2), imgui.GetColorU32Vec4(imgui.GetStyle().Colors[imgui.Col.Separator]), 5)
-- end

function pltcfg(raw, sellbuy)
    local file = io.open(raw, "r")
    if file ~= nil then
        local script = file:read("*all")
        file:close()
        script = 'local tbl = {}\n' .. script .. '\n return tbl'
        local code = loadstring(script)
        setfenv(code, {
            table = { insert = table.insert }
        })
        local res, tbl = pcall(code)
        if sellbuy == 1 then
            sell_list = {}
            for k, v in pairs(tbl) do
                if type(v) == 'table' then
                    local data = {name = tostring(tbl[k].name), price = tostring(tbl[k].price), count = tostring(tbl[k].number), slot_count = {tostring(tbl[k].number)}, slot_id = tostring(tbl[k].number), all_count = tostring(tbl[k].number), enabled = tbl[k].enabled , maximum = tbl[k].maximum, price_vc = tbl[k].number_dynamic }
                    addToData(data, sell_list)
                end
            end
        elseif sellbuy == 2 then
            item_list = {}
            for k, v in pairs(tbl) do
                if type(v) == 'table' then
                    local data = {name = tostring(tbl[k].name), price = tostring(tbl[k].price), count = tostring(tbl[k].number), enabled = tbl[k].enabled, price_vc = tbl[k].number_dynamic}
                    addToData(data, item_list)
                end
            end
        end
    else
        AFKMessage('error2')
    end
end

function loadConfig(path)
    -- print(path)
    return readJsonFile(path) -- ..'.json'
end

function createConfig(name, data)
    local config_path = ('moonloader/ArzMarket/'..name) -- ..'.json'
    writeJsonFile(data, config_path)
end

function string.nlower(s)
	local line_lower = string.lower(s)
	for line in s:gmatch('.') do
		if (string.byte(line) >= 192 and string.byte(line) <= 223) or string.byte(line) == 168 then
			line_lower = string.gsub(line_lower, line, string.char(string.byte(line) == 168 and string.byte(line) + 16 or string.byte(line) + 32), 1)
		end
	end
	return line_lower
end


function imgui.CustomOnlyBorderButton(...)
    local clr = imgui.Col
    imgui.PushStyleColor(clr.Button, imgui.ImVec4(0, 0, 0, 0))
    imgui.PushStyleColor(clr.ButtonHovered, imgui.ImVec4(0, 0, 0, 0))
    imgui.PushStyleColor(clr.ButtonActive, imgui.ImVec4(0, 0, 0, 0))
    imgui.PushStyleColor(clr.Border, imgui.ImVec4(1, 1, 1, 0.1))
    local p = imgui.GetCursorPos()
    local result = imgui.Button(...)
    if imgui.IsItemHovered() then
        imgui.PushStyleColor(clr.Border, imgui.ImVec4(1, 1, 1, 0.5))
        imgui.SetCursorPos(p)
        local result = imgui.Button(...)
        imgui.PopStyleColor(1)
    end
    imgui.PopStyleColor(4)

    return result
end

function cfg_menu() -- // TODO cfg_menu()
    -- CloseButton()
    -- nextpage()
    
    -- imgui.PushItemWidth(125)
    -- -- if imgui.Combo("##1", int_item, ImItems, #item_list) then end
    -- if imgui.CustomOnlyBorderButton(u8'<##0', imgui.ImVec2((imgui.GetWindowWidth() / 2) - 300, 27)) then
    --     menu = menu - 1
    --     imgui.SelectMenu(buttons, menu)
    -- end
    -- imgui.SetCursorPos(imgui.ImVec2((imgui.GetWindowWidth() + 400) / 2, 27))
    -- imgui.PushItemWidth(255)
    -- sampAddChatMessage(search_sell[1],-1)
    -- imgui.NewInput(u8' ����� ���������', search_sell, 255)
    imgui.SameLine(555)
    imgui.SetCursorPosY(imgui.GetCursorPos().y + 5)
    if imgui.CustomOnlyBorderButton(fa('CART_ARROW_UP').."##", imgui.ImVec2(35, 27)) then
        -- table.remove(item_list, key)
        menu = 1
        imgui.SelectMenu(buttons, 1)
    end
    imgui.SameLine()
    if imgui.CustomOnlyBorderButton(fa('CART_CIRCLE_PLUS').."##", imgui.ImVec2(35, 27)) then
        -- table.remove(item_list, key)
        menu = 2
        imgui.SelectMenu(buttons, 2)
    end
    imgui.SameLine()
    
    imgui.SetCursorPosX(imgui.GetCursorPos().x - 2)
    if imgui.CustomOnlyBorderButton(fa('xmark')..'##0', imgui.ImVec2(35, 27)) then
        show_menu = false
        renderWindow[0] = show_menu
    end
    imgui.Hint('xmark', u8'����� ������ �� �������� ���� �������.', false)
    -- imgui.SetCursorPos(imgui.ImVec2(40, 60))
    imgui.CustomInvisibleChild('cfgBlockFirst', imgui.ImVec2(imgui.GetWindowWidth() / 2.1, sizeY), false, imgui.WindowFlags.NoScrollbar)
    -- round_text(1)




    imgui.PushFont(fonts[18])
    imgui.CenterText(u8'���������')
    -- imgui.PopFont()
    
    -- imgui.CustomInvisibleChild('sellLeftList', imgui.ImVec2(imgui.GetWindowWidth() / 2.2, -1))
    -- if readJsonFile(items_sell) ~= nil then
    --     for k, data in pairs(readJsonFile(items_sell)) do
    --         if u8:decode(ffi.string(data.item)) ~= 0 and string.find(string.nlower(data.item), string.nlower(u8:decode(ffi.string(search_sell))), nil, true) then
    --             -- imgui.PushFont(font[22])
    --             imgui.PushFont(fonts[18])
    --             imgui.Text(u8(changeExtraSim(k..'. '..data.item..' - '.. data.count..' ��. [slot_id='..tostring(data.slot_id)..']' , 45))) -- �����
    --         end
    --     end
    -- end
    
    -- imgui.EndCustomInvisibleChild()
    -- imgui.CustomInvisibleChild('cfgBuyBlockSecond', imgui.ImVec2(imgui.GetWindowWidth() / 1, 100), true)
    -- Always_convert
    imgui.PushItemWidth(150)
    
    if imgui.ToggleButton(u8('������ �������������� [VC$/SA$]'), Always_convert) then
        ini.cfg.Always_convert = Always_convert[0]
        save_all()
    end
    if Always_convert[0] then
        if imgui.ToggleButton(u8('�������������� ������ 1 ���'), Always_convert_block) then
            ini.cfg.Always_convert_block = Always_convert_block[0]
            save_all()
        end
    end
    if imgui.InputTextD(u8'  ���� ������� VC$', buy_vc, ffi.sizeof(buy_vc), imgui.InputTextFlags.CharsDecimal) then
        ini.cfg.buy_vc = ffi.string(buy_vc)
        save_all()
    end
    if imgui.InputTextD(u8'  ���� ������� VC$', sell_vc, ffi.sizeof(sell_vc), imgui.InputTextFlags.CharsDecimal) then
        ini.cfg.sell_vc = ffi.string(sell_vc)
        save_all()
    end
    -- if imgui.InputTextWithHintD(u8'  ���� ������� VC$', u8'���� ������� VC$', buy_vc, ffi.sizeof(buy_vc), imgui.InputTextFlags.CharsDecimal) then
    --     ini.cfg.buy_vc = ffi.string(buy_vc)
    --     save_all()
    --     -- AFKMessage(u8:decode(ffi.string(lavka_name)):len())
    -- end
    -- if imgui.InputTextWithHintD(u8'  ���� ������� VC$', u8'���� ������� VC$', buy_sell, ffi.sizeof(buy_sell), imgui.InputTextFlags.CharsDecimal) then
    --     ini.cfg.buy_sell = ffi.string(buy_sell)
    --     save_all()
    --     -- AFKMessage(u8:decode(ffi.string(lavka_name)):len())
    -- end
    if imgui.ToggleButton(u8('�������� ��������� ��������� �����'), lavka_helper) then
        ini.cfg.lavka_helper = lavka_helper[0]
        save_all()
    end
    if imgui.ToggleButton(u8('���� ������'), replace_window) then
        ini.cfg.replace_window = replace_window[0]
        save_all()
    end
    if imgui.ToggleButton(u8('��������� �����������'), telegram_notf) then
        ini.cfg.telegram_notf = telegram_notf[0]
        save_all()
    end
    if telegram_notf[0] then
        if imgui.Button(u8'������� ��������� �����������', imgui.ImVec2((imgui.GetWindowWidth()), 27)) then
            imgui.OpenPopup(u8('[TG] ���������'))
            
        end; tg_settings()
    end
    if imgui.ToggleButton(u8('���������� �������� �������'), controller_sell_buy) then
        ini.cfg.controller_sell_buy = controller_sell_buy[0]
        save_all()
    end
    if imgui.ToggleButton(u8('��� � ���������'), trader_bool) then
        ini.cfg.trader_bool = trader_bool[0]
        save_all()
    end
    if imgui.ToggleButton(u8('������������� �������� �����'), auto_name_lavka) then
        ini.cfg.auto_name_lavka = auto_name_lavka[0]
        save_all()
    end
    -- if imgui.ToggleButton2(u8('������������� �������� �����##01'), auto_name_lavka) then
    --     ini.cfg.auto_name_lavka = auto_name_lavka[0]
    --     save_all()
    -- end
    -- imgui.custom_togglebutton('[2] Test', auto_name_lavka, imgui.ImVec2(40, 20))
    if auto_name_lavka[0] then 

        imgui.PushFont(fonts[18])
        if imgui.InputTextWithHintD('##nazvanie lavki', u8'�������� �����', lavka_name, ffi.sizeof(lavka_name)) then
            ini.cfg.lavka_name = ffi.string(lavka_name)
            save_all()
            -- AFKMessage(u8:decode(ffi.string(lavka_name)):len())
        end
        -- AFKMessage(u8:decode(ffi.string(lavka_name)))
        imgui.PopFont() 
    end
    -- imgui.ToggleButton('Blure function (left)', left_menu_blur)
    imgui.EndCustomInvisibleChild()
    imgui.SameLine()
    -- imgui.VerticalSeparator()
    -- imgui.SetCursorPosX(650)
    imgui.CustomInvisibleChild('cfgSellBlockFirst', imgui.ImVec2(imgui.GetWindowWidth() / 1.95, -1), false, imgui.WindowFlags.NoScrollbar)
        imgui.PushFont(fonts[18])
        imgui.SetCursorPosX(imgui.GetCursorPos().x + 135)
        imgui.Text(u8'�������')
        imgui.PopFont()
        round_text(1)
        imgui.CustomInvisibleChild('cfgSellBlockSecond', imgui.ImVec2(imgui.GetWindowWidth() - 15, sizeY/3.8), true, imgui.WindowFlags.NoScrollWithMouse)
        imgui.Scroller('cfg1', 100, 600, imgui.HoveredFlags.AllowWhenBlockedByActiveItem) 
        round_text(0)
        -- local p = imgui.GetCursorScreenPos()
        -- imgui.GetWindowDrawList():AddRect(p, imgui.ImVec2(p.x + 250, p.y + 120), imgui.GetColorU32Vec4(imgui.ImVec4(1.000, 1.000, 1.000, 0.75)), 0, 0, 0.1)
        for line in lfs.dir(getWorkingDirectory()..'\\ArzMarket\\sell-cfg') do
            if line == nil then
            elseif line:match(".+%.cfg") then
                imgui.PushFont(fonts[18])
                local cfg_name = u8'{FFFFFF}'..line:match(".+%.cfg")
                imgui.SetCursorPosY(imgui.GetCursorPos().y + 5)
                -- AFKMessage(cfg_name..' '..load_config_sell)
                -- imgui.GetWindowDrawList():AddText(imgui.ImVec2(p.x + 471, p.y+22), imgui.GetColorU32Vec4(imgui.ImVec4(1.000, 1.000, 1.000, 0.75)), cfg_name)
                if line:match(".+%.cfg") == load_config_sell..'.cfg' then
                    -- AFKMessage('+__+_+_+_+')
                    imgui.TextColoredRGB(tostring(changeExtraSim(cfg_name..' {808080}[plt.lua]{ffff00} [Loaded]', 100)))
                else
                    imgui.TextColoredRGB(tostring(changeExtraSim(cfg_name..' {808080}[plt.lua]', 100)))
                end
                if #cfg_name > 50 then
                    if imgui.IsItemHovered() then
                        imgui.BeginTooltip()
                        imgui.TextColoredRGB(cfg_name)
                        imgui.EndTooltip()
                    end
                end
                imgui.PopFont()
                imgui.SameLine()
                imgui.PushFont(fonts[18])
                imgui.SetCursorPos(imgui.ImVec2(imgui.GetWindowWidth() - 65, imgui.GetCursorPos().y - 2))
                if imgui.CustomOnlyBorderButton(fa('PLAY')..'##'..line:match(".+%.cfg")) then
                    -- current_cfg.sell = ('moonloader/ArzMarket/sell-cfg/'..line:match("(.+)%.json"))
                    -- sell_list = loadConfig('moonloader/ArzMarket/sell-cfg/'..line:match("(.+)%.json"))
                    -- AFKMessage('������ {505050}'..line:match("(.+)%.json")..'{ffffff} ������� ��������.', sell_list)
                    -- AFKMessage('_+')
                    local raw = getWorkingDirectory() .. "\\ArzMarket\\sell-cfg\\"..tostring(line:match(".+%.cfg"))
                    -- print(raw)
                    if doesFileExist(raw) then
                        AFKMessage('good')
                        pltcfg(raw, 1)
                        ini.cfg.load_config_sell = line:match("(.+)%.cfg")
                        load_config_sell = line:match("(.+)%.cfg")
                        save_all()
                    else
                        AFKMessage('error [plt]')
                    end
                end
                imgui.SameLine()
                if imgui.CustomOnlyBorderButton(fa('trash')..'##'..line..line:match("(.+)%.cfg")) then
                    local success, errorMessage = os.remove('moonloader/ArzMarket/sell-cfg/'..line:match("(.+)%.cfg")..'.cfg')
                    if success then
                        -- print(line)
                        -- print(load_config_sell)
                        if line == load_config_sell..'.cfg' then 
                            ini.cfg.load_config_sell = '' --:match("(.+)%.json")
                            load_config_sell = '' --:match("(.+)%.json")
                            save_all()
                        end
                        AFKMessage('������ {505050}'..line:match("(.+)%.cfg")..' {ffffff}������.')
                    else
                        print(errorMessage)
                    end
                end
                imgui.PopFont()
            elseif line:match(".+%.json") then
                imgui.PushFont(fonts[18])
                local cfg_name = u8'{ffffff}'..line --:match("(.+)%.json")..'.json'
                imgui.SetCursorPosY(imgui.GetCursorPos().y + 5)
                -- AFKMessage(cfg_name..' '..load_config_sell)
                -- imgui.GetWindowDrawList():AddText(imgui.ImVec2(p.x + 471, p.y+22), imgui.GetColorU32Vec4(imgui.ImVec4(1.000, 1.000, 1.000, 0.75)), cfg_name)
                -- AFKMessage(line..' '..load_config_sell)
                if line == load_config_sell then -- :match("(.+)%.json")
                    -- AFKMessage('+__+_+_+_+')
                    imgui.TextColoredRGB(tostring(changeExtraSim(cfg_name..'{ffff00} [Loaded]', 50)))
                else
                    imgui.TextColoredRGB(tostring(changeExtraSim(cfg_name, 50)))
                end
                if #cfg_name > 50 then
                    if imgui.IsItemHovered() then
                        imgui.BeginTooltip()
                        imgui.TextColoredRGB(cfg_name)
                        imgui.EndTooltip()
                    end
                end
                if imgui.IsItemHovered() then
                    -- imgui.Hint(u8"�������� '��� ��������' ���� ����������� :)",0)
                    -- imgui.PushStyleColor(imgui.Col.PopupBg, imgui.ImVec4(0.11, 0.11, 0.11, 1.00))
                    -- imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8.00, 8.00))
                    imgui.BeginTooltip()
                    local data = readJsonFile('moonloader/ArzMarket/sell-cfg/'..line:match("(.+)%.json")..'.json')
                    imgui.Text(u8('�������� �������: '..line:match("(.+)%.json")..'\n '))
                    for k, v in pairs(data) do
                        imgui.Text(tostring(u8(v.name)))
                    end
                    -- imgui.PopStyleVar(1)
                    imgui.EndTooltip()
                end
                imgui.PopFont()
                imgui.SameLine()
                imgui.PushFont(fonts[18])
                imgui.SetCursorPos(imgui.ImVec2(imgui.GetWindowWidth() - 65, imgui.GetCursorPos().y - 2))
                if imgui.CustomOnlyBorderButton(fa('PLAY')..'##'..line:match(".+%.json")) then
                    -- current_cfg.sell = ('moonloader/ArzMarket/sell-cfg/'..line:match("(.+)%.json"))
                    sell_list = loadConfig('moonloader/ArzMarket/sell-cfg/'..line) -- :match("(.+)%.json")
                    AFKMessage('������ {505050}'..line:match("(.+)%.json")..'{ffffff} ������� ��������.', sell_list)
                    ini.cfg.load_config_sell = line --:match("(.+)%.json")
                    load_config_sell = line --:match("(.+)%.json")
                    save_all()
                end
                imgui.SameLine()
                if imgui.CustomOnlyBorderButton(fa('trash')..'##'..line..line:match("(.+)%.json")) then
                    local success, errorMessage = os.remove('moonloader/ArzMarket/sell-cfg/'..line:match("(.+)%.json")..'.json')
                    if success then
                        if line == load_config_sell then 
                            ini.cfg.load_config_sell = '' --:match("(.+)%.json")
                            load_config_sell = '' --:match("(.+)%.json")
                            save_all()
                        end
                        AFKMessage('������ {505050}'..line:match("(.+)%.json")..' {ffffff}������.')
                    else
                        print(errorMessage)
                    end
                end
                imgui.PopFont()
                -- imgui.Separator()
            end
        end
        imgui.EndCustomInvisibleChild()
        imgui.PushItemWidth(imgui.GetWindowWidth() - 43)
        -- imgui.PushItemWidth(imgui.GetWindowWidth() - 15)
        imgui.PushFont(fonts[18])
        imgui.InputTextWithHintD('##search_cfg_sell', u8'�������� �������', search_cfg_sell, ffi.sizeof(search_cfg_sell))
        imgui.SameLine()
        imgui.PushFont(fonts[18])
        -- imgui.SetCursorPosY(imgui.GetCursorPos().y - 107)
        -- imgui.SetCursorPosX(imgui.GetCursorPos().x +)
        if imgui.CustomOnlyBorderButton(fa('FOLDER')..'##0.21223123') then 
            os.execute("explorer "..getWorkingDirectory().."\"\\ArzMarket\\sell-cfg")
        end
        imgui.PopFont()
        imgui.PopItemWidth()
        -- imgui.PushItemWidth(1)
        imgui.GetStyle().FrameBorderSize = border_side[0] and 1 or 0
        if imgui.Button(u8'�������', imgui.ImVec2((imgui.GetWindowWidth() - 15) , 35)) then
            tosave.sell =  u8:decode(ffi.string(search_cfg_sell))
            if (tosave.sell == '') or (tosave.sell == nil) or (tosave.sell:match("^%s*$") ~= nil) then
                AFKMessage("{ff3535}[Error]:{ffffff} �� �� ������ ������� {505050}���������� {ffffff}������.")
            else 
                createConfig('sell-cfg/'..tosave.sell..'.json', {})
                AFKMessage("������ {505050}"..tostring(tosave.sell)..'{ffffff} ������2.')
            end
        end
        imgui.GetStyle().FrameBorderSize = 0
        -- imgui.SameLine()

        
        -- local data = {name = data.item, price = item_sell.price, count = item_sell.count, slot_count = data.count, slot_id = data.slot_id, all_count = data.all_count}
        -- addToData(data, sell_list)
        -- if imgui.Button(u8'����������� �� �������', imgui.ImVec2((imgui.GetWindowWidth() - 25) /2 , 35)) then
        --     tosave.sell =  u8:decode(ffi.string(search_cfg_sell))
        --     if (tosave.sell == '') or (tosave.sell == nil) or (tosave.sell:match("^%s*$") ~= nil) then
        --         AFKMessage("{ff3535}[Error]:{ffffff} �� �� ������ ����������� {505050}���������� {ffffff}������.")
        --     else 
                
        --     end
        -- end
        imgui.PopFont()
        round_text(0)
---------------========================
        -- imgui.CustomInvisibleChild('cfgBlockFirst', imgui.ImVec2(400, 600), false, imgui.WindowFlags.NoScrollbar)
        -- round_text(1)
        imgui.PushFont(fonts[18])
        imgui.SetCursorPosX(imgui.GetCursorPos().x + 140)
        imgui.Text(u8'������')
        imgui.PopFont()
        
        -- imgui.CustomInvisibleChild('sellLeftList', imgui.ImVec2(imgui.GetWindowWidth() / 2.2, -1))
        -- if readJsonFile(items_sell) ~= nil then
        --     for k, data in pairs(readJsonFile(items_sell)) do
        --         if u8:decode(ffi.string(data.item)) ~= 0 and string.find(string.nlower(data.item), string.nlower(u8:decode(ffi.string(search_sell))), nil, true) then
        --             -- imgui.PushFont(font[22])
        --             imgui.PushFont(fonts[18])
        --             imgui.Text(u8(changeExtraSim(k..'. '..data.item..' - '.. data.count..' ��. [slot_id='..tostring(data.slot_id)..']' , 45))) -- �����
        --         end
        --     end
        -- end
        
        -- imgui.EndCustomInvisibleChild()
        -- imgui.SetCursorPosX(imgui.GetCursorPos().x - 5)
        round_text(1)
        imgui.CustomInvisibleChild('cfgBuyBlockSecond', imgui.ImVec2(imgui.GetWindowWidth() - 15 , (sizeY/3.82)), true, imgui.WindowFlags.NoScrollWithMouse)
        imgui.Scroller('cfg2', 100, 600, imgui.HoveredFlags.AllowWhenBlockedByActiveItem) 
        round_text(0)
        for line in lfs.dir(getWorkingDirectory()..'\\ArzMarket\\buy-cfg') do
            if line == nil then
            elseif line:match(".+%.cfg") then
                imgui.PushFont(fonts[18])
                local cfg_name = u8'{FFFFFF}'..line:match(".+%.cfg")
                imgui.SetCursorPosY(imgui.GetCursorPos().y + 5)
                -- AFKMessage(cfg_name..' '..load_config_sell)
                -- imgui.GetWindowDrawList():AddText(imgui.ImVec2(p.x + 471, p.y+22), imgui.GetColorU32Vec4(imgui.ImVec4(1.000, 1.000, 1.000, 0.75)), cfg_name)
                if line:match(".+%.cfg") == load_config_buy..'.cfg' then
                    -- AFKMessage('+__+_+_+_+')
                    imgui.TextColoredRGB(tostring(changeExtraSim(cfg_name..' {808080}[plt.lua]{ffff00} [Loaded]', 100)))
                else
                    imgui.TextColoredRGB(tostring(changeExtraSim(cfg_name..' {808080}[plt.lua]', 100)))
                end
                if #cfg_name > 50 then
                    if imgui.IsItemHovered() then
                        imgui.BeginTooltip()
                        imgui.TextColoredRGB(cfg_name)
                        imgui.EndTooltip()
                    end
                end
                imgui.PopFont()
                imgui.SameLine()
                imgui.PushFont(fonts[18])
                imgui.SetCursorPos(imgui.ImVec2(imgui.GetWindowWidth() - 65, imgui.GetCursorPos().y - 2))
                if imgui.CustomOnlyBorderButton(fa('PLAY')..'##'..line:match(".+%.cfg")) then
                    -- current_cfg.sell = ('moonloader/ArzMarket/sell-cfg/'..line:match("(.+)%.json"))
                    -- sell_list = loadConfig('moonloader/ArzMarket/sell-cfg/'..line:match("(.+)%.json"))
                    -- AFKMessage('������ {505050}'..line:match("(.+)%.json")..'{ffffff} ������� ��������.', sell_list)
                    AFKMessage('_+')
                    local raw = getWorkingDirectory() .. "\\ArzMarket\\buy-cfg\\"..tostring(line:match(".+%.cfg"))
                    -- print(raw)
                    if doesFileExist(raw) then
                        AFKMessage('good1')
                        pltcfg(raw, 2)
                        ini.cfg.load_config_buy = line:match("(.+)%.cfg")
                        load_config_buy = line:match("(.+)%.cfg")
                        save_all()
                    else
                        AFKMessage('error1 [plt]')
                    end
                end
                imgui.SameLine()
                if imgui.CustomOnlyBorderButton(fa('trash')..'##'..line..line:match("(.+)%.cfg")) then
                    local success, errorMessage = os.remove('moonloader/ArzMarket/buy-cfg/'..line:match("(.+)%.cfg")..'.cfg')
                    if success then
                        if line == load_config_buy..'.cfg' then 
                            ini.cfg.load_config_buy = '' --:match("(.+)%.json")
                            load_config_buy = '' --:match("(.+)%.json")
                            save_all()
                        end
                        AFKMessage('������ {505050}'..line:match("(.+)%.cfg")..' {ffffff}������.')
                    else
                        print(errorMessage)
                    end
                end
                imgui.PopFont()
            elseif line:match(".+%.json") then
                imgui.PushFont(fonts[18])
                local cfg_name = u8'{ffffff}'..line --:match("(.+)%.json")
                imgui.SetCursorPosY(imgui.GetCursorPos().y + 5)
                -- imgui.TextColoredRGB(tostring(cfg_name, 50))
                
                imgui.PushFont(fonts[18])
                -- imgui.GetWindowDrawList():AddText(imgui.ImVec2(p.x + 71, p.y+22), imgui.GetColorU32Vec4(imgui.ImVec4(1.000, 1.000, 1.000, 0.75)), cfg_name)
                -- imgui.Text(u8(changeExtraSim(cfg_name, 45))) -- �����
                if line == load_config_buy then -- :match("(.+)%.json")
                    -- AFKMessage('+__+_+_+_+')
                    imgui.TextColoredRGB(tostring(changeExtraSim(cfg_name..'{ffff00} [Loaded]', 45)))
                else
                    imgui.TextColoredRGB(tostring(changeExtraSim(cfg_name, 45)))
                end
                imgui.PushFont(fonts[18])
                if #cfg_name > 50 then
                    if imgui.IsItemHovered() then
                        imgui.BeginTooltip()
                        imgui.TextColoredRGB(cfg_name)
                        imgui.EndTooltip()
                    end
                end
                if imgui.IsItemHovered() then
                    imgui.BeginTooltip()
                    local data = readJsonFile('moonloader/ArzMarket/buy-cfg/'..line:match("(.+)%.json")..'.json')
                    imgui.Text(u8('�������� �������: '..line:match("(.+)%.json")..'\n '))
                    for k, v in pairs(data) do
                        imgui.Text(tostring(u8(v.name)))
                    end
                    imgui.EndTooltip()
                end
                imgui.PopFont()
                imgui.SameLine(100)
                imgui.PushFont(fonts[18])
                imgui.SetCursorPos(imgui.ImVec2(imgui.GetWindowWidth() - 65, imgui.GetCursorPos().y))
                if imgui.CustomOnlyBorderButton(fa('PLAY')..'##'..line:match(".+%.json")) then
                    -- current_cfg.buy = 'moonloader/ArzMarket/buy-cfg/'..line:match("(.+)%.json")
                    item_list = loadConfig('moonloader/ArzMarket/buy-cfg/'..line) -- :match("(.+)%.json")
                    AFKMessage('������ {505050}'..line:match("(.+)%.json")..'{ffffff} ������� ��������.', sell_list)
                    ini.cfg.load_config_buy = line --:match("(.+)%.json")
                    load_config_buy = line --:match("(.+)%.json")
                    save_all()
                end
                imgui.SameLine()
                if imgui.CustomOnlyBorderButton(fa('trash')..'##'..line:match("(.+)%.json")) then
                    local success, errorMessage = os.remove('moonloader/ArzMarket/buy-cfg/'..line:match("(.+)%.json")..'.json')
                    if success then
                        
                        if line == load_config_buy then 
                            ini.cfg.load_config_buy = '' --:match("(.+)%.json")
                            load_config_buy = '' --:match("(.+)%.json")
                            save_all()
                        end
                        AFKMessage('������ {505050}'..line:match("(.+)%.json")..' {ffffff}������.')
                    else
                        print(errorMessage)
                    end
                end
                imgui.PopFont()
                -- imgui.Separator()
            end
        end
        imgui.EndCustomInvisibleChild()
        -- imgui.SetCursorPos(imgui.ImVec2((imgui.GetWindowWidth()) - 34, 00))
        -- imgui.PushItemWidth(imgui.GetWindowWidth() - 40)
        
        imgui.PushItemWidth(imgui.GetWindowWidth() - 42)
        -- imgui.PushItemWidth(imgui.GetWindowWidth() - 15)
        imgui.PushFont(fonts[18])
        imgui.InputTextWithHintD('##search_cfg_buy', u8'�������� �������', search_cfg_buy, ffi.sizeof(search_cfg_buy))
        imgui.SameLine()
        -- imgui.PushFont(font[17])
        -- imgui.SetCursorPosX(imgui.GetCursorPos().x + 5)
        if imgui.CustomOnlyBorderButton(fa('FOLDER')..'##0.29919293') then --, imgui.ImVec2(30, 30)
            -- imgui.StrCopy(search_cfg_buy, '')
            -- os.execute('start '..getWorkingDirectory().."\\ArzMarket\\buy-cfg")
            
            os.execute("explorer "..getWorkingDirectory().."\"\\ArzMarket\\buy-cfg")
        end
        -- imgui.PopFont()
        imgui.PopItemWidth()
        imgui.GetStyle().FrameBorderSize = border_side[0] and 1 or 0
        if imgui.Button(u8'�������##0', imgui.ImVec2((imgui.GetWindowWidth() - 15), 35)) then
            tosave.buy = u8:decode(ffi.string(search_cfg_buy))
            
            if (tosave.buy == '') or (tosave.buy == nil) or (tosave.buy:match("^%s*$") ~= nil) then
                AFKMessage("{ff3535}[Error]:{ffffff} �� �� ������ ������� {505050}���������� {ffffff}������.")
            else
                createConfig('buy-cfg/'..tosave.buy..'.json', {})
                AFKMessage("������ {505050}"..tostring(tosave.buy)..'{ffffff} ������.1')
            end
        end
        imgui.GetStyle().FrameBorderSize = 0
        imgui.SameLine()
        -- if imgui.Button(u8'����������� �� �������##0', imgui.ImVec2((imgui.GetWindowWidth() - 25) /2 , 35)) then
        --     -- AFKMessage('+_+_+')
        --     tosave.buy = u8:decode(ffi.string(search_cfg_buy))
        --     if (tosave.buy == '') or (tosave.buy == nil) or (tosave.buy:match("^%s*$") ~= nil) then
        --         AFKMessage("� ��� �� ������ ��� �������.")
        --     else
        --         local raw = getWorkingDirectory() .. "\\ArzMarket\\"..tostring(tosave.buy)..".cfg"
        --         AFKMessage(raw)
        --         local file = io.open(raw, "r")
        --         if file ~= nil then
        --             local script = file:read("*all")
        --             file:close()
            
        --             script = 'local tbl = {}\n' .. script .. '\n return tbl'
        --             local code = loadstring(script)
        --             setfenv(code, {
        --                 table = { insert = table.insert }
        --             })
        --             local res, tbl = pcall(code)
        --             for k, v in pairs(tbl) do
        --                 if type(v) == 'table' then
        --                     AFKMessage(tostring(tbl[k].name))
                            
        --                     local data = {name = tostring(tbl[k].name), price = tostring(tbl[k].price), count = tostring(tbl[k].number), enabled = tbl[k].enabled}
        --                     addToData(data, item_list)
        --                 end
        --             end
        --             -- createConfig('buy-cfg/'..tosave.buy, item_list)
        --             AFKMessage('������ {505050}'..tostring(tosave.buy)..'{ffffff} ��������')
        --         else
        --             AFKMessage('�� ����� ������� �� ������� � ����� �� ����'..getWorkingDirectory() .. "\\ArzMarket\\"..tostring(tosave.buy)..".cfg")
        --             AFKMessage('��� ����� ����������� ��� �� ���� ����.')
        --         end
        --     end
        -- end
    imgui.PopFont()





    imgui.EndCustomInvisibleChild()
    -- imgui.PushFont(fonts[18])
    -- imgui.SetCursorPos(imgui.ImVec2(1, 425))
    -- imgui.SetCursorPosY(imgui.GetCursorPos().y)
    -- imgui.CenterText(u8'������ ������ (���) ����� ��������� �� ���. ������ ������ ��� ����� ������ ��� �� ���������� ���!')
    -- imgui.PopFont()
end

function round_text(state) -- // TODO round_text(state)
    imgui.GetStyle().WindowBorderSize = state
    imgui.GetStyle().ChildBorderSize = state
    imgui.GetStyle().PopupBorderSize = 1
    imgui.GetStyle().PopupRounding = 0
    
    imgui.GetStyle().FrameBorderSize = state
    imgui.GetStyle().TabBorderSize = state

    -- imgui.GetStyle().WindowBorderSize = 1
    -- imgui.GetStyle().ChildBorderSize = 1
    -- imgui.GetStyle().PopupBorderSize = 1
    -- imgui.GetStyle().FrameBorderSize = 1
    -- imgui.GetStyle().TabBorderSize = 1
end


function buy() -- //TODO buy()
    if (json_timer[1] + 2 <= os.time()) or (json_vlad == nil) then
        json_timer[1] = os.time()
        json_vlad = readJsonFile(items_buy)
    end
    
    -- imgui.PushItemWidth(125)
    -- if imgui.Combo("##1", int_item, ImItems, #item_list) then end
    -- if imgui.CustomOnlyBorderButton(fa('ARROW_LEFT')..'##0', imgui.ImVec2((imgui.GetWindowWidth() / 2) - 300, 27)) then
    --     menu = menu - 1
    --     imgui.SelectMenu(buttons, menu)
    -- end
    
    imgui.SetCursorPosX(imgui.GetCursorPos().x + 5)
    if imgui.CustomOnlyBorderButton(scan and fa('MAGNIFYING_GLASS_LOCATION') or fa('magnifying_glass'), imgui.ImVec2(30, 27)) then
        scan = not scan
        if scan then
            AFKMessage('�������� ���� ����� � ������ ������������� ������ ������������')
        else
            AFKMessage('������������ ���� ��������.')
        end
    end
    imgui.Hint('MAGNIFYING_GLASS_LOCATION', u8'������ ������� ������������ ��� ������������ ���������!', false)
    imgui.SameLine(36)
    
    if imgui.CustomOnlyBorderButton(sort_mode and fa('ARROW_UP_SHORT_WIDE') or fa('ARROW_DOWN_WIDE_SHORT'), imgui.ImVec2(30, 27)) then
        sort_mode = not sort_mode
        ini.cfg.sort_mode = sort_mode
        save_all();
    end
    imgui.Hint('ARROW_UP_SHORT_WIDE', u8'������� ���������� ��������� � ������ �������.\n ���� ������� ������ ������� ���� �� ��� ���������� ��������, �� ����� �������� ����.', false)
    -- imgui.SameLine(30)
    imgui.SetCursorPos(imgui.ImVec2((imgui.GetWindowWidth() - 300) / 2, 5))
    imgui.PushItemWidth(255)
    -- sampAddChatMessage(search_sell[1],-1)
    imgui.NewInput(u8' ����� ���������', search, 255)
    imgui.Hint('search_sell', u8'������ ������� ����� ����� � ���� ��������, � ������ � �����.\n�� ������ ����� �����-�� �����, ��������.\n��� �� �� ��������� ��� �� ������ ����� �����, ����� ������� ��� ��������, �������� ����� � ���������� ���� ��� �����.', false)
    imgui.SameLine(475)
    
    imgui.SetCursorPosY(imgui.GetCursorPos().y - 1)
    if imgui.CustomOnlyBorderButton(vice_city_mode and "SA$" or "VC$", imgui.ImVec2(35, 27)) then
        -- item_list[index+1].enabled = false
        vice_city_mode = not vice_city_mode
        ini.cfg.vice_city_mode = vice_city_mode
        save_all();
        vc_converter();
    end
    imgui.Hint('vice_city_mode', u8'����� ������ �� ������� ����� ��� �� [ViceCity].\n��� �� �� ������� "���������" �� ������ �������� ������� �����������. ����������� ������� ��!', false)
    imgui.SameLine()
    imgui.SetCursorPosY(imgui.GetCursorPos().y + 1)
    
    if imgui.CustomOnlyBorderButton(fa('download').."##", imgui.ImVec2(35, 27)) then
        -- sampProcessChatInput('/getprices')
        get_prices()
    end
    imgui.Hint('download', u8'����� ������ �� �������� ������� ����.\n��� ����� �������� ��� ������ ������ � ����� ���� ������� ��� �� �� ����������� ����� ��� ������ ������!\n��� �� �� ��������� �� ������ �������� �����, ����� ������� �� �������� ������ ������ � ��� ��������� ������ ������� ���!\n���� �� ������� ��� � ������ ������� ���� ��������� ���� - �� ������� ���������� ����.', false)
    imgui.SameLine()
    if imgui.CustomOnlyBorderButton(fa('trash').."##", imgui.ImVec2(35, 27)) then
        -- table.remove(item_list, key)
        -- menu = 3
        -- imgui.SelectMenu(buttons, 3)
        item_list = {}
    end
    imgui.Hint('trash', u8'����� ������ �� ������� ��� ����������� ������ � ������ ����. (� ������ �������)', false)
    imgui.SameLine()
    
    if imgui.CustomOnlyBorderButton(fa('FOLDER').."##", imgui.ImVec2(35, 27)) then
        -- table.remove(item_list, key)
        -- imgui.SelectMenu(buttons, 3)
        menu = 3
        imgui.SelectMenu(buttons, 3)
    end
    imgui.Hint('FOLDER', u8'����� ������ �� ������ ������������� �� ������� "���������".\n��� �� ������� �������� ��������� �������, � ��� �� ��������� ������.\n�-����. ������ ������, � ��� �������� ������ �� �������! ������ ������ �� ������!', false)
    imgui.SameLine()
    
    imgui.SetCursorPosX(imgui.GetCursorPos().x - 2)
    if imgui.CustomOnlyBorderButton(fa('xmark')..'##0', imgui.ImVec2(35, 27)) then
        show_menu = false
        renderWindow[0] = show_menu
    end
    imgui.Hint('xmark', u8'����� ������ �� �������� ���� �������.', false)
    -- if imgui.CustomOnlyBorderButton(fa('ARROW_RIGHT')..'##0', imgui.ImVec2(35, 27)) then
    --     menu = menu + 1
    --     imgui.SelectMenu(buttons, menu)
    -- end
    -- imgui.BeginChild('buyMenuPage', imgui.ImVec2(-1, -1), false, imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse)
    if json_vlad ~= nil then
        
        imgui.CustomInvisibleChild('buyLeftList', imgui.ImVec2(imgui.GetWindowWidth() / 2.2, sizeY-40), true, imgui.WindowFlags.NoScrollWithMouse)
        local itemsSearch = {}
        if json_vlad then
            for k, v in pairs(json_vlad) do
                if (#(u8:decode(ffi.string(search))) > 0) and (list_for_search.buy[k]):find(string.nlower(u8:decode(ffi.string(search))), nil, true) then
                    table.insert(itemsSearch, v)
                end
            end
        end
        imgui.Scroller('buyLeftList', 100, 600, imgui.HoveredFlags.AllowWhenBlockedByActiveItem) --���������: ���� � ���� ������, ������ ������ � ��������, ����� �������� � ��, ����� ����������
        
        local buy_add_list = #ffi.string(search) == 0 and json_vlad or itemsSearch
        local clipper_buy_add = imgui.ImGuiListClipper(#buy_add_list);
        clipper_buy_add:Begin(#buy_add_list)
        while clipper_buy_add:Step() do
            
            for i = clipper_buy_add.DisplayStart, clipper_buy_add.DisplayEnd - 1 do
                -- imgui.PushFont(font[22])
                imgui.PushFont(fonts[18])
                
                -- imgui.CustomSeparator(imgui.GetWindowWidth())
                imgui.SetCursorPosX(imgui.GetCursorPos().x + 2)
                
                if containsItem(item_list, buy_add_list[i + 1]) then
                    imgui.TextColoredRGB('{808080}'..changeExtraSim((i + 1)..'. '.. buy_add_list[i + 1], 35))
                    if imgui.IsItemHovered() then
                        imgui.SameLine()
                        
                        imgui.SetCursorPosY(imgui.GetCursorPos().y + 2)
                        imgui.TextDisabled(fa('CIRCLE_XMARK'))
                        if #((i + 1) .. ". " .. buy_add_list[i + 1]) > 43 then
                            imgui.BeginTooltip()
                            imgui.PushFont(font[17])
                            imgui.Text(u8(buy_add_list[i + 1]))
                            imgui.PopFont()
                            imgui.EndTooltip()
                        end
                        imgui.SetCursorPosY(imgui.GetCursorPos().y - 2)
                    end
                else
                    imgui.TextColoredRGB(ImVec3ToHEX(current_theme.color_text_market)..changeExtraSim((i + 1)..'. '.. buy_add_list[i + 1], 35))
                    
                    if imgui.IsItemClicked() then
                        if not display.buy then
                            AFKMessage(buy_add_list[i + 1]..' '..item_v.price..' '..item_v.count)
                            local data = {name = buy_add_list[i + 1], price = item_v.price, count = item_v.count, enabled = true, price_vc = 10}
                            -- addToData(data, item_list)
                            addToData(data, item_list, sort_mode and 1 or nil)
                        end
                    end
                    if imgui.IsItemHovered() then
                        imgui.SameLine()
                        imgui.SetCursorPosY(imgui.GetCursorPos().y + 1)
                        imgui.TextDisabled(fa('CART_CIRCLE_PLUS'))
                        if #((i + 1) .. ". " .. buy_add_list[i + 1]) > 43 then
                            imgui.BeginTooltip()
                            imgui.PushFont(font[17])
                            imgui.Text(u8(buy_add_list[i + 1]))
                            imgui.PopFont()
                            imgui.EndTooltip()
                        end
                        imgui.SetCursorPosY(imgui.GetCursorPos().y - 1)
                    end
                    imgui.PopFont()
                end
                -- if imgui.IsItemClicked() then
                --     if not display.buy then
                --         local skip = false
                --         if next(item_list) ~= nil then
                --             for k, v in pairs(item_list) do
                --                 if v.name == buy_add_list[i + 1] then
                --                     AFKMessage('already added!')
                --                     skip = true
                --                 end
                --                 AFKMessage('v.item '.. tostring(v.name))
                --             end
                --         end
                --         if skip == false then
                --             AFKMessage(buy_add_list[i + 1]..' '..item_v.price..' '..item_v.count)
                --             local data = {name = buy_add_list[i + 1], price = item_v.price, count = item_v.count}
                --             addToData(data, item_list)
                --         end
                --     else
                --         -- AFKMessage('{ff3535}[Error]:{ffffff} �� �� ������ ��������� ����� ������ ��� {505050}���������� {ffffff}����������� �������.')
                --     end
                -- end
                -- imgui.Separator()
            end
        end
        clipper_buy_add:End()
        imgui.EndCustomInvisibleChild()
        imgui.SameLine()
        imgui.SetCursorPosX(imgui.GetCursorPos().x - 8)
        -- imgui.VerticalSeparator()
        -- imgui.SameLine()
        local moneyForStat = 0

        -- imgui.SetCursorPos(imgui.ImVec2((imgui.GetWindowWidth() / 2) - 34, 40))
        
        imgui.CustomInvisibleChild('buyRightList', imgui.ImVec2(imgui.GetWindowWidth() - 317, sizeY-129), true, imgui.WindowFlags.NoScrollWithMouse)
        local itemsSearchs = {}
        if item_list then
            for k, v in pairs(item_list) do
                -- AFKMessage()
                if item_list[k].enabled then 
                    local current_sum = vice_city_mode and item_list[k].price or item_list[k].price_vc
                    moneyForStat = moneyForStat + (current_sum * item_list[k].count)
                end
                -- if (#(u8:decode(ffi.string(search))) > 0) and (list_for_search.buy[k]):find(string.nlower(u8:decode(ffi.string(search))), nil, true) then
                if (#u8:decode(ffi.string(search)) ~= 0) and (string.nlower(v.name):find(string.nlower(u8:decode(ffi.string(search))))) then
                -- if (#(u8:decode(ffi.string(search_sell))) > 0) and (list_for_search.sell[k]):find(string.nlower(u8:decode(ffi.string(sell_list[k].name))), nil, true) then
                    -- AFKMessage(k)
                    -- AFKMessage('do '..k)
                    table.insert(v, 1, k)
                    table.insert(itemsSearchs, v)
                    -- table.insert(itemsSearchs, 30, v)
                    -- itemsSearchs[30][1] = 33
                end
            end
        end
        -- imgui.VerticalSeparator()
        -- imgui.Scroller('sellRightList', 100, 600, imgui.HoveredFlags.AllowWhenBlockedByActiveItem) --���������: ���� � ���� ������, ������ ������ � ��������, ����� �������� � ��, ����� ����������
        imgui.Scroller('buyRightList', 100, 600, imgui.HoveredFlags.AllowWhenBlockedByActiveItem) --���������: ���� � ���� ������, ������ ������ � ��������, ����� �������� � ��, ����� 
        
        
        imgui.SetCursorPosY(imgui.GetCursorPos().y + 3)
        -- local buy_add_list = #ffi.string(search) == 0 and json_vlad or itemsSearch
        local buy_add_list = #ffi.string(search) == 0 and item_list or itemsSearchs
        -- AFKMessage(tostring(sell_add_list))
        local clipper_sell_add = imgui.ImGuiListClipper(#buy_add_list); -- buy_add_list[i+1]
        clipper_sell_add:Begin(#buy_add_list) -- // TODO PASTING BUY 
        while clipper_sell_add:Step() do
            for i = clipper_sell_add.DisplayStart, clipper_sell_add.DisplayEnd - 1 do
            -- for key, item in pairs(item_list) do
                -- imgui.PushFont(font[20])
                imgui.PushFont(fonts[18])
                -- AFKMessage(tostring(clipper_sell_add.DisplayEnd - 1))
                if #ffi.string(search) ~= 0 then
                    index = buy_add_list[i+1][1] - 1
                    -- AFKMessage('posle '..sell_add_list[i+1][1])
                else
                    index = i 
                end
                if tostring(buy_add_list[i+1]) == 'nil' then goto skiprender_b end

                imgui.CustomSeparator(imgui.GetWindowWidth())
                if buy_add_list[i+1].enabled == true then -- //TODO ����� ����� ��������� ��������
                    if imgui.CustomOnlyBorderButton(fa('TOGGLE_ON').."##21"..(i+1), imgui.ImVec2(50)) then
                        item_list[index+1].enabled = false
                    end
                else
                    if imgui.CustomOnlyBorderButton(fa('TOGGLE_OFF').."##21"..(i+1), imgui.ImVec2(50)) then
                        item_list[index+1].enabled = true
                    end
                end
                imgui.SameLine()
                imgui.SetCursorPosY(imgui.GetCursorPos().y - 2)
                imgui.SetCursorPosX(imgui.GetCursorPos().x - 10)
                -- imgui.SetCursorPosX(imgui.GetCursorPos().x + 2)
                -- imgui.SetCursorPosY(imgui.GetCursorPos().x + 3)
                
                imgui.GetStyle().FrameBorderSize = border_side[0] and 1 or 0
                if imgui.RadioButtonIntPtr('##9999'..tostring(i+1),RadioButton_s[1],index+1) then
                    RadioButton_s[3] = false
                    if RadioButton_s[2] ~= 333 then
                        AFKMessage('switch '.. RadioButton_s[2]..' na >> '..index+1)
                        local swich_save = item_list[RadioButton_s[2]]
                        table.remove(item_list, RadioButton_s[2])
                        table.insert(item_list, index+1, swich_save)
                        RadioButton_s[2] = 333
                        RadioButton_s[1][0] = 333
                        RadioButton_s[3] = true
                        -- break
                    end
                    if RadioButton_s[3] == false then
                        RadioButton_s[2] = index+1
                        AFKMessage('select '.. RadioButton_s[2])
                    end
                end
                imgui.GetStyle().FrameBorderSize = 0
                imgui.SameLine()
                
                -- if item_list[i + 1].enabled then
                    -- imgui.Text(u8(changeExtraSim((i+1) .. ". " .. sell_add_list[i + 1].name, 43)))
                    imgui.TextColoredRGB(item_list[i + 1].enabled and ImVec3ToHEX(current_theme.color_text_market)..changeExtraSim((index + 1) .. ". " .. buy_add_list[i+1].name, 35) or '{808080}'..changeExtraSim((index + 1) .. ". " .. buy_add_list[i+1].name, 35))
                    -- imgui.TextColoredRGB(changeExtraSim((i+1) .. ". {ffffff}" .. sell_add_list[i + 1].name, 43))
                -- else
                --     imgui.TextColoredRGB('{808080}'..changeExtraSim((index + 1) .. ". " .. buy_add_list[i+1].name, 35))
                -- end
                -- imgui.Text(u8(changeExtraSim(index+1 .. ". " .. buy_add_list[i+1].name, 43)))
                if #(i+1 .. ". " .. buy_add_list[i+1].name) > 1 then
                    if imgui.IsItemHovered() then
                        imgui.BeginTooltip()
                        imgui.PushFont(font[17])
                        imgui.Text(u8(buy_add_list[i+1].name))
                        -- if balanced_price ~= nil then
                        --     imgui.Separator()
                        show_prices(buy_add_list[i + 1].name, i)
                        -- end
                        imgui.PopFont()
                        imgui.EndTooltip()
                    end
                end
                -- imgui.PopFont()
                imgui.SetCursorPosX(imgui.GetCursorPos().x + 10)
                -- imgui.PushItemWidth(125)
                imgui.PushItemWidth(100)
                
                input.buy[i+1] = new.char[32](vice_city_mode and ''..buy_add_list[i + 1].price or ''..buy_add_list[i + 1].price_vc)
                if imgui.InputTextD(vice_city_mode and ' SA$##'..(i+1) or ' VC$##'..(i+1), input.buy[(i+1)], 32, imgui.InputTextFlags.CharsDecimal) then
                    if ffi.string(input.buy[(i+1)]):match('^%d+$') then
                        if (ffi.string(input.buy[(i+1)]) ~= '0' and vice_city_mode) then    
                            -- sell_add_list[i + 1].price = ffi.string(input.sell[(i+1)])
                            buy_add_list[i + 1].price = ffi.string(input.buy[(i+1)])
                            -- AFKMessage(tostring(sell_list[i + 1].price))
                        end 
                        
                        if (ffi.string(input.buy[(i+1)]) ~= '0' and not vice_city_mode) then    
                            
                            buy_add_list[i + 1].price_vc = ffi.string(input.buy[(i+1)])
                            AFKMessage(buy_add_list[i + 1].price_vc..' '..buy_add_list[i + 1].name)
                        end
                    end
                    -- AFKMessage(ffi.string(input.sell[(i+1)])..' '..tostring(vice_city_mode))
                end
                imgui.SameLine()
                
                if not vice_city_mode then
                    imgui.SetCursorPosX(imgui.GetCursorPos().x - 1)
                end
                imgui.PushItemWidth(90)
                input.buy[i+1] = new.char[32](''..buy_add_list[i+1].count)
                if imgui.InputTextD(u8'    ��.##1'..i+1, input.buy[i+1], 32, imgui.InputTextFlags.CharsDecimal) then
                    if ffi.string(input.buy[(i+1)]):match('^%d+$') then
                        if ffi.string(input.buy[i+1]) >= '0' then
                            buy_add_list[i+1].count = ffi.string(input.buy[i+1])
                        end
                    end
                end
                imgui.PopItemWidth()
                imgui.SameLine()
                -- moneyForStat = moneyForStat + (buy_add_list[i+1].price * buy_add_list[i+1].count)
                if imgui.CustomOnlyBorderButton(fa('trash').."##"..i+1, imgui.ImVec2(50)) then
                    table.remove(item_list, index+1)
                end
                -- imgui.Separator()
                -- sampAddChatMessage(tostring(moneyForStat),-1)
                -- sampAddChatMessage(tostring(moneyForStat),-1)
                ::skiprender_b::
            -- end
                
            end
        end
        clipper_sell_add:End()
        imgui.EndCustomInvisibleChild()
        if next(item_list) ~= nil then
            
            

            imgui.SetCursorPos(imgui.ImVec2((imgui.GetWindowWidth() / 2) - 29, sizeY-90))
            imgui.CustomInvisibleChild('buyMenuStat', imgui.ImVec2(-1, -1))
            -- imgui.Separator()
            
            imgui.GetStyle().FrameBorderSize = border_side[0] and 1 or 0
            local global_summ = moneyForStat < 100000000 and '(-'..moneySeparator(moneyForStat)..u8')' or '(-......)'
            imgui.CenterText(u8'�������: '.. moneySeparator(getPlayerMoney() - moneyForStat) .. ' '..global_summ..u8' | ���������: '..#item_list)
            if moneyForStat > 100000000 then
                if imgui.IsItemHovered() then
                    imgui.BeginTooltip()
                    imgui.Text('    (-'..moneySeparator(moneyForStat)..')    ')
                    -- if balanced_price ~= nil then
                        -- AFKMessage('++_+')
                    -- end
                    imgui.EndTooltip()
                end
            end
            -- imgui.CenterText(u8'�������: '.. moneySeparator(getPlayerMoney() - moneyForStat) .. ' (-'..moneySeparator(moneyForStat)..u8') | ���������: '..#item_list)
            if imgui.Button(display.buy and u8'������' or u8'��������� �� ����', imgui.ImVec2((imgui.GetWindowWidth() / 2) - 7, 27)) then
                if not display.buy then
                    
                    local ip, _ = sampGetCurrentServerAddress()
                    if (servers[ip] == 0 and vice_city_mode) or (servers[ip] ~= 0 and not vice_city_mode) then
                        AFKMessage('��������! � ��� ���������� �� ��� ����� �������. ������� � ������ � ��������� ������ � ������� �����������.')
                    else
                        cancel_sellorbuy[0] = true
                        display = {sell = false, buy = true, score = 1, score_from = 1}
                        AFKMessage('�������� ���������� ������.')
                        for k, v in pairs(item_list) do
                            display.score_from = k
                        end
                        setGameKeyState(21, 255)
                        sampForceOnfootSync();
                    end
                else
                    cancel_sellorbuy[0] = false
                    display = {sell = false, buy = false, score = 1, score_from = 1}
                    AFKMessage('����������� ������� ���� ��������.')
                end
            end
            imgui.SameLine()
            if imgui.Button(u8'������������ �����##0', imgui.ImVec2((imgui.GetWindowWidth() / 2) - 7, 27)) then
                separatorChar.page = 0
                separator[0] = not separator[0]
            end
            if load_config_buy == '' then
                if create_config[2] == true then
                    if imgui.Button(u8'�������� ��������', imgui.ImVec2((imgui.GetWindowWidth() / 2) - 10, 27)) then
                        create_config[2] = false
                    end
                    imgui.SameLine()
                    imgui.PushItemWidth(98)    
                    imgui.PushFont(fonts[222])
                    imgui.PushStyleVarVec2(imgui.StyleVar.FramePadding, imgui.ImVec2(6,6.5))
                    imgui.InputTextWithHintD("##search_cfg_sell", u8" ��� �������", search_cfg_buy, ffi.sizeof(search_cfg_buy),imgui.InputTextFlags.EnterReturnsTrue)
                    imgui.PopFont()
                    imgui.PopStyleVar()
                    imgui.SameLine()  
                    if imgui.Button(u8"�������", imgui.ImVec2((imgui.GetWindowWidth() /3.99) - 15, 27)) then
                        tosave.buy = u8:decode(ffi.string(search_cfg_buy))
                        if (tosave.buy == '') or (tosave.buy == nil) or (tosave.buy:match("^%s*$") ~= nil) then
                            AFKMessage("{ff3535}[Error]:{ffffff} �� �� ������ ������� {505050}���������� {ffffff}������.")
                        else 
                            create_config[2] = false
                            createConfig('buy-cfg/'..tosave.buy..'.json', {})
                            AFKMessage("������ {505050}"..tostring(tosave.buy)..'{ffffff} ������.')
                            load_config_buy = tosave.buy..'.json'
                            ini.cfg.load_config_buy = load_config_buy --:match("(.+)%.json")
                            save_all()
                        end
                    end
                else
                    if imgui.Button(u8'������� ������', imgui.ImVec2((imgui.GetWindowWidth()) - 9, 27)) then
                        create_config[2] = true
                    end
                end
            else
                if imgui.Button(u8'��������� ������', imgui.ImVec2((imgui.GetWindowWidth()) - 9, 27)) then
                    tosave.buy = load_config_buy:match('(.+)%.json') and load_config_buy or load_config_buy..'.json'
                    createConfig('buy-cfg/'..tosave.buy, item_list)
                    AFKMessage("������ "..tostring(tosave.buy)..' ��������.')
                end
            end
            
            imgui.GetStyle().FrameBorderSize = 0
            imgui.EndCustomInvisibleChild()
        end
    else
        -- helpWithScan()
        
        imgui.SetCursorPos(imgui.ImVec2(sizeX/10,sizeY/2))
        imgui.TextDisabled(u8'��� ����������� ��� ����� ������������� ��� �������� ����� �� ������   '..fa('magnifying_glass'))
    end
    -- imgui.EndChild()
end

function containsItem(arr, target)
    for _, item in ipairs(arr) do
        if item.name == target then
            return true
        end
    end
    return false
end


function updateList()
    if doesFileExist(items_buy) then
        local data = readJsonFile(items_buy)
        list_for_search.buy = {}
        for k, v in pairs(data) do
            table.insert(list_for_search.buy, string.nlower(v))
        end
    end
    if doesFileExist(items_sell) then
        local data = readJsonFile(items_sell)
        list_for_search.sell = {}
        for k, v in pairs(data) do
            table.insert(list_for_search.sell, string.nlower(v.item))
        end
    end
end

-- function load_script_lvl()
--     current_lvl = loadConfig('moonloader\\ArzMarket\\UsersInfo\\info_users_SelfInfo')
--     AFKMessage(current_lvl.exp..' exp>???')
-- end 

function chat_page() -- // TODO chat_page()
    -- imgui.BeginChild("##ChannelsMessages", imgui.ImVec2(0, sizeY-20), true) 

    imgui.SameLine(555)
    imgui.SetCursorPosY(imgui.GetCursorPos().y + 5)
    if imgui.CustomOnlyBorderButton(fa('CART_ARROW_UP').."##", imgui.ImVec2(35, 27)) then
        -- table.remove(item_list, key)
        menu = 1
        imgui.SelectMenu(buttons, 1)
    end
    imgui.SameLine()
    if imgui.CustomOnlyBorderButton(fa('CART_CIRCLE_PLUS').."##", imgui.ImVec2(35, 27)) then
        -- table.remove(item_list, key)
        menu = 2
        imgui.SelectMenu(buttons, 2)
    end
    imgui.SameLine()
    
    imgui.SetCursorPosX(imgui.GetCursorPos().x - 2)
    if imgui.CustomOnlyBorderButton(fa('xmark')..'##0', imgui.ImVec2(35, 27)) then
        show_menu = false
        renderWindow[0] = show_menu
    end
    
    imgui.Hint('xmark', u8'����� ������ �� �������� ���� �������.', false)
    imgui.SetCursorPos(imgui.ImVec2(0,sizeY-35))
    if imgui.InputTextWithHintD("##InputMessage", u8"������� ���������", send_irc_msg, ffi.sizeof(send_irc_msg),imgui.InputTextFlags.EnterReturnsTrue) then
        
        imgui.SetKeyboardFocusHere()
        -- send_irc_msg = new.char[256]()
        
        table.insert(own_server[0] and messages_vc or messages, {text = (json_timer[7] + 2 <= os.time()) and '[��] �������: '..u8:decode(ffi.string(send_irc_msg)) or '[������] �� �����!', controller = own_server[0] and '1' or '0', server = '65535'})
        if json_timer[7] + 2 <= os.time() then
            json_timer[7] = os.time()
            s:sendChat('#Freym_tech', ffi.string(send_irc_msg))
        end
        -- AFKMessage(tostring(u8:decode(ffi.string(send_irc_msg))))
        imgui.StrCopy(send_irc_msg, '')
    end
    imgui.SameLine()
    if imgui.Button(u8"���������") then
        -- sendMessage()s:send(AnsiToUtf8(u8:decode(ffi.string(search_cfg_buy))))
        -- sendstr = AnsiToUtf8(arg) 
        table.insert(own_server[0] and messages_vc or messages, {text = (json_timer[7] + 2 <= os.time()) and '[��] �������: '..u8:decode(ffi.string(send_irc_msg)) or '[������] �� �����!', controller = own_server[0] and '1' or '0', server = '65535'})
        if json_timer[7] + 2 <= os.time() then
            json_timer[7] = os.time()
            s:sendChat('#Freym_tech', ffi.string(send_irc_msg))
        end
        -- AFKMessage(tostring(u8:decode(ffi.string(send_irc_msg))))
        imgui.StrCopy(send_irc_msg, '')
    end
    imgui.SetCursorPos(imgui.ImVec2(0,sizeY-475))
    -- round_text(1)
    imgui.CustomInvisibleChild('##ChannelsMessages', imgui.ImVec2(sizeX - 311, sizeY-60), true)
        -- round_text(1)
        if (messages and #messages ~= 0) or (messages_vc and #messages_vc ~= 0) then
            local messages = own_server[0] and messages_vc or messages
            local clipper = imgui.ImGuiListClipper(#messages)
            while clipper:Step() do
                for i = clipper.DisplayStart + 1, clipper.DisplayEnd do
                    if messages[i] ~= nil then
                        imgui.TextDisabled(messages[i].controller == '0' and u8(messages[i].text) or messages[i].server == '65535' and u8(messages[i].text) or '['..messages[i].server..']'..u8(messages[i].text)) --..' [DBUG INFO = controller:'..messages[i].controller..' server:'..messages[i].server..']' ..' [DBUG INFO = controller:'..messages[i].controller..' server:'..messages[i].server..']'
                        if #messages == i then
                            imgui.SetScrollY(imgui.GetScrollMaxY())
                        end
                    end
                end
            end
        else
            imgui.TextDisabled(u8'������� ��������� �����.')
        end
        -- imgui.SetScrollY(imgui.GetScrollMaxY())
        
    imgui.EndCustomInvisibleChild()
    if own_server[0] == false then
        imgui.SetCursorPos(imgui.ImVec2(sizeX - 354,sizeY-400))
        imgui.TextDisabled(u8'������: '..fa('hashtag')..u8'������-������')
        imgui.SetCursorPos(imgui.ImVec2(sizeX - 340,sizeY-370))
        if imgui.CustomOnlyBorderButton(fa('hashtag')..u8'ViceCity-������', imgui.ImVec2((imgui.GetWindowWidth() / 2) - 150, 27)) then
            if json_timer[6] + 10 <= os.time() then
                local ip, _ = sampGetCurrentServerAddress()
                if servers[ip] then
                    json_timer[6] = os.time()
                    -- irc_name = '[1]['..servers[ip]..']'..sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) --..os.time()
                    irc_name = servers[ip] ~= 0 and '[1]['..servers[ip]..']'..sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) or '[1]'..sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
                    AFKMessage('irc name now>> '..tostring(irc_name))
                    s:send(AnsiToUtf8(string.format("nick %s", tostring(irc_name))))
                end
                own_server[0] = true
            else
                AFKMessage('������ ������� ����� ��� � 10 ������.')
            end
        end
    else
        imgui.SetCursorPos(imgui.ImVec2(sizeX - 340,sizeY-405.5))
        if imgui.CustomOnlyBorderButton(fa('hashtag')..u8'������-������', imgui.ImVec2((imgui.GetWindowWidth() / 2) - 150, 27)) then
            if json_timer[6] + 10 <= os.time() then
                local ip, _ = sampGetCurrentServerAddress()
                if servers[ip] then
                    json_timer[6] = os.time()
                    irc_name = servers[ip] ~= 0 and '[0]['..servers[ip]..']'..sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) or '[0]'..sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
                    AFKMessage('irc name now>> '..tostring(irc_name))
                    s:send(AnsiToUtf8(string.format("nick %s", tostring(irc_name))))
                end
                own_server[0] = false
            else
                AFKMessage('������ ������� ����� ��� � 10 ������.')
            end
        end
        imgui.SetCursorPos(imgui.ImVec2(sizeX - 354,sizeY-364))
        imgui.TextDisabled(u8'������: '..fa('hashtag')..u8'ViceCity-������')
    end
    
    -- imgui.EndChild()
end

function script_Page()
    imgui.GetStyle().FrameBorderSize = border_side[0] and 1 or 0
    local clr = imgui.Col
    imgui.PushStyleColor(clr.Button, imgui.ImVec4(0, 0, 0, 0))
    imgui.PushStyleColor(clr.ButtonHovered, imgui.ImVec4(current_theme.Border[1], current_theme.Border[2], current_theme.Border[3], current_theme.Border[4]))
    imgui.PushStyleColor(clr.ButtonActive, imgui.ImVec4(current_theme.Border[1], current_theme.Border[2], current_theme.Border[3], current_theme.Border[4]))
    imgui.PushStyleColor(clr.Border, imgui.ImVec4(current_theme.Border[1], current_theme.Border[2], current_theme.Border[3], current_theme.Border[4]))
    imgui.CustomInvisibleChild('scripts', imgui.ImVec2(sizeX - 160, sizeY - 10), false)
    for k, v in pairs(download_scripts) do
        imgui.CustomInvisibleChild('scriptNUMBER'..k, imgui.ImVec2(sizeX - 170, 160), true)
        local sizeXX, sizeYY = sizeX - 170, 160
        local p = imgui.GetCursorScreenPos()
        local q = imgui.ImVec2(p.x + ((25) / 2), p.y + 10)
        -- imgui.GetWindowDrawList():AddCircle(imgui.ImVec2(q.x + 37.5, q.y + 37.5), 37.5, imgui.GetColorU32Vec4(imgui.ImVec4(rainbow[1], rainbow[2], rainbow[3], rainbow[4])), 50, 1)
        if scriptPngPage[k] then
            imgui.GetWindowDrawList():AddImage(scriptPngPage[k], q, imgui.ImVec2(q.x + 260, q.y + 140), imgui.ImVec2(0, 0), imgui.ImVec2(1, 1), 0xFFFFFFFF, 60)
            imgui.SameLine()
        end
        
        imgui.SetCursorPos(imgui.ImVec2((imgui.GetWindowWidth()) /2.1, 70))
        imgui.PushFont(fonts[17])
        imgui.TextDisabled(u8(v.description))

        imgui.PopFont()
        
        imgui.PushFont(fonts[24])
        imgui.SetCursorPos(imgui.ImVec2((imgui.GetWindowWidth()) /2.2, 43))
        -- imgui.SetCursorPosX(imgui.GetCursorPos().x - 15)
        -- imgui.(u8'AutoCloseBanner')
        imgui.TextColoredRGB('{cccccc}'..u8(k))
        
        imgui.SetCursorPos(imgui.ImVec2((imgui.GetWindowWidth()) /2.21, 65))
        imgui.CustomSeparator(163)
        imgui.PopFont()
        imgui.SetCursorPos(imgui.ImVec2((imgui.GetWindowWidth()) /1.13, 70))
        
        if imgui.Button(doesFileExist(getWorkingDirectory()..'/'..k..'.lua') and fa('TRASH')..'##'..k or fa('DOWNLOAD')..'##'..k, imgui.ImVec2(50, 27)) then
            if doesFileExist(getWorkingDirectory()..'/'..k..'.lua') then
                AFKMessage('������ '..k..' ������� ������.')
                for _,vv in pairs(script.list()) do
                    if vv.filename == k..'.lua' then
                        vv:unload();
                        os.remove(getWorkingDirectory()..'/'..k..'.lua');
                    end
                end
            else
                local dlstatus = require('moonloader').download_status
                download_id = downloadUrlToFile(v.link, getWorkingDirectory()..'/'..k..'.lua', function(id, status)
                    if status == dlstatus.STATUS_ENDDOWNLOADDATA then 
                        lua_thread.create(function()
                            wait(500)
                            script.load(getWorkingDirectory()..'/'..k..'.lua');
                        end)
                        AFKMessage('�������� ������������ ������. '..k)
                    end
                end)
            end
        end
        imgui.SetCursorPos(imgui.ImVec2((imgui.GetWindowWidth()) /1.13, 70))
        imgui.GetWindowDrawList():AddRect(p, imgui.ImVec2(p.x + sizeXX, p.y + sizeYY), imgui.GetColorU32Vec4(imgui.ImVec4(current_theme.Border[1], current_theme.Border[2], current_theme.Border[3], current_theme.Border[4])), 5, 0, 1.8)
        
        imgui.EndCustomInvisibleChild()
    end

    imgui.EndCustomInvisibleChild()
    
    imgui.PopStyleColor(4)
    imgui.GetStyle().FrameBorderSize = 0

end

function get_prices()
    local srv_name = sampGetCurrentServerName()
    if srv_name:find('Arizona') then
        local result = srv_name:match('|%s*(.+)')
        if result then
            result = string.lower(result)
        end
        AFKMessage(result)
        asyncHttpRequest('GET', 'https://arz-wiki.com/action/?action=get_price&server='..result..'&type=sell', 'sell_'..result, 'sell_')
        asyncHttpRequest('GET', 'https://arz-wiki.com/action/?action=get_price&server=vice-city&type=sell', 'sell_vc', 'sell_vc')
        asyncHttpRequest('GET', 'https://arz-wiki.com/action/?action=get_price&server='..result..'&type=buy', 'buy_'..result, 'buy_')
        asyncHttpRequest('GET', 'https://arz-wiki.com/action/?action=get_price&server=vice-city&type=buy', 'buy_vc', 'buy_vc')
    else
        AFKMessage('�� �� �� ������� ��!')
    end
end

function script_Manager() -- // TODO script_Manager()
    local dlstatus = require('moonloader').download_status
    download_id = downloadUrlToFile('https://github.com/FREYM1337/forumnick/raw/main/scripts_list.json', getWorkingDirectory()..'/ArzMarket/resource/scripts_list.json', function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then 
            download_scripts = readJsonFile("moonloader/ArzMarket/resource/scripts_list.json")
            lua_thread.create(function()
                wait(1000)
                for k, v in pairs(download_scripts) do
                    if doesFileExist(getWorkingDirectory()..'/ArzMarket/resource/'..k..'.png') then
                        scriptPngPage[k] = imgui.CreateTextureFromFile(u8(getWorkingDirectory()..'/ArzMarket/resource/'..k..'.png'))
                    else
                        local dlstatus = require('moonloader').download_status
                        download_id = downloadUrlToFile(v.png..'.png', getWorkingDirectory()..'/ArzMarket/resource/'..k..'.png', function(id, status)
                            if status == dlstatus.STATUS_ENDDOWNLOADDATA then 
                                scriptPngPage[k] = imgui.CreateTextureFromFile(u8(getWorkingDirectory()..'/ArzMarket/resource/'..k..'.png'))
                            end
                        end)
                    end
                end
            end)
        end
    end)
end

function sell() -- // TODO sell()
    -- imgui.BeginChild('sellPage', imgui.ImVec2(-1, -1), false, imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse)
                    
    if (json_timer[2] + 2 <= os.time()) or (json_vlads == nil) then
        json_timer[2] = os.time()
        json_vlads = readJsonFile(items_sell)
        if #sell_list > 0 then
            for k, data in pairs(sell_list) do
                sell_list[k].all_count = Get_AllCountByName(data.name)
            end
        end
    end
    -- CloseButton()
    -- imgui.SameLine(1)
    imgui.SetCursorPosX(imgui.GetCursorPos().x + 5)
    -- imgui.PushItemWidth(80)
    -- if imgui.Combo("##1", int_item, ImItems, #item_list) then end
    -- if imgui.CustomOnlyBorderButton(fa('ARROW_LEFT')..'##0', imgui.ImVec2((imgui.GetWindowWidth() / 2) - 300, 27)) then
    --     menu = menu - 1
    --     imgui.SelectMenu(buttons, menu)
    -- end -- ARROW_UP_SHORT_WIDE
    -- imgui.SameLine(65)
    -- round_text(1)
    if imgui.CustomOnlyBorderButton(scan_sell and fa('MAGNIFYING_GLASS_LOCATION') or fa('magnifying_glass'), imgui.ImVec2(30, 27)) then
        scan_sell = not scan_sell
        if scan_sell then
            item_tab = {}
            window[0] = false
            sampSendChat('/stats')
            AFKMessage('�������� ���� ����� � ������ {505050}������������� {ffffff}������ ������������.')
        else
            AFKMessage('������������ ���� {505050}��������{ffffff}.')
        end
    end
    imgui.Hint('MAGNIFYING_GLASS_LOCATION', u8'������ ������� ������������ ��� ������������ ���������!', false)
    -- if imgui.CustomOnlyBorderButton(fa('ARROW_UP_SHORT_WIDE'), imgui.ImVec2((imgui.GetWindowWidth() / 2) - 300, 27)) then
    --     menu = menu - 1
    --     imgui.SelectMenu(buttons, menu)
    -- end -- ARROW_UP_SHORT_WIDE
    -- imgui.SameLine(80)
    -- if imgui.CustomOnlyBorderButton(fa('ARROW_DOWN_WIDE_SHORT'), imgui.ImVec2((imgui.GetWindowWidth() / 2) - 300, 27)) then
    --     menu = menu - 1
    --     imgui.SelectMenu(buttons, menu)
    -- end -- ARROW_UP_SHORT_WIDE
    imgui.SameLine(36)
    if imgui.CustomOnlyBorderButton(sort_mode and fa('ARROW_UP_SHORT_WIDE') or fa('ARROW_DOWN_WIDE_SHORT'), imgui.ImVec2(30, 27)) then
        sort_mode = not sort_mode
        ini.cfg.sort_mode = sort_mode
        save_all();
    end
    imgui.Hint('ARROW_UP_SHORT_WIDE', u8'������� ���������� ��������� � ������ �������.\n ���� ������� ������ ������� ���� �� ��� ���������� ��������, �� ����� �������� ����.', false)
    imgui.SameLine(67)
    if imgui.CustomOnlyBorderButton(fa('FILTER'), imgui.ImVec2(30, 27)) then
        sell_filter[0] = not sell_filter[0]
    end
    imgui.Hint('FILTER', u8'������� ���������� ��������� � ������ ����.\n��� ������� ��������� ���� � ������� ����� ����� ������������� �������� � ����� ������ ����.', false)
    
    imgui.SetCursorPos(imgui.ImVec2((imgui.GetWindowWidth() - 300) / 2, 5))
    imgui.PushItemWidth(255)
    -- sampAddChatMessage(search_sell[1],-1)
    imgui.NewInput(u8' ����� ���������', search_sell, 255)
    imgui.Hint('search_sell', u8'������ ������� ����� ����� � ���� ��������, � ������ � �����.\n�� ������ ����� �����-�� �����, ��������.\n��� �� �� ��������� ��� �� ������ ����� �����, ����� ������� ��� ��������, �������� ����� � ���������� ���� ��� �����.', false)
    imgui.SameLine(475)
    
    imgui.SetCursorPosY(imgui.GetCursorPos().y - 1)
    if imgui.CustomOnlyBorderButton(vice_city_mode and "SA$" or "VC$", imgui.ImVec2(35, 27)) then
        -- item_list[index+1].enabled = false
        vice_city_mode = not vice_city_mode
        ini.cfg.vice_city_mode = vice_city_mode
        -- AFKMessage(tostring(vice_city_mode))
        save_all();
        vc_converter();
    end
    imgui.Hint('vice_city_mode', u8'����� ������ �� ������� ����� ��� �� [ViceCity].\n��� �� �� ������� "���������" �� ������ �������� ������� �����������. ����������� ������� ��!', false)
    imgui.SameLine()
    imgui.SetCursorPosY(imgui.GetCursorPos().y + 1)
    if imgui.CustomOnlyBorderButton(fa('download').."##", imgui.ImVec2(35, 27)) then
        -- sampProcessChatInput('/getprices')
        get_prices()
    end
    imgui.Hint('download', u8'����� ������ �� �������� ������� ����.\n��� ����� �������� ��� ������ ������ � ����� ���� ������� ��� �� �� ����������� ����� ��� ������ ������!\n��� �� �� ��������� �� ������ �������� �����, ����� ������� �� �������� ������ ������ � ��� ��������� ������ ������� ���!\n���� �� ������� ��� � ������ ������� ���� ��������� ���� - �� ������� ���������� ����.', false)
    imgui.SameLine()
    if imgui.CustomOnlyBorderButton(fa('trash').."##", imgui.ImVec2(35, 27)) then
        -- table.remove(item_list, key)
        -- menu = 3
        -- imgui.SelectMenu(buttons, 3)
        -- itemsSearchs = {}
        sell_list = {}
    end
    imgui.Hint('trash', u8'����� ������ �� ������� ��� ����������� ������ � ������ ����. (� ������ �������)', false)
    imgui.SameLine()
    if imgui.CustomOnlyBorderButton(fa('FOLDER').."##", imgui.ImVec2(35, 27)) then
        -- table.remove(item_list, key)
        menu = 3
        imgui.SelectMenu(buttons, 3)
    end
    imgui.Hint('FOLDER', u8'����� ������ �� ������ ������������� �� ������� "���������".\n��� �� ������� �������� ��������� �������, � ��� �� ��������� ������.\n�-����. ������ ������, � ��� �������� ������ �� �������! ������ ������ �� ������!', false)
    -- imgui.SameLine()
    -- if imgui.CustomOnlyBorderButton(fa('ARROW_RIGHT')..'##0', imgui.ImVec2(35, 27)) then
    --     menu = menu + 1
    --     imgui.SelectMenu(buttons, menu)
    -- end
    imgui.SameLine()
    imgui.SetCursorPosX(imgui.GetCursorPos().x - 2)
    if imgui.CustomOnlyBorderButton(fa('xmark')..'##0', imgui.ImVec2(35, 27)) then
        show_menu = false
        renderWindow[0] = show_menu
    end
    imgui.Hint('xmark', u8'����� ������ �� �������� ���� �������.', false)
    -- imgui.SameLine()
    
    -- imgui.SetCursorPosX(imgui.GetCursorPos().x - 10)
    -- if imgui.CustomOnlyBorderButton(fa('xmark')..'##0', imgui.ImVec2(35, 27)) then
    --     menu = menu + 1
    --     imgui.SelectMenu(buttons, menu)
    -- end
    -- if imgui.Button(fa('xmark'), imgui.ImVec2(35, 27)) then
    --     window[0] = false
    -- end
                    -- imgui.PopFont()
    if json_vlads ~= nil then
        -- imgui.SameLine() --CloseButton()
        -- imgui.Separator()
        -- imgui.SetCursorPos(imgui.ImVec2(5, imgui.GetCursorPos().y - 2))
        
        imgui.CustomInvisibleChild('sellLeftList', imgui.ImVec2(imgui.GetWindowWidth() / 2.2, sizeY-40), true, imgui.WindowFlags.NoScrollWithMouse)
        
        if json_vlads ~= nil then
            -- AFKMessage('_+')
            
            imgui.Scroller('sellLeftList', 100, 600, imgui.HoveredFlags.AllowWhenBlockedByActiveItem) --���������: ���� � ���� ������, ������ ������ � ��������, ����� �������� � ��, ����� ����������
            for k, data in pairs(json_vlads) do
                -- AFKMessage(data.count[0])
                if u8:decode(ffi.string(data.item)) ~= 0 and string.find(string.nlower(data.item), string.nlower(u8:decode(ffi.string(search_sell))), nil, true) then
                    -- imgui.PushFont(font[22])
                    -- AFKMessage(type(data.count))
                    imgui.PushFont(fonts[18])
                    -- item_tab
                    -- if type(data.count) == 'table' then




                    imgui.SetCursorPosX(imgui.GetCursorPos().x + 2)
                    if containsItem(sell_list, data.item) then
                        imgui.TextColoredRGB('{808080}'..changeExtraSim(k..'. '..data.item..' - '.. tostring(data.all_count)..' ��. ' , 35))
                        if imgui.IsItemHovered() then
                            imgui.SameLine()
                            imgui.SetCursorPosY(imgui.GetCursorPos().y + 2)
                            imgui.TextDisabled(fa('CIRCLE_XMARK'))
                            if #(k..'. '..data.item..' - '.. data.all_count..' ��.') > 1 then
                                imgui.BeginTooltip()
                                imgui.PushFont(fonts[18])
                                imgui.Text(u8(k..'. '..data.item..' - '.. data.all_count..' ��. '..data.count[1])) -- [slot_id='..tostring(data.slot_id)..']
                                imgui.PopFont()
                                imgui.EndTooltip()
                            end
                            imgui.SetCursorPosY(imgui.GetCursorPos().y - 2)
                        end
                    else
                        imgui.TextColoredRGB(ImVec3ToHEX(current_theme.color_text_market)..changeExtraSim(k..'. '..data.item..' - '.. tostring(data.all_count)..' ��. ' , 35))
                        
                        if imgui.IsItemClicked() then
                            if not display.sell then
                                if tonumber(item_sell.count) <= tonumber(data.all_count) then 
                                    AFKMessage('++ data.item '..tostring(data.item) .. ' '.. tostring(data.all_count))
                                    
                                    local data = {name = data.item, price = item_sell.price, count = item_sell.count, slot_count = data.count, slot_id = data.slot_id, all_count = tonumber(data.all_count), enabled = true, maximum = true, price_vc = 10}
                                    addToData(data, sell_list, sort_mode and 1 or nil)
                                -- else
                                --     AFKMessage('+22+')
                                --     local data = {name = data.item, price = item_sell.price, count = data.count, slot_id = data.slot_id, all_count = data.all_count}
                                --     addToData(data, sell_list)
                                end
                            end
                        end
                        if imgui.IsItemHovered() then
                            imgui.SameLine()
                            imgui.SetCursorPosY(imgui.GetCursorPos().y + 1)
                            imgui.TextDisabled(fa('CART_ARROW_UP'))
                            if #(k..'. '..data.item..' - '.. data.all_count..' ��.') > 1 then
                                imgui.BeginTooltip()
                                imgui.PushFont(fonts[18])
                                imgui.Text(u8(k..'. '..data.item..' - '.. data.all_count..' ��.')) -- [slot_id='..tostring(data.slot_id)..']
                                imgui.PopFont()
                                imgui.EndTooltip()
                            end
                            imgui.SetCursorPosY(imgui.GetCursorPos().y - 1)
                        end
                        imgui.PopFont()
                    end
                end
            end
        end
        -- local sizeX, sizeY = 800, 700
        imgui.EndCustomInvisibleChild()
        imgui.SameLine()
        imgui.SetCursorPosX(imgui.GetCursorPos().x - 8)
        -- imgui.VerticalSeparator()
        -- imgui.SameLine()
        local moneyForStat = 0
        -- imgui.SetCursorPos(imgui.ImVec2((imgui.GetWindowWidth() / 2) - 34, 40))
        -- round_text(1)
        imgui.CustomInvisibleChild('sellRightList', imgui.ImVec2(imgui.GetWindowWidth() - 317, sizeY-129), true, imgui.WindowFlags.NoScrollWithMouse)
        -- round_text(0)
        -- imgui.SetCursorPosX(imgui.GetCursorPos().x - 15)
        -- imgui.BeginChild("okno", imgui.ImVec2(0, 0), true, imgui.WindowFlags.NoScrollWithMouse)

        local itemsSearchs = {}
        if sell_list then
            for k, v in pairs(sell_list) do
                -- AFKMessage()
                
                if sell_list[k].enabled then
                    
                    local current_sum = vice_city_mode and sell_list[k].price or sell_list[k].price_vc
                    local sort_count = sell_list[k].maximum and sell_list[k].all_count or sell_list[k].count
                    -- AFKMessage(sell_list[k].price * sort_count.. ' ?? '..sell_list[k].name)
                    moneyForStat = moneyForStat + (current_sum * sort_count)
                end
                if (#u8:decode(ffi.string(search_sell)) ~= 0) and (string.nlower(v.name):find(string.nlower(u8:decode(ffi.string(search_sell))))) then
                -- if (#(u8:decode(ffi.string(search_sell))) > 0) and (list_for_search.sell[k]):find(string.nlower(u8:decode(ffi.string(sell_list[k].name))), nil, true) then
                    -- AFKMessage(k)
                    -- AFKMessage('do '..k)
                    table.insert(v, 1, k)
                    table.insert(itemsSearchs, v)
                    -- table.insert(itemsSearchs, 30, v)
                    -- itemsSearchs[30][1] = 33
                end
            end
        end
        imgui.Scroller('sellRightList', 100, 600, imgui.HoveredFlags.AllowWhenBlockedByActiveItem) --���������: ���� � ���� ������, ������ ������ � ��������, ����� �������� � ��, ����� ����������
        -- local buy_add_list = #ffi.string(search) == 0 and json_vlad or itemsSearch
        imgui.SetCursorPosY(imgui.GetCursorPos().y + 3)
        local sell_add_list = #ffi.string(search_sell) == 0 and sell_list or itemsSearchs
        -- AFKMessage(tostring(sell_add_list))
        local clipper_sell_add = imgui.ImGuiListClipper(#sell_add_list);
        clipper_sell_add:Begin(#sell_add_list) -- // TODO PASTING SELL
        while clipper_sell_add:Step() do
            
            for i = clipper_sell_add.DisplayStart, clipper_sell_add.DisplayEnd - 1 do
                -- imgui.TextColoredRGB('{ffffff}'..changeExtraSim((i+1) .. ". " .. sell_add_list[i + 1].name, 35))
                -- AFKMessage(tostring(clipper_sell_add.DisplayEnd))
                -- AFKMessage(clipper_sell_add.DisplayStart)
                imgui.PushFont(fonts[18])
                -- local index 
                if #ffi.string(search_sell) ~= 0 then
                    index = sell_add_list[i+1][1] - 1
                    -- AFKMessage('posle '..sell_add_list[i+1][1])
                else
                    index = i 
                end
                -- AFKMessage(sell_add_list[i+1][1]) -- sell_add_list[1][1]
                -- AFKMessage('goto '..tostring(index+1).. ' ?? '..tostring(sell_add_list[i+1]))
                if tostring(sell_add_list[i+1]) == 'nil' then goto skiprender end
                
                imgui.CustomSeparator(imgui.GetWindowWidth())
                if sell_add_list[i+1].enabled == true then -- //TODO ����� ����� ��������� ��������
                    if imgui.CustomOnlyBorderButton(fa('TOGGLE_ON').."##21"..(i+1), imgui.ImVec2(50)) then
                        sell_list[index+1].enabled = false
                    end
                else
                    if imgui.CustomOnlyBorderButton(fa('TOGGLE_OFF').."##21"..(i+1), imgui.ImVec2(50)) then
                        sell_list[index+1].enabled = true
                    end
                end
                -- imgui.SetCursorPosY(imgui.GetCursorPos().y + 65)
                imgui.SameLine()
                
                imgui.SetCursorPosY(imgui.GetCursorPos().y - 2)
                imgui.SetCursorPosX(imgui.GetCursorPos().x - 10)
                -- if imgui.RadioButtonBool('##'..tostring((i+1)),RadioButton_s[0]) then
                --     -- RadioButton_s[0] = not RadioButton_s[0]
                --     AFKMessage((i+1))
                -- end
                
                imgui.GetStyle().FrameBorderSize = border_side[0] and 1 or 0
                if imgui.RadioButtonIntPtr('##332'..tostring((i+1)),RadioButton_s[1],(index+1)) then
                    RadioButton_s[3] = false
                    if RadioButton_s[2] ~= 333 then
                        AFKMessage('switch '.. RadioButton_s[2]..' na >> '..(index+1))
                        local swich_save = sell_list[RadioButton_s[2]]
                        table.remove(sell_list, RadioButton_s[2])
                        table.insert(sell_list, (index+1), swich_save)
                        RadioButton_s[2] = 333
                        RadioButton_s[1][0] = 333
                        RadioButton_s[3] = true
                        -- break
                    end
                    if RadioButton_s[3] == false then
                        RadioButton_s[2] = (index + 1)
                        AFKMessage('select '.. RadioButton_s[2])
                    end
                end
                imgui.GetStyle().FrameBorderSize = 0
                imgui.SameLine()
                -- if sell_add_list[i + 1].enabled then
                    -- imgui.Text(u8(changeExtraSim((i+1) .. ". " .. sell_add_list[i + 1].name, 43)))
                    -- AFKMessage(type(sell_add_list[i + 1].all_count))
                local color_string = sell_add_list[i + 1].all_count > 0 and ImVec3ToHEX(current_theme.color_text_market) or '{ff6666}'
                imgui.TextColoredRGB(sell_add_list[i + 1].enabled and  color_string..changeExtraSim((index + 1) .. ". " .. sell_add_list[i + 1].name, 35) or '{808080}'..changeExtraSim((index + 1) .. ". " .. sell_add_list[i + 1].name, 35))
                    -- imgui.TextColoredRGB(changeExtraSim((i+1) .. ". {ffffff}" .. sell_add_list[i + 1].name, 43))
                -- else
                --     imgui.TextColoredRGB('{808080}'..changeExtraSim((index + 1) .. ". " .. sell_add_list[i + 1].name, 35))
                -- end
                -- imgui.TextColoredRGB(tostring(changeExtraSim(cfg_name..'{ffff00} [Loaded]', 50)))
                
                -- AFKMessage(tostring(imgui.IsMouseClicked(0)))
                if #((i+1) .. ". " .. sell_add_list[i + 1].name) > 1 then
                    if imgui.IsItemHovered() then
                        imgui.BeginTooltip()
                        imgui.PushFont(font[17])
                        imgui.Text(u8(sell_add_list[i + 1].name)..u8' ('..sell_add_list[i + 1].all_count..u8' ��.)')
                        -- if balanced_price ~= nil then
                            -- AFKMessage('++_+')
                        show_prices(sell_add_list[i + 1].name, i)
                        -- end
                        imgui.PopFont()
                        imgui.EndTooltip()
                    end
                end
                -- imgui.PopFont()
                imgui.SetCursorPosX(imgui.GetCursorPos().x + 10)
                imgui.PushItemWidth(vice_city_mode and 100 or 100)
                input.sell[(i+1)] = new.char[32](vice_city_mode and ''..sell_add_list[i + 1].price or ''..sell_add_list[i + 1].price_vc) 
                if imgui.InputTextD(vice_city_mode and ' SA$##'..(i+1) or ' VC$##'..(i+1), input.sell[(i+1)], 32, imgui.InputTextFlags.CharsDecimal) then

                    if ffi.string(input.sell[(i+1)]):match('^%d+$') then
                        if (ffi.string(input.sell[(i+1)]) ~= '0' and vice_city_mode) then    
                            -- sell_add_list[i + 1].price = ffi.string(input.sell[(i+1)])
                            sell_list[i + 1].price = ffi.string(input.sell[(i+1)])
                            -- AFKMessage(tostring(sell_list[i + 1].price))
                        end 
                        if (ffi.string(input.sell[(i+1)]) ~= '0' and not vice_city_mode) then    
                            sell_list[i + 1].price_vc = ffi.string(input.sell[(i+1)])
                        end
                    end
                    -- AFKMessage(ffi.string(input.sell[(i+1)])..' '..tostring(vice_city_mode))
                end
                -- imgui.SameLine()
                -- if imgui.CustomOnlyBorderButton("SA$##221"..(i+1), imgui.ImVec2(25)) then
                --     item_list[index+1].enabled = false
                -- end
                imgui.PopItemWidth()
                imgui.SameLine()
                if not vice_city_mode then
                    imgui.SetCursorPosX(imgui.GetCursorPos().x - 1)
                end
                if sell_add_list[i + 1].maximum then
                    imgui.SetCursorPosY(imgui.GetCursorPos().y + 1)
                    if imgui.CustomOnlyBorderButton(fa('SQUARE_M').."##21"..(i+1), imgui.ImVec2(25)) then
                        sell_list[(index+1)].maximum = false
                    end
                    imgui.SameLine()
                    imgui.SetCursorPosY(imgui.GetCursorPos().y - 1)
                    imgui.SetCursorPosX(imgui.GetCursorPos().x - 2)
                    imgui.TextColoredRGB('{808080} ��������')
                    imgui.SameLine()
                    imgui.SetCursorPosX(imgui.GetCursorPos().x + 25.6)
                    imgui.Text(u8('��.'))
                else
                    imgui.SetCursorPosY(imgui.GetCursorPos().y + 1)
                    if imgui.CustomOnlyBorderButton(fa('SQUARE_C').."##21"..(i+1), imgui.ImVec2(25)) then
                        sell_list[(index+1)].maximum = true
                    end
                    imgui.SameLine()
                    imgui.SetCursorPosY(imgui.GetCursorPos().y - 1)
                    imgui.SetCursorPosX(imgui.GetCursorPos().x - 2.4)
                    imgui.PushItemWidth(90)
                    input.sell[(i+1)] = new.char[32](''..sell_add_list[i + 1].count)
                    if imgui.InputTextD(u8'    ��.##2 '..(i+1), input.sell[(i+1)], 32, imgui.InputTextFlags.CharsDecimal) then -- ..tostring(sell_add_list[i + 1].slot_id)..']
                        
                        if ffi.string(input.sell[(i+1)]):match('^%d+$') then
                            if (ffi.string(input.sell[(i+1)]) >= '0') then
                                sell_add_list[i + 1].count = ffi.string(input.sell[(i+1)])
                            end
                        end
                    end
                    imgui.PopItemWidth()
                end
                imgui.SameLine()
                -- local sort_count = sell_add_list[i + 1].maximum and sell_add_list[i + 1].all_count or sell_add_list[i + 1].count
                -- moneyForStat = moneyForStat + (sell_add_list[i + 1].price * sort_count)
                if imgui.CustomOnlyBorderButton(fa('trash').."##1"..(i+1), imgui.ImVec2(50)) then
                    AFKMessage(index+1)
                    -- wait(250)
                    -- table.remove(sell_add_list, i+1)
                    table.remove(sell_list, index+1)
                end
                ::skiprender::
                -- imgui.Separator()
            end
        end
        clipper_sell_add:End()
        imgui.EndCustomInvisibleChild()
        if next(sell_list) ~= nil then
            
            imgui.SetCursorPos(imgui.ImVec2((imgui.GetWindowWidth() / 2) - 29, sizeY-90))
            -- imgui.SetCursorPos(imgui.ImVec2((imgui.GetWindowWidth() - 600) / 2, 600))
            -- imgui.SetCursorPosX(imgui.GetCursorPos().x - 55)
            imgui.CustomInvisibleChild('sellBlockStat', imgui.ImVec2(-1, -1))
            -- imgui.Separator()
            -- imgui.PushFont(fonts[17])
            
            imgui.GetStyle().FrameBorderSize = border_side[0] and 1 or 0
            local global_summ = moneyForStat < 100000000 and '(+'..moneySeparator(moneyForStat)..u8')' or '(+......)'
            imgui.CenterText(u8'�������: '.. moneySeparator(getPlayerMoney() + moneyForStat) .. ' '..global_summ..u8' | ���������: '..#sell_list)
            if moneyForStat > 100000000 then
                if imgui.IsItemHovered() then
                    imgui.BeginTooltip()
                    imgui.Text('    (+'..moneySeparator(moneyForStat)..')    ')
                    -- if balanced_price ~= nil then
                        -- AFKMessage('++_+')
                    -- end
                    imgui.EndTooltip()
                end
            end
            -- imgui.PopFont()
            if imgui.Button(display.sell and u8'������' or u8'��������� �� �������', imgui.ImVec2((imgui.GetWindowWidth()) - 9, 27)) then
                if not display.sell then
                    if is_invent_open ~= nil then
		                sampSendClickTextdraw(65535)
                        AFKMessage('� �������� ���������� �� ��������. ����� �����������. ��������� ��������.')
                    else
                        local ip, _ = sampGetCurrentServerAddress()
                        if (servers[ip] == 0 and vice_city_mode) or (servers[ip] ~= 0 and not vice_city_mode) then
                            AFKMessage('��������! � ��� ���������� �� ��� ����� �������. ������� � ������� � ��������� ������ � ������� �����������.')
                        else
                            scan_sell = true
                            item_tab = {}
                            window[0] = false
                            sampSendChat('/stats')
                            AFKMessage('���������� � �������� ������...')
                            sell_check = true
                            cancel_sellorbuy[0] = true
                            display = {sell = true, buy = false, score = 0, score_from = 1}
                            window[0] = false
                            for k, v in pairs(sell_list) do
                                -- AFKMessage(v.count)
                                display.score_from = k
                            end
                        end
                    end
                else
                    sell_check = false
                    scan_sell = false
                    cancel_sellorbuy[0] = false
                    last_stranica = 1
                    display = {sell = false, buy = false, score = 0, score_from = 1}
                    AFKMessage('����������� ������� ���� ��������.')
                    if sell_alitems_d ~= nil then
                        lets_gooo = false
                    end
                end
            end
            -- imgui.SameLine()
            -- if imgui.Button(u8'������������ �����##0', imgui.ImVec2((imgui.GetWindowWidth() / 2) - 10, 27)) then
            --     separatorChar.page = 1
            --     separator[0] = not separator[0]
            -- end
            if load_config_sell == '' then
                if create_config[1] == true then
                    if imgui.Button(u8'�������� ��������', imgui.ImVec2((imgui.GetWindowWidth() / 2) - 10, 27)) then
                        create_config[1] = false
                    end
                    imgui.SameLine()
                    imgui.PushItemWidth(98)    
                    imgui.PushFont(fonts[222])
                    imgui.PushStyleVarVec2(imgui.StyleVar.FramePadding, imgui.ImVec2(6,6.5))
                    -- imgui.InputTextMultiline(u8"##������������� ����� ���", send_irc_msg, 5, imgui.ImVec2((imgui.GetWindowWidth() /5.15) - 15, 20))
                    imgui.InputTextWithHintD("##search_cfg_sell", u8" ��� �������", search_cfg_sell, ffi.sizeof(search_cfg_sell),imgui.InputTextFlags.EnterReturnsTrue)
                    imgui.PopFont()
                    imgui.PopStyleVar()
                    imgui.SameLine()  
                    if imgui.Button(u8"�������", imgui.ImVec2((imgui.GetWindowWidth() /3.99) - 15, 27)) then
                        tosave.sell = u8:decode(ffi.string(search_cfg_sell))
                        if (tosave.sell == '') or (tosave.sell == nil) or (tosave.sell:match("^%s*$") ~= nil) then
                            AFKMessage("{ff3535}[Error]:{ffffff} �� �� ������ ������� {505050}���������� {ffffff}������.")
                        else 
                            create_config[1] = false
                            createConfig('sell-cfg/'..tosave.sell..'.json', {})
                            AFKMessage("������ {505050}"..tostring(tosave.sell)..'{ffffff} ������.')
                            load_config_sell = tosave.sell..'.json'
                            ini.cfg.load_config_sell = load_config_sell --:match("(.+)%.json")
                            save_all()
                        end
                    end
                else
                    if imgui.Button(u8'������� ������', imgui.ImVec2((imgui.GetWindowWidth()) - 9, 27)) then
                        create_config[1] = true
                    end
                end
            else
                if imgui.Button(u8'��������� ������', imgui.ImVec2((imgui.GetWindowWidth()) - 9, 27)) then
                    if load_config_sell ~= '' then
                        tosave.sell = load_config_sell:match('(.+)%.json') and load_config_sell or load_config_sell..'.json'
                        createConfig('sell-cfg/'..tosave.sell, sell_list)
                        AFKMessage("������ "..tostring(tosave.sell)..' ��������.')
                    else
                        AFKMessage('� ��������� �� �� ��������� �� ���� ������. �������� � ��������� ������ ��� ��� ����������.')
                    end
                end
            end
            
            imgui.GetStyle().FrameBorderSize = 0
            imgui.EndCustomInvisibleChild()
        end
    else
        -- helpWithScan()
        
        -- imgui.PushFont(fonts[18])
        -- imgui.SetCursorPos(imgui.ImVec2(1, 325))
        -- imgui.SetCursorPosY(imgui.GetCursorPos().y)
        
        imgui.SetCursorPos(imgui.ImVec2(sizeX/10,sizeY/2))
        imgui.TextDisabled(u8'��� ����������� ��� ����� ������������� ��������� ����� �� ������   '..fa('magnifying_glass'))
        -- imgui.CenterText(u8'��� ����������� ��� ����� ������������� ��������� ����� �� ������'..tostring(thisScript().name))
        -- imgui.PopFont()
    end
    
    -- if alpha_blure ~= nil then
        -- mimgui_blur.apply(imgui.GetWindowDrawList(), 5)
    -- end
    -- imgui.EndChild()
end

function show_prices(arr, i)

    -- AFKMessage('+1')
    if (json_timer[5] == nil) then
        json_timer[5] = os.time()
        -- balanced_price online_price['sell_'] = readJsonFile('moonloader/ArzMarket/UsersInfo/info_users_sell_price.json')
        -- balanced_price_vc = readJsonFile('moonloader/ArzMarket/UsersInfo/info_users_sell_price_vc.json')
        -- buying_price = online_price['buy_'] readJsonFile('moonloader/ArzMarket/UsersInfo/info_users_buy_price.json')
        -- buying_price_vc = readJsonFile('moonloader/ArzMarket/UsersInfo/info_users_buy_price_vc.json')
        local srv_name = sampGetCurrentServerName()
        if srv_name:find('Arizona') then
            local result = srv_name:match('|%s*(.+)')
            if result then
                result = string.lower(result)
                for k, v in pairs(online_price) do
                    local choose = (k ~= 'sell_vc' and k ~= 'buy_vc') and k..result or k
                    online_price[k] = readJsonFile('moonloader/ArzMarket/UsersInfo/info_users_'..choose..'.json')
                end
            end
        end
    end
    -- AFKMessage(tostring(online_price['buy_vc']).. type(online_price['buy_vc']))
    if online_price['buy_'] == nil and online_price['buy_vc'] == nil and online_price['sell_'] == nil and online_price['sell_vc'] == nil then return end
    -- if online_price['buy_vc'][arr] == nil then return end
    -- imgui.Separator()
    imgui.CustomSeparator(400)
    imgui.SetCursorPosY(imgui.GetCursorPos().y - 4)
    imgui.CustomInvisibleChild('sredcena##'..i + 1, imgui.ImVec2(200*2, 250), true, imgui.WindowFlags.NoScrollWithMouse)
    imgui.Scroller('vvvvvv##'..i + 1, 100, 600, imgui.IsMouseDown(0) and 0 or imgui.HoveredFlags.AllowWhenBlockedByActiveItem) 
    local vc_money = (ffi.string(buy_vc) + ffi.string(sell_vc)) / 2
    imgui.Columns(2, 'coloms##'..i + 1, false)
    
    local dates = {}
    for i = 1, 10 do
        dates[i] = os.date('%Y-%m-%d', os.time() - (86400 * (i - 1)))
    end

    -- imgui.PushFont(fonts[17])
    imgui.SetColumnWidth(0, 200)
    imgui.TextDisabled(u8('���������� �������'))
    imgui.NextColumn()
    imgui.TextDisabled(u8('���������� ������'))
    imgui.NextColumn()
    for k, date in pairs(dates) do
        local have_date
        local vc_info
        if online_price['buy_'] ~= nil then
            if online_price['buy_'][arr] ~= nil then
                for k = 1, 10 do
                    if online_price['buy_'][arr].list[k] then
                        -- AFKMessage(online_price['buy_'][arr].list[k][1]..' DATE: '..date)
                        if online_price['buy_'][arr].list[k][1] == date then
                            have_date = true
                            vc_info = k
                            imgui.SetCursorPosY(imgui.GetCursorPos().y + 15)
                            imgui.TextDisabled(u8(online_price['buy_'][arr].list[k][1]..' | SA$ '..moneySeparator(online_price['buy_'][arr].list[k][3])..' '))-- date
                            imgui.SetCursorPosX(imgui.GetCursorPos().x + 15)
                            imgui.Text(u8('SA$ '..moneySeparator(math.floor(online_price['buy_'][arr].list[k][3] / online_price['buy_'][arr].list[k][2]))..' ('..moneySeparator(online_price['buy_'][arr].list[k][2])..' ��)'))
                        end
                    end
                end
            end
        end
        if online_price['buy_vc'] ~= nil then
            if online_price['buy_vc'][arr] ~= nil then
                for k = 1, 10 do
                    if online_price['buy_vc'][arr].list[k] then
                        if online_price['buy_vc'][arr].list[k][1] == date then
                            vc_info = k
                            if have_date ~= true then
                                imgui.SetCursorPosY(imgui.GetCursorPos().y + 15)
                                imgui.TextDisabled(u8(online_price['buy_vc'][arr].list[k][1]..' | VC$ '..moneySeparator(online_price['buy_vc'][arr].list[k][3])..' '))-- date
                            end
                            imgui.SetCursorPosX(imgui.GetCursorPos().x + 15)
                            imgui.Text(u8('VC$ '..moneySeparator(math.floor(online_price['buy_vc'][arr].list[k][3] / online_price['buy_vc'][arr].list[k][2]))..' ('..moneySeparator(online_price['buy_vc'][arr].list[k][2])..' ��)'))
                        end
                    end
                end
            end
        end
        
        if online_price['buy_'] ~= nil then
            if online_price['buy_'][arr] ~= nil then
                if have_date == true and vc_info ~= nil then
                    imgui.SetCursorPosX(imgui.GetCursorPos().x + 15) --math.floor(sell_list[k].price / ffi.string(buy_vc))
                    imgui.TextColoredRGB('{fead5d}VC$ '..moneySeparator(math.floor((online_price['buy_'][arr].list[vc_info][3] / online_price['buy_'][arr].list[vc_info][2]) / vc_money)))
                end
            end
        end
    end
    imgui.NextColumn()
    for k, date in pairs(dates) do
        local have_date
        local vc_info
        
        if online_price['sell_'] ~= nil then
            if online_price['sell_'][arr] ~= nil then
                for k = 1, 10 do
                    if online_price['sell_'][arr].list[k] then
                        if online_price['sell_'][arr].list[k][1] == date then
                            vc_info = k
                            have_date = true
                            imgui.SetCursorPosY(imgui.GetCursorPos().y + 15)
                            imgui.TextDisabled(u8(online_price['sell_'][arr].list[k][1]..' | SA$ '..moneySeparator(online_price['sell_'][arr].list[k][3])..' '))-- date
                            imgui.SetCursorPosX(imgui.GetCursorPos().x + 15)
                            imgui.Text(u8('SA$ '..moneySeparator(math.floor(online_price['sell_'][arr].list[k][3] / online_price['sell_'][arr].list[k][2]))..' ('..moneySeparator(online_price['sell_'][arr].list[k][2])..' ��)'))
                        end
                    end
                end
            end
        end
        
        if online_price['sell_vc'] ~= nil then
            if online_price['sell_vc'][arr] ~= nil then
                for k = 1, 10 do
                    if online_price['sell_vc'][arr].list[k] then
                        if online_price['sell_vc'][arr].list[k][1] == date then
                            -- vc_info = k
                            if have_date ~= true then
                                imgui.SetCursorPosY(imgui.GetCursorPos().y + 15)
                                imgui.TextDisabled(u8(online_price['sell_vc'][arr].list[k][1]..' | VC$ '..moneySeparator(online_price['sell_vc'][arr].list[k][3])..' '))-- date
                            end
                            imgui.SetCursorPosX(imgui.GetCursorPos().x + 15)
                            imgui.Text(u8('VC$ '..moneySeparator(math.floor(online_price['sell_vc'][arr].list[k][3] / online_price['sell_vc'][arr].list[k][2]))..' ('..moneySeparator(online_price['sell_vc'][arr].list[k][2])..' ��)'))
                        end
                    end
                end
            end
        end
        if online_price['sell_'] ~= nil then
            if online_price['sell_'][arr] ~= nil then
                if have_date == true and vc_info ~= nil then
                    imgui.SetCursorPosX(imgui.GetCursorPos().x + 15) --math.floor(sell_list[k].price / ffi.string(buy_vc))
                    imgui.TextColoredRGB('{fead5d}VC$ '..moneySeparator(math.floor((online_price['sell_'][arr].list[vc_info][3] / online_price['sell_'][arr].list[vc_info][2]) / vc_money)))
                end
            end
        end
    end
    imgui.Columns(1)
    imgui.EndCustomInvisibleChild()
end

function list_ArzMarket() -- // TODO list_ArzMarket()
    
        -- imgui.Scroller('toplist', 100, 600, imgui.HoveredFlags.AllowWhenBlockedByActiveItem) 

    imgui.SameLine(555)
    imgui.SetCursorPosY(imgui.GetCursorPos().y + 5)
    if imgui.CustomOnlyBorderButton(fa('CART_ARROW_UP').."##", imgui.ImVec2(35, 27)) then
        -- table.remove(item_list, key)
        menu = 1
        imgui.SelectMenu(buttons, 1)
    end
    imgui.SameLine()
    if imgui.CustomOnlyBorderButton(fa('CART_CIRCLE_PLUS').."##", imgui.ImVec2(35, 27)) then
        -- table.remove(item_list, key)
        menu = 2
        imgui.SelectMenu(buttons, 2)
    end
    imgui.SameLine()
    
    imgui.SetCursorPosX(imgui.GetCursorPos().x - 2)
    if imgui.CustomOnlyBorderButton(fa('xmark')..'##0', imgui.ImVec2(35, 27)) then
        show_menu = false
        renderWindow[0] = show_menu
    end
       
    imgui.Hint('xmark', u8'����� ������ �� �������� ���� �������.', false)
    if (json_timer[4] + 2 <= os.time()) or (toplist == nil) then
        json_timer[4] = os.time()
        toplist = readJsonFile('moonloader\\ArzMarket\\UsersInfo\\info_users_UsersScore.json')
        local function compareExp(item1, item2)
            return item1.exp > item2.exp
        end

        table.sort(toplist, compareExp)
            
    end

    imgui.CustomInvisibleChild('toplist', imgui.ImVec2(imgui.GetWindowWidth() / 1.025, sizeY-40), true, imgui.WindowFlags.NoScrollWithMouse)

    if toplist ~= nil then
        
        -- local buy_add_list = toplist
        -- local clipper_buy_add = imgui.ImGuiListClipper(#buy_add_list);
        -- clipper_buy_add:Begin(#buy_add_list)
        -- while clipper_buy_add:Step() do
        --     imgui.PushFont(fonts[2])
            
        --     -- for k, data in pairs(toplist) do
                
        --     for i = clipper_buy_add.DisplayStart, clipper_buy_add.DisplayEnd - 1 do
                -- AFKMessage(tostring(k)..' '..tostring(data.username))
                -- imgui.TextColoredRGB(''..buy_add_list[i + 1].username)
                -- imgui.SameLine()
                -- imgui.TextColoredRGB('{ffffff}'..buy_add_list[i + 1].exp..' EXP')
                
                local players = {}
                for k, data in pairs(toplist) do
                    local exp = data.exp
                    local expNeeded = 4
                    local playerLevel = 1

                    while exp >= expNeeded do
                        playerLevel = playerLevel + 1
                        exp = exp - expNeeded
                        expNeeded = expNeeded * 2
                    end

                    players[k] = {
                        ['name'] = data.username,
                        ['exp'] = data.exp,
                        ['lvl'] = playerLevel
                    }
                end
                -- for i = 1, 50 do
                --     players[i] = {
                --         ['name'] = (i % 2 == 0 and 'Yuki_Rice' or 'Christian_Carrington'),
                --         ['exp'] = (i % 2 == 0 and 8 or 88),
                --         ['lvl'] = (i % 2 == 0 and 8 or 88)
                --     }
                -- end
                
                imgui.PushFont(fonts[20])
                imgui.CreateLeadersMenu('Test', players, imgui.ImVec2(imgui.GetWindowWidth(), sizeY-40))
                imgui.PopFont()
                -- imgui.SameLine()
                -- imgui.TextColoredRGB('{ffffff}'..changeExtraSim('LVL: 8' , 333))
            -- end

            -- imgui.PopFont()
        -- end
        -- clipper_buy_add:End()
    end
    
    imgui.EndCustomInvisibleChild()
end

function menu_settings()
    
    imgui.CustomInvisibleChild('menu_settings', imgui.ImVec2(-1, sizeY - 7), true, imgui.WindowFlags.NoScrollWithMouse)
    imgui.Scroller('menu_settings1', 100, 600, imgui.HoveredFlags.AllowWhenBlockedByActiveItem) 
    imgui.GetStyle().FrameBorderSize = border_side[0] and 1 or 0
                        
    imgui.PushFont(fonts[18])
    if imgui.ColorEdit4(u8' ���� ���� [������ ��������]', color_window) then
        current_theme.window[1], current_theme.window[2], current_theme.window[3], current_theme.window[4] = color_window[0], color_window[1], color_window[2], color_window[3]
        imgui.FrameTheme()
    end
    if imgui.ColorEdit4(u8' ���� ���� [����� ��������]', left_menu) then
        current_theme.left_menu[1], current_theme.left_menu[2], current_theme.left_menu[3], current_theme.left_menu[4] = left_menu[0], left_menu[1], left_menu[2], left_menu[3]
        imgui.FrameTheme()
    end
    -- if imgui.ColorEdit4(u8'separator', color_separator) then
    --     current_theme.separator[1], current_theme.separator[2], current_theme.separator[3], current_theme.separator[4] = color_separator[0], color_separator[1], color_separator[2], color_separator[3]
    --     imgui.FrameTheme()
    -- end
    if not rgb_window[0] then
        if imgui.ColorEdit4(u8' ���� ������� ����', rgb_windowC) then
            current_theme.rgb_window[1], current_theme.rgb_window[2], current_theme.rgb_window[3], current_theme.rgb_window[4] = rgb_windowC[0], rgb_windowC[1], rgb_windowC[2], rgb_windowC[3]
            imgui.FrameTheme()
        end
    end
    if imgui.ColorEdit4(u8' ���� ������', color_button) then
        current_theme.button[1], current_theme.button[2], current_theme.button[3], current_theme.button[4] = color_button[0], color_button[1], color_button[2], color_button[3]
        imgui.FrameTheme()
    end
    if imgui.ColorEdit4(u8' ���� ������ ��������� ����', active_selector_color) then
        current_theme.active_selector_color[1], current_theme.active_selector_color[2], current_theme.active_selector_color[3], current_theme.active_selector_color[4] = active_selector_color[0], active_selector_color[1], active_selector_color[2], active_selector_color[3]
        imgui.FrameTheme()
    end
    if imgui.ColorEdit4(u8' ���� �������� ����', slider) then
        current_theme.slider[1], current_theme.slider[2], current_theme.slider[3], current_theme.slider[4] = slider[0], slider[1], slider[2], slider[3]
        imgui.FrameTheme()
    end
    if imgui.ColorEdit3(u8' ���� �������������� [���]', active_toggle_button) then
        current_theme.active_toggle_button[1], current_theme.active_toggle_button[2], current_theme.active_toggle_button[3] = active_toggle_button[0], active_toggle_button[1], active_toggle_button[2]
        imgui.FrameTheme()
    end
    if imgui.ColorEdit3(u8' ���� �������������� [����]', deactive_toggle_button) then
        current_theme.deactive_toggle_button[1], current_theme.deactive_toggle_button[2], current_theme.deactive_toggle_button[3] = deactive_toggle_button[0], deactive_toggle_button[1], deactive_toggle_button[2]
        imgui.FrameTheme()
    end
    if imgui.ColorEdit4(u8' ���� ������ � ����', color_text) then
        current_theme.text[1], current_theme.text[2], current_theme.text[3], current_theme.text[4] = color_text[0], color_text[1], color_text[2], color_text[3]
        imgui.FrameTheme()
    end
    if imgui.ColorEdit3(u8' ���� ������ � ���� [�������]', color_text_market) then
        current_theme.color_text_market[1], current_theme.color_text_market[2], current_theme.color_text_market[3] = color_text_market[0], color_text_market[1], color_text_market[2]
        imgui.FrameTheme()
    end
    
    -- if imgui.ColorEdit4(u8' ���� ������ ��������� ����', active_selector_color) then
    --     current_theme.active_selector_color[1], current_theme.active_selector_color[2], current_theme.active_selector_color[3], current_theme.active_selector_color[4] = active_selector_color[0], active_selector_color[1], active_selector_color[2], active_selector_color[3]
    --     imgui.FrameTheme()
    -- end
    
    
    -- imgui.PushItemWidth(500)
    if imgui.ToggleButton(u8'�������� ���� ����', left_menu_blur) then

        ini.cfg.left_menu_blur = left_menu_blur[0]
        right_menu_blur[0] = left_menu_blur[0]
        ini.cfg.right_menu_blur = right_menu_blur[0]
        save_all()
    end
    if left_menu_blur[0] then
        if imgui.ToggleButton(u8'�������� ������� ����', blur_rgb_window) then
            ini.cfg.blur_rgb_window = blur_rgb_window[0]
            save_all()
        end
        if imgui.ToggleButton(u8'�������� �� ���� ����� ��� �������', background_blure) then
            ini.cfg.background_blure = background_blure[0]
            save_all()
        end
        
    end
    -- if imgui.ToggleButton('Blure function (right)', right_menu_blur) then

    --     ini.cfg.right_menu_blur = right_menu_blur[0]
    --     save_all()
    -- end
    
    if imgui.ToggleButton(u8'����� ��������������', button_style) then
        ini.cfg.button_style = button_style[0]
        save_all()
    end
    if imgui.ToggleButton(u8'�������� ������� ���������', border_side) then
        ini.cfg.border_side = border_side[0]
        save_all()
    end
    if imgui.ToggleButton(u8'�������� ��������� � ����', help_message) then
        ini.cfg.help_message = help_message[0]
        save_all()
    end
    if imgui.ToggleButton(u8'��� ������� ������', rgb_window) then
        ini.cfg.rgb_window = rgb_window[0]
        save_all()
    end
    if imgui.ToggleButton(u8'������� �������� � ����', alpha_menuS) then
        ini.cfg.alpha_menuS = alpha_menuS[0]
        save_all()
    end
    
    if imgui.ToggleButton('dbug info in chat', dbug_info) then
        ini.cfg.dbug_info = dbug_info[0]
        save_all()
    end
    
    if replace_window[0] then
        imgui.SetCursorPosY(imgui.GetCursorPos().y - 12)
        imgui.CenterText(u8'���������. "���� ������".')
        round_text(1)
        imgui.CustomInvisibleChild('menu_settings1', imgui.ImVec2(-1, 140), true, imgui.WindowFlags.NoScrollWithMouse+imgui.WindowFlags.NoScrollbar)
        round_text(0)
        imgui.GetStyle().FrameBorderSize = border_side[0] and 1 or 0
        -- imgui.Scroller('menu_settings1', 100, 600, imgui.HoveredFlags.AllowWhenBlockedByActiveItem) 
        if imgui.Button(u8'�������� ������� ���� [���� �����]') then
            replace_logger[0] = true
            sampSetCursorMode(4)
            lua_thread.create(function()
                while true do
                    marketPos = imgui.ImVec2(select(1, getCursorPos()), select(2, getCursorPos()))
                    if imgui.IsMouseClicked(0) then
                        AFKMessage('���������.')
                        replace_loggerS.marketPos = {x = marketPos.x, y = marketPos.y}
                        sampSetCursorMode(0)
                        writeJsonFile(replace_loggerS, color_theme)
                        break
                    end
                    wait(0)
                end
            end)
        end
        
        imgui.SameLine()
        imgui.PushItemWidth(85 - 2.5)
        if imgui.DragInt('##marketSizeX', marketSize.x, 1, 0, select(1, getScreenResolution()), "%.0f") then
            replace_loggerS.marketSize.x = marketSize.x[0]
            writeJsonFile(replace_loggerS, color_theme)
        end
        imgui.SameLine()
        if imgui.DragInt('##marketSizeY', marketSize.y, 1, 0, select(2, getScreenResolution()), "%.0f") then
            replace_loggerS.marketSize.y = marketSize.y[0]
            writeJsonFile(replace_loggerS, color_theme)
        end
        imgui.SameLine()
        imgui.Text(u8(' ������ ����.'))
        imgui.PopItemWidth()
        
        if imgui.ColorEdit4(u8' ���� ������ � ���� �����.', marketColor.text) then
            replace_loggerS.marketColor.text[1], replace_loggerS.marketColor.text[2], replace_loggerS.marketColor.text[3], replace_loggerS.marketColor.text[4] = marketColor.text[0], marketColor.text[1], marketColor.text[2], marketColor.text[3]
            writeJsonFile(replace_loggerS, color_theme)
            imgui.FrameTheme()
        end
        if imgui.ColorEdit4(u8' ���� ���� �����.', marketColor.window) then
            replace_loggerS.marketColor.window[1], replace_loggerS.marketColor.window[2], replace_loggerS.marketColor.window[3], replace_loggerS.marketColor.window[4] = marketColor.window[0], marketColor.window[1], marketColor.window[2], marketColor.window[3]
            writeJsonFile(replace_loggerS, color_theme)
            imgui.FrameTheme()
        end
        if imgui.Button(u8'�������� ������� ���� [���� �����]') then
            sampSetCursorMode(4)
            lua_thread.create(function()
                while true do
                    LogsPos = imgui.ImVec2(select(1, getCursorPos()), select(2, getCursorPos()))
                    if imgui.IsMouseClicked(0) then
                        AFKMessage('���������.')
                        replace_loggerS.LogsPos = {x = LogsPos.x, y = LogsPos.y}
                        sampSetCursorMode(0)
                        writeJsonFile(replace_loggerS, color_theme)
                        break
                    end
                    wait(0)
                end
            end)
        end
        imgui.SameLine()
        imgui.PushItemWidth(85 - 2.5)
        if imgui.DragFloat(u8(' ������ ������'), log_windowFont, 0.01, 0.1, 3.0, "%.1f") then
            replace_loggerS.log_windowFont = log_windowFont[0]
            writeJsonFile(replace_loggerS, color_theme)
        end
        imgui.GetStyle().FrameBorderSize = 0
        imgui.EndCustomInvisibleChild()
    end
    if imgui.SliderFloat(u8" �������� ������������", button_duration, 0.01, 10.0) then
        ini.cfg.button_duration = button_duration[0]
        save_all()
    end
    -- for i = 0, 3 do
    --     if imgui.RadioButtonIntPtr(tostring(i),RadioButton_s,i) then
    --         RadioButton_s[0] = i
    --         AFKMessage(i)
    --     end
    -- end
    -- for i = 0, 3 do
    --     if imgui.RadioButtonBool('RadioButton '..tostring(i),RadioButton_s[0]) then
    --         RadioButton_s[0] = not RadioButton_s[0]
    --         AFKMessage(i)
    --     end
    -- end

    imgui.SliderFloat(u8" �������� ����� ����� [������]", speed_s, 0.0, 5.0) 
    imgui.SliderFloat(u8" ������������ [������]", alpha_s, 0.0, 1.0) 
    imgui.SliderFloat(u8" ������ ������� [������]", rgb_width, 0.0, 10.0) 
    imgui.SliderInt(u8' ������� ��������', blur_count, 1, 100) 
    
    imgui.GetStyle().FrameBorderSize = 0
    
    imgui.EndCustomInvisibleChild()
end

function sampev.onSendDialogResponse(dialogid, button, list, text) --�������� �������
    -- print(dialogid, button, list, text)
    if text:find('������� ���� ArzMarket') and button == 1 then
        zzztime = os.clock()
        kifir = 1.00
        show_menu = not show_menu
        renderWindow[0] = show_menu
    end
    if full_dialog[1] ~= nil then
        full_dialog[1] = nil
        emule_dialog[0] = false
    end
	if telegram_custom['nalog_message'][0] and text ~= '' then
		nalog_txt[2] = tostring(text)
	end
end


function sampev.onSendClickTextDraw(id) -- �������� ����������
    -- msg(id)
    -- if (display.sell or display.buy) and (id ~= 65535) then
    --     AFKMessage('������ ��� �������� �������� ������!')
    --     return false
    -- end
    if (is_invent_open ~= nil or is_invent_open_mobile ~= nil) and id == 65535 then
        is_invent_open_mobile = nil
        is_invent_open = nil
        invent_proper_check = nil
        invent_proper_checks = nil
        AFKMessage('�������� �������')
        tblid = 0
        txd_id = {}
    end
    if (scan_button[0] or auto_full_button[0] or trade_chat[0]) and id == 65535 then
        AFKMessage('�������� ������/�������/invent/trade')
        trade_chat[0] = false
        scan_button[0] = false
        auto_full_button[0] = false
    end
end

function sampev.onTextDrawSetString(id, text) --textdrawstring
    -- print(id..' '..text)
    -- print(text)
    if text == 'PURCHASE' or text == '�PO�A�A' then
        scan_info[4] = 1
        AFKMessage('[textdrawstring] PURCHASE detected ������� '..id)
    end
    if text == 'SALE' or text == 'CKY�KA' then
        scan_info[4] = 0
        AFKMessage('[textdrawstring] SALE detected ������'..id)
    end
    if id == scan_info[1] then
        txd_id = {}
        AFKMessage('[textdrawstring] stranica detected '..text)
        scan_info[2] = text
    end
end


 
function sampev.onTextDrawHide(id)
    if active_lavka == id then
        replace_logger[0] = false
        ini.cfg.active_lavka = -1
        save_all();
    end
end

function sampev.onShowTextDraw(id,data)-- //TODO onShowTextDraw
    -- if id == id then
    --     return false
    -- end
    -- AFKMessage(data.text)
    -- if id == id and not data.text:find('ticks') then
    --     return false
    -- end
    if replace_window[0] and tostring(data.position.x) == '203.13336181641' and tostring(data.position.y) == '347.44888305664' then
        replace_logger[0] = true
        active_lavka = id
        ini.cfg.active_lavka = id
        save_all();
        return false
    end
    if replace_window[0] and ((id == active_lavka + 1) or (id == active_lavka + 71)) then
        return false
    end
    -- if id == 2141 then
    --     -- 2117 ,18 ,0.47999998927116 ,1.1200000047684 ,-13421773 ,8.5 ,9.8333330154419 ,-2139062144 ,2 ,0 ,-16777216 ,4 ,1 ,{531.85168457031 ,314.10000610352} ,0 ,{0 ,0 ,0} ,1 ,-1 ,LD_BEAT:chit
    --     -- msg(data.text)
    --     -- msg(data.modelId)  {ffffff}2120 ,18 ,0.47999998927116 ,1.1200000047684 ,-15066598 ,8.5 ,9.8333330154419 ,-2139062144 ,2 ,0 ,-16777216 ,4 ,0 ,{560.35168457031 ,314.10000610352} ,0 ,{0 ,0 ,0} ,1 ,-1 ,LD_BEAT:chit
    --     -- 2148 ,18 ,0.47999998927116 ,1.1200000047684 ,-1 ,21 ,24.5 ,-2139062144 ,2 ,0 ,-13487452 ,5 ,1 ,{295 ,288.24285888672} ,0 ,{0 ,0 ,90} ,2 ,0 ,LD_SPAC:white
    --     print(id..', '..data.flags..', '..data.letterWidth..', '..data.letterHeight..', '..data.letterColor..', '..data.lineWidth..', '..data.lineHeight..', '..data.boxColor..', '..data.shadow..', '..data.outline..', '..data.backgroundColor..', '..data.style..', '..data.selectable..', {'..data.position.x..', '..data.position.y..'}, '..data.modelId..' ,{'..tostring(data.rotation.x)..', '..tostring(data.rotation.y)..', '..data.rotation.z..'}, '..data.zoom..', '..data.color..', '..data.text)
    -- end
    -- 2141 ,18 ,0.47999998927116 ,1.1200000047684 ,-1 ,25.5 ,29.5 ,-2139062144 ,2 ,0 ,-13421773 ,5 ,1 ,{467.10171508789 ,127.59999847412} ,2107 ,{-30 ,-20 ,30} ,1 ,0 ,LD_SPAC:white
    if data.text == 'ON_SALE' or data.text == 'HA_�PO�A�E' then
        AFKMessage('�������� �������')
        is_invent_open = id
    end
    if trader_bool[0] and data.position.x == 250.25 and tostring(data.position.y) == '267.41101074219' then
        trade_menu = vector3d(convertGameScreenCoordsToWindowScreenCoords(data.position.x - 135, data.position.y - 1))
        trader_name = data.text
        if trader_name:match("%((%d+)%)") then
            trader_name = trader_name:gsub("%((%d+)%)", "[%1]")
        end
        trade_chatM = {}
        trade_chat[0] = true
        local path = os.getenv("USERPROFILE") .. "\\Documents\\GTA San Andreas User Files\\SAMP\\chatlog.txt"
        for line in io.lines(path) do
            local timestamp, text = string.match(line, "^%[(%d+:%d+:%d+)%] (.+)")
            if timestamp and text then
                local status = checkMessageTime('['..timestamp..'] '..text)
                if status ~= false then
                    local name, id, color, message = status:match('([^%s]+)%[(%d+)%]%s+�������:%s*{([^}]+)}%s+(.*)')
                    if name == trader_name and color == 'B7AFAF' and message ~= nil then
                        table.insert(trade_chatM, name..'['..id..'] �������: {B7AFAF}'..message)
                    end
                end
            end
        end
    end
    if (data.text == 'INVENTORY' or data.text == '�H�EH�AP�') and mobile_jostik[0] then
        is_invent_open_mobile = true
    end
    if (data.text == 'CLOSE' or data.text == '�AKP���') and (is_invent_open ~= nil) then
        invent_proper_checks = data.position.y - 6
        AFKMessage('close detected')
    end
    if (data.text == 'INVENTORY' or data.text == '�H�EH�AP�') and (is_invent_open ~= nil) then
        tblid = 0
        txd_id = {}
        buttons_id = id -- �� +1 �� ������
        AFKMessage(id)
        invent_proper_check = data.position.x - 4
    end
    if data.text == 'SHOP' or data.text == 'MA�A��H' then
        scan_button[0] = true
        AFKMessage('data.text SHOP '..id)
    end
    if (data.text == 'INVENTORY' or data.text == '�H�EH�AP�') and (data.position.x == 346.25 and tostring(data.position.y) == '369.68316650391') then
        wkafX, wkafY = convertGameScreenCoordsToWindowScreenCoords(data.position.x - 55, data.position.y - 1)	
        auto_full_button[0] = true
    end
    -- if (data.text == 'WAREHOUSE' or data.text == '�KA�') and (data.position.x == 187.5 and tostring(data.position.y) == '143.65989685059') then
    -- end
    if tostring(data.position.x) == '250.25' and tostring(data.position.y) == '365.22088623047' and scan_button[0] then
        -- print(data.position.x..', '..data.position.y)
        AFKMessage('stranica detected! '..data.text)
        
        kvadratX, kvadraty = convertGameScreenCoordsToWindowScreenCoords(data.position.x + 43, data.position.y+1)	
        txd_id = {}
        scan_info[1], scan_info[2] = id, data.text
    end
    if invent_proper_check ~= nil and invent_proper_checks ~= nil then-- 0.47999998927116 ,1.1200000047684
        if (invent_proper_check < data.position.x) and (invent_proper_checks > data.position.y) then
            -- 2146 ,18 ,0.47999998927116 ,1.1200000047684 ,-1 ,21 ,24.5 ,-2139062144 ,2 ,0 ,-13421773 ,5 ,1 ,{465.70861816406 ,171.27000427246} ,1649 ,{0 ,0 ,90} ,2 ,0 ,LD_SPAC:white
            -- msg(id..' ,'..data.flags..' ,'..data.letterWidth..' ,'..data.letterHeight..' ,'..data.letterColor..' ,'..data.lineWidth..' ,'..data.lineHeight..' ,'..data.boxColor..' ,'..data.shadow..' ,'..data.outline..' ,'..data.backgroundColor..' ,'..data.style..' ,'..data.selectable..' ,{'..data.position.x..' ,'..data.position.y..'} ,'..data.modelId..' ,{'..tostring(data.rotation.x)..' ,'..tostring(data.rotation.y)..' ,'..data.rotation.z..'} ,'..data.zoom..' ,'..data.color..' ,'..data.text)
            -- if tostring(data.letterWidth) == '0.47999998927116' and tostring(data.letterHeight) == '1.1200000047684' and tostring(data.boxColor) == '-2139062144' and tostring(data.text) == 'LD_SPAC:white' then -- and (tostring(data.letterColor) == '-1' or tostring(data.letterColor) == '-8947849')
                -- AFKMessage(id)
                -- msg(id)
                -- if id == 2146 then
                --     sampAddChatMessage('+++')
                -- end
                -- LD_BEAT:chit
                -- lua_thread.create(function()
                    -- print('["'..data.position.x..', '..data.position.y..'"] = '..tblid..',')
                    -- AFKMessage(inventory_slots[data.position.x..', '..data.position.y])
                    -- print(id..' '.. tblid..' '..tostring(data.selectable) .. ' data.letterColor ['..data.letterColor..'] data.letterColor ['..data.letterColor..']')
                    -- table.insert(txd_id, )
                if inventory_slots[data.position.x..', '..data.position.y] then
                    add_slot(txd_id, {id, inventory_slots[data.position.x..', '..data.position.y] + tblid, data.selectable})
                end
                    -- tblid = tblid + 1
                -- end)
            -- end
        end
    else
        if scan_info[1] ~= nil then
            -- AFKMessage(data.text)
            if data.text == 'PURCHASE' or data.text == '�PO�A�A' then
                scan_info[4] = 1
                AFKMessage('PURCHASE detected! ������� '..id)
            end
            if data.text == 'SALE' or data.text == 'CKY�KA' then
                scan_info[4] = 0
                AFKMessage('SALE detected! ������ '..id)
            end
            if scan_slots[data.position.x..', '..data.position.y] then
                -- AFKMessage(id..' ? '..scan_slots[data.position.x..', '..data.position.y])
                add_slot(txd_id, {id, scan_slots[data.position.x..', '..data.position.y], data.selectable})
            end
        end
        -- AFKMessage(scan_slots[data.position.x..', '..data.position.y])
    end
end

function add_slot(arr, mass)
    table.insert(arr, mass)
end

function sampev.onPlaySound(soundId, position)
    -- AFKMessage(soundId)
    if soundId == 6801 and (display.sell or scan_items_s[1] ~= nil) and (wait_dialog_d[1] ~= nil) then
        -- last_sound_id = soundId
        lets_go = true
        AFKMessage(soundId..' off onPlaySound')
    end
end

function wait_dialog()
    while true do 
        AFKMessage('RECLICK___________________'..tostring(wait_dialog_d[2]))
        sampSendClickTextdraw(wait_dialog_d[2])
        wait(1000)
    end
end


function extractTimeFromMessage(message)
    local timeStr = message:match("%[(%d+:%d+:%d+)%]")
    
    if not timeStr then
        return nil
    end

    timeStr = timeStr:gsub("%[%s*(.-)%s*%]", "%1")
    local hours, minutes, seconds = timeStr:match("^(%d+):(%d+):(%d+)$")
    hours = tonumber(hours)
    minutes = tonumber(minutes)
    seconds = tonumber(seconds)

    local currentDate = os.date("*t")
    local timeTable = {
        year = currentDate.year,
        month = currentDate.month,
        day = currentDate.day,
        hour = hours,
        min = minutes,
        sec = seconds
    }

    return os.time(timeTable)
end

function checkMessageTime(message)
    local timestamp = extractTimeFromMessage(message)
    if not timestamp then
        return
    end

    local currentTime = os.time()
    if currentTime - timestamp <= 120 then
        return message
    end
    return false
end

function magiclines(s) if s:sub(-1)~="\n" then s=s.."\n" end return s:gmatch("(.-)\n") end
function sampev.onShowDialog(dialogId, style, title, button1, button2, text) -- // TODO onShowDialog
    last_dialog_id = dialogId
    AFKMessage('Dialog Open: '..tostring(last_dialog_id) ) --'..title..' '..text
    -- print("������ � �������� � ������� ", get_current_function_name())
    -- if dialogId == 26034 then
    --     lua_thread.create(function()
    --         wait(5)
    --         sampSendDialogResponse(26034, 1, 14)
    --     end)
    -- end
    -- if text:find("10 ������") and title:find("��������") then ShowMessage(text:gsub("{......}", ""), "["..sampGetCurrentServerName().."] "..title:gsub("{......}", ""), 0x40) end
    
    
	if telegram_custom['nalog_message'][0] and title:find('������ ���� �������') then
		nalog_txt[1] = tostring(text)
    end
    if text:find('������� �������� ����� �����.') then
        if auto_name_lavka[0] and u8:decode(ffi.string(lavka_name)):len() > 2 then
            lua_thread.create(function()
                wait(300)
                sampSendDialogResponse(dialogId, 1, 65535, u8:decode(ffi.string(lavka_name)))
            end)
            return false
        end
    end
    if title:find('�������� ����') and auto_name_lavka[0] and text:find('|||||||||||||||||||') then
        sampSendDialogResponse(dialogId, 1, 15)
        return false
    end
    if (title:find('������� ��������') or title:find('������� ��������')) and scan_items_s[1] ~= nil then
        if wait_dialog_d[1] ~= nil then
            lets_go = true
        end
        AFKMessage('title:find(�������/������� ��������) ')
        if text:find('��������� ������� ��') and text:find('������ �������') and text:find('15 ���') then
            sampSendDialogResponse(dialogId, 1, 0)
        else
            local items_info = {}
            local ip, _ = sampGetCurrentServerAddress()
            if text:match('{FFFFFF}�������: {......}(.-){......}') then
                -- AFKMessage('ITEM:['..text:match('{FFFFFF}�������: {......}(.-){......}')..'], PRICE:['..text:gsub("%.", ""):match('���������: $(%d+)')..']')
                items_info[1], items_info[2] = text:match('{FFFFFF}�������: {......}(.-){......}'), servers[ip] ~= 0 and text:gsub("%.", ""):match('���������: $(%d+)') or text:gsub("%.", ""):match('���������: VC$(%d+)')
            elseif text:match("{FDCF28}(.-){FFFFFF}") then
                -- AFKMessage('ITEM:['..text:match('{FDCF28}(.-){FFFFFF}')..'], PRICE:['..text:gsub("%.", ""):match('���������: $(%d+)')..']')
                items_info[1], items_info[2] = text:match('{FDCF28}(.-){FFFFFF}'), servers[ip] ~= 0 and text:gsub("%.", ""):match('���������: $(%d+)') or text:gsub("%.", ""):match('���������: VC$(%d+)')
            end
            if items_info[1] ~= nil and items_info[2] ~= nil then
                if scan_info[4] == 1 then
                    local data = {name = items_info[1], price = (servers[ip] == 0 and 10 or items_info[2]), count = 1, slot_count = {999}, slot_id = '999', all_count = '999', enabled = true , maximum = true, price_vc = (servers[ip] ~= 0 and 10 or items_info[2])}
                    addToData(data, sell_list)
                elseif scan_info[4] == 0 then
                    local data = {name = items_info[1], price = (servers[ip] == 0 and 10 or items_info[2]), count = 1, enabled = true, price_vc = (servers[ip] ~= 0 and 10 or items_info[2])}
                    addToData(data, item_list)
                end
            end
            sampSendDialogResponse(dialogId, 0, 0)
            scan_busy = false
            AFKMessage('scan_busy = false ')
        end
        return false
    end
    if text:find('���������� ������ ��������') and text:find('���������� ������� ������') then
        if (display.sell and (display.score <= display.score_from)) then
            sampSendDialogResponse(dialogId, 1, 0)
        elseif (scan == true) then
            sampSendDialogResponse(dialogId, 1, 1)
        elseif (display.score > display.score_from) and display.buy then
            cancel_sellorbuy[0] = false
            AFKMessage('����������� ������� ���������.')
            sampSendDialogResponse(dialogId, 0, 0)
            -- lua_thread.create(function() wait(100) sampCloseCurrentDialogWithButton(0) end)
            display = {buy = false, score = 1, score_from = 1}
        elseif (display.buy and (display.score <= display.score_from)) then
            sampSendDialogResponse(dialogId, 1, 2)
        end
        local text = text .. '\n \n{ffff00}- ������� ���� ArzMarket'
        return {dialogId, style, title, button1, button2, text}
    end
    if text:find('������ ������ ��������') and title:find('�������� ��������') and display.buy then
        sampSendDialogResponse(dialogId, 1, 0, false)
    end
    -- if (dialogId == 25665) and display.buy and (display.score <= display.score_from) then
    --     local i = 0
    --     lua_thread.create(function()
    --         for n in text:gmatch('[^\r\n]+') do
    --             if n:match("%S+%s*{.-}(.+)") == (item_list[display.score].name):gsub("%s*$", "") then
    --                 sampSendDialogResponse(dialogId, 1, i)
    --             elseif n:find(">>>") then sampSendDialogResponse(dialogId, 1, i) end
    --             i = i + 1
    --         end
    --     end)
    -- end

    
    if title:find('����� ������') and text:find('������� ������������ ������') and display.buy and (display.score <= display.score_from) then
        lua_thread.create(function()
            -- wait(ini.cfg.dialog_wait) 
            wait(150)
            sampSendDialogResponse(dialogId, 1, 0, (item_list[display.score].name):gsub("%s*$", ""))
        end)
    end

    if title:find('����� ������') and not text:find('������� ������������ ������') and display.buy and (display.score <= display.score_from) then
        AFKMessage('error stroka? '..tostring(item_list[display.score].name)..' '..dialogId)
        local i = 0
        lua_thread.create(function()
            for n in text:gmatch('[^\r\n]+') do
                if n:match("%S+%s*{.-}(.+)") == (item_list[display.score].name):gsub("%s*$", "") then
                    wait(150) sampSendDialogResponse(dialogId, 1, i)
                    AFKMessage('choose sell [ERR]')
                elseif n:find(">>>") then wait(150) sampSendDialogResponse(dialogId, 1, i) AFKMessage('choose sell [ERR2]') end
                i = i + 1
            end
        end)
    end
    if title:find('��������') and text:find('��������� ��� ������') and scan == true then
        local i = 0
        local page1, page2 = title:match("(%d+)/(%d+)")
        for n in text:gmatch('[^\r\n]+') do
            -- lua_thread.create(function()
                if not n:find("��������") and not n:find("<<<") and not n:find(">>>") and not n:find('��������� ��� ������') then
                    n = n:match("{......}(.+)%s%{......}.+{......}")-- {777777}����	{B6B425} 	{37B625} 
                    -- sampAddChatMessage(tostring(n)..' MMMMMMMMMMMMM',-1)
                    -- setClipboardText(n)--����: Ryder (ID: 86)	{B6B425} �����????: Normal Ped (ID: 9)����: The Mafia (ID: 124)����: Cab Driver (ID: 220)����: Heckler (ID: 258)����: Jizzy B. (ID: 296)��
                    table.insert(items, n)
                end
            
                if n:find(">>>") then
                    -- wait(150)
                    sampSendDialogResponse(dialogId, 1, i-1)
                end
                i = i + 1
            -- end)
        end
        if page1 == page2 then
            
            writeJsonFile(removeDuplicates(items), items_buy)
            updateList()
            scan = false
            AFKMessage('������������ ���������.')
            sampSendDialogResponse(dialogId, 0, 0)
        end
    end
    -- if dialogId == 26556 then
    if display.buy and (text:find('������� ���������� � ���� �� ���� �����') or text:find('������� ���� �� �����')) then
        -- if display.buy and (display.score <= display.score_from) then
        AFKMessage(" { "..display.score.." }" .."_+_++++++++++++++++++++++")
        AFKMessage('off_sell_buyBUY();[2]'..item_list[display.score].name .. ' >> '..text:match('%{57FF6B%}(.-)%s*%{FFFFFF%}'))

        AFKMessage("_+_++++++++++++++++++++++")
        AFKMessage('CHECK ON???? '..tostring(text:match('%{57FF6B%}(.-)%s*%{FFFFFF%}')))
        
            if (item_list[display.score].name ~= text:match('%{57FF6B%}(.-)%s*%{FFFFFF%}')) then
                AFKMessage('OFF SCRIPT... INTERNAL ERR')
                sampSendDialogResponse(dialogId, 0, 0)
                -- off_sell_buy();
                return false
            end
            AFKMessage('display.buy and (display.score <= display.score_from)')
            if text:find("������") then
                AFKMessage('[������] display.buy and (display.score <= display.score_from)')
                AFKMessage(' { '..display.score..' }' ..item_list[display.score].name..item_list[display.score].count..','..tostring(vice_city_mode and item_list[display.score].price or item_list[display.score].price_vc))
                sampSendDialogResponse(dialogId, 1, 0, item_list[display.score].count..','..(vice_city_mode and item_list[display.score].price or item_list[display.score].price_vc))
            else
                AFKMessage('[ELSE ������] display.buy and (display.score <= display.score_from)')
                AFKMessage(' { '..display.score..' }' ..item_list[display.score].name..item_list[display.score].count..'NOT! ,'..tostring(vice_city_mode and item_list[display.score].price or item_list[display.score].price_vc))
                sampSendDialogResponse(dialogId, 1, 0, vice_city_mode and item_list[display.score].price or item_list[display.score].price_vc)
            end
            display.score = display.score + 1
            AFKMessage('score+1')
        -- end
    end
    if (text:find('������� ���������� � ���� �� ���� �����') or text:find('������� ���� �� �����')) and (display.sell) then
        -- lua_thread.create(function() wait(30) --wait(ini.cfg.dialog_wait)
            AFKMessage('+1245125dbug')
            if display.sell then
                -- AFKMessage('+1dbug')
                if text:find("������") then
                    if controller_sell_buy[0] and calculate_similarity(sell_list[display.score].name, text:match('%{57FF6B%}(.-)%s*%{FFFFFF%}')) < 80 then
                        AFKMessage(calculate_similarity(sell_list[display.score].name, text:match('%{57FF6B%}(.-)%s*%{FFFFFF%}'))..'off_sell_buy();[2]'..sell_list[display.score].name..' ?? '..text:match('%{57FF6B%}(.-)%s*%{FFFFFF%}'))
                        off_sell_buy();
                        return false
                    end
                    AFKMessage(tostring(sell_list[display.score].slot_count[need_slot])..' <<>> '..tostring(need_to_sell))
                    if tonumber(sell_list[display.score].slot_count[need_slot]) < need_to_sell then
                        -- AFKMessage('first text '..text)
                        AFKMessage('�� ��� �����������, �������� ��:'..tostring(need_to_sell))
                        sampSendDialogResponse(dialogId, 1, 0, sell_list[display.score].slot_count[need_slot]..','..(vice_city_mode and sell_list[display.score].price or sell_list[display.score].price_vc))
                        need_to_sell = need_to_sell - (sell_list[display.score].slot_count[need_slot])
                        AFKMessage('�� ��� �����������, �������� �����:'..tostring(need_to_sell))
                        -- sell_list[display.score].slot_count[need_slot] = ''
                        need_slot = need_slot + 1
                        -- return
                    else
                        -- sampSendDialogResponse(dialogId, 1, 0, sell_list[display.score].price)
                        
                        sampSendDialogResponse(dialogId, 1, 0, need_to_sell..','..(vice_city_mode and sell_list[display.score].price or sell_list[display.score].price_vc))
                        need_to_sell = 0
                    end
                    AFKMessage(sell_list[display.score].name..'first text23 '..text)
                    -- AFKMessage('+2dbug')
                    -- next_stage = true
                    AFKMessage('FUCTION (���������� �����)')
                    -- sell_busy = false
                else
                    if controller_sell_buy[0] and calculate_similarity(sell_list[display.score].name, text:match('%{57FF6B%}(.-)%s*%{FFFFFF%}')) < 80 then
                        AFKMessage(calculate_similarity(sell_list[display.score].name, text:match('%{57FF6B%}(.-)%s*%{FFFFFF%}'))..'off_sell_buy();[2]'..sell_list[display.score].name..' ?? '..text:match('%{57FF6B%}(.-)%s*%{FFFFFF%}'))
                        off_sell_buy();
                        return false
                    end
                    if tonumber(sell_list[display.score].slot_count[need_slot]) < need_to_sell then
                        need_to_sell = need_to_sell - (sell_list[display.score].slot_count[need_slot])
                    else
                        need_to_sell = 0
                    end
                    AFKMessage(sell_list[display.score].name..'first text23 '..text)
                    need_slot = need_slot + 1
                    AFKMessage('no cena!bro')
                    -- sell_busy = false
                    -- need_to_sell = 0
                    sampSendDialogResponse(dialogId, 1, 0, (vice_city_mode and sell_list[display.score].price or sell_list[display.score].price_vc))
                end
            end
        -- end)
        -- return false
    end

    if dialogId == 235 and scan_sell then
        sampSendDialogResponse(dialogId, 1, 0)
    end
    if dialogId == 25493 and scan_sell then
        local idx = 0
        local linenum = 0
        for i in magiclines(text) do
            if not i:find(">>") and not i:find("<<") and not i:find('��������') and not i:find('���������') and i:find('(%d+) ��') then
                local slot_id, name, count = i:match('%[([^%]]+)%]'), i:match('%]%s+(.-)%s+{'), i:match('{......}%[(%d+)%s+��%]')
                -- sampAddChatMessage(tostring(idx-1)..' slotid >> '..tostring(slot_id)..' name >> '..tostring(name),-1)
                
                -- local all_count = 0

                data = {item = name, count = {count}, slot_id = {slot_id}, all_count = tostring(count)}
                            
                for k, datas in pairs(item_tab) do
                    if data.item == datas.item then
                        find_some = { datas.item,  datas.count, datas.slot_id, datas.all_count}
                        table.remove(item_tab, k)  
                    end
                end
                
                if find_some ~= nil then
                    -- if tostring(type(find_some[2])) == 'string' then
                    --     data = { item = find_some[1], count = {find_some[2], count}, slot_id = {find_some[3], slot_id}, all_count = tostring(find_some[4] + count)}
                    --     -- AFKMessage('first '..find_some[2]..' < find_some[2] find_some[1] > '..find_some[1])
                    -- else
                        -- // TODO ebaniy rot
                        local count_arry = {} 
                        local slot_id_arry = {} 

                        local count = table.concat(find_some[2], ",") .. "," .. count
                        local slot_id = table.concat(find_some[3], ",") .. "," .. slot_id
                        local all_counts = 0
                        for num in count:gmatch("[^,]+") do 
                            all_counts = all_counts + tonumber(num)
                            table.insert(count_arry, num)
                        end 
    
                        for num in slot_id:gmatch("[^,]+") do 
                            table.insert(slot_id_arry, num)
                        end 

                        -- AFKMessage(tostring(find_some[1]))
                        data = { item = find_some[1], count = count_arry, slot_id = slot_id_arry, all_count = tostring(all_counts) }
                    -- end
                    table.insert(item_tab, data)   
                    find_some = nil
                else
                    -- AFKMessage('two '..data.item..' < find_some[2] find_some[1] > '..data.all_count)
                    table.insert(item_tab, data)   
                end
            end

            
            if i:match('>>') then
                -- lua_thread.create(function()
                    -- wait(ini.cfg.dialog_list_wait_bool and ini.cfg.dialog_wait_list or 150)
                    linenum = idx
                    -- sampAddChatMessage(tostring(idx-1)..' '..i,-1)
                    sampSendDialogResponse(dialogId, 1, idx-1)
                -- end)
                return false
            end
            idx = idx + 1
        end
        if not text:find('>> ��������� ��������') then
            writeJsonFile(item_tab, items_sell)
            updateList()
            scan_sell, window[0] = false, true
            AFKMessage("������������ ��������� ���������.")
            sampSendDialogResponse(dialogId, 0, 0)
            json_timer[2] = os.time() - 55
            if sell_check == true and display.sell then
                AFKMessage('���������� ������...')
                sell_busy = false
                next_stage = true
                lets_gooo = true
				setGameKeyState(21, 255)
            end
        end
        return false
    end
    if scan_sell then
        return false
    end
    if dialogId and text:find('A%: (%S+) ������� ���%:.*{cccccc}(.*)$') then
        if telegram_custom['admin_message'][0] then 
            sendTelegramNotification(text)
        end
    end
    if dialogId and (title:find('���������� � ��������') or title:find('������� ��������') or title:find('������� ��������')) and not text:find('��������� ������� �� ') then
        local items_info = {}
        if text:match('{FFFFFF}�������: {......}(.-){......}') then
            items_info[1], items_info[2] = text:match('{FFFFFF}�������: {......}(.-){......}'), text:gsub("%.", ""):match('���������: $(%d+)')
        elseif text:match("{FDCF28}(.-){FFFFFF}") then
            items_info[1], items_info[2] = text:match('{FDCF28}(.-){FFFFFF}'), text:gsub("%.", ""):match('���������: $(%d+)')
        end
        if items_info[1] ~= nil then
            full_dialog[1] = items_info[1]
            emule_dialog[0] = true
        end
    end
	if auto_full_dialog == true and auto_full_button[0] and text:find('������� ����������, ������� ������') and (text:find('�������') or text:find('��������')) and not title:find('���� > ��������') then
        sampSendDialogResponse(dialogId, 1, 0, '999999')
        return false
    end
end

function sampev.onServerMessage(color, text)
    local hookMarket = {
		{text = '^%s*(.+) ����� � ��� (.+), �� ��������(.+)$(.+) �� ������� %(�������� %d+ �������%(�%)%)$', color = -1347440641, key = 2},
		-- {text = '^%s*�� ������� ������� (.+) �������� (.+), � ������� ��������(.+)$(.+) %(�������� %d+ �������%(�%)%)$', color = -65281, key = 2},
		{text = '^%s*�� ������ (.+) � ������ (.+) ��(.+)$(.+)', color = -1347440641, key = 3},
		-- {text = '^%s*�� ������� ������ (.+) � (.+) ��(.+)$(.+)', color = -65281, key = 3}
	}
    
    if trade_chat[0] and color == -1 and text:match('([^%s]+)%[(%d+)%]%s+�������:%s*{([^}]+)}%s+(.*)') then
        local name, id, color, message = text:match('([^%s]+)%[(%d+)%]%s+�������:%s*{([^}]+)}%s+(.*)')
        if (name == trader_name or name == sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))) and (color == 'B7AFAF' and message ~= nil) then
            table.insert(trade_chatM, name..'['..id..'] �������: {B7AFAF}'..message)
        end
    end

    local hookActionsShop = {
		'^%s*%[����������%] {FFFFFF}�� ���������� �� ������ �����!',
		'^%s*%[����������%] {FFFFFF}�� ����� �����!',
		'^%s*%[����������%] {FFFFFF}���� ����� ���� �������, ��%-�� ���� ��� �� � ��������!'
	}

    if telegram_custom['nalog_message'][0] then
        if text:find('�� �������� ��� ������ �� �����') and color == 1941201407 then
            sendTelegramNotification('[SAMP | Oplata_naloga (all_nalogs)] \n' .. sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) .. '\n' .. sampGetCurrentServerName() .. '\nLast input: \n \n \n'..tostring(nalog_txt[1])) 
            nalog_txt[1] = nil
        end
        if text:find('�� ������� �������� ������������ ����� �� ������') and color == 1118842111 then
            sendTelegramNotification('[SAMP | Oplata_naloga (business)] \n' .. sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) .. '\n' .. sampGetCurrentServerName() .. '\nLast input: '..tostring(nalog_txt[2]))
        end
        if text:find('�� ������� �������� ������������ ����� �� ������������ ������') and color == 1118842111 then
            sendTelegramNotification('[SAMP | Oplata_naloga (house)] \n' .. sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) .. '\n' .. sampGetCurrentServerName() .. '\nLast input: '..tostring(nalog_txt[2]))
        end
    end
    
	if text:find('^%s*%(%( ����� 30 ������ �� ������� ����� ����������� � �������� ��� ��������� ������ %)%)%s*$') then
		if telegram_custom["death_notf"][0] then
			sendTelegramNotification('��������� ����! �� ������!')
		end
	end

    if text:find('A%: (%S+) ������� ���%:.*} (.*)$') then
        if telegram_custom['admin_message'][0] then
            sendTelegramNotification(text)
        end
    end

	for k, v in ipairs(hookActionsShop) do
		if text:find(v) then
			if telegram_custom["lavka_status"][0] then
				sendTelegramNotification(text)
			end
		end
	end

	for k, v in ipairs(hookMarket) do
		if string.find(text, v['text']) and v['color'] == color and jsonLog ~= nil then
			local args = splitArguments({text:match(v['text'])}, text:find('����� � ���'))
			local textLog = getTypeMessageMarket(text, args)
            AFKMessage(tostring(textLog))
			
			if jsonLog[os.date('%d.%m.%Y')] == nil then jsonLog[os.date('%d.%m.%Y')] = {{}, 0, 0, 0, 0} end
            
			if #marketShop >= 10 then marketShop = {} end
            table.insert(marketShop, textLog)
			table.insert(jsonLog[os.date('%d.%m.%Y')][1], textLog)
			jsonLog[os.date('%d.%m.%Y')][(#args['ViceCity'] == 3 and v.key + 2 or v.key)] = jsonLog[os.date('%d.%m.%Y')][(#args['ViceCity'] == 3 and v.key + 2 or v.key)] + args['money']
            if telegram_custom['notf_buysell'][0] then
                if telegram_custom['stats'][0] then
                    textLog = textLog .. '\n\n' .. '������� �� ����: $' .. moneySeparator(jsonLog[os.date('%d.%m.%Y')][2]) .. '\n' .. '������� �� ����: $' .. moneySeparator(jsonLog[os.date('%d.%m.%Y')][3]) .. '\n\n' .. '������� �� ����: VC$' .. moneySeparator(jsonLog[os.date('%d.%m.%Y')][4]) .. '\n' .. '������� �� ����: VC$' .. moneySeparator(jsonLog[os.date('%d.%m.%Y')][5])
                end
                sendTelegramNotification(textLog)
            end
            writeJsonFile(jsonLog, 'moonloader\\ArzMarket\\Log.json')
		end
	end

    if (text:find('������ ������ ��������� ��������� �� � ������ �����') or text:find('��������� ������ � ��������� ����� SIM')) and color == -1104335361 and display.sell and sell_busy == true then
        if wait_dialog_d[1] ~= nil then
            lets_go = true
        end
        sell_busy = false
        need_to_sell = 0
        AFKMessage('[onServerMessage] ��������� ������ sell_busy = false ������ ������ ��������� ��������� �� � ������ �����')
    end

    if (text:find('������� ��������� �� �������') or text:find('����������� ���������') or text:find('� ��� ������������') or text:find('������������ ���������') or text:find('�� ������� ������ �� ����� �����')) and (color == 1941201407 or color == -1104335361) and display.sell and sell_busy == true then
        sell_busy = false
        AFKMessage('[onServerMessage] ��������� ������ sell_busy = false')
        if text:find('�� ������� ������ �� ����� �����') then
            AFKMessage('ofaem script. daleko ot lavki')
            last_stranica = 1
            cancel_sellorbuy[0] = false
            AFKMessage('����������� ������� ���������.')
            display = {sell = false, score = 1, score_from = 1}
            AFKMessage('goto skips')
            if sell_alitems_d ~= nil then
                lets_gooo = false
            end
        end
    end
end

function splitArguments(array, key)
	return {
		['name'] = (key and array[1] or array[2]),
		['item'] = (key and array[2] or array[1]),
		['ViceCity'] = array[3],
		['money'] = stringToCount(array[4])
	}
end

function getTypeMessageMarket(text, args)
	local array = {
		['����� � ���'] = '%s %s ����� "%s" ��%s$%s',
		['�� ������'] = '%s %s ������ "%s" ��%s$%s',
	}
	for k, v in pairs(array) do
		if text:find(k) then return string.format(v, os.date('[%H:%M:%S]'), args['name'], args['item'], args['ViceCity'], moneySeparator(args['money'])) end
	end
end


function stringToCount(text)
	local count = ''
	for line in text:gmatch('%d') do
		count = count .. line
	end
	return tonumber(count)
end


--=============================================IRC CHAT

function calculate_similarity(text_old, text_new)
    local percentage = calculate_percentage(text_old, text_new)
    return 100 * (1 - percentage / math.max(#text_old, #text_new))
end


function calculate_percentage(string1, string2)
    local string1_len = string.len(string1)
    local string2_len = string.len(string2)
    local matrix = {}
    local cost = 0
 
    if (string1_len == 0) then
        return string2_len
    elseif (string2_len == 0) then
        return string1_len
    elseif (string1 == string2) then
        return 0
    end
 
    for i = 0, string1_len, 1 do
        matrix[i] = {}
        matrix[i][0] = i
    end
    for j = 0, string2_len, 1 do
        matrix[0][j] = j
    end
 
    for i = 1, string1_len, 1 do
        for j = 1, string2_len, 1 do
            if (string1:byte(i) == string2:byte(j)) then
                cost = 0
            else
                cost = 1
            end
         
            matrix[i][j] = math.min(matrix[i-1][j] + 1, matrix[i][j-1] + 1, matrix[i-1][j-1] + cost)
        end
    end
    return matrix[string1_len][string2_len]
end

function removeDuplicates(t)
    local seen = {}
    local j = 1

    for i = 1, #t do
        local value = t[i]
        if not seen[value] then
            seen[value] = true
            t[j] = value
            j = j + 1
        end
    end

    for i = j, #t do
        t[i] = nil
    end

    -- for i = 1, #t do
    --     print(t[i])
    -- end
    return t
end

function room_upd_irc()
	-- cmd_connected = true
	while true do
		wait(555)
		
		-- sampAddChatMessage('?',-1)
		if disconnect_button == true then
		else
			s:think() 
		end
	end
end

function onIRCMessage(user, channel, message, rank)  

	-- AFKMessage('message '.. tostring(message).. ' user '..tostring(user.nick)..' new '..tostring(user.access.voice)..' '..tostring(rank.channels))
    
    -- if rank.channels[channel] ~= nil and rank.channels[channel].users[user.nick] ~= nil then
    --     AFKMessage(tostring(rank.channels[channel].users[user.nick].access.voice))
    --     -- for W, resource in pairs(rank.channels['#Freym_tech'].users['Freym'].access.voice) do
    --     --     AFKMessage(W..' ')
    --     -- end
    -- end
    -- AFKMessage(rank.channels)
    -- if rank.channels[channel] ~= nil and rank.channels[channel].users[user.nick] ~= nil then
        -- AFKMessage(tostring(rank.channels[channel].users[user.nick].access.voice))
    -- end
	-- if message:find('VERSION') then
	-- 	AFKMessage('connected')
	-- 	connect_to_host_full = true
	-- end
    -- lcoa
    if user.nick ~= 'StatServ' and rank.channels[channel] ~= nil and rank.channels[channel].users[user.nick] ~= nil then
        local controller, server, korova = user.nick:match("%[(%-?%d+)%]%[(%-?%d+)%](%S+)")
        if controller ~= nil and server ~= nil and korova ~= nil and rank.channels[channel].users[user.nick].access.voice then
            local ip, _ = sampGetCurrentServerAddress()
            -- local testII = (controller == '0' and servers[ip] == tonumber(server) and messages or messages_vc)
            -- AFKMessage('testII '..testII)
            AFKMessage('('..servers[ip]..' == tonumber('..server..')) and (controller == '..controller..')')
            if controller == '0' and servers[ip] == tonumber(server) then
                table.insert(messages, { text = '['..korova..'] �������: '..u8:decode(message), controller = controller, server = server})
            elseif controller == '1' then
                table.insert(messages_vc, { text = '['..korova..'] �������: '..u8:decode(message), controller = controller, server = server})
            end
            -- table.insert((controller == '0' and servers[ip] == tonumber(server) and messages or messages_vc), { text = '['..korova..'] �������: '..u8:decode(message), controller = controller, server = server })
        end
    end
end

function onIRCRaw(line)
    -- AFKMessage(line)
	-- print(line)
    -- if line:find('Unixverse.MindForge.org 311') then
    --     irc_nickname, irc_hostname = line:match("311 (%S+) (%S+) lua (%S+)")
    --     setClipboardText(irc_nickname..'!lua@'..irc_hostname)
    --     AFKMessage('��� ��� ����������. ������ � ���� �������� /access ������������� ���')
    -- end 
    
    if line:find('MindForge.org 353') and not line:find('PRIVMSG') then    
        -- AFKMessage('ff '..line)    
        local channel, nick = line:match("(.*) :(.*)")
        -- AFKMessage(nick..' ??>>?>?><'.. channel)
        for w in string.gmatch(nick, "%S+") do
            -- AFKMessage(w..' ??>>?>?><')
            local w = string.gsub(w, "@", "")
            -- table.insert(users[channel], w)
            -- AFKMessage(w..' ??>>?>?><')
            if w:find('+') then
                -- AFKMessage('find access! '..w:gsub(".*%+", ""))
                s:jaba('jaba', true, w:gsub(".*%+", "")) 
            end
        end
    end
	if line:find("Welcome to MindForge IRC Network") and line:find('We hope you enjoy chatti') then
		s:send(AnsiToUtf8(string.format("nick %s", tostring(irc_name))))
        -- AFKMessage('irc name now222222>> '..tostring(irc_name))
		wait(1000)
		s:join("#Freym_tech")
		-- s:join("#Freym_tech", passsamp)
	end
end

function onIRCModeChange(name_user, user, target, modes, ...)
    -- print(...,-1)
    full_irc_connect = true
    -- AFKMessage('modes '..tostring(modes)..' '..tostring(user.nick)..' name_user '..tostring(name_user)..' >>> '..tostring(irc_name))
    if name_user == irc_name then
        if modes == '+v' or modes == '+vv' or modes == '+rv-o' then
            ready_send_message = true
        elseif modes == '-v' or modes == '-vv' then
            ready_send_message = false
        end
    end
    -- if modes:find("b") then
    --     local banNick = string.match(..., "(%S+)!")
    --     if modes == "-b" then
    --         if messages[target] then table.insert(messages[target], string.format("{A77BCA}[*] {C3C3C3}%s ��� ������������� ���������� %s", banNick, user.nick)) end
    --     else
    --         if messages[target] then table.insert(messages[target], string.format("{A77BCA}[*] {C3C3C3}%s ��� ������������ ���������� %s", banNick, user.nick)) end
    --     end
    -- end 
end

function onIRCJoin(user, channel)
    AFKMessage(tostring(user.nick)..' ???? '..tostring(irc_name)..'!'..tostring(user.username)..'@'..''..tostring(user.host))
    if user.nick == irc_name then
        irc_fullnickname = user.nick..'!'..user.username..'@'..''..user.host
    end
	-- connect_to_host_full = true
	-- AFKMessage('[Tools Chat] '..tostring(user.nick)..' connected to chat.')
end

--=============================================IC



function auto_load_config()
    if load_config_sell ~= '' then
        -- AFKMessage(load_config_sell)
        if doesFileExist('moonloader/ArzMarket/sell-cfg/'..load_config_sell) then
            -- current_cfg.sell = ('moonloader/ArzMarket/sell-cfg/'..load_config_sell)
            sell_list = loadConfig('moonloader/ArzMarket/sell-cfg/'..load_config_sell)
            AFKMessage('������ '..load_config_sell..' ������� ��������.')
        elseif doesFileExist('moonloader/ArzMarket/sell-cfg/'..load_config_sell..'.cfg') then
            pltcfg('moonloader/ArzMarket/sell-cfg/'..load_config_sell..'.cfg', 1)
            AFKMessage('������ '..load_config_sell..' ������� ��������.') -- sell_list = 
        else
            AFKMessage('load standart config (cant find file)')
        end
    else
        AFKMessage('load standart config(sell)')
    end
    if load_config_buy ~= '' then
        if doesFileExist('moonloader/ArzMarket/buy-cfg/'..load_config_buy) then
            -- current_cfg.buy = ('moonloader/ArzMarket/buy-cfg/'..load_config_buy)
            item_list = loadConfig('moonloader/ArzMarket/buy-cfg/'..load_config_buy)
            AFKMessage('������ '..load_config_buy..' ������� ��������.')
        elseif doesFileExist('moonloader/ArzMarket/buy-cfg/'..load_config_buy..'.cfg') then
            pltcfg('moonloader/ArzMarket/buy-cfg/'..load_config_buy..'.cfg', 2)
            AFKMessage('������ '..load_config_buy..' ������� ��������.')
        else
            AFKMessage('load standart config (cant find file) '..'moonloader/ArzMarket/sell-cfg/'..load_config_buy..'.json')
        end
    else
        AFKMessage('load standart config(buy)')
    end
end

function off_sell_buy()
    cancel_sellorbuy[0] = false
    if display.sell then
        if sell_alitems_d ~= nil then
            lets_gooo = false 
        end
    end
    last_stranica = 1
    display = {sell = false, buy = false, score = 1, score_from = 1}
    AFKMessage('����������� ������� ���� ��������.')
end


function vc_converter()
    -- AFKMessage(tostring(Always_convert))
    if Always_convert[0] then
        for k, data in pairs(sell_list) do
            -- AFKMessage(k..' '..tostring(data.name))
            if not vice_city_mode then
                sell_list[k].price_vc = math.floor(sell_list[k].price / ffi.string(buy_vc))
            else
                sell_list[k].price = math.floor(sell_list[k].price_vc * ffi.string(sell_vc))
            end 
        end
        for k, data in pairs(item_list) do
            -- AFKMessage(k..' '..tostring(data.name))
            if not vice_city_mode then
                item_list[k].price_vc = math.floor(item_list[k].price / ffi.string(buy_vc))
            else
                item_list[k].price = math.floor(item_list[k].price_vc * ffi.string(sell_vc))
            end 
        end
        if Always_convert_block[0] then
            Always_convert[0] = false
            ini.cfg.Always_convert = Always_convert[0]
            save_all();
        end
    end
end

function save_all()
    inicfg.save(ini, directIni)
end
AFKMessage = function(text) 
    if dbug_info[0] == true then
	    sampAddChatMessage('[Freym-tech] {ffffff}'..tostring(text),0xFF4141) 
    end
end



function AnsiToUtf8(s)
    local r, b = ''
    for i = 1, s and s:len() or 0 do
      b = s:byte(i)
      if b < 128 then
        r = r..string.char(b)
      else
        if b > 239 then
          r = r..'\209'..string.char(b - 112)
        elseif b > 191 then
          r = r..'\208'..string.char(b - 48)
        elseif ansi_decode[b] then
          r = r..ansi_decode[b]
        else
          r = r..'_'
        end
      end
    end
    return r
end


imgui.Scroller = {
	_ids = {}
}

setmetatable(imgui.Scroller, {__call = function(self, id, step, duration, HoveredFlags)
	if not HoveredFlags then
		HoveredFlags = imgui.HoveredFlags.AllowWhenBlockedByActiveItem
	end
	
    -- AFKMessage(tostring(id))
	if not imgui.Scroller._ids[id] then
		imgui.Scroller._ids[id] = {}
	end
	
	local current_position = imgui.GetScrollY()
	
	if (imgui.IsWindowHovered(HoveredFlags) and HoveredFlags ~= 0 and imgui.IsMouseDown(0)) then
		imgui.Scroller._ids[id].start_clock = nil
	end
	
	if imgui.Scroller._ids[id].start_clock then
        -- AFKMessage(tostring(id))
		if (os.clock() - imgui.Scroller._ids[id].start_clock) * 1000 <= duration then		
			local progress = (os.clock() - imgui.Scroller._ids[id].start_clock) * 1000 / duration			
			local fading_progress = progress * (2 - progress)
			local distance = (imgui.Scroller._ids[id].target_position - imgui.Scroller._ids[id].start_position)
			local new_position = imgui.Scroller._ids[id].start_position + distance * fading_progress
			
			if new_position < 0 then
				new_position = 0
				imgui.Scroller._ids[id].start_clock = nil
				
			elseif new_position > imgui.GetScrollMaxY() then
				new_position = imgui.GetScrollMaxY()
				imgui.Scroller._ids[id].start_clock = nil
			end
			-- AFKMessage(tostring(imgui.GetScrollMaxY()))
			imgui.SetScrollY(math.floor(new_position))
			
		else
			imgui.Scroller._ids[id].start_clock = nil
			imgui.SetScrollY(imgui.Scroller._ids[id].target_position)
		end
	end
	
	---
	
	local wheel_delta = imgui.GetIO().MouseWheel
	
	if wheel_delta ~= 0 and (imgui.IsWindowHovered(HoveredFlags) or HoveredFlags == 0) then
		local offset = -wheel_delta * step		
		
		if not imgui.Scroller._ids[id].start_clock then
			imgui.Scroller._ids[id].start_clock = os.clock()
			imgui.Scroller._ids[id].start_position = current_position
			imgui.Scroller._ids[id].target_position = current_position + offset
			
		else
			imgui.Scroller._ids[id].start_clock = os.clock()
			imgui.Scroller._ids[id].start_position = current_position
			
			if imgui.Scroller._ids[id].start_position < imgui.Scroller._ids[id].target_position and offset > 0 then
				imgui.Scroller._ids[id].target_position = imgui.Scroller._ids[id].target_position + offset
				
			elseif imgui.Scroller._ids[id].start_position > imgui.Scroller._ids[id].target_position and offset < 0 then
				imgui.Scroller._ids[id].target_position = imgui.Scroller._ids[id].target_position + offset
			
			else
				imgui.Scroller._ids[id].target_position = current_position + offset
			end
		end
	end
end})
-- print("������ � �������� � ������� ", get_current_function_name())
-- function get_current_function_name()
--     local info = debug.getinfo(2, "n")
--     if info then return info.name or "unknown" end
--     return "main"
-- end

-- function get_caller_function_name()
--     local info = debug.getinfo(3, "n")
--     if info then return info.name or "unknown" end
--     return "main"
-- end


---@number oX �������� � �������� �� ��� X
---@number oY �������� � �������� �� ��� Y
function shiftCameraByPixelsOffset(oX, oY)
  local w, h = convert3DCoordsToScreen(getActiveCameraPointAt())
  local v = vector3d(getActiveCameraCoordinates()) - vector3d(convertScreenCoordsToWorld3D(w + oX, h + oY, 10))
  local f = math.atan2(v.y, v.x)
  local t = math.atan2(math.sqrt(v.x ^ 2 + v.y ^ 2), v.z) - math.pi / 2
  setCameraPositionUnfixed(t, f)
end


addEventHandler('onWindowMessage', function(msg, key)
    if mobile_jostik[0] then
        if key == 0x25 then
            consumeWindowMessage(true, false) 
        end
        if key == 0x26 then
            consumeWindowMessage(true, false) 
        end
        if key == 0x28 then
            consumeWindowMessage(true, false) 
        end
        if key == 0x27 then
            consumeWindowMessage(true, false) 
        end
    end
end)


function sampev.onSetPlayerName(playerId,name,success)
    local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
    if playerId == myid and full_irc_connect == true and name:match("%[(%-?%d+)%](%S+)") then
        local server, korova = name:match("%[(%-?%d+)%](%S+)")
        if server and korova then
            local ip, _ = sampGetCurrentServerAddress()
            own_server[0] = false
            json_timer[6] = os.time()
            irc_name = '[0]'..'['..server..']'..korova
            AFKMessage('irc name now playerId>> '..tostring(irc_name))
            s:send(AnsiToUtf8(string.format("nick %s", tostring(irc_name))))
        end
    end
end
function onReceivePacket(id, bs)
    
    if mobile_jostik[0] and id == 220 then -- 
        raknetBitStreamIgnoreBits(bs, 8)
        if (raknetBitStreamReadInt8(bs) == 17) then
            raknetBitStreamIgnoreBits(bs, 32)
            local cefstr = raknetBitStreamReadString(bs, raknetBitStreamReadInt32(bs))
            local param, event = cefstr:match(".*%[\"([^\"]+)\"].*"), cefstr:match("executeEvent%('([^']+)'")
            if event == 'cef.modals.showModal' and param == 'carMenu' then
                is_invent_open_mobile = true
            elseif event == 'cef.modals.closeModal' and param == 'carMenu' then
                is_invent_open_mobile = nil
            end 
        end
    end

    if id == 34 and full_irc_connect == true then
        local ip, _ = sampGetCurrentServerAddress()
        if servers[ip] ~= 0 then
            local name = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
            if not name:match('(%d+)') then
                own_server[0] = false
                json_timer[6] = os.time()
                irc_name = '[0]['..servers[ip]..']'..name --..os.time()
                AFKMessage('irc name now onReceivePacket>> '..tostring(irc_name))
                s:send(AnsiToUtf8(string.format("nick %s", tostring(irc_name))))
            end
        end
    end
    if telegram_custom['connect_message'][0] then
        local parsed_list = {
            [32] = {'������ ������ ����������.'},
            [33] = {'����������� ���������.'},
            [34] = {'������������. ������ � ����...'},
            [37] = {'�������� ������ �� �������'}
        }

        if parsed_list[id] then
            sendTelegramNotification(parsed_list[id][1])
        end
    end
    if id == 34 and active_lavka ~= -1 then
        replace_logger[0] = false
        ini.cfg.active_lavka = -1
        save_all();
    end
end

function resetIO()
    for i = 0, 511 do
        imgui.GetIO().KeysDown[i] = false
    end
    for i = 0, 4 do
        imgui.GetIO().MouseDown[i] = false
    end
    imgui.GetIO().KeyCtrl = false
    imgui.GetIO().KeyShift = false
    imgui.GetIO().KeyAlt = false
    imgui.GetIO().KeySuper = false
end

function sendTelegramNotification(msg) 
    local msg = u8(msg)
    if telegram_notf[0] == false then return end
    local text = msg:gsub('{......}', '')
	local text = string.gsub(text, "([^%w-_ %.~=])", function(c)
		return string.format("%%%02X", string.byte(c))
	end)
	local text = string.gsub(text, " ", "+")
    -- local text = u8(tostring(text))
    asyncHttpRequest('POST','https://api.telegram.org/bot' .. ffi.string(telegram_custom["token"]) .. '/sendMessage?chat_id=' .. ffi.string(telegram_custom["chat_id"]) .. '&text='..text)
end


function asyncHttpRequest(method, url, save_info, tbl, args, resolve, reject)
    local request_thread = effil.thread(function (method, url, args)
        local requests = require 'requests'
        local result, response = pcall(requests.request, method, url, args)
        if result then
            response.json, response.xml = nil, nil
            return true, response
        else
            return false, response
        end
    end)(method, url, args)
    if not resolve then resolve = function() end end
    if not reject then reject = function() end end
    lua_thread.create(function()
        local runner = request_thread
        while true do
            local status, err = runner:status()
            if not err then
                if status == 'completed' then
                    local result, response = runner:get(0)
                    if result then
                        if save_info ~= nil and tbl ~= nil and response.text ~= '' then
                            local file = io.open('moonloader/ArzMarket/UsersInfo/info_users_'..save_info..'.json', "w")
                            file:write(response.text)
                            file:close()
                            online_price[tbl] = readJsonFile('moonloader/ArzMarket/UsersInfo/info_users_'..save_info..'.json')
                        end
                        AFKMessage(tostring(response.text))
                        -- print(tostring(response.text))
                        resolve(response)
                    else
                        reject(response)
                    end
                    -- balanced_price = readJsonFile('moonloader/ArzMarket/UsersInfo/info_users_sell_price.json')
                    -- balanced_price_vc = readJsonFile('moonloader/ArzMarket/UsersInfo/info_users_sell_price_vc.json')
                    -- buying_price = readJsonFile('moonloader/ArzMarket/UsersInfo/info_users_buy_price.json')
                    -- buying_price_vc = readJsonFile('moonloader/ArzMarket/UsersInfo/info_users_buy_price_vc.json')
                    return
                elseif status == 'canceled' then
                    return reject(status)
                end
            else
                return reject(err)
            end
            wait(0)
        end
    end)
end


function imgui.FrameTheme()
    imgui.SwitchContext()
    --==[ STYLE ]==--
    imgui.GetStyle().WindowPadding = imgui.ImVec2(0, 0)
    imgui.GetStyle().FramePadding = imgui.ImVec2(5, 5)
    imgui.GetStyle().ItemSpacing = imgui.ImVec2(5, 5)
    imgui.GetStyle().ItemInnerSpacing = imgui.ImVec2(2, 2)
    imgui.GetStyle().TouchExtraPadding = imgui.ImVec2(0, 0)
    imgui.GetStyle().IndentSpacing = 0
    imgui.GetStyle().ScrollbarSize = 10
    imgui.GetStyle().GrabMinSize = 10

    --==[ BORDER ]==--
    imgui.GetStyle().WindowBorderSize = 0
    imgui.GetStyle().ChildBorderSize = 0
    imgui.GetStyle().PopupBorderSize = 1
    imgui.GetStyle().FrameBorderSize = 0
    imgui.GetStyle().TabBorderSize = 0

    --==[ ROUNDING ]==--
    imgui.GetStyle().WindowRounding = 1
    imgui.GetStyle().ChildRounding = 0
    imgui.GetStyle().FrameRounding = 5
    imgui.GetStyle().PopupRounding = 0
    imgui.GetStyle().ScrollbarRounding = 5
    imgui.GetStyle().GrabRounding = 5
    imgui.GetStyle().TabRounding = 5

    --==[ ALIGN ]==--
    imgui.GetStyle().WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().SelectableTextAlign = imgui.ImVec2(0.5, 0.5)
    
    imgui.GetStyle().GrabRounding = 1
    imgui.GetStyle().FrameRounding = 1
    --==[ COLORS ]==--
    imgui.GetStyle().Colors[imgui.Col.Text]                   = imgui.ImVec4(current_theme.text[1], current_theme.text[2], current_theme.text[3], current_theme.text[4])
    imgui.GetStyle().Colors[imgui.Col.TextDisabled]           = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)
    imgui.GetStyle().Colors[imgui.Col.WindowBg]               = imgui.ImVec4(0.03, 0.02, 0.04, 0)
    imgui.GetStyle().Colors[imgui.Col.ChildBg]                = imgui.ImVec4(0.05, 0.06, 0.1, 0)
    imgui.GetStyle().Colors[imgui.Col.PopupBg]                = imgui.ImVec4(0.05, 0.06, 0.1, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Border]                 = imgui.ImVec4(current_theme.Border[1], current_theme.Border[2], current_theme.Border[3], current_theme.Border[4])
    imgui.GetStyle().Colors[imgui.Col.BorderShadow]           = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
    imgui.GetStyle().Colors[imgui.Col.FrameBg]                = imgui.ImVec4(current_theme.input[1], current_theme.input[2], current_theme.input[3], current_theme.input[4])
    imgui.GetStyle().Colors[imgui.Col.FrameBgHovered]         = imgui.ImVec4(current_theme.input[1], current_theme.input[2], current_theme.input[3], 0.1)
    imgui.GetStyle().Colors[imgui.Col.FrameBgActive]          = imgui.ImVec4(current_theme.input[1], current_theme.input[2], current_theme.input[3], 0.05)
    imgui.GetStyle().Colors[imgui.Col.TitleBg]                = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TitleBgActive]          = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed]       = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.MenuBarBg]              = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarBg]            = imgui.ImVec4(current_theme.slider[1], current_theme.slider[2], current_theme.slider[3], 0)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab]          = imgui.ImVec4(current_theme.slider[1], current_theme.slider[2], current_theme.slider[3], current_theme.slider[4])
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered]   = imgui.ImVec4(1, 1, 1, 0.04)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive]    = imgui.ImVec4(1, 1, 1, 0.04)
    imgui.GetStyle().Colors[imgui.Col.CheckMark]              = imgui.ImVec4(0.500, 0.500, 0.500, 0.35)
    imgui.GetStyle().Colors[imgui.Col.SliderGrab]             = imgui.ImVec4(current_theme.Border[1], current_theme.Border[2], current_theme.Border[3], current_theme.Border[4])
    imgui.GetStyle().Colors[imgui.Col.SliderGrabActive]       = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Button]                 = imgui.ImVec4(current_theme.button[1], current_theme.button[2], current_theme.button[3], current_theme.button[4])
    imgui.GetStyle().Colors[imgui.Col.ButtonHovered]          = imgui.ImVec4(0.11, 0.12, 0.24, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ButtonActive]           = imgui.ImVec4(0.12, 0.13, 0.27, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Header]                 = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.HeaderHovered]          = imgui.ImVec4(0.20, 0.20, 0.20, 1.00)
    imgui.GetStyle().Colors[imgui.Col.HeaderActive]           = imgui.ImVec4(0.47, 0.47, 0.47, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Separator]              = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.SeparatorHovered]       = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.SeparatorActive]        = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ResizeGrip]             = imgui.ImVec4(1.00, 1.00, 1.00, 0.25)
    imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered]      = imgui.ImVec4(1.00, 1.00, 1.00, 0.67)
    imgui.GetStyle().Colors[imgui.Col.ResizeGripActive]       = imgui.ImVec4(1.00, 1.00, 1.00, 0.95)
    imgui.GetStyle().Colors[imgui.Col.Tab]                    = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TabHovered]             = imgui.ImVec4(0.28, 0.28, 0.28, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TabActive]              = imgui.ImVec4(0.30, 0.30, 0.30, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TabUnfocused]           = imgui.ImVec4(0.07, 0.10, 0.15, 0.97)
    imgui.GetStyle().Colors[imgui.Col.TabUnfocusedActive]     = imgui.ImVec4(0.14, 0.26, 0.42, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotLines]              = imgui.ImVec4(0.61, 0.61, 0.61, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered]       = imgui.ImVec4(1.00, 0.43, 0.35, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotHistogram]          = imgui.ImVec4(0.90, 0.70, 0.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered]   = imgui.ImVec4(1.00, 0.60, 0.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TextSelectedBg]         = imgui.ImVec4(1.00, 0.00, 0.00, 0.35)
    imgui.GetStyle().Colors[imgui.Col.DragDropTarget]         = imgui.ImVec4(1.00, 1.00, 0.00, 0.90)
    imgui.GetStyle().Colors[imgui.Col.NavHighlight]           = imgui.ImVec4(0.26, 0.59, 0.98, 1.00)
    imgui.GetStyle().Colors[imgui.Col.NavWindowingHighlight]  = imgui.ImVec4(1.00, 1.00, 1.00, 0.70)
    imgui.GetStyle().Colors[imgui.Col.NavWindowingDimBg]      = imgui.ImVec4(0.80, 0.80, 0.80, 0.20)
    imgui.GetStyle().Colors[imgui.Col.ModalWindowDimBg]       = imgui.ImVec4(0.00, 0.00, 0.00, 0.70)
end
function theme()
    imgui.SwitchContext()
    -- local a = imgui.GetStyle()
    -- local b = a.Colors
    -- a.Alpha = 1
    -- a.WindowPadding = imgui.ImVec2(8.00, 8.00)
    -- a.WindowRounding = 1
    -- a.WindowBorderSize = 1
    -- a.WindowMinSize = imgui.ImVec2(32.00, 32.00)
    -- a.WindowTitleAlign = imgui.ImVec2(0.00, 0.50)
    -- a.ChildRounding = 0
    -- a.ChildBorderSize = 1
    -- a.PopupRounding = 25
    -- a.PopupBorderSize = 25
    -- a.FramePadding = imgui.ImVec2(4.00, 3.00)
    -- a.FrameRounding = 1
    -- a.FrameBorderSize = 0
    -- a.ItemSpacing = imgui.ImVec2(8.00, 4.00)
    -- a.ItemInnerSpacing = imgui.ImVec2(4.00, 4.00)
    -- a.IndentSpacing = 21
    -- a.ScrollbarSize = 14
    -- a.ScrollbarRounding = 9
    -- a.GrabMinSize = 10
    -- a.GrabRounding = 1
    -- a.TabRounding = 1
    -- a.ButtonTextAlign = imgui.ImVec2(0.50, 0.50)
    -- a.SelectableTextAlign = imgui.ImVec2(0.00, 0.00)
    -- b[imgui.Col.Text]                   = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
    -- b[imgui.Col.TextDisabled]           = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)
    -- b[imgui.Col.WindowBg]               = imgui.ImVec4(0.06, 0.06, 0.06, 0.7)
    -- b[imgui.Col.ChildBg]                = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
    -- b[imgui.Col.PopupBg]                = imgui.ImVec4(0.08, 0.08, 0.08, 0.94)
    -- b[imgui.Col.Border]                 = imgui.ImVec4(0.43, 0.43, 0.50, 0.50)
    -- b[imgui.Col.BorderShadow]           = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
    -- b[imgui.Col.FrameBg]                = imgui.ImVec4(0.48, 0.48, 0.48, 0.54)
    -- b[imgui.Col.FrameBgHovered]         = imgui.ImVec4(0.98, 0.98, 0.98, 0.40)
    -- b[imgui.Col.FrameBgActive]          = imgui.ImVec4(0.98, 0.98, 0.98, 0.67)
    -- b[imgui.Col.TitleBg]                = imgui.ImVec4(0.04, 0.04, 0.04, 1.00)
    -- b[imgui.Col.TitleBgActive]          = imgui.ImVec4(0.48, 0.48, 0.48, 1.00)
    -- b[imgui.Col.TitleBgCollapsed]       = imgui.ImVec4(0.00, 0.00, 0.00, 0.51)
    -- b[imgui.Col.MenuBarBg]              = imgui.ImVec4(0.14, 0.14, 0.14, 1.00)
    -- b[imgui.Col.ScrollbarBg]            = imgui.ImVec4(0.02, 0.02, 0.02, 0.53)
    -- b[imgui.Col.ScrollbarGrab]          = imgui.ImVec4(0.31, 0.31, 0.31, 1.00)
    -- b[imgui.Col.ScrollbarGrabHovered]   = imgui.ImVec4(0.41, 0.41, 0.41, 1.00)
    -- b[imgui.Col.ScrollbarGrabActive]    = imgui.ImVec4(0.51, 0.51, 0.51, 1.00)
    -- b[imgui.Col.CheckMark]              = imgui.ImVec4(0.98, 0.98, 0.98, 1.00)
    -- b[imgui.Col.SliderGrab]             = imgui.ImVec4(0.88, 0.88, 0.88, 1.00)
    -- b[imgui.Col.SliderGrabActive]       = imgui.ImVec4(0.98, 0.98, 0.98, 1.00)
    -- b[imgui.Col.Button]                 = imgui.ImVec4(0.98, 0.98, 0.98, 0.40)
    -- b[imgui.Col.ButtonHovered]          = imgui.ImVec4(0.59, 0.59, 0.59, 1.00)
    -- b[imgui.Col.ButtonActive]           = imgui.ImVec4(0.39, 0.39, 0.39, 1.00)
    -- b[imgui.Col.Header]                 = imgui.ImVec4(0.98, 0.98, 0.98, 0.31)
    -- b[imgui.Col.HeaderHovered]          = imgui.ImVec4(0.98, 0.98, 0.98, 0.80)
    -- b[imgui.Col.HeaderActive]           = imgui.ImVec4(0.98, 0.98, 0.98, 1.00)
    -- b[imgui.Col.Separator]              = imgui.ImVec4(0.50, 0.50, 0.50, 0.50)
    -- b[imgui.Col.SeparatorHovered]       = imgui.ImVec4(0.75, 0.75, 0.75, 0.78)
    -- b[imgui.Col.SeparatorActive]        = imgui.ImVec4(0.75, 0.75, 0.75, 1.00)
    -- b[imgui.Col.ResizeGrip]             = imgui.ImVec4(0.98, 0.98, 0.98, 0.25)
    -- b[imgui.Col.ResizeGripHovered]      = imgui.ImVec4(0.98, 0.98, 0.98, 0.67)
    -- b[imgui.Col.ResizeGripActive]       = imgui.ImVec4(0.98, 0.98, 0.98, 0.95)
    -- b[imgui.Col.Tab]                    = imgui.ImVec4(0.58, 0.58, 0.58, 0.86)
    -- b[imgui.Col.TabHovered]             = imgui.ImVec4(0.98, 0.98, 0.98, 0.80)
    -- b[imgui.Col.TabActive]              = imgui.ImVec4(0.68, 0.68, 0.68, 1.00)
    -- b[imgui.Col.TabUnfocused]           = imgui.ImVec4(0.15, 0.15, 0.15, 0.97)
    -- b[imgui.Col.TabUnfocusedActive]     = imgui.ImVec4(0.42, 0.42, 0.42, 1.00)
    -- b[imgui.Col.PlotLines]              = imgui.ImVec4(0.61, 0.61, 0.61, 1.00)
    -- b[imgui.Col.PlotLinesHovered]       = imgui.ImVec4(1.00, 0.43, 0.35, 1.00)
    -- b[imgui.Col.PlotHistogram]          = imgui.ImVec4(0.90, 0.70, 0.00, 1.00)
    -- b[imgui.Col.PlotHistogramHovered]   = imgui.ImVec4(1.00, 0.60, 0.00, 1.00)
    -- b[imgui.Col.TextSelectedBg]         = imgui.ImVec4(0.98, 0.98, 0.98, 0.35)
    -- b[imgui.Col.DragDropTarget]         = imgui.ImVec4(1.00, 1.00, 0.00, 0.90)
    -- b[imgui.Col.NavHighlight]           = imgui.ImVec4(0.98, 0.98, 0.98, 1.00)
    -- b[imgui.Col.NavWindowingHighlight]  = imgui.ImVec4(1.00, 1.00, 1.00, 0.70)
    -- b[imgui.Col.NavWindowingDimBg]      = imgui.ImVec4(0.80, 0.80, 0.80, 0.20)
    -- b[imgui.Col.ModalWindowDimBg]       = imgui.ImVec4(0.80, 0.80, 0.80, 0.35)
end

-- function theme()
--     imgui.SwitchContext()
--     --==[ STYLE ]==--
--     imgui.GetStyle().WindowPadding = imgui.ImVec2(5, 5)
--     imgui.GetStyle().FramePadding = imgui.ImVec2(5, 5)
--     imgui.GetStyle().ItemSpacing = imgui.ImVec2(5, 5)
--     imgui.GetStyle().ItemInnerSpacing = imgui.ImVec2(2, 2)
--     imgui.GetStyle().TouchExtraPadding = imgui.ImVec2(0, 0)
--     imgui.GetStyle().IndentSpacing = 0
--     imgui.GetStyle().ScrollbarSize = 11
--     imgui.GetStyle().GrabMinSize = 10

--     --==[ BORDER ]==--
--     imgui.GetStyle().WindowBorderSize = 1
--     imgui.GetStyle().ChildBorderSize = 1
--     imgui.GetStyle().PopupBorderSize = 1
--     imgui.GetStyle().FrameBorderSize = 1
--     imgui.GetStyle().TabBorderSize = 1

--     --==[ ROUNDING ]==--
--     imgui.GetStyle().WindowRounding = 5
--     imgui.GetStyle().ChildRounding = 5
--     imgui.GetStyle().FrameRounding = 5
--     imgui.GetStyle().PopupRounding = 5
--     imgui.GetStyle().ScrollbarRounding = 5
--     imgui.GetStyle().GrabRounding = 5
--     imgui.GetStyle().TabRounding = 5

--     --==[ ALIGN ]==--
--     imgui.GetStyle().WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
--     imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
--     imgui.GetStyle().SelectableTextAlign = imgui.ImVec2(0.5, 0.5)
    
--     --==[ COLORS ]==--
--     imgui.GetStyle().Colors[imgui.Col.Text]                   = imgui.ImVec4(current_theme.text[1], current_theme.text[2], current_theme.text[3], current_theme.text[4])
--     imgui.GetStyle().Colors[imgui.Col.TextDisabled]           = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)
--     imgui.GetStyle().Colors[imgui.Col.WindowBg]               = imgui.ImVec4(0, 0, 0, 0)
--     imgui.GetStyle().Colors[imgui.Col.ChildBg]                = imgui.ImVec4(0, 0, 0, 0)
--     imgui.GetStyle().Colors[imgui.Col.PopupBg]                = imgui.ImVec4(0, 0, 0, 0)
--     imgui.GetStyle().Colors[imgui.Col.Border]                 = imgui.ImVec4(current_theme.Border[1], current_theme.Border[2], current_theme.Border[3], current_theme.Border[4])
--     imgui.GetStyle().Colors[imgui.Col.BorderShadow]           = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
--     imgui.GetStyle().Colors[imgui.Col.FrameBg]                = imgui.ImVec4(current_theme.input[1], current_theme.input[2], current_theme.input[3], current_theme.input[4])
--     imgui.GetStyle().Colors[imgui.Col.FrameBgHovered]         = imgui.ImVec4(0.25, 0.25, 0.26, 0)
--     imgui.GetStyle().Colors[imgui.Col.FrameBgActive]          = imgui.ImVec4(0.25, 0.25, 0.26, 0)
--     imgui.GetStyle().Colors[imgui.Col.TitleBg]                = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
--     imgui.GetStyle().Colors[imgui.Col.TitleBgActive]          = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
--     imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed]       = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
--     imgui.GetStyle().Colors[imgui.Col.MenuBarBg]              = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
--     imgui.GetStyle().Colors[imgui.Col.ScrollbarBg]            = imgui.ImVec4(0.12, 0.12, 0.12, 0.3)
--     imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab]          = imgui.ImVec4(0.00, 0.00, 0.00, 1.00)
--     imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered]   = imgui.ImVec4(0, 0, 0, 0.5)
--     imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive]    = imgui.ImVec4(0, 0, 0, 0.2)
--     imgui.GetStyle().Colors[imgui.Col.CheckMark]              = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
--     imgui.GetStyle().Colors[imgui.Col.SliderGrab]             = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
--     imgui.GetStyle().Colors[imgui.Col.SliderGrabActive]       = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
--     imgui.GetStyle().Colors[imgui.Col.Button]                 = imgui.ImVec4(current_theme.button[1], current_theme.button[2], current_theme.button[3], current_theme.button[4])
--     imgui.GetStyle().Colors[imgui.Col.ButtonHovered]          = imgui.ImVec4(current_theme.button_hovered[1], current_theme.button_hovered[2], current_theme.button_hovered[3], current_theme.button_hovered[4])
--     imgui.GetStyle().Colors[imgui.Col.ButtonActive]           = imgui.ImVec4(current_theme.button_active[1], current_theme.button_active[2], current_theme.button_active[3], current_theme.button_active[4])
--     imgui.GetStyle().Colors[imgui.Col.Header]                 = imgui.ImVec4(0.12, 0.12, 0.12, 0)
--     imgui.GetStyle().Colors[imgui.Col.HeaderHovered]          = imgui.ImVec4(0.20, 0.20, 0.20, 0.1)
--     imgui.GetStyle().Colors[imgui.Col.HeaderActive]           = imgui.ImVec4(0.47, 0.47, 0.47, 0)
--     imgui.GetStyle().Colors[imgui.Col.Separator]              = imgui.ImVec4(0.2, 0.2, 0.2, 1.00)
--     imgui.GetStyle().Colors[imgui.Col.SeparatorHovered]       = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
--     imgui.GetStyle().Colors[imgui.Col.SeparatorActive]        = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
--     imgui.GetStyle().Colors[imgui.Col.ResizeGrip]             = imgui.ImVec4(1.00, 1.00, 1.00, 0.25)
--     imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered]      = imgui.ImVec4(1.00, 1.00, 1.00, 0.67)
--     imgui.GetStyle().Colors[imgui.Col.ResizeGripActive]       = imgui.ImVec4(1.00, 1.00, 1.00, 0.95)
--     imgui.GetStyle().Colors[imgui.Col.Tab]                    = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
--     imgui.GetStyle().Colors[imgui.Col.TabHovered]             = imgui.ImVec4(0.28, 0.28, 0.28, 1.00)
--     imgui.GetStyle().Colors[imgui.Col.TabActive]              = imgui.ImVec4(0.30, 0.30, 0.30, 1.00)
--     imgui.GetStyle().Colors[imgui.Col.TabUnfocused]           = imgui.ImVec4(0.07, 0.10, 0.15, 0.97)
--     imgui.GetStyle().Colors[imgui.Col.TabUnfocusedActive]     = imgui.ImVec4(0.14, 0.26, 0.42, 1.00)
--     imgui.GetStyle().Colors[imgui.Col.PlotLines]              = imgui.ImVec4(0.61, 0.61, 0.61, 1.00)
--     imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered]       = imgui.ImVec4(1.00, 0.43, 0.35, 1.00)
--     imgui.GetStyle().Colors[imgui.Col.PlotHistogram]          = imgui.ImVec4(0.90, 0.70, 0.00, 1.00)
--     imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered]   = imgui.ImVec4(1.00, 0.60, 0.00, 1.00)
--     imgui.GetStyle().Colors[imgui.Col.TextSelectedBg]         = imgui.ImVec4(1.00, 1.00, 1.00, 0.1)
--     imgui.GetStyle().Colors[imgui.Col.DragDropTarget]         = imgui.ImVec4(1.00, 1.00, 0.00, 0.90)
--     imgui.GetStyle().Colors[imgui.Col.NavHighlight]           = imgui.ImVec4(0.26, 0.59, 0.98, 1.00)
--     imgui.GetStyle().Colors[imgui.Col.NavWindowingHighlight]  = imgui.ImVec4(1.00, 1.00, 1.00, 0.70)
--     imgui.GetStyle().Colors[imgui.Col.NavWindowingDimBg]      = imgui.ImVec4(0.80, 0.80, 0.80, 0.20)
--     imgui.GetStyle().Colors[imgui.Col.ModalWindowDimBg]       = imgui.ImVec4(0.00, 0.00, 0.00, 0.70)
-- end