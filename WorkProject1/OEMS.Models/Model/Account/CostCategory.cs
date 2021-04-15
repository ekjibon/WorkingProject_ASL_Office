using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace OEMS.Models.Model.Account
{
    [Table("ACC_CostCategory")]
    [ClassName("CostCategory")]
    public class CostCategory : Entity
    {
        [Key]
        public int Id { get; set; }
        public string CostCategoryName { get; set; }
       
    }
}
