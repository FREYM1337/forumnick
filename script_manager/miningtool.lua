script_author('JustFedot')
script_name('[JF, F] Mining Tools [Fixed]')
script_version('1.0.6')

require("moonloader")
local sampev = require("samp.events")
local imgui = require("imgui")
local encoding = require('encoding')
encoding.default =('CP1251')
local u8 = encoding.UTF8

if sampev.INTERFACE.INCOMING_RPCS[61][2]['dialogId'] == 'uint16' then
    print('normal sampev, patched.')
    
    sampev.INTERFACE.INCOMING_RPCS[61] = {
        'onShowDialog',
        {dialogId = 'uint16'},
        {style = 'uint8'},
        {title = 'string8'},
        {button1 = 'string8'},
        {button2 = 'string8'},
        {text = 'encodedString4096'},
        {placeholder = 'string8'}
    }
else
    print('old sampev, skip patch onShowDialog')
end
  
do
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
    local ImVec2 = imgui.ImVec2

    -- Цвета
    colors[clr.Text]                 = ImVec4(0.90, 0.90, 0.90, 1.00)
    colors[clr.TextDisabled]         = ImVec4(0.60, 0.60, 0.60, 1.00)
    colors[clr.WindowBg]             = ImVec4(0.12, 0.14, 0.17, 1.00)
    colors[clr.ChildWindowBg]        = ImVec4(0.10, 0.14, 0.17, 1.00)
    colors[clr.PopupBg]              = ImVec4(0.08, 0.08, 0.08, 0.94)
    colors[clr.Border]               = ImVec4(0.43, 0.43, 0.50, 0.50)
    colors[clr.BorderShadow]         = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.FrameBg]              = ImVec4(0.20, 0.25, 0.29, 1.00)
    colors[clr.FrameBgHovered]       = ImVec4(0.18, 0.35, 0.58, 0.40)
    colors[clr.FrameBgActive]        = ImVec4(0.18, 0.35, 0.58, 0.67)
    colors[clr.TitleBg]              = ImVec4(0.09, 0.12, 0.14, 0.65)
    colors[clr.TitleBgActive]        = ImVec4(0.18, 0.35, 0.58, 1.00)
    colors[clr.TitleBgCollapsed]     = ImVec4(0.00, 0.00, 0.00, 0.51)
    colors[clr.MenuBarBg]            = ImVec4(0.15, 0.18, 0.22, 1.00)
    colors[clr.ScrollbarBg]          = ImVec4(0.02, 0.02, 0.02, 0.39)
    colors[clr.ScrollbarGrab]        = ImVec4(0.20, 0.25, 0.29, 1.00)
    colors[clr.ScrollbarGrabHovered] = ImVec4(0.18, 0.22, 0.25, 1.00)
    colors[clr.ScrollbarGrabActive]  = ImVec4(0.09, 0.21, 0.31, 1.00)
    colors[clr.ComboBg]              = ImVec4(0.20, 0.25, 0.29, 1.00)
    colors[clr.CheckMark]            = ImVec4(0.18, 0.35, 0.58, 1.00)
    colors[clr.SliderGrab]           = ImVec4(0.18, 0.35, 0.58, 1.00)
    colors[clr.SliderGrabActive]     = ImVec4(0.22, 0.39, 0.63, 1.00)
    colors[clr.Button]               = ImVec4(0.20, 0.25, 0.29, 1.00)
    colors[clr.ButtonHovered]        = ImVec4(0.18, 0.35, 0.58, 1.00)
    colors[clr.ButtonActive]         = ImVec4(0.22, 0.39, 0.63, 1.00)
    colors[clr.Header]               = ImVec4(0.18, 0.35, 0.58, 0.55)
    colors[clr.HeaderHovered]        = ImVec4(0.22, 0.39, 0.63, 0.80)
    colors[clr.HeaderActive]         = ImVec4(0.22, 0.39, 0.63, 1.00)
    colors[clr.Separator]            = ImVec4(0.43, 0.43, 0.50, 0.50)
    colors[clr.SeparatorHovered]     = ImVec4(0.60, 0.60, 0.70, 1.00)
    colors[clr.SeparatorActive]      = ImVec4(0.70, 0.70, 0.90, 1.00)
    colors[clr.ResizeGrip]           = ImVec4(0.18, 0.35, 0.58, 0.25)
    colors[clr.ResizeGripHovered]    = ImVec4(0.18, 0.35, 0.58, 0.67)
    colors[clr.ResizeGripActive]     = ImVec4(0.18, 0.35, 0.58, 0.95)
    colors[clr.CloseButton]          = ImVec4(0.20, 0.25, 0.29, 0.60)
    colors[clr.CloseButtonHovered]   = ImVec4(0.25, 0.30, 0.35, 0.80)
    colors[clr.CloseButtonActive]    = ImVec4(0.30, 0.35, 0.40, 1.00)       
    colors[clr.PlotLines]            = ImVec4(0.61, 0.61, 0.61, 1.00)
    colors[clr.PlotLinesHovered]     = ImVec4(1.00, 0.43, 0.35, 1.00)
    colors[clr.PlotHistogram]        = ImVec4(0.90, 0.70, 0.00, 1.00)
    colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
    colors[clr.TextSelectedBg]       = ImVec4(0.18, 0.35, 0.58, 0.35)
    --colors[clr.ModalWindowDarkening] = ImVec4(0.80, 0.80, 0.80, 0.35)

    -- Скругления и отступы
    style.WindowPadding = ImVec2(15, 15)
    style.WindowRounding = 3.0
    style.FramePadding = ImVec2(5, 5)
    style.ItemSpacing = ImVec2(12, 8)
    style.ItemInnerSpacing = ImVec2(8, 6)
    style.IndentSpacing = 25.0
    style.ScrollbarSize = 15.0
    style.ScrollbarRounding = 15.0
    style.GrabMinSize = 15.0
    style.GrabRounding = 7.0
    style.ChildWindowRounding = 8.0
    style.FrameRounding = 6.0
