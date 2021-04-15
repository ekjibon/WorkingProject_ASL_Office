using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.SMS
{
    [Table("SMS_ScheduleSMSConfig")]
    [ClassName("Schedule SMS Config")]
    public class ScheduleSMSConfig : Entity 
    {
        [Key]
        public int ConfigId { get; set; }
        public string RunTime { get; set; } // Must 24-hour Format
        public string Body { get; set; }
        public string Type { get; set; } //  A = Auto , S= Schedule
        /// <summary>
        ///  1 = Daily Fees Collection , 2 = Daily Accounts , 3 = Student Attendance summary,
        ///  4 = Employee attendance summary, 5 =Employee Leave summary
        /// </summary>
        public int CategoryId { get; set; } // Data get from Common Dropdown
        public string Recipent { get; set; } ///  Number Should Be num1,num2,num3 .....,numn
        [NotMapped]
        public int Hours { get; set; }
        [NotMapped]
        public int Min { get; set; }
    }
}
