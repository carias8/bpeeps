
CHANCE_OF_ITEM_IN_BLOCK = 1 # chances are out of 1
ITEMS = [
  @PowerPlusItem, 
  @PowerMinusItem
]


@ItemFactory = 
  roll_for_item: (position) ->
    if Math.random() < CHANCE_OF_ITEM_IN_BLOCK
      return @random_item(position)
    else
      return null
  random_item: (position) ->
    sum_weights = 0
    for item in ITEMS
      sum_weights += item.weight

    roll = Math.random() * sum_weights


    last_item = false
    for item in ITEMS
      last_item = item
      roll -= item.weight
      break if roll < 0

    return new last_item(position)

