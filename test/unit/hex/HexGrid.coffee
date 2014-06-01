describe 'Hex Grid module', ->
  HexTile = null
  HexGrid = null

  beforeEach module('HexGrid')
  beforeEach inject (_HexTile_, _HexGrid_) ->
    HexTile = _HexTile_
    HexGrid = _HexGrid_

  describe 'HexTile', ->
    it 'should default to location (0, 0) with an undefined value', ->
      tile = new HexTile()
      expect(tile.pos).to.eql([0, 0])
      expect(tile.val).to.eql(undefined)

    it 'should accept a location and value as parameters', ->
      tile = new HexTile([1, 2], 3)
      expect(tile.pos).to.eql([1, 2])
      expect(tile.val).to.eql(3)

    describe '.neighbors()', ->
      it 'should return a list of coordinates for all neighboring spaces', ->
        tile = new HexTile()
        neighbors = tile.neighbors()
        expect(tile.pos).to.eql([0, 0])
        expect(neighbors).to.not.deep.include.members [[0, 0], [2, 0]]
        expect(neighbors).to.deep.include.members [
          [1, 0]
          [-1, 0]
          [0, 1]
          [0, -1]
          [-1, 1]
          [1, -1]
        ]

  describe 'HexGrid', ->
    grid = null

    beforeEach ->
      grid = new HexGrid()

    it 'should default to a 7-hex grid, centered at (0, 0)', ->
      expect(grid.valid(0, 0)).to.be.true
      expect(grid.valid(3, 3)).to.be.false

    describe '.valid(x, y)', ->
      it 'should analyze boundary coordinates properly', ->
        expect(grid.valid(2, 0)).to.be.false
        expect(grid.valid(1, 1)).to.be.false

      it 'should handle custom grid sizes', ->
        grid = new HexGrid([3, 1])
        expect(grid.valid(3, 0)).to.be.true
        expect(grid.valid(3, 1)).to.be.false
        expect(grid.valid(2, 1)).to.be.true

      it 'should handle asymmetric grid sizes', ->
        # X X X Z Z Z X
        #  X X Z 0 Z X X
        #   X Z Z Z X X X
        grid = new HexGrid([3, 1, 1])
        expect(grid.valid(2, -1)).to.be.true
        expect(grid.valid(2, 0)).to.be.false
        expect(grid.valid(1, 1)).to.be.false

    describe '.add(tile)', ->
      it 'should add a tile to the grid', ->
        tile = new HexTile()
        expect(grid.add(tile)).to.be.ok
        expect(grid.get([0, 0])).to.equal(tile)

      it 'should fail if the tile location is not in the grid', ->
        tile = new HexTile([3, 0])
        expect(grid.valid(tile.pos)).to.be.false

        expect(grid.add(tile)).to.be.not.ok
        expect(grid.get([0, 0])).to.not.equal(tile)

      it 'should fail if the tile location is already taken', ->
        tile = new HexTile()
        tile2 = new HexTile()
        expect(grid.add(tile)).to.be.ok
        expect(grid.add(tile)).to.be.not.ok
        expect(grid.add(tile2)).to.be.not.ok
        expect(grid.get(0, 0)).to.not.equal(tile2)

    describe '.contains(tile)', ->
      it 'should return true if the tile is in the grid', ->
        tile = new HexTile()
        expect(grid.add(tile)).to.be.ok
        expect(grid.contains(tile)).to.be.ok

      it 'should return false if the tile is not in the grid', ->
        tile = new HexTile()
        expect(grid.contains(tile)).to.be.not.ok

    describe '.remove(tile)', ->
      it 'should remove the tile from the grid', ->
        tile = new HexTile()
        expect(grid.add(tile)).to.be.ok
        expect(grid.contains(tile)).to.be.ok
        expect(grid.remove(tile)).to.be.ok
        expect(grid.contains(tile)).to.be.not.ok

    describe '.get(x, y)', ->
      it 'should be undefined if there is no tile at (x, y)', ->
        expect(grid.get([0, 0])).to.equal(undefined)

    describe '.move(x1, y1, x2, y2)', ->
      it 'should move the tile at (x1, y1) to (x2, y2)', ->
        tile = new HexTile()
        expect(grid.add(tile)).to.be.ok
        expect(grid.get([0, 0])).to.equal(tile)
        expect(grid.move([0, 0], [1, 0])).to.be.ok
        expect(grid.get([0, 0])).to.equal(undefined)
        expect(grid.get([1, 0])).to.equal(tile)

      it 'should fail if a tile is already at (x2, y2)', ->
        tile = new HexTile()
        expect(grid.add(new HexTile([0, 0]))).to.be.ok
        expect(grid.add(new HexTile([1, 0]))).to.be.ok
        expect(grid.move([0, 0], [1, 0])).to.not.be.ok

      it 'should fail if no tile is at (x1, y1)', ->
        expect(grid.move([0, 0], [1, 0])).to.not.be.ok

