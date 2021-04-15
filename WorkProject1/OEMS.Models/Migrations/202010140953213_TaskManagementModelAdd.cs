namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class TaskManagementModelAdd : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Task_Bug",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        ModuleId = c.Int(nullable: false),
                        TestSiteId = c.Int(nullable: false),
                        ProjectId = c.Int(nullable: false),
                        Code = c.String(),
                        Title = c.String(),
                        Description = c.String(),
                        Comments = c.String(),
                        DeveloperFeedback = c.String(),
                        TesterFeedback = c.String(),
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
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.Task_BugAttachment",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        BugId = c.Int(nullable: false),
                        Path = c.String(),
                    })
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.Task_Comments",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        RefId = c.Int(nullable: false),
                        Type = c.Int(nullable: false),
                        Description = c.String(),
                        Like = c.Int(nullable: false),
                        Dislike = c.Int(nullable: false),
                        AddBy = c.String(),
                        AddDate = c.DateTime(nullable: false),
                    })
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.CRM_Meeting",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        Title = c.String(nullable: false),
                        Topics = c.String(nullable: false),
                        ClientId = c.Int(),
                        MeetingDate = c.DateTime(nullable: false),
                        StartTime = c.Time(nullable: false, precision: 7),
                        EndTime = c.Time(nullable: false, precision: 7),
                        Notes = c.String(),
                        Location = c.String(nullable: false),
                        MeetingPersonName = c.String(),
                        MeetingPersonMobileNo = c.String(),
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
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.CRM_MeetingPersons",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        MeetingId = c.Int(nullable: false),
                        UserId = c.String(),
                    })
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.Task_Modules",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        ModuleName = c.String(),
                        ProductName = c.String(),
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
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.Task_Notifications",
                c => new
                    {
                        Id = c.Long(nullable: false, identity: true),
                        CategoryId = c.Int(nullable: false),
                        TypeId = c.Int(nullable: false),
                        Title = c.String(nullable: false, maxLength: 30),
                        Message = c.String(nullable: false, maxLength: 200),
                        DetailsURL = c.String(maxLength: 200),
                        SentTo = c.String(),
                        AddDate = c.DateTime(nullable: false),
                        IsRead = c.Boolean(nullable: false),
                        IsDeleted = c.Boolean(nullable: false),
                        IsReminder = c.Boolean(nullable: false),
                    })
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.Task_Project",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        ProjectName = c.String(),
                        ExpireDate = c.DateTime(nullable: false),
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
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.Task_ProjectUsers",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        ProjectId = c.Int(nullable: false),
                        UserId = c.String(),
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
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.Task_Sprint",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        SprintTitle = c.String(),
                        StartDate = c.DateTime(nullable: false),
                        EndDate = c.DateTime(nullable: false),
                        Completed = c.Int(nullable: false),
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
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.Task_TaskActivityLog",
                c => new
                    {
                        Id = c.Long(nullable: false, identity: true),
                        UserId = c.String(),
                        Type = c.String(),
                        Description = c.String(),
                        RefId = c.Int(nullable: false),
                        LogDate = c.DateTime(nullable: false),
                    })
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.Task_TaskAssign",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        TaskId = c.Int(nullable: false),
                        UserId = c.String(),
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
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.Task_TaskInfo",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        TicketId = c.Int(nullable: false),
                        ProjectId = c.Int(nullable: false),
                        SprintId = c.Int(nullable: false),
                        TaskName = c.String(),
                        Description = c.String(),
                        Comments = c.String(),
                        StartDate = c.DateTime(nullable: false),
                        DueDate = c.DateTime(nullable: false),
                        WorkingHour = c.Int(nullable: false),
                        IsClosed = c.Boolean(nullable: false),
                        ClientId = c.Int(nullable: false),
                        Priority = c.Int(nullable: false),
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
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.Task_TestSite",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        SiteName = c.String(),
                        Description = c.String(),
                        URL = c.String(),
                        TestingPerson = c.String(),
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
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.Task_TicketCategory",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        CategoryName = c.String(),
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
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.Task_TicketFwdMapping",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        CategoryId = c.Int(nullable: false),
                        UserId = c.String(),
                        UserName = c.String(),
                        Status = c.String(),
                    })
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.Task_Tickets",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        Title = c.String(),
                        ProjectId = c.Int(nullable: false),
                        CategoryId = c.Int(nullable: false),
                        ModuleId = c.Int(nullable: false),
                        Description = c.String(),
                        Priority = c.Int(nullable: false),
                        DepartmentId = c.Int(nullable: false),
                        ClosedDate = c.DateTime(nullable: false),
                        ClientId = c.Int(nullable: false),
                        Url = c.String(),
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
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.Task_TicketsAttachment",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        TicketId = c.Int(nullable: false),
                        FileName = c.String(),
                        FileType = c.String(),
                        Size = c.Int(nullable: false),
                        Path = c.String(),
                        File = c.Binary(),
                        ImgUrl = c.String(),
                    })
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.Task_TicketUsers",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        UserId = c.String(),
                        TicketId = c.Int(nullable: false),
                    })
                .PrimaryKey(t => t.Id);
            
            AddColumn("dbo.CRM_Client", "HasAppsService", c => c.Boolean(nullable: false));
            AddColumn("dbo.CRM_Client", "HasWebPortal", c => c.Boolean(nullable: false));
            AddColumn("dbo.CRM_Client", "HasSMS", c => c.Boolean(nullable: false));
            AddColumn("dbo.CRM_Client", "DefaultDbId", c => c.Int());
        }
        
        public override void Down()
        {
            DropColumn("dbo.CRM_Client", "DefaultDbId");
            DropColumn("dbo.CRM_Client", "HasSMS");
            DropColumn("dbo.CRM_Client", "HasWebPortal");
            DropColumn("dbo.CRM_Client", "HasAppsService");
            DropTable("dbo.Task_TicketUsers");
            DropTable("dbo.Task_TicketsAttachment");
            DropTable("dbo.Task_Tickets");
            DropTable("dbo.Task_TicketFwdMapping");
            DropTable("dbo.Task_TicketCategory");
            DropTable("dbo.Task_TestSite");
            DropTable("dbo.Task_TaskInfo");
            DropTable("dbo.Task_TaskAssign");
            DropTable("dbo.Task_TaskActivityLog");
            DropTable("dbo.Task_Sprint");
            DropTable("dbo.Task_ProjectUsers");
            DropTable("dbo.Task_Project");
            DropTable("dbo.Task_Notifications");
            DropTable("dbo.Task_Modules");
            DropTable("dbo.CRM_MeetingPersons");
            DropTable("dbo.CRM_Meeting");
            DropTable("dbo.Task_Comments");
            DropTable("dbo.Task_BugAttachment");
            DropTable("dbo.Task_Bug");
        }
    }
}
