using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace OEMS.Models.Model.Employee
{
    [Table("Emp_GPS")]
    [ClassName("Employee GPS")]
    public class EmpGPS: Entity
    {
        [Key]
        public Guid GPSId { get; set; }
        public int EmpId { get; set; }
        public DateTime GPSDate { get; set; }
        public string UserId { get; set; }
        public string Addressline { get; set; }
        public string Coordinate { get; set; }
        public string CountryCode { get; set; }
        public string CountryName { get; set; }
        public string FeatureName { get; set; }
        public string Locality { get; set; }
        public string PostalCode { get; set; }
        public string AdminArea { get; set; }
        public string SubadminArea { get; set; }
        public string SubLocality { get; set; }
        public string Throughfare { get; set; }
        public string SubThroughfare { get; set; }

    }
}
