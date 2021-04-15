using System.Web;
using System.Web.Optimization;

namespace UI.WebClients
{
    public class BundleConfig
    {
        // For more information on bundling, visit http://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.UseCdn = true;

            var bootstrapCdnPath = "http://cdn.addiesoft.com/admin";

            bundles.Add(new ScriptBundle("~/bundles/jquery").Include(
                        "~/Scripts/jquery-{version}.js"));

            bundles.Add(new ScriptBundle("~/bundles/jqueryval").Include(
                        "~/Scripts/jquery.validate*"));

            // Use the development version of Modernizr to develop with and learn from. Then, when you're
            // ready for production, use the build tool at http://modernizr.com to pick only the tests you need.
            bundles.Add(new ScriptBundle("~/bundles/modernizr").Include(
                        "~/Scripts/modernizr-*"));

            bundles.Add(new ScriptBundle("~/bundles/bootstrap").Include(
                      "~/Scripts/bootstrap.js",
                      "~/Scripts/respond.js"));

            bundles.Add(new StyleBundle("~/Content/css").Include(
                      "~/Content/bootstrap.css",
                      "~/Content/site.css"));
            bundles.Add(new ScriptBundle("~/bundles/common").Include(
                     "~/Scripts/jquery.localize.js"));

            bundles.Add(new StyleBundle("~/bundles/GLOBAL_MANDATORY").Include(
                    "~/assets/global/plugins/font-awesome/css/font-awesome.min.css",
                    "~/assets/global/plugins/simple-line-icons/simple-line-icons.min.css",
                    "~/assets/global/plugins/bootstrap/css/bootstrap.min.css",
                    "~/assets/global/plugins/bootstrap-switch/css/bootstrap-switch.min.css",
                    "~/assets/global/plugins/bootstrap-toastr/toastr.min.css" ,
                    "~/assets/angular/lib/angular-block-ui.css"
                    ));
            bundles.Add(new StyleBundle("~/bundles/THEME_GLOBAL").Include(
                    "~/assets/global/css/components-md.min.css",
                    "~/assets/global/css/plugins-md.min.css"
                    ));
            bundles.Add(new StyleBundle("~/bundles/THEME_LAYOUT").Include(
                   "~/assets/layouts/layout4/css/layout.min.css",
                   //"~/assets/layouts/layout4/css/themes/default.css",
                   "~/assets/layouts/layout4/css/custom.min.css"
                   ));


            bundles.Add(new ScriptBundle("~/bundles/CORE_PLUGINS").Include(
                  "~/assets/global/plugins/jquery.min.js",
                  "~/assets/global/plugins/bootstrap/js/bootstrap.min.js",
                  "~/assets/global/plugins/js.cookie.min.js",
                  "~/assets/global/plugins/jquery-slimscroll/jquery.slimscroll.min.js",
                  "~/assets/global/plugins/jquery.blockui.min.js",
                  "~/assets/global/plugins/bootstrap-switch/js/bootstrap-switch.min.js",
                  "~/assets/global/plugins/bootstrap-toastr/toastr.min.js"                   

                  ));

            bundles.Add(new ScriptBundle("~/bundles/ANGULAR").Include(
                  "~/assets/angular/lib/angular.min.js",
                  "~/assets/angular/lib/angular-resource.min.js",
                  "~/assets/angular/lib/angular-animate.min.js",
                  "~/assets/angular/lib/angular-messages.min.js",
                  "~/assets/angular/lib/ui-bootstrap-tpls-2.5.0.min.js",
                  "~/assets/angular/lib/dirPagination.js",
                  "~/assets/angular/lib/SweetAlert.min.js",
                  "~/assets/angular/lib/angular-block-ui.js",
                  "~/App/app.js",
                  "~/App/directive.js"
                  ));
        }
    }              
}                 


