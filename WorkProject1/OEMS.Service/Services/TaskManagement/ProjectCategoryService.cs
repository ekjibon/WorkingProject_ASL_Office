using OEMS.Models;
using OEMS.Models.Model;
using OEMS.Models.Model.TaskManagement;
using OEMS.Repository.Repositories;
using OEMS.Repository.Repositories.ProjectCategorys;
using OEMS.Service.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Service.Services.ProjectCategorys
{
    public class ProjectCategoryService : IService<ProjectCategory>
    {
        ProjectCategoryRepository ProjectCategoryRepository;
        private CommonRepository commonRepository;
        public ProjectCategoryService() 
        {
            ProjectCategoryRepository = new ProjectCategoryRepository();
            commonRepository = new CommonRepository();
        }

        public bool Add(ProjectCategory entity)
        {
            return ProjectCategoryRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<ProjectCategory> entities)
        {
            return ProjectCategoryRepository.AddRange(entities);
        }

        public bool Update(ProjectCategory entity)
        {
            return ProjectCategoryRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<ProjectCategory> entities)
        {
            return ProjectCategoryRepository.AddRange(entities);
        }

        public bool Remove(long id)
        {
            ProjectCategory entity = new ProjectCategory();
            entity = ProjectCategoryRepository.SingleOrDefault(e => e.Id == id);
            return ProjectCategoryRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<ProjectCategory> entities = new List<ProjectCategory>();
            entities = ProjectCategoryRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return ProjectCategoryRepository.RemoveRange(entities);
        }

        public ProjectCategory Get(long id)
        {
            return ProjectCategoryRepository.Get(id);
        }

        public ProjectCategory SingleOrDefault(Expression<Func<ProjectCategory, bool>> filter)
        {
            return ProjectCategoryRepository.SingleOrDefault(filter);
        }


        public IEnumerable<ProjectCategory> GetAll()
        {
            return ProjectCategoryRepository.GetAll();
        }

        public IEnumerable<ProjectCategory> Filter(Expression<Func<ProjectCategory, bool>> filter, Func<IQueryable<ProjectCategory>, IOrderedQueryable<ProjectCategory>> orderBy = null, string[] Children = null)
        {
            return ProjectCategoryRepository.Filter(filter, orderBy);
        }

        public IEnumerable<ProjectCategory> GetByPage(int pageno, int pagesize)
        {
            return ProjectCategoryRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return ProjectCategoryRepository.getPageResponse(pageno, pagesize);
        }
        public List<DropDownConfig> SearchProjectCategory(string SrchText)
        {
            var dt = commonRepository.GetBySpWithParam("GetForTypehead", new object[] { SrchText, 15 });
            return CommonRepository.ConvertDataTable<DropDownConfig>(dt);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return ProjectCategoryRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return ProjectCategoryRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<ProjectCategory, bool>> filter, Func<IQueryable<ProjectCategory>, IOrderedQueryable<ProjectCategory>> orderBy = null)
        {
            return ProjectCategoryRepository.Filter(pageno, pagesize, filter, orderBy);
        }
        
    }
}
