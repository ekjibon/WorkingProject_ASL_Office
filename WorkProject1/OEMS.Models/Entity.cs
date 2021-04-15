
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Net;
using System.Net.NetworkInformation;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Web;

namespace OEMS.Models
{
    public abstract class Entity
    {
     

        [DefaultValue(false)]
        public bool IsDeleted { get; set; }
        [StringLength(128)]
        public string AddBy { get; set; }

        public DateTime? AddDate { get; set; }

        [StringLength(128)]
        public string UpdateBy { get; set; }
        public DateTime? UpdateDate { get; set; } 
        [StringLength(100)]
        public string Remarks { get; set; }
        [StringLength(20)]
        public string Status { get; set; }
        [StringLength(50)]
        public string IP { get; set; }
        [StringLength(50)]
        public string MacAddress { get; set; }

        public void SetDate()
       {
            if(AddDate == null)
            {     
                AddDate = DateTime.Now;
            }               
            if (!String.IsNullOrEmpty(UpdateBy) && UpdateDate == null)
            {
                UpdateDate = DateTime.Now;
            }
            this.IP = Dns.GetHostAddresses(HttpContext.Current.Request.UserHostAddress.ToString()).GetValue(0).ToString();
            //getting mac address
            var myInterfaceAddress = NetworkInterface.GetAllNetworkInterfaces()
         .Where(n => n.OperationalStatus == OperationalStatus.Up && n.NetworkInterfaceType != NetworkInterfaceType.Loopback)
         .OrderByDescending(n => n.NetworkInterfaceType == NetworkInterfaceType.Ethernet)
         .Select(n => n.GetPhysicalAddress())
         .FirstOrDefault();
            //add separation into mac address
            this.MacAddress = myInterfaceAddress.ToString();
            MacAddress = Regex.Replace(MacAddress, ".{2}", "$0-");
            //MacAddress = MacAddress.Remove(MacAddress.Length - 1);
        }


        public virtual IEnumerable<ValidationResult> Validate()
        {
            return EntityValidator.ValidateEntity(this);
        }


    }

    public class EntityValidator
    {
        public static IEnumerable<ValidationResult> ValidateEntity<T>(T entity) where T : Entity
        {
            return new EntityValidation<T>().Validate(entity);
        }
    }
    public class EntityValidation<T> where T : Entity
    {
        public IEnumerable<ValidationResult> Validate(T entity)
        {
            var validationResults = new List<ValidationResult>();
            var validationContext = new ValidationContext(entity, null, null);
            Validator.TryValidateObject(entity, validationContext, validationResults, true);
            return validationResults;
        }
    }
}
