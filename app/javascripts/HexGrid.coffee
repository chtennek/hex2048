app = angular
  .module('HexGrid', [])

  .directive 'hexGrid', ->
    templateUrl: 'javascripts/hex-grid.html'
    scope:
      ngModel: '='
      game: '='
      width: '='
      height: '='

  .directive 'hexTile', ->
    templateUrl: 'javascripts/hex-tile.html'
    scope:
      position: '='
      value: '@'
    link: (scope, elem, attrs) ->
      hexCoordToCartesian = (position) ->
        xhat = [1, 0]
        yhat = [Math.cos(-60 * Math.PI / 180), Math.sin(-60 * Math.PI / 180)]
        [x, y] = position
        return [x*xhat[0] + y*yhat[0], x*xhat[1] + y*yhat[1]]

      # [TODO] figure out how to move this to Hex2048Game
      valTo2048Display = (val) ->
        Math.pow(2, parseInt(val)) || -1

      scope.coord = hexCoordToCartesian(scope.position)
      attrs.$observe 'value', (val) ->
        return if not val?
        scope.value = valTo2048Display(val)

  .factory 'HexTile', ->
    #  x Z
    # Y 0 y map of isolines for each axis, lowercase for positive
    #  z X
    #
    # Tile position is right, then down.
    class Tile
      constructor: (@pos=[0, 0], @val) ->

      neighbors: ->
        [x, y] = @pos
        neighbors = []
        neighbors.push([x +  1, y +  0])
        neighbors.push([x + -1, y +  0])
        neighbors.push([x +  0, y +  1])
        neighbors.push([x +  0, y + -1])
        neighbors.push([x + -1, y +  1])
        neighbors.push([x +  1, y + -1])
        return neighbors

  .factory 'HexGrid', (HexTile) ->
    class Grid
      constructor: (@size=[1, 1, 1]) ->
        @tiles = {}
        @size[1] = @size[0] if @size.length < 2 # make the grid point-symmetric by default
        @size[2] = @size[0] if @size.length < 3 # make the grid vertically symmetric by default

        @locations = []
        for x in [-@size[0]..@size[0]]
          for y in [-@size[1]..@size[1]]
            @locations.push([x, y]) if @valid(x, y)

      valid: (x, y) ->
        z = -(x + y)
        return false if !x? or Math.abs(x) > @size[0]
        return false if !y? or Math.abs(y) > @size[1]
        return false if !z? or Math.abs(z) > @size[2]
        return true

      randomLocation: -> @locations[parseInt(Math.random() * @locations.length)]

      get: ([x, y]) -> @tiles[[x, y]]

      contains: (tile) -> @get(tile.pos)

      add: (tile) ->
        [x, y] = tile.pos
        return if !@valid(x, y)
        return if @tiles[[x, y]]
        @tiles[[x, y]] = tile

      remove: (tile) ->
        if @contains(tile)
          delete @tiles[[tile.pos[0], tile.pos[1]]]

      move: ([x1, y1], [x2, y2]) ->
        tile = @get([x1, y1])
        return if !tile
        return if @get([x2, y2])
        @remove(tile)
        tile.pos = [x2, y2]
        @add(tile)
