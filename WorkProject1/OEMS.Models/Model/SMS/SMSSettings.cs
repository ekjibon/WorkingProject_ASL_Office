using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.SMS
{
    [Table("SMS_Settings")]
    [ClassName("SMS Settings")]
    public class SMSSettings:Entity
    {
        [Key]
        public int SettingsId { get; set; }
        public int NoSMSPart { get; set; }
        public Boolean AllowUnicode { get; set; }
        public Boolean ForStudent { get; set; }
        public Boolean ForEmployee { get; set; }
        public Boolean IsSMSNumber { get; set; }
        public Boolean IsFatherNumber { get; set; }
        public Boolean IsMotherNumber { get; set; }
        public string ClientId { get; set; }
        public string Key { get; set; }
        public string UserName { get; set; }
        public string Password { get; set; }

    }
}
