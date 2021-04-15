using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.AppData
{
    public class Constant
    {
        public static string SUCCESS { get { return "Request Successful."; } }
        public static string SAVED { get { return "Save Successfully !"; } }
        public static string NOT_FOUND { get { return "No Data Found !"; } }
        public static string SAVED_ERROR { get { return "Data Not Save."; } }
        public static string UPDATED_ERROR { get { return "Data Not Updated."; } }
        public static string FAILED { get { return "Request Failed."; } }
        public static string UPDATED { get { return "Updated Successfully !"; } }
        public static string DELETED { get { return "Deleted Successfully !"; } }
        public static string DELETE_ERROR { get { return "Data not Deleted"; } }
        public static string INVAILD_DATA { get { return "Invaild Data !"; } }
        public static string DATA_NOT_FOUND { get { return "No Data Found !"; } }
        public static string DUPLICATE { get { return "Data is Duplicated!"; } }
        public static string DATA_EXISTS { get { return "Data is Exist."; } }

        public static string Encrypt_Key { get { return "JHGFD123"; } }
        public static string UPDATE_FROM_COLLECTION { get { return "CU"; } }

        public static string TSUCCESS { get { return "success"; } }
        public static string TERROR { get { return "error"; } }
        public static string TINFO { get { return "info"; } }
        public const string NoImage = "~/assets/global/img/userimg.png";

        public static string GetBkashStatus(string Code)
        {


            switch (Code)
            {
                case "0010":
                case "0011":
                    return "Transaction Pending";
                case "0100":
                    return "Transaction Reversed";
                case "0111":
                    return "Transaction Failure";
                case "1001":
                    return "Invalid Mobile Number";
                case "1002":
                    return "Invalid trxID";
                case "1003":
                    return "Username or Password is incorrect";
                case "1004":
                    return "trxID is not related to this username";
                case "2000":
                    return "User does not have access to this module";
                case "2001":
                    return "User date time request is exceeded of the defined limit";
                case "3000":
                    return "Missing fields Error";
                case "4001":
                    return "Server Busy.Please Try after 5 minutes.";
                case "9999":
                    return "Could not process request.";
                default:
                    return string.Empty;
            }

        }
        //public static Byte[] image(dynamic data)
        //{
        //    Byte[] data_image;
        //    if (data != null)
        //    {
        //        Image bm = Image.FromStream(data.InputStream);
        //        Bitmap result = new Bitmap(100, 100);
        //        using (Graphics g = Graphics.FromImage((Image)result))
        //            g.DrawImage(bm, 0, 0, 100, 100);
        //        using (var memoryStream = new MemoryStream())
        //        {
        //            result.Save(memoryStream, ImageFormat.Bmp);
        //            return data_image = memoryStream.ToArray();
        //        }
        //    }
        //    else
        //    {
        //        Image bm =Image.FromFile("~/assets/global/img/userimg.png");
        //        Bitmap result = new Bitmap(100, 100);
        //        using (Graphics g = Graphics.FromImage((Image)result))
        //            g.DrawImage(bm, 0, 0, 100, 100);
        //        using (var memoryStream = new MemoryStream())
        //        {
        //            result.Save(memoryStream, ImageFormat.Bmp);
        //            return data_image = memoryStream.ToArray();
        //        }
        //    }


        //    //return null;
        //}

    }
}
