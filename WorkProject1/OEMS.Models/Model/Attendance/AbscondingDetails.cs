using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Attendance
{
    [Table("Att_AbscondingDetails")]
    [ClassName("Absconding Details")]
    public class AbscondingDetails 
    {
        [Key]
        public long AbscondingId { get; set; }
        public long  AttenId { get; set; }
        public int PeriodId { get; set; }

    }
}
