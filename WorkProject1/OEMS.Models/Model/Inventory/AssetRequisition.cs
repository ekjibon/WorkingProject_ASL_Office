using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Inventory
{
    [Table("FA_AssetRequisition")]
    [ClassName("Asset Requisition")]
    public class AssetRequisition : Entity
    {
        public AssetRequisition()
        {
            ReqDetailsList = new List<AssetRequisitionDetails>();
            requisition = new List<AssetRequisition>();
        }
        [Key]
        public int AssetRequisitionId { get; set; }
        public string ReqCode { get; set; } // Automatice Generate 
        public DateTime DueDate { get; set; }
        public DateTime EventDate { get; set; }
        public string Description { get; set; }
        public bool IsApproved { get; set; }
        public string ApprovedBy { get; set; }
        public string ApprovedComments { get; set; }
        [NotMapped]
        public string Date { get; set; }

        [NotMapped]
        public List<AssetRequisitionDetails> ReqDetailsList { get; set; }

        [NotMapped]

        public List<AssetRequisition> requisition { get; set; }
    }
}
