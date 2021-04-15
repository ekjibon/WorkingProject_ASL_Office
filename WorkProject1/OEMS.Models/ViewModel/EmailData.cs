using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.ViewModel
{
    public class EmailData
    {
        public string Name { get; set; }
        public string Description { get; set; }
        

        public bool HasButton { get; set; }
        public string ButtonLink { get; set; }
        public string ButtonText { get; set; }
    }
}
