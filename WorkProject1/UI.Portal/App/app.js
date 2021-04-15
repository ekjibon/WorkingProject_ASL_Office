//(function () {
//    "use strict";
var baseUrl = "http://localhost:42950/";
    // Common Functions
    toastr.options = {
        "closeButton": true,
        "debug": false,
        "positionClass": "toast-bottom-right",
        "onclick": null,
        "showDuration": "1000",
        "hideDuration": "1000",
        "timeOut": "5000",
        "extendedTimeOut": "1000",
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
    var OEMSApp = angular.module('OEMS', ['angularUtils.directives.dirPagination', 'ngAnimate', 'ui.bootstrap', 'ngResource', 'oitozero.ngSweetAlert', 'blockUI', 'angular.filter']);
//})();