using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Inventory
{
    [Table("Inv_Supplier")]
    [ClassName("Supplier")]
    public class Supplier:Entity
    {
        [Key]
        public int SupplierId { get; set; }
        public string SupplierName { get; set; }
        public string SupplierCode { get; set; }
        public string BIN { get; set; }
        public string CompanyName { get; set; }
        public string ContactPersonName { get; set; }
        public string ConatactPersonMobileNo { get; set; }
        public string Email { get; set; }
        public string Address { get; set; }
        public string AccountCode { get; set; }// When Supplier Will Create a ledger will be added to accounts and Code ill be added here.
    }
}
