using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Account
{
    [Table("ACC_RootGroup")]
    [ClassName("Root Group")]
    public class RootGroup:Entity
    {
        [Key]
        public int Id { get; set; }
        public string Name { get; set; }
        public string Prefix { get; set; }
        public string Surfix { get; set; }
        public string Seperator { get; set; }
        public string Position { get; set; }
        public int Length { get; set; }
        public int Order { get; set; }
    }
}
