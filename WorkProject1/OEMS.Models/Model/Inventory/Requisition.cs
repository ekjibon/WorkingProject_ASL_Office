using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Inventory
{
    [Table("Inv_Requisition")]
    [ClassName("Requisition")]
    public class Requisition:Entity
    {
        public Requisition()
        {
            ReqDetailsList = new List<RequisitionDetails>();
            requisition = new List<Requisition>();
        }
        [Key]
        public int RequisitionId { get; set; }
        public string ReqCode { get; set; } // Automatice Generate 
        public DateTime DueDate { get; set; }
        public string Description { get; set; }
        public bool IsApproved { get; set; }
        public string ApprovedBy { get; set; }
        public string ApprovedComments { get; set; }
        [NotMapped]
        public string Date { get; set; }

        [NotMapped]
        public List<RequisitionDetails> ReqDetailsList { get; set; }

        [NotMapped]

        public List<Requisition> requisition { get; set; }
    }
}
