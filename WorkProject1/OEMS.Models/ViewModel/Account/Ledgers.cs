using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace OEMS.Models.ViewModel.Account
{
    public class LedgersVM 
    {
        public int LedgerId { get; set; }
        public int RootGroupId { get; set; }
        public int ParentId { get; set; }
        public string Name { get; set; }
        public string Code { get; set; }
        [RegularExpression(@"\d+(\.\d{1,2})?", ErrorMessage = "Invalid Openning Balance")]
        public decimal OpenningBalance { get; set; }
        public int OpenningBalanceDc { get; set; }
        [RegularExpression(@"\d+(\.\d{1,2})?", ErrorMessage = "Invalid CurrentBalance Balance")]
        public decimal CurrentBalance { get; set; }
        public int CurrentBalanceDc { get; set; }
        public bool IsEdit { get; set; }
        public bool IsLedger { get; set; }
        public bool IsGroup { get; set; }
        public bool IsDisplay { get; set; }
        public int DisplayOrder { get; set; }
        [NotMapped]
        public string Type { get; set; }
        public List<LedgersVM> LedgersVMs { get; set; } = new List<LedgersVM>();
    }
}
