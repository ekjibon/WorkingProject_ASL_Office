using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using OEMS.Models.Model;
using System.ComponentModel.DataAnnotations.Schema;

namespace OEMS.Models.ViewModel
{
    [NotMapped]
    public class DividedExamMarkSetupVM : DividedExamMarkSetup
    {
        
           public string DividedExamName { get; set; }
           public string DividedExmConfigured { get; set; }
           public int DividedExamMarksEntry { get; set; }

    }
}