end

do
    Jcfg = {
        _version = 0.1,
        _author = "JustFedot",
        _telegram = "@justfedot",
        _help = [[
            Jcfg - модуль для сохранения и загрузки конфигурационных файлов в Lua, используя формат JSON, с поддержкой конфигурации для ImGui.
            Важно: модуль должен быть подключен после всех необходимых `require`.
        
            Использование:
                - Инициализация модуля:
                    jcfg = Jcfg()
        
                - Сохранение массива в файл:
                    jcfg.save(table, path)
                    - table: массив, который нужно сохранить.
                    - path: путь для сохранения. Если не указан, сохранение будет в moonloader/config/Имя_скрипта/config.json
        
                - Загрузка массива из файла:
                    table = jcfg.load(path)
                    - table: переменная, в которую будет загружен массив.
                    - path: путь к файлу для загрузки. Если не указан, будет искать в moonloader/config/Имя_скрипта/config.json
        
                - Обновление массива данными из файла:
                    jcfg.update(table, path)
                    - table: массив, который нужно обновить данными из файла.
                    - path: путь к файлу для загрузки. Если не указан, будет искать в moonloader/config/Имя_скрипта/config.json
        
                - Настройка массива для использования с ImGui:
                    imtable = jcfg.setupImgui(table)
                    - table: массив, который будет преобразован для использования с ImGui.
                    - imtable: возвращает массив, готовый к использованию с ImGui.
        
            Пример использования:
        
                -- Инициализация модуля
                local jcfg = Jcfg()
        
                -- Создание конфигурации
                local cfg = {
                    params = {'123'},
                    param = 12
                }
        
                -- Обновление конфигурации данными из файла (если файл существует)
                jcfg.update(cfg)
        
                -- Настройка конфигурации для использования с ImGui
                local imcfg = jcfg.setupImgui(cfg)
        
                -- Сохранение конфигурации в файл
                jcfg.save(cfg)
        ]]                      
    }

    function Jcfg.__init()
        local self = {}

        local json = require('dkjson')

        local function makeDirectory(path)
            assert(type(path) == "string" and path:find('moonloader'), "Path must be a string and include 'moonloader' folder")
            
            path = path:gsub("[\\/][^\\/]+%.json$", "")

            if not doesDirectoryExist(path) then
                if not createDirectory(path) then
                    return error("Failed to create directory: " .. path)
                end
            end
        end        

        local function setupImguiConfig(table)
            assert(type(table) == "table", ("bad argument #1 to 'setupImgui' (table expected, got %s)"):format(type(table)))
            local function setupImguiConfigRecursive(table)
                local imcfg = {}
                for k, v in pairs(table) do
                    if type(v) == "table" then
                        imcfg[k] = setupImguiConfigRecursive(v)
                    elseif type(v) == "number" then
                        if v % 1 == 0 then
                            imcfg[k] = imgui.ImInt(v)
                        else
                            imcfg[k] = imgui.ImFloat(v)
                        end
                    elseif type(v) == "string" then
                        imcfg[k] = imgui.ImBuffer(256)
                        imcfg[k].v = u8(v)
                    elseif type(v) == "boolean" then
                        imcfg[k] = imgui.ImBool(v)
                    else
                        error(("Unsupported type for imguiConfig: %s"):format(type(v)))
                    end
                end
                return imcfg
            end
            return setupImguiConfigRecursive(table)
        end
        ----------------------------------------------------------------

        function self.save(table, path)
            assert(type(table)=="table", ("bad argument #1 to 'save' (table expected, got %s)"):format(type(table)))
            assert(path == nil or type(path) == "string", "Path must be nil or a valid file path.")
            if path then
                path = path:find('%.json$') and path or path..'.json'
            else
                assert(thisScript().name, "Script name is not defined")
                path = getWorkingDirectory()..'\\config\\'..thisScript().name..'\\config.json'
            end
            makeDirectory(path)
            local file = io.open(path,"w")
            if file then
                file:write(json.encode(table, {indent = true}))
                file:close()
            else
                error("Could not open file for writing: " .. path)
            end
        end

        function self.load(path)
            assert(path == nil or type(path) == "string", "Path must be nil or a valid file path.")
            if path then
                path = path:find('%.json$') and path or path..'.json'
			else
				path = getWorkingDirectory()..'\\config\\'..thisScript().name..'\\config.json'
			end
            if doesFileExist(path) then
                local file = io.open(path, "r")
                if file then
                    local content = file:read("*all")
                    file:close()
                    return json.decode(content)
                else
                    return error("Could not load configuration")
                end
            else
                return {}
            end
        end

        function self.update(table, path)
            assert(type(table)=="table", ("bad argument #1 to 'update' (table expected, got %s)"):format(type(table)))
            assert(path == nil or (type(path) == "string" and path:match("^.+%.json$")), "Path must be nil or a valid file path ending with '.json'")
            local loadedCfg = self.load(path)
			
			if loadedCfg then
				for k, v in pairs(table) do
					if loadedCfg[k] ~= nil then
						table[k] = loadedCfg[k]
					end
				end
			end

            return true
        end

        function self.setupImgui(table)
            assert(imgui ~= nil, "The imgui library is not loaded. Please ensure it is required before using 'setupImgui' function.")
            return setupImguiConfig(table)
        end

        return self
    end

    setmetatable(Jcfg, {
        __call = function(self)
            return self.__init()
        end
    })
