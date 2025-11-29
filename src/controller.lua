

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