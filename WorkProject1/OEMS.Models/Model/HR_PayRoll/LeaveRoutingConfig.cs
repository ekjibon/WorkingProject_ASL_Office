using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace OEMS.Models.Model.HR_PayRoll
{
    [Table("HR_LeaveRoutingConfig")]
    [ClassName("Leave Routing Config")]
    public class LeaveRoutingConfig : Entity
    {
        public LeaveRoutingConfig()
        {
            LeaveRoutingConfigDetailsList = new List<LeaveRoutingConfigDetails>();
        }
        [Key]
        public int RoutingId { get; set; } 
        public string RouteName { get; set; }
        //public string RouteCode { get; set; }
        public int DesignationId { get; set; } // fk
        public int DisplayOrder { get; set; }

        [NotMapped]
        public List<LeaveRoutingConfigDetails> LeaveRoutingConfigDetailsList { get; set; }
    }
}
