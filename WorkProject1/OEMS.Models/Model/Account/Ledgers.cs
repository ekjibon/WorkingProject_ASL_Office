using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace OEMS.Models.Model.Account
{
    [Table("ACC_Ledgers")]
    [ClassName("Ledgers")]
    public class Ledgers : Entity
    {
        [Key]
        public int LedgerId { get; set; }
        public int RootGroupId { get; set; }
        public int ParentId { get; set; }
        [StringLength(1000)]
        [Index(IsUnique = true)]
        public string Name { get; set; }
        [StringLength(500)]
        [Index(IsUnique = true)]
        public string Code { get; set; }
        [RegularExpression(@"\d+(\.\d{1,2})?", ErrorMessage = "Invalid Openning Balance")]
        public decimal OpenningBalance { get; set; }
        public int OpenningBalanceDc { get; set; }
        [RegularExpression(@"\d+(\.\d{1,2})?", ErrorMessage = "Invalid Current Balance")]
        public decimal CurrentBalance { get; set; }
        public int CurrentBalanceDc { get; set; }
        public bool IsEdit { get; set; }
        public bool IsLedger { get; set; }
        public bool IsGroup { get; set; }
        public bool IsDisplay { get; set; }
        public int DisplayOrder { get; set; }
        public string CashFlowType { get; set; }

        [NotMapped]
        public string Type { get; set; }
        public Ledgers()
        {
            IsEdit = true;
        }
    }
}