end
local jcfg = Jcfg()

local cfg = {
    on = true,
    coolantPercents = 50,
    multiply = 1
}
jcfg.update(cfg)
local imcfg = jcfg.setupImgui(cfg)
function save()
    jcfg.save(cfg)
end

local utils = (function()
    local self = {}

    local function cyrillic(text)
        local convtbl = {[230]=155,[231]=159,[247]=164,[234]=107,[250]=144,[251]=168,[254]=171,[253]=170,[255]=172,[224]=97,[240]=112,[241]=99,[226]=162,[228]=154,[225]=151,[227]=153,[248]=165,[243]=121,[184]=101,[235]=158,[238]=111,[245]=120,[233]=157,[242]=166,[239]=163,[244]=63,[237]=174,[229]=101,[246]=36,[236]=175,[232]=156,[249]=161,[252]=169,[215]=141,[202]=75,[204]=77,[220]=146,[221]=147,[222]=148,[192]=65,[193]=128,[209]=67,[194]=139,[195]=130,[197]=69,[206]=79,[213]=88,[168]=69,[223]=149,[207]=140,[203]=135,[201]=133,[199]=136,[196]=131,[208]=80,[200]=133,[198]=132,[210]=143,[211]=89,[216]=142,[212]=129,[214]=137,[205]=72,[217]=138,[218]=167,[219]=145}
        local result = {}
        for i = 1, #text do
            local c = text:byte(i)
            result[i] = string.char(convtbl[c] or c)
        end
        return table.concat(result)
    end

    local function roundUpToThreeDecimalPlaces(num)
        local mult = 10^3
        return math.ceil(num * mult) / mult
    end

    --------------------------------------------------------------------------------------------------------------------------------

    function self.addChat(a)
        if a then local a_type = type(a) if a_type == 'number' then a = tostring(a) elseif a_type ~= 'string' then return end else return end
        sampAddChatMessage('{ffa500}'..thisScript().name..'{ffffff}: '..a, -1)
    end

    function self.printStringNow(text, time)
        if not text then return end
        time = time or 100
        text = type(text) == "number" and tostring(text) or text
        if type(text) ~= 'string' then return end
        printStringNow(cyrillic(text), time)
    end

    function self.getVideocardEarnings(level)
        -- local earningsTable = {
        --     0.0327855,  -- 1 лвл
        --     0.06557125, -- 2 лвл
        --     0.09835675, -- 3 лвл
        --     0.13114275, -- 4 лвл
        --     0.1639285,  -- 5 лвл
        --     0.19671425, -- 6 лвл
        --     0.22949975, -- 7 лвл
        --     0.2622855,  -- 8 лвл
        --     0.2950715,  -- 9 лвл
        --     0.327857    -- 10 лвл
        -- }
        local earningsTable = {
            0.021858,  -- 1 лвл
            0.043716, -- 2 лвл
            0.065568, -- 3 лвл
            0.087432, -- 4 лвл
            0.109284,  -- 5 лвл
            0.131142, -- 6 лвл
            0.153, -- 7 лвл
            0.174858,  -- 8 лвл
            0.196716,  -- 9 лвл
            0.218568    -- 10 лвл
        }

        local mult = cfg.multiply == 1 and 1 or cfg.multiply == 2 and 1.5 or cfg.multiply == 3 and 2

        if earningsTable[level] then
            return roundUpToThreeDecimalPlaces(earningsTable[level] * mult * 1.22)
            --return earningsTable[level]*1.15
        else
            return {0, 0}
        end
    end

    function self.calculateRemainingHours(percent)
        local consumptionPerHour = 0.48
        local remainingHours = percent / consumptionPerHour
        return remainingHours
    end    

    return self
end)()

local work = {
    on = false,
    mode = 1,
    needSkip = false,
    videocardMode = ""
}

local imgui_windows = {
    main = imgui.ImBool(false),
    dialog = imgui.ImBool(false)
}

local json_timer = {false, os.clock(), 0, 0, 0, ''}

function main()
    repeat wait(0) until isSampAvailable()
    while not isSampLoaded() do wait(0) end

    utils.addChat('{99ff99}Загружен{ffffff}. Команда: {ffa500}/jmnt')

    sampRegisterChatCommand('jmnt', function()
        cfg.on = not cfg.on
        local text = cfg.on and "Скрипт {99ff99}включен{ffffff}." or "Скрипт {ff0000}отключен{ffffff}."
        utils.addChat(text)
        save()
        --imgui_windows.dialog.v = not imgui_windows.dialog.v
    end)
    

    while true do wait(0)
        imgui.Process = imgui_windows.dialog.v
        
        if json_timer[1] then
            if json_timer[2] + 0.125 <= os.clock() then
                json_timer[2] = os.clock()
                json_timer[1] = false
                sampSendDialogResponse(json_timer[3], json_timer[4], json_timer[5], json_timer[6])
            end
        end
    end
end

local __imDialogData = {
    id = 25565,
    title = "Dialog",
    videocards = {},
    selectedVideocard = -1
}

