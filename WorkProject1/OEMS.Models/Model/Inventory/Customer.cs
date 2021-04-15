using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Inventory
{
    [Table("Inv_Customer")]
    [ClassName("Customer")]
    public class Customer : Entity
    {
        [Key]
        public int CustomerId { get; set; }
        public string CustomerName { get; set; }
        public string CustomerCode { get; set; } 
        public string BIN { get; set; }
        public string CompanyName { get; set; }
        public string ContactPersonName { get; set; }
        public string ConatactPersonMobileNo { get; set; }
        public string Email { get; set; }
        public string Address { get; set; }
        public string AccountCode { get; set; }
    }
}
