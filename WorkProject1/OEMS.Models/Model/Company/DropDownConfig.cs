using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model
{
    [Table("Common_DropDownConfig")]
    [ClassName("DropDown Config")]
    public class DropDownConfig
    {
        [Key]
        public int Id { get; set; } 
        [Required]        
        public string Text { get; set; }
        [Required]
        public string Value { get; set; }
        public string Type { get; set; }      
        [NotMapped]    
        public string AccountType { get; set; }
        //[NotMapped]
        //public int Paymode { get; set; }

    }  
   
}
