using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.ViewModel
{
    public class ChartData
    {
        public ChartData()
        {
            series = new List<series>();
        }
        public List<series> series { get; set; }
    }

    public class series
    {
        public int y { get; set; }
        public string color { get; set; }
        public string name { get; set; }
        public seriesdata[] data { get; set; }
    }
    public class branchShift
    {
        public int y { get; set; }
        public string color { get; set; }
        public string name { get; set; }
        public int branchId { get; set; }
        public seriesdata[] data { get; set; }
    }
    public class seriesdata
    {
        public int y { get; set; }
        public string color { get; set; }
        public string name { get; set; }
        public int branchId { get; set; }
    }
}
