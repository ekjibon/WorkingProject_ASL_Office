using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Club
{
    [Table("Ins_ECAClubConfig")]
    [ClassName("Club Config")]
    public class ClubConfig :Entity
        
    {
        public ClubConfig()
        {
            Class = new List<string>();
        }
        [Key]
        public int Id { get; set; }
        public int BranchId { get; set; }
        public int SessionId { get; set; }
        public int ClassId { get; set; } 
        public int ShiftId { get; set; }
        public string CategoryName { get; set; }
        public int ClubId { get; set; }
        public int TermId { get; set; }
        public int DayId { get; set; }
        public int SeatCapacity { get; set; }
        public int NoOfClass { get; set; }
        public DateTime? FromTime { get; set; }
        public DateTime? ToTime { get; set; }

        public DateTime Deadline { get; set; }

        [NotMapped]

        public List<string> Class { get; set; }
        
      
       
    }
}
