using Hangfire;
using Microsoft.Owin;
using Owin;
using System;
using System.Configuration;

[assembly: OwinStartupAttribute(typeof(UI.WebClients.Startup))]
namespace UI.WebClients
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            string ConStr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString();
            GlobalConfiguration.Configuration
                .UseSqlServerStorage(ConStr);
            ConfigureAuth(app);
            app.MapSignalR();
            app.UseHangfireDashboard();
            app.UseHangfireServer();          
            RecurringJob.AddOrUpdate(() => ProccessReport(), Cron.Minutely);
        }
        public void ProccessReport()
        {
            try
            {
                

            }
            catch (Exception ex)
            {

                throw ex;
            }
        }
    }
}