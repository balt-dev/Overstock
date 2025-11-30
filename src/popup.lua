
function OVERSTOCK.show_popup(text)
  if OVERSTOCK.popup_box then
    OVERSTOCK.popup_box:remove()
  end
  OVERSTOCK.popup_box = UIBox({
    definition = OVERSTOCK.popup_definition(text),
    config = {
      instance_type = "ALERT",
      align = "cm",
      major = G.ROOM_ATTACH,
      can_collide = false,
      offset = {x = 0, y = 4},
    },
  })
end

local POPUP_BACKGROUND_OPACITY = 0.4
local POPUP_FADE_START = 1
local POPUP_FADE_END = 1.5

function G.FUNCS.overstock_fade_popup(e)
  local elapsed = love.timer.getTime() - e.config.ref_value
  local factor = math.max(0, math.min(1, (elapsed - POPUP_FADE_START) / (POPUP_FADE_END - POPUP_FADE_START)))
  e.config.colour[4] = (1 - factor) * POPUP_BACKGROUND_OPACITY
end

function G.FUNCS.overstock_fade_popup_text(e)
  local elapsed = love.timer.getTime() - e.config.ref_value
  local factor = math.max(0, math.min(1, (elapsed - POPUP_FADE_START) / (POPUP_FADE_END - POPUP_FADE_START)))
  e.config.colour[4] = (1 - factor)
end

function G.FUNCS.overstock_fade_popup_delete(e)
  if love.timer.getTime() - e.config.ref_value > POPUP_FADE_END then
    e:remove()
  end
end

function OVERSTOCK.popup_definition(text)
    return {n = G.UIT.ROOT,
        config = { align = "cm", padding = 0.1, r = 0.1, colour = G.C.CLEAR, id = "overstock_popup", ref_value = love.timer.getTime(), func = "overstock_fade_popup_delete" },
        nodes = {
          {n = G.UIT.C,
            config = { align = "cm", padding = 0.15, r = 0.1, colour = {0, 0, 0, POPUP_BACKGROUND_OPACITY}, func = "overstock_fade_popup", ref_value = love.timer.getTime() },
            nodes = {
              {n = G.UIT.R,
              config = {align = "cm"},
                nodes = {{n = G.UIT.T, config = {text = text, scale = 0.45, colour = {1, 1, 1, 1}, func = "overstock_fade_popup_text", ref_value = love.timer.getTime()}},},
              },
            },
        },
      },
    }
end