local workLauncher = (function()
    local self = {}

    local checkers = {
        [1] = function(v) -- checkVideocardStatus
            if work.mode == 3 then
                if v[2]:find("{F78181}На паузе") and tonumber(v[2]:match("(%d+%.%d+)%%?%s*$")) > 0 then
                    return true
                else
                    return false
                end
            else
                return v[2]:find("{BEF781}Работает") and true or false
            end
        end,
        
        [2] = function(v) -- checkProfit
            return tonumber(v[2]:match("(%d+)%.%d%d%d%d%d%d")) > 0
        end,

        [3] = function(v) -- checkCoolant
            return tonumber(v[2]:match("(%d+%.%d+)%%?%s*$")) <= cfg.coolantPercents
        end
    }

    function self.handleVideocardAction(mode, checkFunction, successMessage)
        work.on = true
        work.mode = mode
        work.needSkip = false
        for k, v in pairs(__imDialogData.videocards) do
            if checkers[checkFunction](v) then
                sampSendDialogResponsed(__imDialogData.id, 1, v[1])
                return
            end
        end
        work.on = false
        utils.addChat(successMessage)
    end

    return self
end)()

local w,h = getScreenResolution()
local window_width,window_height = 233,140
local imStyle = imgui.GetStyle()
function imgui.OnDrawFrame()
    
    if imgui_windows.dialog.v then

        imgui.SetNextWindowSize(imgui.ImVec2(1000, 600), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2(w/2 - 500, h/2 - 300), imgui.Cond.FirstUseEver)
        imgui.Begin("##dialog_window", imgui_windows.dialog, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoMove)

        local coolantRestore = 0
        local needAttention = false
        local summaryAverage = {asc = 0, btc = 0}
        local avaibleCrypto = {asc = 0, btc = 0}

        if imgui.Link("t.me/justfedotScript", u8"Telegram канал автора") then
            os.execute(('explorer.exe "%s"'):format("https://t.me/justfedotScript"))
        end
        imgui.SameLine()
        imgui.SetCursorPosX(1000/2 - imgui.CalcTextSize(u8(__imDialogData.title)).x/2)
        imgui.TextColoredRGB(thisScript().name .. "[1]: "..__imDialogData.title)

        imgui.SameLine()

        imgui.SetCursorPosX(1000 - 50 - imStyle.ItemSpacing.x)
        imgui.SetCursorPosY(imStyle.ItemSpacing.y)
        if imgui.customCloseButton("X##close_button", imgui.ImVec2(50, 25)) and not work.on then
            __closeWindow(true)
        end

        imgui.Separator()

        imgui.BeginChild('##child_wrapper 1', imgui.ImVec2(500, 0), false)

            imgui.BeginChild('##dialog_child 1', imgui.ImVec2(0, imgui.GetWindowHeight()-50-imStyle.ItemSpacing.y*2), true)

            --imgui.TextColoredRGB(__imDialogData.subTitle)
            --imgui.Separator()

            for k, v in pairs(__imDialogData.videocards) do
                -- Проверка необходимости внимания
                if v[2]:find("На паузе") or tonumber(v[2]:match('(%d+%.%d+)%%')) <= cfg.coolantPercents then
                    needAttention = true
                end
            
                -- Обновление суммарного заработка
                local level = tonumber(v[2]:match("(%d+) уровень"))
                local earnings = utils.getVideocardEarnings(level)
                if v[2]:find("ASC") then
                    summaryAverage.asc = summaryAverage.asc + earnings
                    avaibleCrypto.asc = avaibleCrypto.asc + tonumber(v[2]:match("(%d+)%.%d%d%d%d%d%d"))
                else
                    avaibleCrypto.btc = avaibleCrypto.btc + tonumber(v[2]:match("(%d+)%.%d%d%d%d%d%d"))
                    summaryAverage.btc = summaryAverage.btc + earnings
                end
            
                -- Извлечение текущего процента охлаждающей жидкости
                local cT = tonumber(v[2]:match("(%d+%.%d+)%%"))
                coolantRestore = (coolantRestore ~= 0) and (cT < coolantRestore and cT or coolantRestore) or cT
            
                -- Обработка элементов интерфейса imgui
                if imgui.SelectableEx(v[2], __imDialogData.selectedVideocard == v[1], 0, imgui.ImVec2(0, 15), function()
                    if imgui.IsItemHovered() then
                        if imgui.IsMouseDoubleClicked(0) then
                            sampSendDialogResponsed(__imDialogData.id, 1, v[1])
                            imgui_windows.dialog.v = false
                        end
                        imgui.BeginTooltip()
                            imgui.TextColoredRGB('Доход:\n - В час: '..(v[2]:find('BTC') and "{99ff99}~"..earnings.." BTC" or "{ffa500}~"..earnings.." ASC")..'{ffffff}.\n - В сутки: '..(v[2]:find('BTC') and "{99ff99}~"..(earnings*24).." BTC" or "{ffa500}~"..(earnings*24).." ASC")..'{ffffff}.')
                            imgui.TextColoredRGB('Проработает: {ffa500}~'..(math.floor(utils.calculateRemainingHours(cT)))..' {ffffff}часов.')
                        imgui.EndTooltip()
                    end
                end) then
                    __imDialogData.selectedVideocard = v[1]
                end
            end

            imgui.EndChild()

            imgui.SetCursorPosX(imgui.GetWindowWidth()/2-100-imStyle.ItemSpacing.x)
            if imgui.Button(u8'Выбрать##selectDialogBtn', imgui.ImVec2(100, 50)) and not work.on then
                sampSendDialogResponsed(__imDialogData.id, 1, __imDialogData.selectedVideocard)
                imgui_windows.dialog.v = false
            end
            imgui.SameLine()
            if imgui.Button(u8'Закрыть##CloseDialogBtn', imgui.ImVec2(100, 50)) and not work.on then
                __closeWindow(true)
            end

        imgui.EndChild()

        imgui.SameLine()

        imgui.BeginChild('##child_wrapper 2', imgui.ImVec2(0, 0), false)

            imgui.BeginChild('##dialog_child 2', imgui.ImVec2(0, imgui.GetWindowHeight()/2 - imStyle.ItemSpacing.y), true)

                imgui.TextColoredRGB("Статус фермы: "..(needAttention and "{FFA500}Требует внимания!" or "{99ff99}Всё хорошо."))

                local maxVideocards = (__imDialogData.title:find("дом") == nil) and 4 or 20

                imgui.TextColoredRGB("Видеокарт: {ffa500}"..#__imDialogData.videocards.." из "..maxVideocards..". {abcdef}"..(#__imDialogData.videocards>=maxVideocards and "(Полная)" or "(Не хватает: "..(maxVideocards-#__imDialogData.videocards)..")"))

                imgui.TextColoredRGB("Доходность:\n - В час: {99ff99}~"..summaryAverage.btc.." BTC {ffffff} | {ffa500}~"..summaryAverage.asc.." ASC{ffffff}.\n - В сутки: {99ff99}~"..(summaryAverage.btc*24)..' BTC{ffffff} | {ffa500}~'..(summaryAverage.asc*24)..' ASC{ffffff}.')

                imgui.TextColoredRGB("Можно снять: {99ff99}"..avaibleCrypto.btc.." BTC{ffffff} | {ffa500}"..avaibleCrypto.asc.." ASC")

                local coolantRestore = (math.floor(utils.calculateRemainingHours(coolantRestore)))
                imgui.TextColoredRGB("Дозаправка через: {ffa500}~"..coolantRestore.." {ffffff}ч.{abcdef}(~"..(math.floor(coolantRestore/24)).." суток)")

                imgui.Separator()

                imgui.Text(u8'Множитель доходности:') imgui.SameLine() imgui.TextDisabled("( ? )") if imgui.IsItemHovered() then imgui.SetTooltip(u8("Множитель доходности видеокарт.\nМного кто написал, если фермы стоят в ПХ или ВС, то там может быть x1.5 и x2.")) end
                if imgui.RadioButton("x1##multuplyButton", imcfg.multiply, 1) then
                    cfg.multiply = imcfg.multiply.v
                    save()
                end
                imgui.SameLine()
                if imgui.RadioButton("x1.5##multuplyButton", imcfg.multiply, 2) then
                    cfg.multiply = imcfg.multiply.v
                    save()
                end
                imgui.SameLine()
                if imgui.RadioButton("x2##multuplyButton", imcfg.multiply, 3) then
                    cfg.multiply = imcfg.multiply.v
                    save()
                end

            imgui.EndChild()

            imgui.BeginChild('##dialog_child 3', imgui.ImVec2(0, 0), true)

                if work.on then
                    local name = ""
                    if work.mode == 1 then
                        name = "Забираю прибыль..."
                    elseif work.mode == 2 then
                        name = "Заливаю охл. жидкость..."
                    elseif work.mode == 3 then
                        name = "Включаю видеокарты..."
                    elseif work.mode == 4 then
                        name = "Выключаю видеокарты..."
                    end
                    imgui.MihailKrug(name)
                else

                    if imgui.Button(u8'Включить Видеокарты', imgui.ImVec2(imgui.GetWindowWidth()/2-imStyle.ItemSpacing.x*2, 30)) then
                        workLauncher.handleVideocardAction(3, 1, "Все видеокарты включены, или в видеокартах нет охл. жидкости.")
                    end
                    
                    imgui.SameLine()
                    
                    if imgui.Button(u8'Выключить Видеокарты', imgui.ImVec2(imgui.GetWindowWidth()/2-imStyle.ItemSpacing.x, 30)) then
                        workLauncher.handleVideocardAction(4, 1, "Все видеокарты выключены.")
                    end
                    
                    if imgui.Button(u8'Забрать прибыль', imgui.ImVec2(imgui.GetWindowWidth()-imStyle.ItemSpacing.x*2, 30)) then
                        workLauncher.handleVideocardAction(1, 2, "Нечего забирать.")
                    end
                    
                    if imgui.ButtonClickable("Нельзя заливать жидкости через 'Флэшка Майнера'", (__imDialogData.title:find("дом") == nil), u8'Залить охлаждающие жидкости', imgui.ImVec2(imgui.GetWindowWidth()-imStyle.ItemSpacing.x*2, 30)) then
                        workLauncher.handleVideocardAction(2, 3, "Охлаждение не требуется.")
                    end

                    if imgui.Button(u8'Настройки', imgui.ImVec2(imgui.GetWindowWidth()-imStyle.ItemSpacing.x*2, 30)) then
                        imgui.OpenPopup(u8'Настройки##confirmPopup')
                    end

                    _settingsPopup()

                end

            imgui.EndChild()

        imgui.EndChild()

        imgui.End()

    end

end

function imgui.SelectableEx(label, selected, flags, imVecSize, hoverFunc)
    if imgui.Selectable("##"..label, selected, flags, imVecSize) then
        return true
    end
    hoverFunc()
    imgui.SameLine()
    imgui.SetCursorPosX(imgui.GetStyle().ItemSpacing.x)
    imgui.TextColoredRGB(label)
end
function imgui.TextColoredRGB(text)
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
        return imgui.ImColor(r, g, b, a):GetVec4()
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
function imgui.customCloseButton(label, size)
    local style = imgui.GetStyle()
    local colors = style.Colors

    local buttonColor = imgui.ImVec4(0.8, 0.0, 0.0, 1.0) -- Red
    local buttonHoverColor = imgui.ImVec4(1.0, 0.2, 0.2, 1.0) -- Lighter Red
    local buttonActiveColor = imgui.ImVec4(0.6, 0.0, 0.0, 1.0) -- Darker Red

    local oldButtonColor = colors[imgui.Col.Button]
    local oldButtonHoveredColor = colors[imgui.Col.ButtonHovered]
    local oldButtonActiveColor = colors[imgui.Col.ButtonActive]
    local oldTextColor = colors[imgui.Col.Text]

    imgui.PushStyleColor(imgui.Col.Button, buttonColor)
    imgui.PushStyleColor(imgui.Col.ButtonHovered, buttonHoverColor)
    imgui.PushStyleColor(imgui.Col.ButtonActive, buttonActiveColor)
    imgui.PushStyleColor(imgui.Col.Text, oldTextColor)

    local clicked = imgui.Button(label, size)
    
    imgui.PopStyleColor(4)

    return clicked
end
function imgui.ButtonClickable(hint, clickable, ...)
    if clickable then
        return imgui.Button(...)

    else
        local r, g, b, a = imgui.ImColor(imgui.GetStyle().Colors[imgui.Col.Button]):GetFloat4()
        imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(r, g, b, a/2) )
        imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(r, g, b, a/2))
        imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(r, g, b, a/2))
        imgui.PushStyleColor(imgui.Col.Text, imgui.GetStyle().Colors[imgui.Col.TextDisabled])
            imgui.Button(...)
        imgui.PopStyleColor()
        imgui.PopStyleColor()
        imgui.PopStyleColor()
        imgui.PopStyleColor()
        if hint then
            if imgui.IsItemHovered() then
                imgui.SetTooltip(u8(hint))
            end
        end
    end
