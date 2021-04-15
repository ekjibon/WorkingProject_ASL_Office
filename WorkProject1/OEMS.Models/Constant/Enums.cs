
namespace OEMS.Models.Constant
{
     public class Enums
    {
        public enum EMAILTYPE
        {
            LEAVEAPPLY
        }
        public enum OEMSModule
        {
            HR_Payrol = 1,
            Attendence = 2,
            TaskManagement = 3,
            Invoice = 4,
            SMS = 5,
            Accounts =6,
            Inventory= 7,        
            User = 12,
         
        }


        public enum OPERATOR
        {
            AIRTEL = 1,
            BANGLALINK = 2,
            GP = 3,
            ROBI = 4,
            TELETALK = 5
        }

        public enum GATEWAY
        {
            AIRTEL = 1,
            BANGLALINK = 2,
            GP = 3,
            ROBI = 4,
            TELETALK = 5,
            BOOMCAST = 6
        }


        public enum PRIORITY
        {
            High = 1,
            Medium = 2,
            Low = 3
        }
        public enum HttpStatus
        {
            
         Unauthorized        =  401,
         Forbidden           = 403,
         Not_Found           = 404,
         Method_Not_Allowed  = 405,
         Not_Acceptable      = 406,
         Precondition_Failed = 412,
         Internal_Server_Error = 500,
         Not_Implemented      = 501,
         Bad_Gateway          = 502,
         No_Data = 601

        }

        public const string NoImage = "~/assets/global/img/userimg.png";
        public enum ExamName
        {
            PSC ,
            JSC,
            SSC,
            HSC
        }
        public enum AddressType
        {
            present,
            permanent
        }
        public enum CommonDropDown
        {
            Gender,
            MaritalStatus,
            BloodGroup,
            Religion,
            Club,
            InterestIn,
            Organization,
            MemberofClub,
            Participation
        }
        public enum TCStatues
        {
            A, //Approved
            P  //pendding
        }
        public enum LeaveType
        {
            TC, //TransferCertificate
            TM,  //TestiMonial
            CC  //Character Certificate
        }

        public enum DayType
        {
            Regular,
            Holiday,
            Weekend
        }

        public enum LeaveStatus
        {
            Approved,
            Pending,
            Cancel
        }

    }
}
