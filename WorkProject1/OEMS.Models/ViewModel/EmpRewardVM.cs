using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.ViewModel
{
    public class EmpRewardVM
    {
        public int EmpRewardId { get; set; }
        public int EmpId { get; set; }
        public decimal RewardAmount { get; set; }
        public int EmpBasicInfoID { get; set; }
    }
}
