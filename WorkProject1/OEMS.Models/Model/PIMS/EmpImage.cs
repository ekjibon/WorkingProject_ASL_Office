using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model
{
    [Table("Emp_Image")]
    [ClassName("Emp Image")]
    public class EmpImage : Entity
    {
        [Key]
        public int ImageId { get; set; }
       
        public long EmpID { get; set; }
        public byte[] Photo { get; set; }
        public string ImageName { get; set; }
       
    }
}
