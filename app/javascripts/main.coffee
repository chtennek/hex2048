app = angular.module 'Hex2048App', ['HexGrid', 'Hex2048Game']

app.controller 'RootCtrl', ($scope) ->
  $scope.greeting = 'Hello world!'

