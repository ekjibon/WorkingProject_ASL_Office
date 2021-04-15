using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace OEMS.Models.Model.HR_PayRoll
{
    [Table("HR_LeaveRoutingConfigDetails")]
    [ClassName("Leave Routing Config Details")]
    public class LeaveRoutingConfigDetails : Entity
    {
        [Key]
        public int DetailsId { get; set; }
        public int RoutingId { get; set; } // fk 
        public string NextApproval { get; set; } //  user Id
        [Range(1, 5)]
        public int SerialNo { get; set; }
        public bool IsMandatory { get; set; }
        public bool IsFinalApprove { get; set; }

    }
}
