using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Invoice
{
    [Table("Invoice_PhoneCallMaintain")]
    [ClassName("Phone Call Maintain")]
    public class PhoneCallMaintain : Entity
    {
        [Key]
        public int Id { get; set; }
        
        public int ClientId { get; set; }
        public DateTime CallDate { get; set; }
        public DateTime ProbablePaymentDate { get; set; }
        public string ContactNo { get; set; }
        public string ContactPerson { get; set; }
        public string Comments { get; set; }

    }
}
