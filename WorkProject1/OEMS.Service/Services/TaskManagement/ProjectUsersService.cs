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
    public class ProjectUsersService : IService<ProjectUsers>
    {
        private ProjectUsersRepository projectUsersRepository;

        public ProjectUsersService()
        {
            projectUsersRepository = new ProjectUsersRepository();
        }
        public bool Add(ProjectUsers entity)
        {
        // entity.Id =   ( Convert.ToInt32( SessionRepository.GetAll().ToList().Select(e => e.Id).Max()) + 1).ToString();
          return projectUsersRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<ProjectUsers> entities)
        {
            return projectUsersRepository.AddRange(entities);
        }

        public bool Update(ProjectUsers entity)
        {
            return projectUsersRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<ProjectUsers> entities)
        {
            return projectUsersRepository.AddRange(entities);
        }

        public IEnumerable<ProjectUsers> Filter(Expression<Func<ProjectUsers, bool>> filter, Func<IQueryable<ProjectUsers>, IOrderedQueryable<ProjectUsers>> orderBy = null, string[] Children = null)
        {
            return projectUsersRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<ProjectUsers, bool>> filter, Func<IQueryable<ProjectUsers>, IOrderedQueryable<ProjectUsers>> orderBy = null)
        {
            return projectUsersRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public ProjectUsers Get(long id)
        {
            return projectUsersRepository.Get(id);
        }

        public IEnumerable<ProjectUsers> GetAll()
        {
            return projectUsersRepository.GetAll();
        }

        public IEnumerable<ProjectUsers> GetByPage(int pageno, int pagesize)
        {
            return projectUsersRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return projectUsersRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return projectUsersRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return projectUsersRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            ProjectUsers entity = new ProjectUsers();
            entity = projectUsersRepository.SingleOrDefault(e=>e.Id==id);
            return projectUsersRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<ProjectUsers> entities = new List<ProjectUsers>();
            entities = projectUsersRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return projectUsersRepository.RemoveRange(entities);
        }

        public ProjectUsers SingleOrDefault(Expression<Func<ProjectUsers, bool>> filter)
        {
            return projectUsersRepository.SingleOrDefault(filter);
        }

        

    }
}
