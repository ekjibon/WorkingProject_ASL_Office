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
    public class ModulesService : IService<Modules>
    {
        private ModulesRepository modulesRepository;

        public ModulesService()
        {
            modulesRepository = new ModulesRepository();
        }
        public bool Add(Modules entity)
        {
        // entity.Id =   ( Convert.ToInt32( SessionRepository.GetAll().ToList().Select(e => e.Id).Max()) + 1).ToString();
          return  modulesRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<Modules> entities)
        {
            return modulesRepository.AddRange(entities);
        }

        public IEnumerable<Modules> Filter(Expression<Func<Modules, bool>> filter, Func<IQueryable<Modules>, IOrderedQueryable<Modules>> orderBy = null, string[] Children = null)
        {
            return modulesRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<Modules, bool>> filter, Func<IQueryable<Modules>, IOrderedQueryable<Modules>> orderBy = null)
        {
            return modulesRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public Modules Get(long id)
        {
            return modulesRepository.Get(id);
        }

        public IEnumerable<Modules> GetAll()
        {
            return modulesRepository.GetAll();
        }

        public IEnumerable<Modules> GetByPage(int pageno, int pagesize)
        {
            return modulesRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return modulesRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return modulesRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return modulesRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            Modules entity = new Modules();
            entity = modulesRepository.SingleOrDefault(e=>e.Id==id);
            return modulesRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<Modules> entities = new List<Modules>();
            entities = modulesRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return modulesRepository.RemoveRange(entities);
        }

        public Modules SingleOrDefault(Expression<Func<Modules, bool>> filter)
        {
            return modulesRepository.SingleOrDefault(filter);
        }

        public bool Update(Modules entity)
        {
            return modulesRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<Modules> entities)
        {
            return modulesRepository.AddRange(entities);
        }

    }
}
