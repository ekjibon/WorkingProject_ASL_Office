using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.ViewModel
{
   public class HeadTeacherCommentVM
    {
        public long StudentIID { get; set; }
        public string HeadTeacherComments { get; set; }
        public int MainExamId { get; set; }
        public string ReportGLComments { get; set; }
        public string FailSubComments { get; set; }
        public string COComments { get; set; }
        public int? TermId { get; set; }
        public int? Id { get; set; }
    }
}
