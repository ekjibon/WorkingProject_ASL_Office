using OEMS.Models.Constant;
using OEMS.Models.ViewModel;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Reflection;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;

namespace UI.WebClients
{
    public  class Uitility
    {

        public static int CalculateSmsPart(string text)
        {
            if (IsEnglishText(text))
            {
                return text.Length <= 160 ? 1 : Convert.ToInt32(Math.Ceiling(Convert.ToDouble(text.Length) / 153));
            }

            return text.Length <= 70 ? 1 : Convert.ToInt32(Math.Ceiling(Convert.ToDouble(text.Length) / 67));
        }

        public static int GetSmslength(string text)
        {
            return Convert.ToInt32(Math.Ceiling(Convert.ToDouble(text.Length) ));
        }

        public static byte[] ToByteFromPath(string path)
        {
            using (Stream inputStream = new FileStream(path, FileMode.Open))
            {
                MemoryStream memoryStream = inputStream as MemoryStream;
                if (memoryStream == null)
                {
                    memoryStream = new MemoryStream();
                    inputStream.CopyTo(memoryStream);
                }
                return memoryStream.ToArray();
            }
        }
        public static bool IsEnglishText(string text)
        {
            return Regex.IsMatch(text, @"^[\u0000-\u007F]+$");
        }

        public static DateTime StringToDateTime(string Date)
        {
            try
            {

                if (string.IsNullOrEmpty(Date))
                {
                    return DateTime.Now.AddMinutes(1);
                }

                int Year = Convert.ToInt32(Date.Substring(0, 4));
                int Month = Convert.ToInt32(Date.Substring(4, 2));
                int Day = Convert.ToInt32(Date.Substring(6, 2));
                int HH = Convert.ToInt32(Date.Substring(8, 2));
                int MM = Convert.ToInt32(Date.Substring(10, 2));

                return new DateTime(Year, Month, Day, HH, MM, 0);
            }
            catch (Exception ex)
            {

                throw ex;
            }


        }
        public static byte[] ToByte(HttpPostedFile img)
        {
            using (Stream inputStream = img.InputStream)
            {
                MemoryStream memoryStream = inputStream as MemoryStream;
                if (memoryStream == null)
                {
                    memoryStream = new MemoryStream();
                    inputStream.CopyTo(memoryStream);
                }
                return memoryStream.ToArray();
            }
        }


        public static byte[] ToByte(HttpPostedFileBase img)
        {
            using (Stream inputStream = img.InputStream)
            {
                MemoryStream memoryStream = inputStream as MemoryStream;
                if (memoryStream == null)
                {
                    memoryStream = new MemoryStream();
                    inputStream.CopyTo(memoryStream);
                }
                return memoryStream.ToArray();
            }
        }
        public static int GetMobileGateway(string MobileNo)
        {
            try
            {
                int res = -1;
                if (isVaildMobileNo(MobileNo))
                {
                    string prefix = string.Empty;
                    if (MobileNo.Length == 11)
                    {
                        prefix = MobileNo.Substring(0, 3);
                    }
                    else if (MobileNo.Length == 13)
                    {
                        prefix = MobileNo.Substring(2, 3);
                    }

                    switch (prefix)
                    {
                        case "016":
                            res = (int)Enums.OPERATOR.AIRTEL;
                            break;
                        case "019":
                            res = (int)Enums.OPERATOR.BANGLALINK;
                            break;
                        case "017":
                            res = (int)Enums.OPERATOR.GP;
                            break;
                        case "018":
                            res = (int)Enums.OPERATOR.ROBI;
                            break;
                        case "015":
                            res = (int)Enums.OPERATOR.TELETALK;
                            break;

                        default:
                            res = -1;
                            break;
                    }


                }
                return res;
            }
            catch (Exception ex)
            {

                throw ex;
            }


        }

        private static bool isVaildMobileNo(string mobileNo)
        {
            return Regex.IsMatch(mobileNo, @"^(?:88|01)?\d{11}\r?$");
        }

 
    
        public static string ViewToHtml(string viewToRender, ViewDataDictionary viewData, ControllerContext controllerContext)
        {
            var result = ViewEngines.Engines.FindView(controllerContext, viewToRender, null);

            StringWriter output;
            using (output = new StringWriter())
            {
                var viewContext = new ViewContext(controllerContext, result.View, viewData, controllerContext.Controller.TempData, output);
                result.View.Render(viewContext, output);
                result.ViewEngine.ReleaseView(controllerContext, result.View);
            }

            return output.ToString();
        }
        

        public static List<T> ConvertDataTable<T>(DataTable dt)
        {
            List<T> data = new List<T>();
            foreach (DataRow row in dt.Rows)
            {
                T item = GetItem<T>(row);
                data.Add(item);
            }
            return data;
        }
        private static T GetItem<T>(DataRow dr)
        {
            Type temp = typeof(T);
            T obj = Activator.CreateInstance<T>();

            foreach (DataColumn column in dr.Table.Columns)
            {
                foreach (PropertyInfo pro in temp.GetProperties())
                {
                    if (pro.Name == column.ColumnName)
                        pro.SetValue(obj, dr[column.ColumnName] == DBNull.Value ? string.Empty : dr[column.ColumnName], null);
                    else
                        continue;
                }
            }
            return obj;
        }

        public static DateTime ToDateTime(string Value, string format)
        {
            try
            {
                string[] val = Value.Split('-');
                if (format == "101")
                    return new DateTime(Convert.ToInt32(val[2]), Convert.ToInt32(val[1]), Convert.ToInt32(val[0]));
                else
                    return DateTime.Now;
            }
            catch (Exception ex)
            {

                throw ex;
            }
           
        }

    }
}