//(function () {
//    "use strict";
    var baseUrl = "http://localhost:64462/";
    // Common Functions
    toastr.options = {
        "closeButton": true,
        "debug": false,
        "positionClass": "toast-bottom-left",
        "onclick": null,
        "showDuration": "5000",
        "hideDuration": "5000",
        "timeOut": "5000",
        "extendedTimeOut": "5000",
        "showEasing": "swing",
        "hideEasing": "linear",
        "showMethod": "fadeIn",
        "hideMethod": "fadeOut"
    }

    function addProgress()
    {
        console.log("dsfsdf");

    }
    ///
    var OEMSApp = angular.module('OEMS', ['angularUtils.directives.dirPagination', 'ngAnimate', 'ui.bootstrap', 'ngResource', 'oitozero.ngSweetAlert', 'blockUI', 'angularjs-dropdown-multiselect', 'datatables', 'angular.filter']);
   
    OEMSApp.directive('onlyDigits', function () {
        return {
            require: 'ngModel',
            restrict: 'A',
            link: function (scope, element, attr, ctrl) {
                function inputValue(val) {
                    if (val) {
                        var digits = val.replace(/[^0-9.]/g, '');

                        if (digits.split('.').length > 2) {
                            digits = digits.substring(0, digits.length - 1);
                        }

                        if (digits !== val) {
                            ctrl.$setViewValue(digits);
                            ctrl.$render();
                        }
                        return parseFloat(digits);
                    }
                    return undefined;
                }            
                ctrl.$parsers.push(inputValue);
            }
        };
    })
//})();