require "ISUI/ISModalDialog"

-- 1. Create a dedicated handler object so the button doesn't throw a nil error
local AntiDebugHandler = {}

-- 2. The function that fires when "Ok" is clicked
function AntiDebugHandler:onExitClick(button)
    -- Project Zomboid's API is notoriously inconsistent with capitalization.
    -- We fire all variations of the quit command to guarantee a hit.
    if getCore().quitToDesktop then getCore():quitToDesktop() end
    if getCore().QuitToDesktop then getCore():QuitToDesktop() end
    if getCore().quit then getCore():quit() end

    -- Ultimate fallback: If the engine somehow ignores the exit commands,
    -- this locks the main thread instantly. The game will freeze and become unplayable.
    while true do end
end

local function ShowAntiDebugBanner()
    if getCore() and getCore():getDebug() then
        local screenW = getCore():getScreenWidth()
        local screenH = getCore():getScreenHeight()
        local width = 500
        local height = 150
        local x = (screenW / 2) - (width / 2)
        local y = (screenH / 2) - (height / 2)
        local message = getText("UI_AntiDebugMessage")

        -- Notice we pass 'AntiDebugHandler' as the target now, preventing the silent error
        local modal = ISModalDialog:new(x, y, width, height, message, false, AntiDebugHandler, AntiDebugHandler.onExitClick)

        modal:initialise()
        modal:addToUIManager()
        modal:setAlwaysOnTop(true)

        -- 3. BULLETPROOFING: Prevent the player from bypassing the banner
        -- This disables closing via the Escape key or controller 'B' button
        modal.close = function(self) end
        -- This disables clicking outside the banner to dismiss it
        modal.onMouseDownOutside = function(self) end
    end
end
require "ISUI/ISPanel"
require "ISUI/ISModalDialog"

local AntiDebugHandler = {}

function AntiDebugHandler:onExitClick(button)
    if getCore().quitToDesktop then getCore():quitToDesktop() end
    if getCore().QuitToDesktop then getCore():QuitToDesktop() end
    if getCore().quit then getCore():quit() end
    while true do end
end

local function ShowAntiDebugBanner()
    if getCore() and getCore():getDebug() then
        local screenW = getCore():getScreenWidth()
        local screenH = getCore():getScreenHeight()

        ---------------------------------------------------------
        -- 1. THE BULLETPROOF SHIELD (Full-Screen Blocker)
        ---------------------------------------------------------
        -- Create a panel that takes up the entire monitor
        -- Create a panel that takes up the entire monitor
                local blocker = ISPanel:new(0, 0, screenW, screenH)
                blocker:initialise()

                -- Darkens the game behind the banner (90% black)
                blocker.backgroundColor = {r=0, g=0, b=0, a=0.9}

                -- NEW LINE: Makes the default panel border completely invisible
                blocker.borderColor = {r=0, g=0, b=0, a=0}

                -- Devour ALL mouse interactions so they never reach the main menu
                blocker.onMouseDown = function() return true end

        -- Darkens the game behind the banner (90% black) so it looks professional
        blocker.backgroundColor = {r=0, g=0, b=0, a=0.9}

        -- Devour ALL mouse interactions so they never reach the main menu
        blocker.onMouseDown = function() return true end
        blocker.onMouseUp = function() return true end
        blocker.onRightMouseDown = function() return true end
        blocker.onRightMouseUp = function() return true end
        blocker.onMouseMove = function() return true end
        blocker.onMouseWheel = function() return true end

        blocker:addToUIManager()
        blocker:setAlwaysOnTop(true) -- Throws the shield over everything

        ---------------------------------------------------------
        -- 2. THE BANNER (Sits on top of the shield)
        ---------------------------------------------------------
        local width = 500
        local height = 150
        local x = (screenW / 2) - (width / 2)
        local y = (screenH / 2) - (height / 2)

        -- Pulls your Russian/English translation setup
        local message = getText("UI_AntiDebugMessage")

        local modal = ISModalDialog:new(x, y, width, height, message, false, AntiDebugHandler, AntiDebugHandler.onExitClick)
        modal:initialise()
        modal:addToUIManager()
        modal:setAlwaysOnTop(true) -- Throws the banner over the shield

        -- Disables closing the banner directly via Escape or clicking outside
        modal.close = function(self) end
        modal.onMouseDownOutside = function(self) end
    end
end

Events.OnMainMenuEnter.Add(ShowAntiDebugBanner)
Events.OnMainMenuEnter.Add(ShowAntiDebugBanner)