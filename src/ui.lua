function G.FUNCS.inline_number_select(e)
  local args = e.config.ref_table
  args.ref_table[args.ref_value] = (e.config.ref_value and math.min(args.max, math.max(args.min, args.ref_table[args.ref_value] + e.config.ref_value))) or args.default
end

function create_inline_number_select(args)
  args = args or {}
  args.min = args.min or -math.huge
  args.max = args.max or math.huge
  args.step = args.step or 1
  args.scale = args.scale or 1
  args.default = args.default or args.current                   
  args.prefix = args.prefix or 'x'
  args.colour = args.colour or G.C.RED
  args.w = (args.w or 2.5) * args.scale
  args.h = (args.h or 0.8) * args.scale
  args.text_scale = (args.text_scale or 0.5) * args.scale

  local left_button = {
		n = G.UIT.C,
		config = {
		align = "cm", r = 0.1, minw = 0.6 * args.scale, minh = 0.4 * args.scale,
		hover = true, colour = args.colour, shadow = true,
		focus_args = { type = 'none' },
		ref_table = args, ref_value = -args.step,
		button = "inline_number_select"
		},
		nodes = {{
		n = G.UIT.T,
		config = {
				text = "-", scale = args.text_scale, colour = G.C.UI.TEXT_LIGHT, minh = 0.4 * args.scale
		}
		}}
  }

  local display = {
		n = G.UIT.C,
		config = {
		id = 'numsel_main', align = "cm",
		minw = args.w, minh = args.h,
		r = 0.1, padding = 0.05, colour = args.colour,
		emboss = 0.1, hover = true, can_collide = true,
		on_demand_tooltip = args.on_demand_tooltip
		},
		nodes = {{
		n = G.UIT.R,
		config = { align = "cm", colour = G.C.CLEAR },
		nodes = {{
				n = G.UIT.O,
				config = {
				object = DynaText({
						string = { { ref_table = args.ref_table, ref_value = args.ref_value, prefix = args.prefix } },
						colours = { G.C.UI.TEXT_LIGHT },
						pop_in = 0, pop_in_rate = 8, reset_pop_in = false,
						shadow = true, float = true, silent = true,
						bump = true, scale = args.text_scale,
						non_recalc = true
				}), colour = G.C.CLEAR
				}
		}}
		}}
  }

  local right_button = {
		n = G.UIT.C,
		config = {
		align = "cm", r = 0.1, minw = 0.6 * args.scale, minh = 0.4 * args.scale,
		hover = true, colour = args.colour, shadow = true,
		focus_args = { type = 'none' },
		ref_table = args, ref_value = args.step,
		button = "inline_number_select"
		},
		nodes = {{
		n = G.UIT.T,
		config = {
				text = "+", scale = args.text_scale, colour = G.C.UI.TEXT_LIGHT, minh = 0.4 * args.scale
		}
		}}
  }

  local t = {
		n = G.UIT.R,
		config = { align = "cm", colour = G.C.CLEAR, padding = 0.0 },
		nodes = {
		{
				n = G.UIT.C,
				config = {
				align = "cm", padding = 0.1,
				colour = G.C.CLEAR, id = args.id and (not args.label and args.id or nil) or nil,
				focus_args = args.focus_args
				},
				nodes = { left_button, display, right_button }
		},
		}
  }

  return t
end

function G.UIDEF.overstock_overview()
  local ref_table = { card_key = "", cutoff = G.GAME.interest_cap }
  
  return create_UIBox_generic_options({ back_func = 'exit_overlay_menu', contents = {
    {n=G.UIT.C, config={align = "cm", padding = 0.2, r = 0.2, colour = G.C.BLACK}, nodes={
      {n=G.UIT.R, config={align = "cm"}, nodes={{n=G.UIT.T, config={text = localize("k_overstock_menu"), scale = 1, colour = G.C.UI.TEXT_DARK}}}},
      {n=G.UIT.R, config = {minh=0.5}},
      {n=G.UIT.R, config={align = "cm"}, nodes={{n=G.UIT.T, config={text = "Key of card:", scale = 0.45, colour = G.C.WHITE}}}},
      {n=G.UIT.R, config={align = "cm"}, nodes={create_text_input({
        w = 4, max_length = 64, prompt_text = localize('k_overstock_enter_id'),
        ref_table = ref_table, ref_value = 'card_key', keyboard_offset = 1, extended_corpus = true
      })}},
      {n=G.UIT.R, config = {minh=0.1}},
      {n=G.UIT.R, config={align = "cm"}, nodes={{n=G.UIT.T, config={text = localize("k_overstock_cutoff"), scale = 0.45, colour = G.C.WHITE}}}},
      {n=G.UIT.R, config={align = "cm"}, nodes={create_inline_number_select({
        w = 2, colour = G.C.MONEY, h = 0.5, ref_table = ref_table, ref_value = 'cutoff', prefix=localize'$', default = math.min(G.GAME.interest_cap, 50), step = 1, min = G.GAME.bankrupt_at
      })}},
      {n=G.UIT.R, config = {minh=0.1}},
      {n=G.UIT.R, config = {align = "cm"}, nodes={{n = G.UIT.C, 
        config = {align = "cm", r = 0.1, minw = 1.5, minh = 0.6, hover = true, colour = G.C.GREEN, shadow = true, focus_args = { type = 'none' }, func = "overstock_can_bulk_reroll", button = "overstock_start_rerolling", ref_table = ref_table},
		nodes = {{n=G.UIT.T, config={text = localize('k_reroll'), scale = 0.5, colour = G.C.WHITE, shadow = true}}}
      }}},
    }}
  }})
end

local function can_reroll_into(card_key)
  local center = G.P_CENTERS[card_key]
  if not center then return false end
  if not center.unlocked then return false end
  if G.GAME.banned_keys and G.GAME.banned_keys[card_key] then return false end
  if center.no_appear_in_shop then return false end
  return true
end

function G.FUNCS.overstock_can_bulk_reroll(e)
  local b = {config={}}
  G.FUNCS.can_reroll(b)
  if
    (not b.config.button) or
    (to_big(G.GAME.dollars) - to_big(G.GAME.current_round.reroll_cost)) <= to_big(e.config.ref_table.cutoff) or
    (not can_reroll_into(e.config.ref_table.card_key))
  then 
    e.config.colour = G.C.UI.BACKGROUND_INACTIVE
    e.config.button = nil
  else
    e.config.colour = G.C.GREEN
    e.config.button = 'overstock_start_rerolling'
  end
end

function G.FUNCS.open_overstock_menu(e)
  G.SETTINGS.paused = true
  G.FUNCS.overlay_menu{
    definition = G.UIDEF.overstock_overview(),
  }
  G.OVERLAY_MENU:recalculate()
end