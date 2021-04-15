using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Company
{
    [Table("Ins_NoticeInfo")]
    [ClassName("Notice Info")]
    public class NoticeInfo:Entity
    {
        [Key]
        public int Id { get; set; }
        [MaxLength(50)]
        [Required]
        public string Title { get; set; }
        public string Description { get; set; }
        public DateTime PublishDate { get; set; }
        public string ColorCode { get; set; }
        public string Type { get; set; }
    }
}
