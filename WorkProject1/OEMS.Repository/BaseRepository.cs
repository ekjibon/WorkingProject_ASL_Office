using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;
using OEMS.Repository.Interface;
using System.Data.Entity;
using OEMS.Models;
using OEMS.Models.Constant;
using System.Net;
using OEMS.Repository.Helpers;
using System.Configuration;
using System.Data;
using System.Reflection;
using System.Data.Entity.Validation;
using System.IO;
using System.Web;
using System.Diagnostics;

namespace OEMS.Repository
{
    public class BaseRepository<TEntity> :  IRepository<TEntity>  where TEntity : class 
    {    
        private DbContext context ;
        public BaseRepository(DbContext context)
        {
            this.context = context;
           // this.context = new ModelDbContext();
        }
        ~BaseRepository()
        {
            context = null;
        }
        public DbSet<TEntity> Set
        {
             get { return this.context.Set<TEntity>(); }

            
        }

        public DbContext contexts() {
            return this.context;
        }

        #region Entity Response Method         
        public bool Add(TEntity entity)
        {
            try
            {
                using (var _context = new ModelDbContext())
                {
                                    
                  
                    _context.Set<TEntity>().Add(entity);
                    int res = _context.SaveChanges();
                    if (res > 0)
                    {
                        string ClassName = typeof(TEntity).GetAttributeValue((ClassName e) => e.Name);
                        LogHelper.Information(ClassName + " Added Successfully.");
                        return true;
                    }
                    return false;
                }

            }
            catch (DbEntityValidationException e)
            {              
                LogHelper.Error(e);               
                throw e;
            }
            catch (Exception ex )
            {
                LogHelper.Error(ex);
                throw ex;
            }
            
        }

        public bool AddRange(IEnumerable<TEntity> entities)
        {
            try
            {
                using (var _context = new ModelDbContext())
                {
                    _context.Set<TEntity>().AddRange(entities);
                    int res = _context.SaveChanges();
                    if (res > 0)
                    {
                        string ClassName = typeof(TEntity).GetAttributeValue((ClassName e) => e.Name);
                        LogHelper.Information(ClassName + " Added Successfully.");
                        return true;
                    }
                    return false;
                }

            }
            catch (DbEntityValidationException e)
            {
                LogHelper.Error(e);
                throw e;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                throw ex;
            }
           
            
        }
        public bool Update(TEntity entity)
        {
            try
            {
                using (var _context = new ModelDbContext())
                {
                    // _context.Set<TEntity>().Attach(entity);
                    // _context.Database.Log = logInfo => FileLogger.Log(logInfo);
                    _context.Entry(entity).State = EntityState.Modified;
                    int res = _context.SaveChanges();
                    if (res > 0)
                    {
                        string ClassName = typeof(TEntity).GetAttributeValue((ClassName e) => e.Name);
                        LogHelper.Information(ClassName + " Updated Successfully.");
                        return true;
                    }
                    return false;


                    //_context.Entry(entity).State = EntityState.Detached;   // Need to add this line Shahin July 15
                }
            }
            catch (DbEntityValidationException e)
            {
                LogHelper.Error(e);
                throw e;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                throw ex;
            }
            //this.context.Entry(entity).State = EntityState.Modified; 
            //var res = context.SaveChanges() > 0;
            //this.context.Entry(entity).State = EntityState.Detached;
            //return res;    
        }
        public TEntity FirstOrDefault(Expression<Func<TEntity, bool>> filter)
        {
            //context.Database.Log = logInfo => FileLogger.Log(logInfo);
            return Set.AsNoTracking<TEntity>().SingleOrDefault(filter);  //Writen By Shahin July152017

        }     
        public bool UpdateRange(IEnumerable<TEntity> entities)
        {
            try
            {
                foreach (var item in entities)
                {
                    context.Entry(item).State = EntityState.Modified;
                }
                
                int res = context.SaveChanges();
                if (res > 0)
                {
                    string ClassName = typeof(TEntity).GetAttributeValue((ClassName e) => e.Name);
                    LogHelper.Information(ClassName + " Updated Successfully.");
                    return true;
                }
                return false;

            }
            catch (DbEntityValidationException e)
            {
                LogHelper.Error(e);
                throw e;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                throw ex;
            }
                       
        }
        public TEntity Get(long id)
        {
            
            return Set.Find(id);
        }
        public TEntity SingleOrDefault(Expression<Func<TEntity, bool>> filter){
           
            return Set.AsNoTracking().SingleOrDefault(filter);   
        }     
        public IEnumerable<TEntity> GetAll()
        {

            var query = context.Set<TEntity>().AsNoTracking().AsQueryable();

            return query;
        }
        public IEnumerable<TEntity> Filter(Expression<Func<TEntity, bool>> filter, Func<IQueryable<TEntity>, IOrderedQueryable<TEntity>> orderBy = null ,string[] Children=null)
        {
            try
            {
                var query = context.Set<TEntity>().AsNoTracking().AsQueryable();
                if (Children != null)
                {
                    for (int i = 0; Children.Count() > i; i++)
                    {
                        query = query.Include(Children[i]);
                    }
                    //switch (Children.Count())
                    //{
                    //    case 1:
                    //        query = query.Include(Children[0]);
                    //        break;
                    //    case 2:
                    //        query = query.Include(Children[0]).Include(Children[1]);
                    //        break;
                    //    default:
                    //        break;
                    //}
                }

                if (filter != null)
                {
                    query = query.Where(filter);
                }

                if (orderBy != null)
                {
                    query = orderBy(query);
                }
                return query;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                throw;
            }
           
        }
        public IEnumerable<TEntity> GetByPage(int pageno,int pagesize)
        {
            return Set.ToList().Skip(pagesize * (pageno - 1)).Take(pagesize).ToList();
        }

