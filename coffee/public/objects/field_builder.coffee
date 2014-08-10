FieldMap =
  basic: [
    [ 2, 1, 2, 1, 2 ]
    [ 1, 0, 1, 1, 1 ]
    [ 2, 1, 0, 0, 2 ]
    [ 1, 0, 1, 0, 1 ]
    [ 2, 1, 2, 1, 2 ]
  ]
  advanced: [
    [ 2, 2, 2, 2, 2, 2, 2, 2, 2 ]
    [ 2, 0, 0, 1, 1, 1, 1, 1, 2 ]
    [ 2, 0, 2, 1, 2, 1, 2, 1, 2 ]
    [ 2, 1, 1, 1, 1, 1, 1, 1, 2 ]
    [ 2, 1, 2, 1, 2, 1, 2, 1, 2 ]
    [ 2, 1, 1, 1, 1, 1, 1, 1, 2 ]
    [ 2, 1, 2, 1, 2, 1, 2, 0, 2 ]
    [ 2, 1, 1, 1, 1, 1, 0, 0, 2 ]
    [ 2, 2, 2, 2, 2, 2, 2, 2, 2 ]
  ]
  open_advanced: [
    [ 2, 0, 2, 1, 2, 1, 2, 1, 2 ]
    [ 0, 0, 0, 1, 1, 1, 1, 1, 1 ]
    [ 2, 0, 2, 1, 2, 1, 2, 1, 2 ]
    [ 1, 1, 1, 1, 1, 1, 1, 1, 1 ]
    [ 2, 1, 2, 1, 2, 1, 2, 1, 2 ]
    [ 1, 1, 1, 1, 1, 1, 1, 1, 1 ]
    [ 2, 1, 2, 1, 2, 1, 2, 0, 2 ]
    [ 1, 1, 1, 1, 1, 1, 0, 0, 0 ]
    [ 2, 1, 2, 1, 2, 1, 2, 0, 2 ]
  ]


TileMap =
  0: Tile
  1: BrickTile
  2: WallTile

@FieldBuilder =
  build_new_field: (type_of_field) ->
    $.map FieldMap[type_of_field], (row, row_index) ->
      [$.map(row, (value, column_index) ->
        new TileMap[value]([
          row_index
          column_index
        ])
      )]


  draw_field: (field, stage) ->
    $.each field, (row_index, row) ->
      $.each row, (column_index, tile) ->
        tile.draw stage
