using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.SMS
{
    [Table("SMS_SMSTempTag")]
    [ClassName("SMS Temp Tag")]
    public class SMSTempTag : Entity
    {
        [Key]
        public int TagId { get; set; }
        public string TagType { get; set; }
        public string TagName { get; set; }
        public string FieldsName { get; set; } // Column Name of Database 
        public int Count { get; set; } 



    }
}