end
function imgui.MihailKrug(text, hint)
    local value = 0.3
    local bgColor = imgui.GetColorU32(imgui.ImVec4(0.2, 0.2, 0.2, 1.0))
    local fgColor = imgui.GetColorU32(imgui.ImVec4(1.0, 1.0, 1.0, 1.0))
    local speed = 2.0
    local width = 10.0
    text = u8(text or "Process...")
    hint = hint and u8(hint) or nil

    -- Вычисление размеров текста и радиуса круга
    local textSize = imgui.CalcTextSize(text)
    local radius = math.max(textSize.x, textSize.y) * 0.5 + width + 10

    -- Установка позиции курсора для центрирования круга
    imgui.SetCursorPosX((imgui.GetContentRegionAvail().x - (radius * 2)) / 2)

    local drawList = imgui.GetWindowDrawList()
    local cursorPos = imgui.GetCursorScreenPos()
    local centerX = cursorPos.x + radius
    local centerY = cursorPos.y + radius

    -- Параметры анимации
    local segments = 64
    local angle = (1.0 - value) * math.pi
    local animatedAngle = (math.pi * 0.5 + os.clock() * speed) % (math.pi * 2)
    local endAngle = animatedAngle + angle
    local radiusInner = radius - width

    -- Рисование круга и проверка наведения курсора
    imgui.Dummy(imgui.ImVec2(radius * 2, radius * 2))
    if hint and imgui.IsItemHovered() then
        fgColor = imgui.GetColorU32(imgui.ImVec4(imgui.GetStyle().Colors[imgui.Col.ButtonHovered]))
        imgui.SetTooltip(hint)
    end

    -- Рисование сегментов круга
    if angle > 0 then
        local step = angle / segments
        for i = 0, segments - 1 do
            local currentAngle = animatedAngle + i * step
            local nextAngle = currentAngle + step

            local x1 = centerX + math.cos(currentAngle) * radius
            local y1 = centerY + math.sin(currentAngle) * radius
            local x2 = centerX + math.cos(nextAngle) * radius
            local y2 = centerY + math.sin(nextAngle) * radius
            local x3 = centerX + math.cos(currentAngle) * radiusInner
            local y3 = centerY + math.sin(currentAngle) * radiusInner
            local x4 = centerX + math.cos(nextAngle) * radiusInner
            local y4 = centerY + math.sin(nextAngle) * radiusInner

            drawList:AddQuadFilled(imgui.ImVec2(x1, y1), imgui.ImVec2(x2, y2), imgui.ImVec2(x4, y4), imgui.ImVec2(x3, y3), fgColor)
        end
    end

    -- Рисование текста в центре круга
    local textPos = imgui.ImVec2(centerX - textSize.x * 0.5, centerY - textSize.y * 0.5)
    drawList:AddText(textPos, fgColor, text)

    -- Проверка нажатия на элемент
    if imgui.IsItemHovered() and imgui.IsItemClicked(0) then
        return true
    end
