using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Club
{
    [Table("Stu_Clubs")]
    [ClassName("Student Clubs")]
    public class StudentClubs : Entity
    {
        [Key]
        public int Id { get; set; }
        public long StudentId { get; set; }      
        public int ClubId { get; set; }
        public int ChoiceTypeId { get; set; }
        public int TermId { get; set; } 
        public int DayId { get; set; }

        public int NewClubId { get; set; }


    }
}
