using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Invoice
{
    [Table("Invoice_BillingHeadConfigDetails")]
    [ClassName("BillingHeadConfigDetails")]
    public class BillingHeadConfigDetails : Entity
    {
        [Key]
        public int Id { get; set; }
        public int? BillingHeadConfigId { get; set; }
        public int? Year { get; set; }
        public int? MonthId { get; set; }
        public string MonthName { get; set; }
        [NotMapped]
        public string Text { get; set; }
        [NotMapped]
        public int? Value { get; set; }
        [NotMapped]
        public string IsProcess { get; set; }

    }
}
