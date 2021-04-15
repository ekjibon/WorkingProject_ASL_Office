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
    public class SprintService : IService<Sprint>
    {
        private SprintRepository sprintRepository;

        public SprintService()
        {
            sprintRepository = new SprintRepository();
        }
        public bool Add(Sprint entity)
        {
        // entity.Id =   ( Convert.ToInt32( SessionRepository.GetAll().ToList().Select(e => e.Id).Max()) + 1).ToString();
          return  sprintRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<Sprint> entities)
        {
            return sprintRepository.AddRange(entities);
        }

        public bool Update(Sprint entity)
        {
            return sprintRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<Sprint> entities)
        {
            return sprintRepository.AddRange(entities);
        }

        public IEnumerable<Sprint> Filter(Expression<Func<Sprint, bool>> filter, Func<IQueryable<Sprint>, IOrderedQueryable<Sprint>> orderBy = null, string[] Children = null)
        {
            return sprintRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<Sprint, bool>> filter, Func<IQueryable<Sprint>, IOrderedQueryable<Sprint>> orderBy = null)
        {
            return sprintRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public Sprint Get(long id)
        {
            return sprintRepository.Get(id);
        }

        public IEnumerable<Sprint> GetAll()
        {
            return sprintRepository.GetAll();
        }

        public IEnumerable<Sprint> GetByPage(int pageno, int pagesize)
        {
            return sprintRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return sprintRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return sprintRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return sprintRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            Sprint entity = new Sprint();
            entity = sprintRepository.SingleOrDefault(e=>e.Id==id);
            return sprintRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<Sprint> entities = new List<Sprint>();
            entities = sprintRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return sprintRepository.RemoveRange(entities);
        }

        public Sprint SingleOrDefault(Expression<Func<Sprint, bool>> filter)
        {
            return sprintRepository.SingleOrDefault(filter);
        }

        

    }
}
