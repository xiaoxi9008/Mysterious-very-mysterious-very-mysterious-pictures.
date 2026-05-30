local Players = game:GetService("Players")

local KEY_FILE_NAME = "XIAOXI Hub"
local failedAttempts = 0
local MAX_ATTEMPTS = 3

-- ==================== 加载 Junkie SDK（你的原版验证）====================
local Junkie = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
Junkie.service = "XIAOXI HUB"
Junkie.identifier = "1051580"
Junkie.provider = "XIAOXI HUB"

-- ==================== 加载 Patriot UI ====================
local Patriot = loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Mysterious-very-mysterious-very-mysterious-pictures./refs/heads/main/%E5%8D%A1%E5%AF%86%E5%90%8E%E5%8F%B0.lua"))()

-- ==================== 文件操作 ====================
local function hasFileSystemSupport()
    local hasWritefile = pcall(function() return type(writefile) == "function" end)
    local hasReadfile = pcall(function() return type(readfile) == "function" end)
    return hasWritefile and hasReadfile
end

local fileSystemSupported = hasFileSystemSupport()

local function saveKey(key)
    if not fileSystemSupported then return false end
    pcall(function()
        writefile(KEY_FILE_NAME, key)
    end)
    return true
end

local function loadKey()
    if not fileSystemSupported then return nil end
    local success, key = pcall(function()
        return readfile(KEY_FILE_NAME)
    end)
    if success and key and #key > 1 then
        return key
    end
    return nil
end

local function deleteKey()
    if not fileSystemSupported then return false end
    pcall(function()
        delfile(KEY_FILE_NAME)
    end)
    return true
end

-- ==================== 加载主脚本 ====================
local function loadMainScript()
    pcall(function()
        print("=== XIAOXI Hub 付费验证系统 ===")
        print("✅ 验证成功")
        print("========================")
        
        wait(0.5)
        
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Paid-version./refs/heads/main/XIAOXI%E9%80%89%E6%8B%A9%E7%89%88%E6%9C%AC%E4%BB%98%E8%B4%B9%E7%89%88.lua"))()
        end)
        
        if success then
            print("✅ XIAOXI Hub 加载成功")
        else
            warn("❌ 加载主脚本失败:", err)
            game.StarterGui:SetCore("SendNotification", {
                Title = "提示",
                Text = "脚本加载失败请重试",
                Duration = 5
            })
        end
    end)
end

-- ==================== Patriot 配置 ====================

Patriot.Appearance = {
    Title = "XIAOXI HUB",
    Subtitle = "付费系统 - 卡密输入验证",
    Icon = "rbxassetid://100601171677910",
    IconSize = UDim2.new(0, 30, 0, 30)
}

Patriot.Links = {
    GetKey = "",
    Discord = "点击链接加入群聊【XIAOXI HUB主群】：https://qun.qq.com/universal-share/share?ac=1&authKey=u1cBPzpgoqQTu4PhbVTJVkoj5ng3u%2BmRTXu1Qi57OFzkqyJE3IKkQwDGa7c95Yur&busi_data=eyJncm91cENvZGUiOiI3MDUzNzgzOTYiLCJ0b2tlbiI6IlZxZER0Y0hnaHByZHhHWHM4d09jVWJCQjRnTUpmNlVOM3h4azg5TG1PclZwRmxkMEQ2cU9Ld2ZrcGY1cWxnT2kiLCJ1aW4iOiIzNTc0NzY5NDE1In0%3D&data=kG2R8tCTlBDpzykAKtjNgYrG22pobi7C7ejXMtqDe18bQiR-X9BSqucSNiMXVcPzIfkmzjWREkb27T4beYbfJQ&svctype=4&tempid=h5_group_info"
}

Patriot.Storage = {
    FileName = KEY_FILE_NAME,
    Remember = true,
    AutoLoad = true
}

Patriot.Options = {
    Keyless = false,
    Blur = true,
    Draggable = true
}

Patriot.Theme = {
    Accent = Color3.fromRGB(200, 200, 210),
    AccentHover = Color3.fromRGB(255, 255, 255),
    Background = Color3.fromRGB(0, 0, 0),
    Header = Color3.fromRGB(10, 10, 10),
    Input = Color3.fromRGB(25, 25, 30),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(160, 160, 170),
    Success = Color3.fromRGB(80, 220, 100),
    Error = Color3.fromRGB(255, 50, 50),
    Warning = Color3.fromRGB(255, 200, 0),
    StatusIdle = Color3.fromRGB(200, 200, 210),
    Discord = Color3.fromRGB(200, 200, 210),
    DiscordHover = Color3.fromRGB(255, 255, 255),
    Divider = Color3.fromRGB(30, 30, 30),
    Pending = Color3.fromRGB(40, 40, 40)
}

Patriot.Changelog = {
    {Version = "v2.0.0", Date = "2024年12月15日", Changes = {"更新卡密系统界面", "优化卡密验证UI"}},
}

Patriot.Shop = {
    Enabled = false,
}

-- ==================== 验证回调（使用你的 Junkie SDK）====================

Patriot.Callbacks.OnVerify = function(key)
    if not key or #key <= 1 then
        Patriot:Notify("错误", "请输入有效的卡密", 2, "error")
        return false
    end
    
    -- 用你原本的 Junkie 验证卡密
    local result = Junkie.check_key(key)
    
    if result and result.valid then
        -- 验证成功，保存卡密
        saveKey(key)
        failedAttempts = 0
        return true
    else
        -- 验证失败
        failedAttempts = failedAttempts + 1
        local remaining = MAX_ATTEMPTS - failedAttempts
        
        Patriot:Notify("验证失败", "卡密无效" .. (remaining > 0 and " 还剩" .. remaining .. "次机会" or ""), 2, "error")
        
        if failedAttempts >= MAX_ATTEMPTS then
            return false
        end
        return false
    end
end

Patriot.Callbacks.OnSuccess = function()
    print("✅ 卡密验证成功！")
    Patriot:Notify("成功", "卡密验证通过！正在加载脚本...", 2, "success")
    loadMainScript()
end

Patriot.Callbacks.OnFail = function(errorMsg)
    print("❌ 验证失败:", errorMsg)
    if failedAttempts >= MAX_ATTEMPTS then
        wait(1)
        Players.LocalPlayer:Kick("❌ 尝试次数过多，请重新加入游戏")
    end
end

Patriot.Callbacks.OnClose = function()
    print("⚠️ 用户关闭了验证窗口")
end

-- ==================== 启动 ====================
Patriot:Launch()