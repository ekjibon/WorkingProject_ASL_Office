using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.SMS
{
    [Table("SMS_SMSSendHistroy")]
    [ClassName("SMS Send Histroy")]
    public class SMSSendHistroy:Entity
    {
        [Key]
        public long HistoryId { get; set; }
        public long? StudentIId { get; set; }
        public int? EmpId { get; set; }
        public int TemplateId { get; set; } //  0 = No Template
        public int CategoryId { get; set; } // Data get from Common Dropdown
        public string SMSBody { get; set; } // for Dynamic SMS
        public int SMSPart { get; set; }
        public int SMSLength { get; set; }
        public int SMSTypeId { get; set; } // 1 = Static , 2 = Dynamic, 3 = Schedule , 4 = Auto Schedule
        public DateTime SendDateTime { get; set; }
        public int SendStatus { get; set; } // 1 = Success , 2 = Pending , 3 = Failed  
        public int? JobId { get; set; } //  Will be update from api callback
        public string ReceiveNumber { get; set; }

    }
}
