using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Net;
using System.Net.NetworkInformation;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Web;

namespace OEMS.Models.Model.Account
{
    [Table("ACC_Logs")]
    [ClassName("Account Logs")]
    public class AccountLogs
    {
        [Key]
        public int Id { get; set; }
        public int TransactionDetailId { get; set; }
        public int LedgerId { get; set; }
        public decimal DrAmount { get; set; }
        public decimal CrAmount { get; set; }
        public string Description { get; set; }
        [StringLength(128)]
        public string AddBy { get; set; }
        public DateTime? AddDate { get; set; }
        [StringLength(50)]
        public string IP { get; set; }
        [StringLength(50)]
        public string MacAddress { get; set; }
        public void SetDate()
        {
            if (AddDate == null)
            {
                AddDate = DateTime.Now;
            }
            this.IP = Dns.GetHostAddresses(HttpContext.Current.Request.UserHostAddress.ToString()).GetValue(0).ToString();
            //getting mac address
            var myInterfaceAddress = NetworkInterface.GetAllNetworkInterfaces()
         .Where(n => n.OperationalStatus == OperationalStatus.Up && n.NetworkInterfaceType != NetworkInterfaceType.Loopback)
         .OrderByDescending(n => n.NetworkInterfaceType == NetworkInterfaceType.Ethernet)
         .Select(n => n.GetPhysicalAddress())
         .FirstOrDefault();
            //add separation into mac address
            this.MacAddress = myInterfaceAddress.ToString();
            MacAddress = Regex.Replace(MacAddress, ".{2}", "$0-");
            MacAddress = MacAddress.Remove(MacAddress.Length - 1);
        }
    }
}
