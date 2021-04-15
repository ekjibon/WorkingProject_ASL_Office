using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.SMS
{
    [Table("SMS_SMSTemplate")]
    [ClassName("SMS Template")]
    public class SMSTemplate:Entity
    {
        [Key]
        public int TemplateId { get; set; }
        public string Title { get; set; }
        public string TempType { get; set; }
        public int CategoryId { get; set; } // Data get from Common Dropdown
        public int BodyType { get; set; } //  1 = Static , 2 = Dynamic , 3 = Scheduler , 4 = Auto Scheduler
        public string AddType { get; set; } // N = Normal , D = Draft 
        public string SMSBody { get; set; }
        public int SMSPart { get; set; }
        public int SMSLen { get; set; }
        public Boolean isUnicode { get; set; }


    }
}
