using Microsoft.Owin;
using Owin;
using System.Configuration;

[assembly: OwinStartupAttribute(typeof(UI.Portal.Startup))]
namespace UI.Portal
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            string ConStr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString();

          
            ConfigureAuth(app);
        }
    }
}