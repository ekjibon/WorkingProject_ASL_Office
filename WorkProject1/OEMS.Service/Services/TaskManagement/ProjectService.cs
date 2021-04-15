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
    public class ProjectService : IService<Project>
    {
        private ProjectRepository projectRepository;

        public ProjectService()
        {
            projectRepository = new ProjectRepository();
        }
        public bool Add(Project entity)
        {
          return projectRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<Project> entities)
        {
            return projectRepository.AddRange(entities);
        }

        public bool Update(Project entity)
        {
            //Project _entity = projectRepository.SingleOrDefault(e => e.Id == entity.Id);
            return projectRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<Project> entities)
        {
            return projectRepository.AddRange(entities);
        }

        public IEnumerable<Project> Filter(Expression<Func<Project, bool>> filter, Func<IQueryable<Project>, IOrderedQueryable<Project>> orderBy = null, string[] Children = null)
        {
            return projectRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<Project, bool>> filter, Func<IQueryable<Project>, IOrderedQueryable<Project>> orderBy = null)
        {
            return projectRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public Project Get(long id)
        {
            return projectRepository.Get(id);
        }

        public IEnumerable<Project> GetAll()
        {
            return projectRepository.GetAll();
        }

        public IEnumerable<Project> GetByPage(int pageno, int pagesize)
        {
            return projectRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return projectRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return projectRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return projectRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            Project entity = new Project();
            entity = projectRepository.SingleOrDefault(e=>e.Id==id);
            return projectRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<Project> entities = new List<Project>();
            entities = projectRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return projectRepository.RemoveRange(entities);
        }

        public Project SingleOrDefault(Expression<Func<Project, bool>> filter)
        {
            return projectRepository.SingleOrDefault(filter);
        }

        

    }
}
