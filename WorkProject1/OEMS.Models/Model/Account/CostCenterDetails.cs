using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace OEMS.Models.Model.Account
{
    [Table("ACC_CostCenterDetails")]
    [ClassName("CostCenterDetails")]
    public class CostCenterDetails : Entity
    {
        [Key]
        public int Id { get; set; }
        public int? TransactionId { get; set; }
        public int? LedgerId { get; set; }
        public int? CostCenterId { get; set; }
        public decimal? Amount { get; set; }
        
       
    }
}
