using OEMS.Models;
using OEMS.Repository.Helpers;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Reflection;

namespace OEMS.Repository.Repositories
{
    public class CommonRepository 
    {
        public CommonResponse getResponseBySp(string SpName)
        {
            DataTable result = SqlHelper.ExecuteDataTable(ConStr, SpName, null);
            CommonResponse cr = new CommonResponse(result.Rows.Count > 0 ? HttpStatusCode.Accepted : HttpStatusCode.NoContent);
            cr.pageno = 0;
            cr.totalcount = 0;
            cr.totalSum = 0;
            cr.message = string.Empty;

            List<object> _obj = new List<object>();
            //_obj.Add(result.Rows[0]);
            //foreach (DataRow row in result.Rows[0])
            //{
            ////    _obj.Add(row.Table); // = result.AsEnumerable().Select(e => e.Table).ToList();
            ////}

            //foreach (DataRow row in result.Rows)
            //{
            //    T item = GetItem<T>(row);
            //    data.Add(item);
            //}
            //cr.Results = ConvertDataTable<object> result.AsEnumerable().ToList();

            //cr.Results = result.Rows[0].Table..AsEnumerable().ToList();
            cr.results = result;
            return cr;
        }
        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            try
            {
                //DataTable result = SqlHelper.ExecuteDataTable(ConStr, SpName, parameterValues);
                DataTable result = SqlHelper.ExecuteDataTable(ConStr, SpName, parameterValues);
                CommonResponse cr = new CommonResponse(result.Rows.Count > 0 ? HttpStatusCode.Accepted : HttpStatusCode.NoContent);
                cr.pageno = 0;
                cr.totalcount = 0;
                cr.totalSum = 0;
                cr.message = string.Empty;
                cr.results = result;
                return cr;
            }
            catch (Exception ex)
            {

                CommonResponse cr = new CommonResponse(HttpStatusCode.BadRequest);
                cr.results = null;
                cr.HasError = true;
                cr.message = ex.Message;
                return cr;
            }
           
        }

        public DataTable GetDatatableBySQL(string strSQL, Dictionary<string, string> WhereClauses, SqlParameter[] sqlParameterlist)
        {
            strSQL = strSQL.Trim(',');
            strSQL += " WHERE ";//  Set Where Clause
            foreach (var item in WhereClauses)
            {
                strSQL += " " + item.Key + " = " + item.Value;
                if (!WhereClauses.LastOrDefault().Equals(item))
                {
                    strSQL += " AND ";
                }
            }
            try
            {

                DataTable dt  = SqlHelper.ExecuteDataTable(ConStr, CommandType.Text, strSQL, sqlParameterlist);
                return dt;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                throw ex;
            }
        }

