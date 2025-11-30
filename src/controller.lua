

function Controller:R_cursor_press(x, y)
    x = x or self.cursor_position.x
    y = y or self.cursor_position.y

    if ((self.locked) and (not G.SETTINGS.paused or G.screenwipe)) or (self.locks.frame) then return end

    self.right_cursor_down.T = {x = x/(G.TILESCALE*G.TILESIZE), y = y/(G.TILESCALE*G.TILESIZE)}
    self.right_cursor_down.time = G.TIMERS.TOTAL
    self.right_cursor_down.handled = false
    self.right_cursor_down.target = nil
    self.is_right_cursor_down = true

    local press_node =  (self.HID.touch and self.cursor_hover.target) or self.hovering.target or self.focused.target

    if press_node then 
        self.right_cursor_down.target = press_node.states.right_click.can and press_node or press_node:can_drag() or nil
    end

    if self.right_cursor_down.target == nil then 
        self.right_cursor_down.target = G.ROOM
    end
end

function Controller:R_cursor_release(x, y)
    x = x or self.cursor_position.x
    y = y or self.cursor_position.y

    if ((self.locked) and (not G.SETTINGS.paused or G.screenwipe)) or (self.locks.frame) then return end

    self.right_cursor_up.T = {x = x/(G.TILESCALE*G.TILESIZE), y = y/(G.TILESCALE*G.TILESIZE)}
    self.right_cursor_up.time = G.TIMERS.TOTAL
    self.right_cursor_up.handled = false
    self.right_cursor_up.target = nil
    self.is_right_cursor_down = false

    self.right_cursor_up.target = self.hovering.target or self.focused.target

    if self.right_cursor_up.target == nil then 
        self.right_cursor_up.target = G.ROOM
    end
end

function Node:right_click() end

function UIElement:right_click()
    if self.config.right_button and (not self.last_clicked or self.last_clicked + 0.1 < G.TIMERS.REAL) and self.states.visible and not self.under_overlay and not self.disable_button then
        self.last_right_clicked = G.TIMERS.REAL

        --Removes a layer from the overlay menu stack
        G.FUNCS[self.config.right_button](self)
        
        play_sound('button', 1, 0.3)
        G.ROOM.jiggle = G.ROOM.jiggle + 0.5
        self.right_button_clicked = true
    end
    if self.config.button_UIE then
        self.config.button_UIE:right_click()
    end
end

function Card:right_click()
    if not (love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift")) then return end
    self:juice_up(0.5, 0.1)
    love.system.setClipboardText(self.config.center_key)
    OVERSTOCK.show_popup("Copied to clipboard: " .. self.config.center_key)
end

local Controller_key_press_update = Controller.key_press_update

function Controller:key_press_update(key, dt)
    if key == "v" and (love.keyboard.isDown "lctrl" or love.keyboard.isDown "rctrl") then
        local string = love.system.getClipboardText()
        for char in string:gmatch "." do
            Controller_key_press_update(self, char, dt)
        end
        return
    end
    Controller_key_press_update(self, key, dt)
end