        public bool Remove(TEntity entity)
        {
            try
            {
                
                    Set.Attach(entity);
                    Set.Remove(entity);
                    int res = context.SaveChanges();
                    if (res > 0)
                    {
                        string ClassName = typeof(TEntity).GetAttributeValue((ClassName e) => e.Name);
                        LogHelper.Information(ClassName + " Removed Successfully.");
                        return true;
                    }
                    return false;

                
            }
            catch (DbEntityValidationException e)
            {
                LogHelper.Error(e);
                throw e;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                throw ex;
            }
            
        }


        public bool RemoveRange(IEnumerable<TEntity> entities)
        {

            try
            {

                Set.Local.Clear();
                foreach (var item in entities)
                {
                    Set.Attach(item);
                    Set.Remove(item);
                }
                int res = context.SaveChanges();
                if (res > 0)
                {
                    string ClassName = typeof(TEntity).GetAttributeValue((ClassName e) => e.Name);
                    LogHelper.Information(ClassName + " Removed Successfully.");
                    return true;
                }
                return false;


            }
            catch (DbEntityValidationException e)
            {
                LogHelper.Error(e);
                throw e;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                throw ex;
            }

        }
        #endregion

        #region All Common Response Method

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
           
            // Set.Local.Clear();
            CommonResponse cr = new CommonResponse();
            List<TEntity> result = new List<TEntity>();
            IEnumerable<TEntity> _res;
            if (pagesize != -1)
            {
                result = Set.AsNoTracking().ToList().Skip(pagesize * (pageno - 1)).Take(pagesize).ToList();
                cr.results = result;
            }
            else
            {
                _res = Set.AsNoTracking();
                cr.results = _res;
               

            }
            cr.httpStatusCode = HttpStatusCode.OK;
            //CommonResponse cr = new CommonResponse(result.Count() > 0 ? HttpStatusCode.OK : HttpStatusCode.NoContent);
            cr.pageno = pageno;
            cr.pagesize = pagesize;
            cr.totalcount = GetCount();
            cr.totalSum = 0;
            cr.message = string.Empty;
           // cr.results = result;

            return cr;
        }
        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<TEntity, bool>> filter, Func<IQueryable<TEntity>, IOrderedQueryable<TEntity>> orderBy = null)
        {

            var result = context.Set<TEntity>().AsQueryable(); // for Filter 

            if (filter != null)
            {
                result = result.Where(filter);//.Skip(pagesize * (pageno - 1)).Take(pagesize); // filter with limit-offset
            }

            if (orderBy != null)
            {
                result = orderBy(result);
            }
            if(pagesize != -1)
            {
                result = result.Select(e=>e).Skip(pagesize * (pageno - 1)).Take(pagesize);
            }             
            CommonResponse cr = new CommonResponse(result.Count() > 0 ? HttpStatusCode.OK : HttpStatusCode.NoContent);
            cr.pageno = pageno;
            cr.pagesize = pagesize;
            cr.totalcount = filter!=null? result.Count(): GetCount();
            cr.totalSum = 0; cr.message = string.Empty;
            cr.results = result.AsNoTracking().ToList();
           return cr;
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            try
            {
                DataTable result = SqlHelper.ExecuteDataTable(ConStr, SpName, null);
                List<TEntity> lstData = ConvertDataTable<TEntity>(result);
                CommonResponse cr = new CommonResponse(lstData.Count > 0 ? HttpStatusCode.Accepted : HttpStatusCode.NoContent);
                cr.pageno = 0;
                cr.totalcount = 0;
                cr.totalSum = 0;                  
                cr.message = string.Empty;
                cr.results = lstData;
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
        public CommonResponse getDatasetResponseBySp(string SpName)
        {
            try
            {
             
                DataSet result = SqlHelper.ExecuteDataset(ConStr, SpName, null);                    
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

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            try
            {
                DataTable result = SqlHelper.ExecuteDataTable(ConStr, SpName, parameterValues);
                List<TEntity> lstData = ConvertDataTable<TEntity>(result); 
                CommonResponse cr = new CommonResponse(lstData.Count > 0 ? HttpStatusCode.Accepted : HttpStatusCode.NoContent);
                cr.pageno = 0;
                cr.totalcount = 0;
                cr.totalSum = 0;
                cr.message = string.Empty;
                cr.results = lstData;
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

        
        #endregion

        #region Private Method
        public string ConStr
        {
            get
            {
                return ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString();
            }

        }
        private static List<T> ConvertDataTable<T>(DataTable dt)
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
                    if (pro.Name == column.ColumnName) {
                        var aa = dr[column.ColumnName];
                        if (dr[column.ColumnName] == DBNull.Value) {
                            if (column.DataType.Name == "Int32")
                            {
                                pro.SetValue(obj, 0, null);
                            }
                           else if (column.DataType.Name == "Decimal")
                            {
                                pro.SetValue(obj,Convert.ToDecimal(0.00), null);
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
                            else {
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
        public int GetCount()
        {
            return Set.Count();
        }
        #endregion 
        // Uses >>>   _context.Database.Log = logInfo => FileLogger.Log(logInfo);
        //public class FileLogger
        //{
        //    public static void Log(string logInfo)
        //    {



        //        var path = HttpContext.Current.Server.MapPath("~");
        //        ///File.AppendAllText(path + "/Logger.txt", logInfo);
        //    }
        //}
    }
}
