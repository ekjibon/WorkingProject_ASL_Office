namespace OEMS.Models.Model
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    [ClassName("AspNet Page Api")]
    public partial class AspNetPageApi
    {
        [Key]
        public int PageApiId { get; set; }
        public int ApiId { get; set; }
        public int PageId { get; set; }
      
    }
}
