using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.ViewModel
{
    public class ECAAttendanceVM
    {
        public int Id { get; set; }
        public int StudentId { get; set; }
        public int TermId { get; set; }
        public int DayId { get; set; }
        public int ClubId { get; set; }
        public int ClassId { get; set; }
        public int SessionId { get; set; }
        public int SectionId { get; set; }
        public string FullName { get; set; }
        public string ClassName { get; set; }
        public string SessionName { get; set; }
        public bool IsPresent { get; set; }
        public DateTime AttnDateTime { get; set; }
    }
}
