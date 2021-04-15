using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Account
{
    [Table("ACC_Settings")]
    [ClassName("Account Settings")]
    public class AccountSettings : Entity
    {
        [Key]
        public int SettingId { get; set; }
        public string Name { get; set; }
        public string Address { get; set; }
        public DateTime FiscalYearStart { get; set; }
        public DateTime FiscalYearEnd { get; set; }
        public string Email { get; set; }
      
        public char CurrencyFormat { get; set; }
        public char CurrencySymbol { get; set; }
        public int DecimalPlaces { get; set; }
        public string DateFormat { get; set; }
        public string TimeZone { get; set; }
        public bool ManageInventory { get; set; }
        public bool AccountLocked { get; set; }
        public AccountSettings()
        {
            ManageInventory = false;
            AccountLocked = false;
            DecimalPlaces = 2;
        }
    }
}
