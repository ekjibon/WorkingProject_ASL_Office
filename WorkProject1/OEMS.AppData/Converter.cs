using Newtonsoft.Json;
using OEMS.Models.Constant;
using OEMS.Models.ViewModel;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Drawing.Imaging;

namespace OEMS.AppData
{
    public class Converter 
    {
        public static T ToJson<T>(string response)        {
            return JsonConvert.DeserializeObject<T>(response);
        }
        public static List<T> ToJsonList<T>(string response)
        {
            return JsonConvert.DeserializeObject<List<T>>(response);
        }
        
        
        
        public static System.Drawing.Image SetImageOpacity(System.Drawing.Image image, float opacity)
        {
            try
            {
                //create a Bitmap the size of the image provided  
                Bitmap bmp = new Bitmap(image.Width, image.Height);

                //create a graphics object from the image  
                using (Graphics gfx = Graphics.FromImage(bmp))
                {

                    //create a color matrix object  
                    ColorMatrix matrix = new ColorMatrix();

                    //set the opacity  
                    matrix.Matrix33 = opacity;

                    //create image attributes  
                    ImageAttributes attributes = new ImageAttributes();

                    //set the color(opacity) of the image  
                    attributes.SetColorMatrix(matrix, ColorMatrixFlag.Default, ColorAdjustType.Bitmap);

                    //now draw the image  
                    gfx.DrawImage(image, new Rectangle(0, 0, bmp.Width, bmp.Height), 0, 0, image.Width, image.Height, GraphicsUnit.Pixel, attributes);
                }
                return bmp;
            }
            catch (Exception ex)
            {

                throw ex;
            }
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


        public static SqlParameter ToSqlParameter(string ParameterName, DataTable dtt,string TypeNamed)
        {
            SqlParameter Obj = new SqlParameter(ParameterName, dtt);
            Obj.SqlDbType = SqlDbType.Structured;
            Obj.TypeName = TypeNamed;
            return Obj;
        }
    }
}
