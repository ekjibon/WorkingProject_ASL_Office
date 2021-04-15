using OEMS.Models.Model;
using OEMS.Service.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using OEMS.Models;
using System.Linq.Expressions;
using OEMS.Models.Model.Employee;
using OEMS.Repository.Repositories;
using OEMS.Repository.Repositories.Employee;

namespace OEMS.Service.Services
{
    public class EmpCategoryService : IService<EmpCategory>
    {
        private EmpCategoryRepository empCategoryRepository;

        public EmpCategoryService()
        {
            empCategoryRepository = new EmpCategoryRepository();
        }
        public bool Add(EmpCategory entity)
        {
            return empCategoryRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<EmpCategory> entities)
        {
            return empCategoryRepository.AddRange(entities);
        }

        public IEnumerable<EmpCategory> Filter(Expression<Func<EmpCategory, bool>> filter, Func<IQueryable<EmpCategory>, IOrderedQueryable<EmpCategory>> orderBy = null, string[] Children = null)
        {
            return empCategoryRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<EmpCategory, bool>> filter, Func<IQueryable<EmpCategory>, IOrderedQueryable<EmpCategory>> orderBy = null)
        {
            return empCategoryRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public EmpCategory Get(long id)
        {
            return empCategoryRepository.Get(id);
        }

        public IEnumerable<EmpCategory> GetAll()
        {
            return empCategoryRepository.GetAll();
        }

        public IEnumerable<EmpCategory> GetByPage(int pageno, int pagesize)
        {
            return empCategoryRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return empCategoryRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return empCategoryRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return empCategoryRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            EmpCategory entity = new EmpCategory();
            entity = empCategoryRepository.SingleOrDefault(e=>e.CategoryID==id);
            entity.IsDeleted = true;
            entity.SetDate();
            return empCategoryRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<EmpCategory> entities = new List<EmpCategory>();
            entities = empCategoryRepository.Filter(x => ids.Contains(Convert.ToInt64(x.CategoryID))).ToList();

            return empCategoryRepository.RemoveRange(entities);
        }

        public EmpCategory SingleOrDefault(Expression<Func<EmpCategory, bool>> filter)
        {
            return empCategoryRepository.SingleOrDefault(filter);
        }

        public bool Update(EmpCategory entity)
        { 
            return empCategoryRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<EmpCategory> entities)
        {
            return empCategoryRepository.AddRange(entities);
        }
        public bool Remove(string CategoryName)
        {
            EmpCategory entity = new EmpCategory();
            entity = empCategoryRepository.SingleOrDefault(e => e.CategoryName == CategoryName);
            return empCategoryRepository.Remove(entity);
        }

        public int GetBranchId(string CategoryName)
        {

            int branchID = empCategoryRepository.SingleOrDefault(e => e.CategoryName == CategoryName).CategoryID;
            return branchID;
        }
        
        
       
    }
}
