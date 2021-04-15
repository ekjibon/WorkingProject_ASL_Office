using OEMS.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Service.Interface
{
   public interface IService<TEntity> where TEntity : class
    {
        bool Add(TEntity entity);
        bool AddRange(IEnumerable<TEntity> entities);
        bool Update(TEntity entity);
        bool UpdateRange(IEnumerable<TEntity> entities);
        bool Remove(long id);
        bool RemoveRange(List<long> ids);

        TEntity Get(long id);
        TEntity SingleOrDefault(Expression<Func<TEntity, bool>> filter);
        IEnumerable<TEntity> GetAll();
        IEnumerable<TEntity> Filter(Expression<Func<TEntity, bool>> filter, Func<IQueryable<TEntity>, IOrderedQueryable<TEntity>> orderBy = null, string[] Children=null);
        IEnumerable<TEntity> GetByPage(int pageno, int pagesize);


        CommonResponse getPageResponse(int pageno, int pagesize);
        CommonResponse Filter(int pageno, int pagesize, Expression<Func<TEntity, bool>> filter, Func<IQueryable<TEntity>, IOrderedQueryable<TEntity>> orderBy = null);
        CommonResponse getResponseBySp(string SpName);
        CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues);

    }
}
