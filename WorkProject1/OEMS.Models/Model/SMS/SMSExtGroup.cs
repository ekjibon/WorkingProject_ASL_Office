using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.SMS
{
    [Table("SMS_SMSExtGroup")]
    [ClassName("SMS Ext Group")]
    public class SMSExtGroup : Entity
    {
        [Key]
        public int GroupId { get; set; }
        public string GroupName { get; set; } 
    }
}