end
function imgui.Link(label, description)

    local size = imgui.CalcTextSize(label)
    local p = imgui.GetCursorScreenPos()
    local p2 = imgui.GetCursorPos()
    local result = imgui.InvisibleButton(label, size)

    imgui.SetCursorPos(p2)

    if imgui.IsItemHovered() then
        if description then
            imgui.BeginTooltip()
            imgui.PushTextWrapPos(600)
            imgui.TextUnformatted(description)
            imgui.PopTextWrapPos()
            imgui.EndTooltip()

        end

        imgui.TextColored(imgui.GetStyle().Colors[imgui.Col.CheckMark], label)
        imgui.GetWindowDrawList():AddLine(imgui.ImVec2(p.x, p.y + size.y), imgui.ImVec2(p.x + size.x, p.y + size.y), imgui.GetColorU32(imgui.GetStyle().Colors[imgui.Col.CheckMark]))

    else
        imgui.TextColored(imgui.GetStyle().Colors[imgui.Col.CheckMark], label)
    end

    return result
end
function _settingsPopup()
    if imgui.BeginPopupModal(u8'Настройки##confirmPopup',nil,imgui.WindowFlags.NoResize) then

        --imgui.SetCursorPosX(imgui.GetWindowWidth()/2 - imgui.CalcTextSize(u8("Укажите процент охлаждающей жидкости для заполнения:")).x/2)
        imgui.Text(u8("Укажите процент охлаждающей жидкости для заполнения:"))
        imgui.PushItemWidth(imgui.GetWindowWidth()-imStyle.ItemSpacing.x*2)
        if imgui.SliderInt('##coolantSlider', imcfg.coolantPercents, 1, 99) then
            cfg.coolantPercents = imcfg.coolantPercents.v
            save()
        end
        imgui.Separator()
        --imgui.Text(u8'Множитель: '..cfg.multiply .. " | "..tostring(cfg.multiply == 1 and 1 or cfg.multiply == 2 and 1.5 or cfg.multiply == 3 and 2))

        -- if imgui.Checkbox(u8'Считать 2х прибыль', imcfg.multiply2x) then
        --     cfg.multiply2x = imcfg.multiply2x.v
        --     save()
        -- end
        -- if imgui.IsItemHovered() then
        --     imgui.SetTooltip(u8("Если ваши фермы находятся на Vice-City или ПХ, то майнинг приносит x2.\nНажмите эту галочку."))
        -- end

        imgui.NewLine()

        imgui.SetCursorPosX(imgui.GetWindowWidth()/2-50)
        if imgui.Button(u8'Закрыть##declinePopup', imgui.ImVec2(100, 50)) then
            imgui.CloseCurrentPopup()
        end
    
        imgui.EndPopup()
    end
