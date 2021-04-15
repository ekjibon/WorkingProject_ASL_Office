OEMSApp.directive('multiSelect', function () {
    function link(scope, element) {
        var options = {
            enableClickableOptGroups: true,
            onChange: function () {
                element.change();
            }
        };
        element.multiselect(options);
    }
    return {
        restrict: 'A',
        link: link
    };
}).config(['$provide', function ($provide) {
    $provide.decorator('selectDirective', ['$delegate', function ($delegate) {
        var directive = $delegate[0];
        directive.compile = function () {
            function post(scope, element, attrs, ctrls) {
                directive.link.post.apply(this, arguments);
                var ngModelController = ctrls[1];
                if (ngModelController && attrs.multiple === true) {
                    originalRender = ngModelController.$render;
                    ngModelController.$render = function () {
                        originalRender();
                        element.multiselect('rebuild');
                    };
                }
            }
            return {
                pre: directive.link.pre,
                post: post
            };
        };
        return $delegate;
    }]);
}]).directive("limitToMax", function() {
  return {
    link: function(scope, element, attributes) {
      element.on("keydown keyup", function(e) {
    if (Number(element.val()) > Number(attributes.max) &&
          e.keyCode != 46 // delete
          &&
          e.keyCode != 8 // backspace
        ) {
          e.preventDefault();
          element.val(attributes.max);
        }
      });
    }
  };
}).directive("preventTypingGreater", function() {
  return {
    link: function(scope, element, attributes) {
      var oldVal = null;
      element.on("keydown keyup", function(e) {
    if (Number(element.val()) > Number(attributes.max) &&
          e.keyCode != 46 // delete
          &&
          e.keyCode != 8 // backspace
        ) {
          e.preventDefault();
          element.val(oldVal);
        } else {
          oldVal = Number(element.val());
        }
      });
    }
  };
}).directive('wysiwyg', function ($timeout) {
    return {
        template: '<div>' +
    			'<style>' +
    			'	.wysiwyg-btn-group-margin{  margin-right:5px; }' +
    			'	.wysiwyg-select{ height:30px;margin-bottom:1px;}' +
    			'	.wysiwyg-colorpicker{ font-family: arial, sans-serif !important;font-size:16px !important; padding:2px 10px !important;}' +
    			'</style>' +
        			'<div class="btn-group btn-group-sm wysiwyg-btn-group-margin">' +
    				'<button title="Bold" tabindex="-1" type="button" unselectable="on" class="btn btn-default" ng-click="format(\'bold\')" ng-class="{ active: isBold}"><i class="fa fa-bold"></i></button>' +
    				'<button title="Italic" tabindex="-1" type="button" unselectable="on" class="btn btn-default" ng-click="format(\'italic\')" ng-class="{ active: isItalic}"><i class="fa fa-italic"></i></button>' +
    				'<button title="Underline" tabindex="-1" type="button" unselectable="on" class="btn btn-default" ng-click="format(\'underline\')" ng-class="{ active: isUnderlined}"><i class="fa fa-underline"></i></button>' +
    				'<button title="Strikethrough" tabindex="-1" type="button" unselectable="on" class="btn btn-default" ng-click="format(\'strikethrough\')" ng-class="{ active: isStrikethrough}"><i class="fa fa-strikethrough"></i></button>' +
    				'<button title="Subscript" tabindex="-1" type="button" unselectable="on" class="btn btn-default" ng-click="format(\'subscript\')" ng-class="{ active: isSubscript}"><i class="fa fa-subscript"></i></button>' +
    				'<button title="Superscript" tabindex="-1" type="button" unselectable="on" class="btn btn-default" ng-click="format(\'superscript\')" ng-class="{ active: isSuperscript}"><i class="fa fa-superscript"></i></button>' +
    			'</div>' +
    			'<div class="btn-group btn-group-sm wysiwyg-btn-group-margin">' +
    				'<select tabindex="-1"  unselectable="on" class="form-control wysiwyg-select" ng-model="font" ng-options="f for f in fonts" ng-change="setFont()">' +
    				'</select>' +
    			'</div>' +
    			'<div class="btn-group btn-group-sm wysiwyg-btn-group-margin">' +
    				'<select unselectable="on" tabindex="-1" class="form-control wysiwyg-select" ng-model="fontSize" ng-options="f.size for f in fontSizes" ng-change="setFontSize()">' +
    				'</select>' +
    			'</div>' +
    			'<div class="btn-group btn-group-sm wysiwyg-btn-group-margin">' +
    				'<button title="Font Color" tabindex="-1" colorpicker="rgba" type="button" colorpicker-position="top" class="btn btn-default ng-valid ng-dirty wysiwyg-colorpicker wysiwyg-fontcolor" ng-model="fontColor" ng-change="setFontColor()">A</button>' +
    				'<button title="Hilite Color" tabindex="-1" colorpicker="rgba" type="button" colorpicker-position="top" class="btn btn-default ng-valid ng-dirty wysiwyg-colorpicker wysiwyg-hiliteColor" ng-model="hiliteColor" ng-change="setHiliteColor()">H</button>' +
    				'</div>' +
    				'<div class="btn-group btn-group-sm wysiwyg-btn-group-margin">' +
    				'<button title="Remove Formatting" tabindex="-1" type="button" unselectable="on" class="btn btn-default" ng-click="format(\'removeFormat\')" ><i class="fa fa-eraser"></i></button>' +
    			'</div>' +
    			'<div class="btn-group btn-group-sm wysiwyg-btn-group-margin">' +
    				'<button title="Ordered List" tabindex="-1" type="button" unselectable="on" class="btn btn-default" ng-click="format(\'insertorderedlist\')" ng-class="{ active: isOrderedList}"><i class="fa fa-list-ol"></i></button>' +
    				'<button title="Unordered List" tabindex="-1" type="button" unselectable="on" class="btn btn-default" ng-click="format(\'insertunorderedlist\')" ng-class="{ active: isUnorderedList}"><i class="fa fa-list-ul"></i></button>' +
    				'<button title="Outdent" tabindex="-1" type="button" unselectable="on" class="btn btn-default" ng-click="format(\'outdent\')"><i class="fa fa-outdent"></i></button>' +
    				'<button title="Indent" tabindex="-1" type="button" unselectable="on" class="btn btn-default" ng-click="format(\'indent\')"><i class="fa fa-indent"></i></button>' +
    			'</div>' +
    			'<div class="btn-group btn-group-sm wysiwyg-btn-group-margin">' +
    				'<button title="Left Justify" tabindex="-1" type="button" unselectable="on" class="btn btn-default" ng-click="format(\'justifyleft\')" ng-class="{ active: isLeftJustified}"><i class="fa fa-align-left"></i></button>' +
    				'<button title="Center Justify" tabindex="-1" type="button" unselectable="on" class="btn btn-default" ng-click="format(\'justifycenter\')" ng-class="{ active: isCenterJustified}"><i class="fa fa-align-center"></i></button>' +
    				'<button title="Right Justify" tabindex="-1" type="button" unselectable="on" class="btn btn-default" ng-click="format(\'justifyright\')" ng-class="{ active: isRightJustified}"><i class="fa fa-align-right"></i></button>' +
    			'</div>' +
    			'<div class="btn-group btn-group-sm wysiwyg-btn-group-margin">' +
    				'<button title="Code" tabindex="-1" type="button" unselectable="on" class="btn btn-default" ng-click="format(\'formatblock\', \'pre\')"  ng-class="{ active: isPre}"><i class="fa fa-code"></i></button>' +
    				'<button title="Quote" tabindex="-1" type="button" unselectable="on" class="btn btn-default" ng-click="format(\'formatblock\', \'blockquote\')"  ng-class="{ active: isBlockquote}"><i class="fa fa-quote-right"></i></button>' +
    				'<button title="Paragragh" tabindex="-1" type="button" unselectable="on" class="btn btn-default" ng-click="format(\'insertParagraph\')"  ng-class="{ active: isParagraph}">P</button>' +
    			'</div>' +

    			'<div class="btn-group btn-group-sm wysiwyg-btn-group-margin" >' +
    				'<button ng-show="!isLink" tabindex="-1" title="Link" type="button" unselectable="on" class="btn btn-default" ng-click="createLink()"><i class="fa fa-link" ></i> </button>' +
    				'<button ng-show="isLink" tabindex="-1" title="Unlink" type="button" unselectable="on" class="btn btn-default" ng-click="format(\'unlink\')"><i class="fa fa-unlink"></i> </button>' +
    				'<button title="Image" tabindex="-1" type="button" unselectable="on" class="btn btn-default" ng-click="insertImage()"><i class="fa fa-picture-o"></i> </button>' +

    			'</div>' +

    				'<div id="{{textareaId}}" style="resize:vertical;height:{{textareaHeight || \'80px\'}}; overflow:auto" contentEditable="true" class="{{textareaClass}} wysiwyg-textarea" rows="{{textareaRows}}" name="{{textareaName}}" required="{{textareaRequired}}" placeholder="{{textareaPlaceholder}}" ng-model="value"></div>' +
    			'</div>',
        restrict: 'E',
        scope: {
            value: '=ngModel',
            textareaHeight: '@textareaHeight',
            textareaName: '@textareaName',
            textareaPlaceholder: '@textareaPlaceholder',
            textareaClass: '@textareaClass',
            textareaRequired: '@textareaRequired',
            textareaId: '@textareaId',
        },
        replace: true,
        require: 'ngModel',
        link: function (scope, element, attrs, ngModelController) {

            var textarea = element.find('div.wysiwyg-textarea');

            scope.fonts = [
                  'Georgia',
                  'Palatino Linotype',
                  'Times New Roman',
                  'Arial',
                  'Helvetica',
                  'Arial Black',
                  'Comic Sans MS',
                  'Impact',
                  'Lucida Sans Unicode',
                  'Tahoma',
                  'Trebuchet MS',
                  'Verdana',
                  'Courier New',
                  'Lucida Console',
                  'Helvetica Neue'
            ].sort();

            scope.font = scope.fonts[6];

            scope.fontSizes = [
                {
                    value: '1',
                    size: '10px'
                },
                {
                    value: '2',
                    size: '13px'
                },
                {
                    value: '3',
                    size: '16px'
                },
                {
                    value: '4',
                    size: '18px'
                },
                {
                    value: '5',
                    size: '24px'
                },
                {
                    value: '6',
                    size: '32px'
                },
                {
                    value: '7',
                    size: '48px'
                }
            ];

            scope.fontSize = scope.fontSizes[1];

            if (attrs.enableBootstrapTitle === "true" && attrs.enableBootstrapTitle !== undefined)
                element.find('button[title]').tooltip({ container: 'body' })

            textarea.on('keyup mouseup', function () {
                scope.$apply(function readViewText() {
                    var html = textarea.html();

                    if (html == '<br>') {
                        html = '';
                    }

                    ngModelController.$setViewValue(html);
                });
            });
            scope.isLink = false;


            //Used to detect things like A tags and others that dont work with cmdValue().
            function itemIs(tag) {
                var selection = window.getSelection().getRangeAt(0);
                if (selection) {
                    if (selection.startContainer.parentNode.tagName === tag.toUpperCase() || selection.endContainer.parentNode.tagName === tag.toUpperCase()) {
                        return true;
                    } else { return false; }
                } else { return false; }
            }

            //Used to detect things like A tags and others that dont work with cmdValue().
            function getHiliteColor() {
                var selection = window.getSelection().getRangeAt(0);
                if (selection) {
                    var style = $(selection.startContainer.parentNode).attr('style');

                    if (!angular.isDefined(style))
                        return false;

                    var a = style.split(';');
                    for (var i = 0; i < a.length; i++) {
                        var s = a[i].split(':');
                        if (s[0] === 'background-color')
                            return s[1];
                    }
                    return '#fff';
                } else {
                    return '#fff';
                }
            }


            textarea.on('click keyup focus mouseup', function () {
                $timeout(function () {
                    scope.isBold = scope.cmdState('bold');
                    scope.isUnderlined = scope.cmdState('underline');
                    scope.isStrikethrough = scope.cmdState('strikethrough');
                    scope.isItalic = scope.cmdState('italic');
                    scope.isSuperscript = itemIs('SUP');//scope.cmdState('superscript');
                    scope.isSubscript = itemIs('SUB');//scope.cmdState('subscript');	
                    scope.isRightJustified = scope.cmdState('justifyright');
                    scope.isLeftJustified = scope.cmdState('justifyleft');
                    scope.isCenterJustified = scope.cmdState('justifycenter');
                    scope.isPre = scope.cmdValue('formatblock') == "pre";
                    scope.isBlockquote = scope.cmdValue('formatblock') == "blockquote";

                    scope.isOrderedList = scope.cmdState('insertorderedlist');
                    scope.isUnorderedList = scope.cmdState('insertunorderedlist');

                    scope.fonts.forEach(function (v, k) { //works but kinda crappy.
                        if (scope.cmdValue('fontname').indexOf(v) > -1) {
                            scope.font = v;
                            return false;
                        }
                    });

                    scope.fontSizes.forEach(function (v, k) {
                        if (scope.cmdValue('fontsize') === v.value) {
                            scope.fontSize = v;
                            return false;
                        }
                    })

                    scope.hiliteColor = getHiliteColor();
                    element.find('button.wysiwyg-hiliteColor').css("background-color", scope.hiliteColor);

                    scope.fontColor = scope.cmdValue('forecolor');
                    element.find('button.wysiwyg-fontcolor').css("color", scope.fontColor);

                    scope.isLink = itemIs('A');
                }, 10);
            });

            // model -> view
            ngModelController.$render = function () {
                textarea.html(ngModelController.$viewValue);
            };

            scope.format = function (cmd, arg) {
                document.execCommand(cmd, false, arg);
            }

            scope.cmdState = function (cmd, id) {
                return document.queryCommandState(cmd);
            }

            scope.cmdValue = function (cmd) {
                return document.queryCommandValue(cmd);
            }

            scope.createLink = function () {
                var input = prompt('Enter the link URL');
                if (input && input !== undefined)
                    scope.format('createlink', input);
            }

            scope.insertImage = function () {
                var input = prompt('Enter the image URL');
                if (input && input !== undefined)
                    scope.format('insertimage', input);
            }

            scope.setFont = function () {
                scope.format('fontname', scope.font)
            }

            scope.setFontSize = function () {
                scope.format('fontsize', scope.fontSize.value)
            }

            scope.setFontColor = function () {
                scope.format('forecolor', scope.fontColor)
            }

            scope.setHiliteColor = function () {
                scope.format('hiliteColor', scope.hiliteColor)
            }

            scope.format('enableobjectresizing', true);
            scope.format('styleWithCSS', true);
        }
    };
}).factory('Helper', function () {
    return {
        closestSlider: function (elem) {
            var matchesSelector = elem.matches || elem.webkitMatchesSelector || elem.mozMatchesSelector || elem.msMatchesSelector;
            if (matchesSelector.bind(elem)('I')) {
                return elem.parentNode;
            }
            return elem;
        },
        getOffset: function (elem, fixedPosition) {
            var
                x = 0,
                y = 0,
                scrollX = 0,
                scrollY = 0;
            while (elem && !isNaN(elem.offsetLeft) && !isNaN(elem.offsetTop)) {
                x += elem.offsetLeft;
                y += elem.offsetTop;
                if (!fixedPosition && elem.tagName === 'BODY') {
                    scrollX += document.documentElement.scrollLeft || elem.scrollLeft;
                    scrollY += document.documentElement.scrollTop || elem.scrollTop;
                } else {
                    scrollX += elem.scrollLeft;
                    scrollY += elem.scrollTop;
                }
                elem = elem.offsetParent;
            }
            return {
                top: y,
                left: x,
                scrollX: scrollX,
                scrollY: scrollY
            };
        },
        // a set of RE's that can match strings and generate color tuples. https://github.com/jquery/jquery-color/
        stringParsers: [
          {
              re: /rgba?\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*(?:,\s*(\d+(?:\.\d+)?)\s*)?\)/,
              parse: function (execResult) {
                  return [
                    execResult[1],
                    execResult[2],
                    execResult[3],
                    execResult[4]
                  ];
              }
          },
          {
              re: /rgba?\(\s*(\d+(?:\.\d+)?)\%\s*,\s*(\d+(?:\.\d+)?)\%\s*,\s*(\d+(?:\.\d+)?)\%\s*(?:,\s*(\d+(?:\.\d+)?)\s*)?\)/,
              parse: function (execResult) {
                  return [
                    2.55 * execResult[1],
                    2.55 * execResult[2],
                    2.55 * execResult[3],
                    execResult[4]
                  ];
              }
          },
          {
              re: /#([a-fA-F0-9]{2})([a-fA-F0-9]{2})([a-fA-F0-9]{2})/,
              parse: function (execResult) {
                  return [
                    parseInt(execResult[1], 16),
                    parseInt(execResult[2], 16),
                    parseInt(execResult[3], 16)
                  ];
              }
          },
          {
              re: /#([a-fA-F0-9])([a-fA-F0-9])([a-fA-F0-9])/,
              parse: function (execResult) {
                  return [
                    parseInt(execResult[1] + execResult[1], 16),
                    parseInt(execResult[2] + execResult[2], 16),
                    parseInt(execResult[3] + execResult[3], 16)
                  ];
              }
          }
        ]
    };
})
    .factory('Color', ['Helper', function (Helper) {
        return {
            value: {
                h: 1,
                s: 1,
                b: 1,
                a: 1
            },
            // translate a format from Color object to a string
            'rgb': function () {
                var rgb = this.toRGB();
                return 'rgb(' + rgb.r + ',' + rgb.g + ',' + rgb.b + ')';
            },
            'rgba': function () {
                var rgb = this.toRGB();
                return 'rgba(' + rgb.r + ',' + rgb.g + ',' + rgb.b + ',' + rgb.a + ')';
            },
            'hex': function () {
                return this.toHex();
            },

            // HSBtoRGB from RaphaelJS
            RGBtoHSB: function (r, g, b, a) {
                r /= 255;
                g /= 255;
                b /= 255;

                var H, S, V, C;
                V = Math.max(r, g, b);
                C = V - Math.min(r, g, b);
                H = (C === 0 ? null :
                    V == r ? (g - b) / C :
                        V == g ? (b - r) / C + 2 :
                            (r - g) / C + 4
                    );
                H = ((H + 360) % 6) * 60 / 360;
                S = C === 0 ? 0 : C / V;
                return { h: H || 1, s: S, b: V, a: a || 1 };
            },

            //parse a string to HSB
            setColor: function (val) {
                val = val.toLowerCase();
                for (var key in Helper.stringParsers) {
                    if (Helper.stringParsers.hasOwnProperty(key)) {
                        var parser = Helper.stringParsers[key];
                        var match = parser.re.exec(val),
                            values = match && parser.parse(match),
                            space = parser.space || 'rgba';
                        if (values) {
                            this.value = this.RGBtoHSB.apply(null, values);
                            return false;
                        }
                    }
                }
            },

            setHue: function (h) {
                this.value.h = 1 - h;
            },

            setSaturation: function (s) {
                this.value.s = s;
            },

            setLightness: function (b) {
                this.value.b = 1 - b;
            },

            setAlpha: function (a) {
                this.value.a = parseInt((1 - a) * 100, 10) / 100;
            },

            // HSBtoRGB from RaphaelJS
            // https://github.com/DmitryBaranovskiy/raphael/
            toRGB: function (h, s, b, a) {
                if (!h) {
                    h = this.value.h;
                    s = this.value.s;
                    b = this.value.b;
                }
                h *= 360;
                var R, G, B, X, C;
                h = (h % 360) / 60;
                C = b * s;
                X = C * (1 - Math.abs(h % 2 - 1));
                R = G = B = b - C;

                h = ~~h;
                R += [C, X, 0, 0, X, C][h];
                G += [X, C, C, X, 0, 0][h];
                B += [0, 0, X, C, C, X][h];
                return {
                    r: Math.round(R * 255),
                    g: Math.round(G * 255),
                    b: Math.round(B * 255),
                    a: a || this.value.a
                };
            },

            toHex: function (h, s, b, a) {
                var rgb = this.toRGB(h, s, b, a);
                return '#' + ((1 << 24) | (parseInt(rgb.r, 10) << 16) | (parseInt(rgb.g, 10) << 8) | parseInt(rgb.b, 10)).toString(16).substr(1);
            }
        };
    }])
    .factory('Slider', ['Helper', function (Helper) {
        var
            slider = {
                maxLeft: 0,
                maxTop: 0,
                callLeft: null,
                callTop: null,
                knob: {
                    top: 0,
                    left: 0
                }
            },
            pointer = {};

        return {
            getSlider: function () {
                return slider;
            },
            getLeftPosition: function (event) {
                return Math.max(0, Math.min(slider.maxLeft, slider.left + ((event.pageX || pointer.left) - pointer.left)));
            },
            getTopPosition: function (event) {
                return Math.max(0, Math.min(slider.maxTop, slider.top + ((event.pageY || pointer.top) - pointer.top)));
            },
            setSlider: function (event, fixedPosition) {
                var
                  target = Helper.closestSlider(event.target),
                  targetOffset = Helper.getOffset(target, fixedPosition);
                slider.knob = target.children[0].style;
                slider.left = event.pageX - targetOffset.left - window.pageXOffset + targetOffset.scrollX;
                slider.top = event.pageY - targetOffset.top - window.pageYOffset + targetOffset.scrollY;

                pointer = {
                    left: event.pageX,
                    top: event.pageY
                };
            },
            setSaturation: function (event, fixedPosition) {
                slider = {
                    maxLeft: 100,
                    maxTop: 100,
                    callLeft: 'setSaturation',
                    callTop: 'setLightness'
                };
                this.setSlider(event, fixedPosition)
            },
            setHue: function (event, fixedPosition) {
                slider = {
                    maxLeft: 0,
                    maxTop: 100,
                    callLeft: false,
                    callTop: 'setHue'
                };
                this.setSlider(event, fixedPosition)
            },
            setAlpha: function (event, fixedPosition) {
                slider = {
                    maxLeft: 0,
                    maxTop: 100,
                    callLeft: false,
                    callTop: 'setAlpha'
                };
                this.setSlider(event, fixedPosition)
            },
            setKnob: function (top, left) {
                slider.knob.top = top + 'px';
                slider.knob.left = left + 'px';
            }
        };
    }])
    .directive('colorpicker', ['$document', '$compile', 'Color', 'Slider', 'Helper', function ($document, $compile, Color, Slider, Helper) {
        return {
            require: '?ngModel',
            restrict: 'A',
            link: function ($scope, elem, attrs, ngModel) {
                var
                    thisFormat = attrs.colorpicker ? attrs.colorpicker : 'hex',
                    position = angular.isDefined(attrs.colorpickerPosition) ? attrs.colorpickerPosition : 'bottom',
                    fixedPosition = angular.isDefined(attrs.colorpickerFixedPosition) ? attrs.colorpickerFixedPosition : false,
                    target = angular.isDefined(attrs.colorpickerParent) ? elem.parent() : angular.element(document.body),
                    withInput = angular.isDefined(attrs.colorpickerWithInput) ? attrs.colorpickerWithInput : false,
                    inputTemplate = withInput ? '<input type="text" name="colorpicker-input">' : '',
                    template =
                        '<div class="colorpicker dropdown">' +
                            '<div class="dropdown-menu">' +
                            '<colorpicker-saturation><i></i></colorpicker-saturation>' +
                            '<colorpicker-hue><i></i></colorpicker-hue>' +
                            '<colorpicker-alpha><i></i></colorpicker-alpha>' +
                            '<colorpicker-preview></colorpicker-preview>' +
                            inputTemplate +
                            '<button class="close close-colorpicker">&times;</button>' +
                            '</div>' +
                            '</div>',
                    colorpickerTemplate = angular.element(template),
                    pickerColor = Color,
                    sliderAlpha,
                    sliderHue = colorpickerTemplate.find('colorpicker-hue'),
                    sliderSaturation = colorpickerTemplate.find('colorpicker-saturation'),
                    colorpickerPreview = colorpickerTemplate.find('colorpicker-preview'),
                    pickerColorPointers = colorpickerTemplate.find('i');

                $compile(colorpickerTemplate)($scope);

                if (withInput) {
                    var pickerColorInput = colorpickerTemplate.find('input');
                    pickerColorInput
                        .on('mousedown', function () {
                            event.stopPropagation();
                        })
                        .on('keyup', function (event) {
                            var newColor = this.value;
                            elem.val(newColor);
                            if (ngModel) {
                                $scope.$apply(ngModel.$setViewValue(newColor));
                            }
                            event.stopPropagation();
                            event.preventDefault();
                        });
                    elem.on('keyup', function () {
                        pickerColorInput.val(elem.val());
                    });
                }

                var bindMouseEvents = function () {
                    $document.on('mousemove', mousemove);
                    $document.on('mouseup', mouseup);
                };

                if (thisFormat === 'rgba') {
                    colorpickerTemplate.addClass('alpha');
                    sliderAlpha = colorpickerTemplate.find('colorpicker-alpha');
                    sliderAlpha
                        .on('click', function (event) {
                            Slider.setAlpha(event, fixedPosition);
                            mousemove(event);
                        })
                        .on('mousedown', function (event) {
                            Slider.setAlpha(event, fixedPosition);
                            bindMouseEvents();
                        });
                }

                sliderHue
                    .on('click', function (event) {
                        Slider.setHue(event, fixedPosition);
                        mousemove(event);
                    })
                    .on('mousedown', function (event) {
                        Slider.setHue(event, fixedPosition);
                        bindMouseEvents();
                    });

                sliderSaturation
                    .on('click', function (event) {
                        Slider.setSaturation(event, fixedPosition);
                        mousemove(event);
                    })
                    .on('mousedown', function (event) {
                        Slider.setSaturation(event, fixedPosition);
                        bindMouseEvents();
                    });

                if (fixedPosition) {
                    colorpickerTemplate.addClass('colorpicker-fixed-position');
                }

                colorpickerTemplate.addClass('colorpicker-position-' + position);

                target.append(colorpickerTemplate);

                if (ngModel) {
                    ngModel.$render = function () {
                        elem.val(ngModel.$viewValue);
                    };
                    $scope.$watch(attrs.ngModel, function () {
                        update();
                    });
                }

                elem.on('$destroy', function () {
                    colorpickerTemplate.remove();
                });

                var previewColor = function () {
                    try {
                        colorpickerPreview.css('backgroundColor', pickerColor[thisFormat]());
                    } catch (e) {
                        colorpickerPreview.css('backgroundColor', pickerColor.toHex());
                    }
                    sliderSaturation.css('backgroundColor', pickerColor.toHex(pickerColor.value.h, 1, 1, 1));
                    if (thisFormat === 'rgba') {
                        sliderAlpha.css.backgroundColor = pickerColor.toHex();
                    }
                };

                var mousemove = function (event) {
                    var
                        left = Slider.getLeftPosition(event),
                        top = Slider.getTopPosition(event),
                        slider = Slider.getSlider();

                    Slider.setKnob(top, left);

                    if (slider.callLeft) {
                        pickerColor[slider.callLeft].call(pickerColor, left / 100);
                    }
                    if (slider.callTop) {
                        pickerColor[slider.callTop].call(pickerColor, top / 100);
                    }
                    previewColor();
                    var newColor = pickerColor[thisFormat]();
                    elem.val(newColor);
                    if (ngModel) {
                        $scope.$apply(ngModel.$setViewValue(newColor));
                    }
                    if (withInput) {
                        pickerColorInput.val(newColor);
                    }
                    return false;
                };

                var mouseup = function () {
                    $document.off('mousemove', mousemove);
                    $document.off('mouseup', mouseup);
                };

                var update = function () {
                    pickerColor.setColor(elem.val());
                    pickerColorPointers.eq(0).css({
                        left: pickerColor.value.s * 100 + 'px',
                        top: 100 - pickerColor.value.b * 100 + 'px'
                    });
                    pickerColorPointers.eq(1).css('top', 100 * (1 - pickerColor.value.h) + 'px');
                    pickerColorPointers.eq(2).css('top', 100 * (1 - pickerColor.value.a) + 'px');
                    previewColor();
                };

                var getColorpickerTemplatePosition = function () {
                    var
                        positionValue,
                        positionOffset = Helper.getOffset(elem[0]);

                    if (angular.isDefined(attrs.colorpickerParent)) {
                        positionOffset.left = 0;
                        positionOffset.top = 0;
                    }

                    if (position === 'top') {
                        positionValue = {
                            'top': positionOffset.top - 147,
                            'left': positionOffset.left
                        };
                    } else if (position === 'right') {
                        positionValue = {
                            'top': positionOffset.top,
                            'left': positionOffset.left + 126
                        };
                    } else if (position === 'bottom') {
                        positionValue = {
                            'top': positionOffset.top + elem[0].offsetHeight + 2,
                            'left': positionOffset.left
                        };
                    } else if (position === 'left') {
                        positionValue = {
                            'top': positionOffset.top,
                            'left': positionOffset.left - 150
                        };
                    }
                    return {
                        'top': positionValue.top + 'px',
                        'left': positionValue.left + 'px'
                    };
                };

                var documentMousedownHandler = function () {
                    hideColorpickerTemplate();
                };

                elem.on('click', function () {
                    update();
                    colorpickerTemplate
                        .addClass('colorpicker-visible')
                        .css(getColorpickerTemplatePosition());

                    // register global mousedown event to hide the colorpicker
                    $document.on('mousedown', documentMousedownHandler);
                });

                colorpickerTemplate.on('mousedown', function (event) {
                    event.stopPropagation();
                    event.preventDefault();
                });

                var hideColorpickerTemplate = function () {
                    if (colorpickerTemplate.hasClass('colorpicker-visible')) {
                        colorpickerTemplate.removeClass('colorpicker-visible');

                        // unregister the global mousedown event
                        $document.off('mousedown', documentMousedownHandler);
                    }
                };

                colorpickerTemplate.find('button').on('click', function () {
                    hideColorpickerTemplate();
                });
            }
        };
    }]);;
