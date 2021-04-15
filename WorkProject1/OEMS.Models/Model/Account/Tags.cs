using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Account
{
    [Table("ACC_Tags")]
    [ClassName("Tags")]
    public class Tags : Entity
    {
        [Key]
        public int TagId { get; set; }
        public string Title { get; set; }
        public string Color { get; set; }
        public string Background { get; set; }
    }
}