        public DataTable GetBySp(string SpName)
        {
            try
            {
                DataTable result = SqlHelper.ExecuteDataTable(ConStr, SpName);
                return result;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                throw ex;
            }
           
        }
        public DataTable GetBySpWithParam(string SpName, params object[] parameterValues)
        {
            try   
            {
                //SqlHelper.SqlDbType.Structured
                DataTable result = SqlHelper.ExecuteDataTable(ConStr, SpName, parameterValues);
                //string qry = SqlHelper.ToQuery( SpName, parameterValues);
                return result;
            } 
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                throw ex;
            }
        }
        public DataTable GetBySpWithParam(string SpName, params SqlParameter[] parameterValues)
        {
            try
            {
                //SqlHelper.SqlDbType.Structured
                DataTable result = SqlHelper.ExecuteDataTable(ConStr, CommandType.StoredProcedure, SpName, parameterValues);
                //string qry = SqlHelper.ToQuery( SpName, parameterValues);
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public DataSet GetDatasetBySp(string SpName, params object[] paramValues)
        {
            try
            {
                DataSet result = SqlHelper.ExecuteDataset(ConStr, SpName, paramValues);                   
                return result;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                throw ex;
            }
        } 
        public CommonResponse getDatasetResponseBySp(string SpName, params object[] paramValues)
        {
            try
            {

                DataSet result = SqlHelper.ExecuteDataset(ConStr, SpName, paramValues);
                CommonResponse cr = new CommonResponse(result.Tables.Count > 0 ? HttpStatusCode.OK : HttpStatusCode.NoContent);
                cr.results = result;
                cr.pageno = 0;
                cr.totalcount = 0;
                cr.totalSum = 0;
                cr.message = string.Empty;
                cr.results = result;
                return cr;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                CommonResponse cr = new CommonResponse(HttpStatusCode.BadRequest);
                cr.results = null;
                cr.HasError = true;
                cr.message = ex.Message;
                return cr;
            }

        }
        public CommonResponse getDataTableResponseBySp(int pageno,int pagesize, string SpName, params object[] paramValues)
        {
            try
            {
                DataTable result = SqlHelper.ExecuteDataTable(ConStr, SpName, paramValues);
                CommonResponse cr = new CommonResponse(result.Rows.Count > 0 ? HttpStatusCode.OK : HttpStatusCode.NoContent);
                cr.results = result.Select().Skip(pagesize * (pageno - 1)).Take(pagesize).CopyToDataTable();
                cr.pageno = pageno;
                cr.pagesize = pagesize;
                cr.totalcount = result.Rows.Count;
                cr.totalSum = 0;
                cr.message = cr.totalcount + " Data Found";
               
                return cr;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                CommonResponse cr = new CommonResponse(HttpStatusCode.BadRequest);
                cr.results = null;
                cr.HasError = true;
                cr.message = ex.Message;
                return cr;
            }

        }
        public object GetScalarValueBySP(string SPName)
        {
            object objValue;
            try
            {
                objValue = SqlHelper.ExecuteScalar(ConStr, CommandType.StoredProcedure, SPName);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                throw ex;
            }
            return objValue;
        }
        public DataTable GetDatatableBySQL(string SQL)
        {
            DataTable objValue;
            try
            {
                objValue = SqlHelper.ExecuteDataTable(ConStr, CommandType.Text, SQL);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                throw ex;
            }
            return objValue;
        }
        public dynamic ExecuteSQL(string SQL)
        {
            dynamic objValue;
            try
            {
                objValue = SqlHelper.ExecuteNonQuery(ConStr, CommandType.Text, SQL);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                throw ex;
            }
            return objValue;
        }
        public DataTable ExecuteSQLQUERY(string SQL)
        {
            dynamic objValue;
            try
            {
                objValue = SqlHelper.ExecuteDataTable(ConStr, CommandType.Text, SQL);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                throw ex;
            }
            return objValue;
        }
        public dynamic ExecuteSQL(string SQL, params SqlParameter[] commandParameters)
        {
            dynamic objValue;
            try
            {
                objValue = SqlHelper.ExecuteNonQuery(ConStr, CommandType.Text, SQL,commandParameters);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                throw ex;
            }
            return objValue;
        }
        public bool IsExist(string TableName,string Col, string value)
        {
            bool isExist = true;
            DataTable dtResults = new DataTable();
            try
            {
                string strSQL = "SELECT TOP 1 "+ Col +" FROM " + TableName + " WHERE " + Col + " = " + "'"+value+"'";
                dtResults = SqlHelper.ExecuteDataTable(ConStr, CommandType.Text, strSQL);
                isExist = dtResults.Rows.Count > 0 ? true : false;
            }
            catch (Exception )
            {
                isExist = true;
            }
            return isExist;
        }
        public bool IsExist(string TableName, string Col, int value)
        {
            bool isExist = true;
            DataTable dtResults = new DataTable();
            try
            {
                string strSQL = "SELECT TOP 1 " + Col + " FROM " + TableName + " WHERE " + Col + " = " + value ;
                dtResults = SqlHelper.ExecuteDataTable(ConStr, CommandType.Text, strSQL);
                isExist = dtResults.Rows.Count > 0 ? true : false;
            }
            catch (Exception )
            {
                isExist = true;
            }
            return isExist;
        }
        public bool IsExist(string TableName, string WhereClause)
        {
            bool isExist = true;
            DataTable dtResults = new DataTable();
            try
            {
                string strSQL = "SELECT TOP 1 * FROM " + TableName + " WHERE " + WhereClause;
                dtResults = SqlHelper.ExecuteDataTable(ConStr, CommandType.Text, strSQL);
                isExist = dtResults.Rows.Count > 0 ? true : false;
            }
            catch (Exception )
            {
                isExist = true;
            }
            return isExist;
        }
        public bool WriteLog(int Vid, int SId, int ShId, int ClassId, int GroupId, int MainExamId,string PID, string Msg, string AddBy,int SectionId)
        {
          
            string strSQL = @"INSERT INTO [dbo].[Res_ExamProccessLog]
           ([VersionID],[SessionId],[ShiftID],[ClassId],[GroupId],[MainExamId],[PId],[LogTime],[Msg],[AddBy],[SectionId])
     VALUES(" + Vid + "," + SId + "," + ShId + "," + ClassId + "," + GroupId + "," + MainExamId + ",'" + PID + "',GETDATE(),'" + Msg + "','" + AddBy + "' ,'"+ SectionId + "' )";
            bool isExist = true;
            DataTable dtResults = new DataTable();
            try
            {

                int res = SqlHelper.ExecuteNonQuery(ConStr, CommandType.Text, strSQL);
                isExist = res > 0 ? true : false;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return isExist;
        }
        public bool WriteLog( int SId, int ClassId,  int MainExamId,int SubjectId, string PID, string Msg, string AddBy,int SectionId)
        {

            string strSQL = @"INSERT INTO [dbo].[Res_ExamProccessLog]
           ([SessionId],[ClassId],[MainExamId],[SubjectId],[PId],[LogTime],[Msg],[AddBy],[SectionId])
     VALUES(" + SId + ","  + ClassId + "," + MainExamId + ",'" + SubjectId + "','" + PID + "',GETDATE(),'" + Msg + "','" + AddBy + "','"+ SectionId + "' )";
            bool isExist = true;
            DataTable dtResults = new DataTable();
            try
            {

                int res = SqlHelper.ExecuteNonQuery(ConStr, CommandType.Text, strSQL);
                isExist = res > 0 ? true : false;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return isExist;
        }
        public bool WriteLog(string Message, string Status)
        {

            string strSQL = $"INSERT INTO [dbo].[SystemLogs]([Msg],[LogTime],[Status]) " + 
                            "VALUES('"+ Message + "' ,GETDATE(),'"+Status+"')";

             bool isExist = true;
            DataTable dtResults = new DataTable();
            try
            {

                int res = SqlHelper.ExecuteNonQuery(ConStr, CommandType.Text, strSQL);
                isExist = res > 0 ? true : false;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return isExist;
        }
      
        /// <summary>
        /// Dynamic Update Table by Raw Query
        /// </summary>
        /// <param name="ShiftId"></param>
        /// <param name="ClassId"></param>
        /// <param name="GroupId"></param>
        /// <returns></returns>
        public bool UpdateBySql( string TableName,Dictionary<string,string> Columns, Dictionary<string, string> WhereClauses, params SqlParameter[] sqlParameterlist )
        {
            string strSQL = @"UPDATE " + TableName + " SET ";
            foreach (var item in Columns)
            {
                strSQL += " " + item.Key + " = " + item.Value + " ,";
            }
            strSQL =  strSQL.Trim(',');
            strSQL += " WHERE ";//  Set Where Clause


            foreach (var item in WhereClauses)
            {
                
                strSQL += " " + item.Key + " = " + item.Value ;
                if (!WhereClauses.LastOrDefault().Equals(item) )
                {
                    strSQL += " AND ";
                }
            }
            try
            {
                int Res = SqlHelper.ExecuteNonQuery(ConStr, CommandType.Text, strSQL,sqlParameterlist);
                return Res > 0;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public string ConStr
        {
            get
            {
                return ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString();
            }
        }
        public static List<T> ConvertDataTable<T>(DataTable dt)
        {
            try
            {
            List<T> data = new List<T>();
            foreach (DataRow row in dt.Rows)
            {
                T item = GetItem<T>(row);
                data.Add(item);
            }
                return data;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public static T GetItem<T>(DataRow dr)
        {
            try
            {
            Type temp = typeof(T);
            T obj = Activator.CreateInstance<T>();
            foreach (DataColumn column in dr.Table.Columns)
            {
                foreach (PropertyInfo pro in temp.GetProperties())
                {
                    if (pro.Name == column.ColumnName)
                    {
                        var aa = dr[column.ColumnName];
                        if (dr[column.ColumnName] == DBNull.Value)
                        {
                            if (column.DataType.Name == "Int32")
                            {
                                pro.SetValue(obj, 0, null);
                            }
                            else if (column.DataType.Name == "Decimal")
                            {
                                pro.SetValue(obj, Convert.ToDecimal(0.00), null);
                            }
                            else if (column.DataType.Name == "String")
                            {
                                pro.SetValue(obj, null, null);
                            }
                            else if (column.DataType.Name == "DateTime")
                            {
                                pro.SetValue(obj, null, null);
                            }
                            else if (column.DataType.Name == "Boolean")
                            {
                                pro.SetValue(obj, false, null);
                            }
                            else if (column.DataType.Name == "Byte[]")
                            {
                                pro.SetValue(obj, null, null);
                            }
                            else
                            {
                                pro.SetValue(obj, dr[column.ColumnName], null);
                            }
                        }
                        else
                        {
                            pro.SetValue(obj, dr[column.ColumnName], null);
                        }
                    }
                    else
                        continue;
                }
            }
            return obj;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
