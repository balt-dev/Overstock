local function roll_event()
  if (to_big(G.GAME.dollars) - to_big(G.GAME.current_round.reroll_cost)) <= to_big(OVERSTOCK.money_cutoff) then
    G.GAME.overstock_rerolling = false
    G.CONTROLLER.locks.shop_reroll = false
    return true
  end
  local b = {config = {}}
  G.FUNCS.can_reroll(b)
  if not b.config.button then
    G.GAME.overstock_rerolling = false
    G.CONTROLLER.locks.shop_reroll = false
    return true
  end
  G.FUNCS.reroll_shop()
  G.E_MANAGER:add_event(Event { trigger = 'after', delay = 0.1, func = roll_event, blocking = false, blockable = true })
  return true
end

function G.FUNCS.overstock_start_rerolling(e)
  G.GAME.overstock_rerolling = true
  G.FUNCS.exit_overlay_menu()
  OVERSTOCK.target_key = e.config.ref_table["card_key"]
  OVERSTOCK.money_cutoff = e.config.ref_table["cutoff"]
  G.E_MANAGER:add_event(Event { trigger = 'after', delay = 0.1, func = roll_event, blocking = false, blockable = true })
end