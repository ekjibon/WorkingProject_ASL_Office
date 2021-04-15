using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Company
{
    [Table("Ins_NoticeDetails ")]
    [ClassName("Notice Details")]
    public class NoticeDetails 
    {
        [Key]
        public long Id { get; set; }
        public int NoticeId { get; set; }
        public int TargetId { get; set; }
        public int TargetType { get; set; } // 1= Student 2 = Employee
    }
}
