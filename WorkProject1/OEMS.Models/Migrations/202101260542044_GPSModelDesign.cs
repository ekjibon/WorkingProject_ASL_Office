namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class GPSModelDesign : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Emp_GPS",
                c => new
                    {
                        GPSId = c.Guid(nullable: false),
                        EmpId = c.Int(nullable: false),
                        GPSDate = c.DateTime(nullable: false),
                        UserId = c.String(),
                        Addressline = c.String(),
                        Coordinate = c.String(),
                        CountryCode = c.String(),
                        CountryName = c.String(),
                        FeatureName = c.String(),
                        Locality = c.String(),
                        PostalCode = c.String(),
                        AdminArea = c.String(),
                        SubadminArea = c.String(),
                        SubLocality = c.String(),
                        Throughfare = c.String(),
                        SubThroughfare = c.String(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.GPSId);
            
        }
        
        public override void Down()
        {
            DropTable("dbo.Emp_GPS");
        }
    }
}