end
function __closeWindow(bool)
    sampSendDialogResponsed(__imDialogData.id, 0)
    imgui_windows.dialog.v = false
    if bool and sampIsDialogActive() then sampCloseCurrentDialogWithButton(0) end
end

local needReturnToMainWindow = false
local cryptoAnalysys = {
    btc = 0,
    asc = 0
}

function sampev.onShowDialog(id, style, title, button1, button2, text, placeholder)
    if needReturnToMainWindow then
        local a = title:gsub("%-","")
        if a:find("{BFBBBA}Стойка №%d+ | Полка №%d+") or a:find("{BFBBBA}Выберите тип жидкости") then
            sampSendDialogResponsed(id, 0)
        end
    end

    if title:find("{BFBBBA}Выберите видеокарту") then
        needReturnToMainWindow = false
        if not cfg.on then return end
        __imDialogData.id = id
        __imDialogData.title = title
        __imDialogData.videocards = {}
        __imDialogData.selectedVideocard = -1

        local listboxId = -1

        --Полка №1 | {BEF781}Работает	2.449996 BTC	7 уровень	91.37%
        for line in text:gmatch("[^\r\n]+") do

            if line:find("^Полка") then
                local insertText = (line:find("Работает") and line:gsub("Работает", "Работает{ffffff}") or line:gsub("На паузе", "На паузе{ffffff}")):gsub("Полка №%d+", "Видеокарта №"..(#__imDialogData.videocards+1))
                local properDetect = line:match("(%d+%.%d+)%%?%s*$")
                if properDetect and tonumber(properDetect) <= cfg.coolantPercents then
                    insertText = insertText:gsub("(%d+%.%d+)%%?%s*$", "{ff9999}%1%%")
                elseif properDetect then
                    insertText = insertText:gsub("(%d+%.%d+)%%?%s*$", "{99ff99}%1%%")
                end
                insertText = insertText:gsub("(%d+%.%d+%s+BTC)", "{99ff99}%1{ffffff}"):gsub("(%d+%.%d+%s+ASC)", "{ffa500}%1{ffffff}")
                
                table.insert(__imDialogData.videocards, {
                    listboxId,
                    insertText
                })
                __imDialogData.selectedVideocard = __imDialogData.selectedVideocard==-1 and listboxId or __imDialogData.selectedVideocard
            end

            listboxId = listboxId+1

        end

        imgui_windows.dialog.v = true

        if not work.on then
            return false
        end
    else
        if not work.on then imgui_windows.dialog.v = false end
    end

    if not work.on then return end

    local function deactivateScript(message, needOff)
        if needOff then imgui_windows.dialog.v = false end
        work.on = false
        utils.addChat(message)
    end

    local function findLineAndRespond(pattern, checkFunc, listboxId)
        for line in string.gmatch(text, "[^\r\n]+") do
            if line:find(pattern) and checkFunc(line) then
                sampSendDialogResponsed(id, 1, listboxId, line)
                return true
            end
            listboxId = listboxId + 1
        end
        return false
    end

    if work.mode == 1 then
        if title:find('{BFBBBA}Выберите видеокарту') then
            if not text:find('%d+%.%d%d%d%d%d%d') then
                deactivateScript("Ошибка! Код 1.")
                return
            end
    
            if not findLineAndRespond('%d+%.%d%d%d%d%d%d', function(line)
                return tonumber(line:match("(%d+)%.%d%d%d%d%d%d")) > 0
            end, -1) then
                deactivateScript("Криптовалюта не найдена.")
                if cryptoAnalysys.btc > 0 or cryptoAnalysys.asc > 0 then
                    utils.addChat("Забрали: {99ff99}"..cryptoAnalysys.btc.." BTC {ffffff}| {ffa500}"..cryptoAnalysys.asc..' ASC{ffffff}.')
                    cryptoAnalysys.btc = 0
                    cryptoAnalysys.asc = 0
                end
            end
    
        elseif title:gsub("%-",""):find("{BFBBBA}Стойка №%d+ | Полка №%d+") then
            if not findLineAndRespond('%d+%.%d%d%d%d%d%d', function(line)
                return tonumber(line:match("(%d+)%.%d%d%d%d%d%d")) > 0
            end, 0) then
                sampSendDialogResponsed(id, 0)
            end
        elseif title:find('{BFBBBA}Вывод прибыли видеокарты') then
            sampSendDialogResponsed(id, 1)
        end

    elseif work.mode == 2 then

        if title:find('{BFBBBA}Выберите видеокарту') then
            if title:find('%(дом') then 
                deactivateScript("Режим охлаждения работает только в ручном режиме. Не в /flashminer. Скрипт деактивирован.", true) 
                return 
            end            

            if not text:find("(%d+%.%d+)%%?%s*$") then
                deactivateScript("Охлаждение не нужно. 1")
                return
            end

            if not findLineAndRespond("(%d+%.%d+)%%?%s*$", function(line) return tonumber(line:match("(%d+%.%d+)%%?%s*$")) <= cfg.coolantPercents end, -1) then
                deactivateScript("Охлаждение не нужно. 2")
            end

        elseif title:gsub("%-",""):find("{BFBBBA}Стойка №%d+ | Полка №%d+") then
            if work.needSkip then
                sampSendDialogResponsed(id, 0)
                work.needSkip = false
                return
            end

            if not findLineAndRespond('Залить охлаждающую жидкость', function() return true end, 0) then
                sampSendDialogResponsed(id, 0)
            else
                work.videocardMode = ""
                if text:find("BTC") then
                    work.videocardMode = "btc"
                elseif text:find("ASC") then
                    work.videocardMode = "asc"
                end
            end

        elseif title:find('{BFBBBA}Выберите тип жидкости') then
            local fluidType = "None"
            if work.videocardMode == 'btc' then
                fluidType = "для видеокарты"
            elseif work.videocardMode == 'asc' then
                fluidType = "Охлаждающая жидкость для Arizona Video Card"
            end
            if not findLineAndRespond(fluidType, function(line) -- Охлаждающая жидкость для видеокарты	{CCCCCC}[ 15 ]
                return tonumber(line:match("%[ (%d+) %]")) > 0
            end, -1) then
                deactivateScript("Скрипт деактивирован. Нет охлаждающей жидкости.", false)
                sampSendDialogResponsed(id, 0)
                needReturnToMainWindow = true
            end
            work.needSkip = true
        end

    elseif work.mode == 3 or work.mode == 4 then

        if title:find('{BFBBBA}Выберите видеокарту') then           

            if not findLineAndRespond(work.mode==3 and "{F78181}На паузе" or "{BEF781}Работает", function(line)
                return tonumber(line:match("(%d+%.%d+)%%?%s*$")) > 0
            end, -1) then
                deactivateScript("Работа не требуется, или в видеокартах нет охл. жидкости.")
            end

        elseif title:gsub("%-",""):find("{BFBBBA}Стойка №%d+ | Полка №%d+") then
            if not findLineAndRespond(work.mode==3 and "{BEF781}Запустить видеокарту" or "{F78181}Остановить видеокарту", function() return true end, 0) then
                sampSendDialogResponsed(id, 0)
            end
        end
    end
end

function sampev.onServerMessage(color, text)
    if not work.on then return end
    if text:find("^Вы вывели {ffffff}%d+ [BTCASC]+{ffff00}") then
        if text:find("BTC") then
            cryptoAnalysys.btc = cryptoAnalysys.btc + tonumber(text:match("Вы вывели {ffffff}(%d+)"))
        elseif text:find("ASC") then
            cryptoAnalysys.asc = cryptoAnalysys.asc + tonumber(text:match("Вы вывели {ffffff}(%d+)"))
        end
        return false
    elseif text:find("^Вам был добавлен предмет") and (text:find("BTC") or text:find("ASC")) then
        return false
    elseif text:find("^%[Ошибка%] {ffffff}Чтобы запустить видеокарту в работу") then
        work.on = false
        lua_thread.create(function() wait(0) __closeWindow(true) end)
    end
end

sampSendDialogResponsed = function(dialogId, button, list, text) 
    json_timer = {true, json_timer[2], dialogId, button, list, text}
end

local function findCardIndexById(videocards, id)
    for index, card in ipairs(videocards) do
        if card[1] == id then
            return index
        end
    end
    return nil
end
function onWindowMessage(msg, wparam, lparam)
    if not work.on and imgui_windows.dialog.v and not isPauseMenuActive() then
        if msg == 0x101 or msg == 0x100 then 
            if msg == 0x101 and wparam == 0x1B then
                consumeWindowMessage(true, false)
                __closeWindow(false)
            elseif msg == 0x101 and wparam == 0x0D then
                consumeWindowMessage(true, false)
                sampSendDialogResponsed(__imDialogData.id, 1, __imDialogData.selectedVideocard)
                imgui_windows.dialog.v = false
            end
            if msg == 0x100 and (wparam == 0x26 or wparam == 0x28) then
                consumeWindowMessage(true, false)
                if wparam == 0x26 then
                    local currentIndex = findCardIndexById(__imDialogData.videocards, __imDialogData.selectedVideocard)
                    if currentIndex then
                        currentIndex = currentIndex - 1
                        if currentIndex < 1 then
                            currentIndex = #__imDialogData.videocards
                        end
                        __imDialogData.selectedVideocard = __imDialogData.videocards[currentIndex][1]
                    end
                elseif wparam == 0x28 then
                    local currentIndex = findCardIndexById(__imDialogData.videocards, __imDialogData.selectedVideocard)
                    if currentIndex then
                        currentIndex = currentIndex + 1
                        if currentIndex > #__imDialogData.videocards then
                            currentIndex = 1
                        end
                        __imDialogData.selectedVideocard = __imDialogData.videocards[currentIndex][1]
                    end
                end               
            end
        end
    end
end
