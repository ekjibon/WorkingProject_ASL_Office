using System.Data.Entity;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using System;
using OEMS.Models;
using System.ComponentModel;
using System.Net.NetworkInformation;
using System.Net;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace UI.WebClients.Models
{
    // You can add profile data for the user by adding more properties to your ApplicationUser class, please visit http://go.microsoft.com/fwlink/?LinkID=317594 to learn more.
    public class ApplicationUser : IdentityUser
    {
        public async Task<ClaimsIdentity> GenerateUserIdentityAsync(UserManager<ApplicationUser> manager)
        {
            // Note the authenticationType must match the one defined in CookieAuthenticationOptions.AuthenticationType
            var userIdentity = await manager.CreateIdentityAsync(this, DefaultAuthenticationTypes.ApplicationCookie);
            var uId = userIdentity.GetUserId();
            // Add custom user claims here
            userIdentity.AddClaim(new Claim("Fullname", FullName.ToString()));
            userIdentity.AddClaim(new Claim("Roleid", manager.GetRoles(uId)[0]));
            //var img = Uri.EscapeDataString(System.Convert.ToBase64String(Image)); //Convert.ToBase64String(Image);
            //userIdentity.AddClaim(new Claim("Image", img));
            //userIdentity.
            //  userIdentity.AddClaim(new Claim("Image", System.Text.Encoding.Default.GetString(Image)));
            return userIdentity;
        }

        public string FullName { get; set; }
        public string MobileNo { get; set; }
        public byte[] Image { get; set; }
        public string Address { get; set; }
        public int? EmpId { get; set; }
       
        
    }

    public class ApplicationDbContext : IdentityDbContext<ApplicationUser>
    {
        public ApplicationDbContext()
            : base("DefaultConnection", throwIfV1Schema: false)
        {
        }  

        public static ApplicationDbContext Create()
        {
            return new ApplicationDbContext();
        }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            Database.SetInitializer<ApplicationDbContext>(null);
            base.OnModelCreating(modelBuilder);
        }
    }
}