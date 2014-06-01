app = angular
  .module('Hex2048Game', ['cfp.hotkeys', 'HexGrid'])

  .controller 'Hex2048Ctrl', ($scope, Hex2048Game, hotkeys) ->
    $scope.game = new Hex2048Game()
    $scope.game.addRandomTile()

    hotkeys.add 'w', -> $scope.game.addRandomTile() if $scope.game.shift '-y'
    hotkeys.add 's', -> $scope.game.addRandomTile() if $scope.game.shift '+y'
    hotkeys.add 'a', -> $scope.game.addRandomTile() if $scope.game.shift '-z'
    hotkeys.add 'e', -> $scope.game.addRandomTile() if $scope.game.shift '+z'
    hotkeys.add 'q', -> $scope.game.addRandomTile() if $scope.game.shift '+x'
    hotkeys.add 'd', -> $scope.game.addRandomTile() if $scope.game.shift '-x'

  .factory 'Hex2048Game', (HexTile, HexGrid) ->
    class HexGame
      constructor: -> @reset()

      reset: ->
        @grid = new HexGrid([2, 2])

      add: (tile) -> @grid.add tile

      addRandomTile: ->
        freeLocations = (pos for pos in @grid.locations when not @grid.get(pos))
        return if freeLocations.length == 0
        pos = freeLocations[Math.floor(Math.random() * freeLocations.length)]
        @grid.add(new HexTile(pos, 1))

      row: (axis, value) ->
        switch axis
          when 'x' then \
            return (pos for pos in @grid.locations when pos[0] == value)
          when 'y' then \
            return (pos for pos in @grid.locations when pos[1] == value).reverse()
          when 'z' then \
            return (pos for pos in @grid.locations when -(pos[0] + pos[1]) == value)

      combine: (row) ->
        tiles_moved = false
        tile_stack = []
        last_tile_combined = false # if the top tile is a combined tile, ignore it
        for pos in row
          tile = @grid.get(pos)
          continue if not tile?
          last_tile = tile_stack[tile_stack.length - 1] || {} # if no last_tile yet, make sure .val is undefined
          if !last_tile_combined and tile_stack and last_tile.val == tile.val
            tiles_moved = true
            # combine the tiles
            @grid.remove(last_tile)
            @grid.remove(tile)
            tile_stack.pop() # we are combining with the tile on top of the stack
            tile = new HexTile(last_tile.pos, last_tile.val + 1)
            @grid.add(tile)
            last_tile_combined = true
          else
            last_tile_combined = false
          tile_stack.push(tile)

        row.forEach (pos, i) =>
          return if i >= tile_stack.length
          tiles_moved = true if @grid.move(tile_stack[i].pos, pos)
        return tiles_moved

      shift: (direction) ->
        tiles_moved = false
        switch direction
          when '+x' then \
            for x in [-@grid.size[0]..@grid.size[0]]
              tiles_moved = true if @combine @row('x', x)
          when '-x' then \
            for x in [-@grid.size[0]..@grid.size[0]]
              tiles_moved = true if @combine @row('x', x).reverse()
          when '+y' then \
            for y in [-@grid.size[1]..@grid.size[1]]
              tiles_moved = true if @combine @row('y', y)
          when '-y' then \
            for y in [-@grid.size[1]..@grid.size[1]]
              tiles_moved = true if @combine @row('y', y).reverse()
          when '+z' then \
            for z in [-@grid.size[2]..@grid.size[2]]
              tiles_moved = true if @combine @row('z', z)
          when '-z' then \
            for z in [-@grid.size[2]..@grid.size[2]]
              tiles_moved = true if @combine @row('z', z).reverse()

        return tiles_moved
