OEMSApp.service('ComService', function ($scope, $http) {
    this.PhNumPattern = function () {
        $scope.ph_numbr = /^\+?\d{10}$/;
        return $scope.ph_numbr;
    }
    this.EmailPattern = function () {
        $scope.eml_add = /^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/;
        return $scope.eml_add;
    }
});