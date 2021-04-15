using System.Data.Entity;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using System.ComponentModel.DataAnnotations.Schema;
using OEMS.AppData;

namespace UI.Portal.Models
{
    // You can add profile data for the user by adding more properties to your ApplicationUser class, please visit http://go.microsoft.com/fwlink/?LinkID=317594 to learn more.
    [Table("AspNetPortalUsers")]
    public class AspNetPortalUsers : IdentityUser
    {
        public int StudentId { get; set; }
        public async Task<ClaimsIdentity> GenerateUserIdentityAsync(UserManager<AspNetPortalUsers> manager)
        {
            // Note the authenticationType must match the one defined in CookieAuthenticationOptions.AuthenticationType
            var userIdentity = await manager.CreateIdentityAsync(this, DefaultAuthenticationTypes.ApplicationCookie);
            // Add custom user claims here
          var Student =   DataAccess.Instance.StudentBasicInfo.Get(StudentId);
            userIdentity.AddClaim(new Claim("StudentId", StudentId.ToString()));
            userIdentity.AddClaim(new Claim("FullName", Student.FullName.ToString()));
            userIdentity.AddClaim(new Claim("StudentInsId", Student.StudentInsID.ToString()));

            return userIdentity;
        }
    }

    public class ApplicationDbContext : IdentityDbContext<AspNetPortalUsers>
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
            base.OnModelCreating(modelBuilder);
            modelBuilder.Entity<AspNetPortalUsers>().ToTable("AspNetPortalUsers");
        }
    }
}