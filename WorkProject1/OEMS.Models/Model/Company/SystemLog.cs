using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model
{
    [ClassName("System Log")]
    public class SystemLog
    {
        [Key]
        public int LogId { get; set; }
        public int Msg { get; set; }
        public DateTime LogTime { get; set; }
        public string Status { get; set; }
    }
}
