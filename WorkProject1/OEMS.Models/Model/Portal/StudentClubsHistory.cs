using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Club
{
    [Table("Stu_ClubsHistory")]
    [ClassName("Student Clubs History")]
    public class StudentClubsHistory : Entity
    {
        [Key]
        public int Id { get; set; }
        public long StudentId { get; set; }      
        public int FromClubId { get; set; }
        public int ToClubId { get; set; }
        public string Reason { get; set; }
        public DateTime ChangingDate { get; set; }


    }
}
