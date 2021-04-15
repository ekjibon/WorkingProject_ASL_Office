using OEMS.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Repository.Interface
{
   
        public interface IRepository<TEntity> where TEntity : class
        {
            bool Add(TEntity entity); 
            bool AddRange(IEnumerable<TEntity> entities);
            bool Update(TEntity entity);
            bool UpdateRange(IEnumerable<TEntity> entities);
            bool Remove(TEntity entity);
            bool RemoveRange(IEnumerable<TEntity> entities);

            TEntity Get(long id);
            TEntity SingleOrDefault(Expression<Func<TEntity, bool>> filter);
            IEnumerable<TEntity> GetAll();
            IEnumerable<TEntity> Filter(Expression<Func<TEntity, bool>> filter, Func<IQueryable<TEntity>, IOrderedQueryable<TEntity>> orderBy = null, string[] Children =null);
            IEnumerable<TEntity> GetByPage(int pageno,int pagesize);

         
            CommonResponse getPageResponse(int pageno, int pagesize);
            CommonResponse Filter(int pageno, int pagesize, Expression<Func<TEntity, bool>> filter, Func<IQueryable<TEntity>, IOrderedQueryable<TEntity>> orderBy = null);
            CommonResponse getResponseBySp(string SpName);
            CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues);
            
           
    }
    
}
