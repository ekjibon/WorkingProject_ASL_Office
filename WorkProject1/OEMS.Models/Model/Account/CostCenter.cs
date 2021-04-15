using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace OEMS.Models.Model.Account
{
    [Table("ACC_CostCenter")]
    [ClassName("CostCenter")]
    public class CostCenter : Entity
    {
        [Key]
        public int Id { get; set; }
        public int CostCategoryId { get; set; }
        public string CostCenterName { get; set; }
        public int? LedgerId { get; set; }

    }
}
