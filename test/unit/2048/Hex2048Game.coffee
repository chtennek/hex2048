#   X Z z
#  Z X z Z
# y y 0 Y Y
#  Z Z x Z
#   Z Z x
describe '2048 Hex Game module', ->
  HexTile = null
  HexGame = null
  getValues = (pos) ->
    tile = HexGame.grid.get(pos)
    return if tile then tile.val else null

  beforeEach module('Hex2048Game')
  beforeEach inject (_HexTile_, _Hex2048Game_) ->
    HexTile = _HexTile_
    HexGame = new _Hex2048Game_()

  describe 'Hex2048Game', ->
    it 'should be a service that can be reset', ->
      expect(HexGame).to.exist

    describe '.row(axis, value)', ->
      describe 'X axis', ->
        it 'should return values on the given isolines in a consistent order', ->
          row = HexGame.row('x', 0)
          expect(row).to.eql [
            [0, -2]
            [0, -1]
            [0, 0]
            [0, 1]
            [0, 2]
          ]

        it 'should only return positions in the grid', ->
          row = HexGame.row('x', 1)
          expect(row).to.eql [
            [1, -2]
            [1, -1]
            [1, 0]
            [1, 1]
          ]

      describe 'Y axis', ->
        it 'should return values on the given isolines in a consistent order', ->
          row = HexGame.row('y', 0)
          expect(row).to.eql [
            [2, 0]
            [1, 0]
            [0, 0]
            [-1, 0]
            [-2, 0]
          ]

        it 'should only return positions in the grid', ->
          row = HexGame.row('y', 1)
          expect(row).to.eql [
            [1, 1]
            [0, 1]
            [-1, 1]
            [-2, 1]
          ]

      describe 'Z axis', ->
        it 'should return values on the given isolines in a consistent order', ->
          row = HexGame.row('z', 0)
          expect(row).to.eql [
            [-2, 2]
            [-1, 1]
            [0, 0]
            [1, -1]
            [2, -2]
          ]

        it 'should only return positions in the grid', ->
          row = HexGame.row('z', 1)
          expect(row).to.eql [
            [-2, 1]
            [-1, 0]
            [0, -1]
            [1, -2]
          ]

    describe '.combine(locations)', ->
      it 'should combine each tile at most once', ->
        HexGame.add(new HexTile([0, -2], 1))
        HexGame.add(new HexTile([0, -1], 1))
        HexGame.add(new HexTile([0, 0], 1))
        HexGame.add(new HexTile([0, 1], 1))
        row = HexGame.row('x', 0)
        expect(row.map(getValues)).to.eql [1, 1, 1, 1, null]
        HexGame.combine(row)
        expect(row.map(getValues)).to.eql [2, 2, null, null, null]
        HexGame.combine(row)
        expect(row.map(getValues)).to.eql [3, null, null, null, null]

    describe '.shift(direction)', ->
      beforeEach ->
        HexGame.add(new HexTile([0, 0], 1))

      it 'should shift +x correctly', ->
        HexGame.shift '+x'
        expect(HexGame.grid.get([0, -2])).to.be.ok

      it 'should shift -x correctly', ->
        HexGame.shift '-x'
        expect(HexGame.grid.get([0, 2])).to.be.ok

      it 'should shift +y correctly', ->
        HexGame.shift '+y'
        expect(HexGame.grid.get([2, 0])).to.be.ok

      it 'should shift -y correctly', ->
        HexGame.shift '-y'
        expect(HexGame.grid.get([-2, 0])).to.be.ok

      it 'should shift +z correctly', ->
        HexGame.shift '+z'
        expect(HexGame.grid.get([-2, 2])).to.be.ok

      it 'should shift -z correctly', ->
        HexGame.shift '-z'
        expect(HexGame.grid.get([2, -2])).to.be.ok
