using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.SMS
{
    [Table("SMS_SMSExtNumbers")]
    [ClassName("SMS Ext Numbers")]
    public class SMSExtNumbers : Entity
    {
        [Key]
        public int Id { get; set; }
        public int GroupId { get; set; } 
        public string FullName { get; set; } 
        public string ReceiveNumber { get; set; }
    }
}
