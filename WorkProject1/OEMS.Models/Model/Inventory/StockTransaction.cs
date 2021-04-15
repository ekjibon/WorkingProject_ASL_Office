using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Inventory
{
    [Table("Inv_StockTransaction")]
    [ClassName("Stock Transaction")]
    public class StockTransaction:Entity
    {
        [Key]
        public int TransactionId { get; set; }
        public int ProductId { get; set; }
        public decimal Quantity { get; set; }
        public decimal LastStockQty { get; set; }
        public string TransType { get; set; }/// IN , OUT
        public string TransCategory { get; set; } // .... Sales = "S" , Purchase = "P", OpeningBalcnce = "OP"
    }
}
