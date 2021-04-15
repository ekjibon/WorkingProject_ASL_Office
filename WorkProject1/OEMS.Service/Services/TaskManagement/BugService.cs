using OEMS.Models.Model;
using OEMS.Service.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using OEMS.Models;
using System.Linq.Expressions;
using OEMS.Repository.Repositories;
using UI.Admin.Models.Task;

namespace OEMS.Service.Services
{
    public class BugService : IService<Bug>
    {
        private BugRepository bugRepository;

        public BugService()
        {
            bugRepository = new BugRepository();
        }
        public bool Add(Bug entity)
        {
        // entity.Id =   ( Convert.ToInt32( SessionRepository.GetAll().ToList().Select(e => e.Id).Max()) + 1).ToString();
          return  bugRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<Bug> entities)
        {
            return bugRepository.AddRange(entities);
        }

        public bool Update(Bug entity)
        {
            return bugRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<Bug> entities)
        {
            return bugRepository.AddRange(entities);
        }

        public IEnumerable<Bug> Filter(Expression<Func<Bug, bool>> filter, Func<IQueryable<Bug>, IOrderedQueryable<Bug>> orderBy = null, string[] Children = null)
        {
            return bugRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<Bug, bool>> filter, Func<IQueryable<Bug>, IOrderedQueryable<Bug>> orderBy = null)
        {
            return bugRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public Bug Get(long id)
        {
            return bugRepository.Get(id);
        }

        public IEnumerable<Bug> GetAll()
        {
            return bugRepository.GetAll();
        }

        public IEnumerable<Bug> GetByPage(int pageno, int pagesize)
        {
            return bugRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return bugRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return bugRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return bugRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            Bug entity = new Bug();
            entity = bugRepository.SingleOrDefault(e=>e.Id==id);
            return bugRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<Bug> entities = new List<Bug>();
            entities = bugRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return bugRepository.RemoveRange(entities);
        }

        public Bug SingleOrDefault(Expression<Func<Bug, bool>> filter)
        {
            return bugRepository.SingleOrDefault(filter);
        }

        

    }
}
