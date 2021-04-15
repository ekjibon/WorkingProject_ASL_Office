using OEMS.Models;
using OEMS.Models.Model.Account;
using OEMS.Repository.Repositories.Account;
using OEMS.Service.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Service.Services.Account
{
    
    public  class CostCategoryService : IService<CostCategory>
    {
        private CostCategoryRepository costCategoryRepository;

        public CostCategoryService()
        {
            costCategoryRepository = new CostCategoryRepository();
        }
        public bool Add(CostCategory entity)
        {
            return costCategoryRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<CostCategory> entities)
        {
            return costCategoryRepository.AddRange(entities);
        }

        public IEnumerable<CostCategory> Filter(Expression<Func<CostCategory, bool>> filter, Func<IQueryable<CostCategory>, IOrderedQueryable<CostCategory>> orderBy = null, string[] Children = null)
        {
            return costCategoryRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<CostCategory, bool>> filter, Func<IQueryable<CostCategory>, IOrderedQueryable<CostCategory>> orderBy = null)
        {
            return costCategoryRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public CostCategory Get(long id)
        {
            return costCategoryRepository.Get(id);
        }

        public IEnumerable<CostCategory> GetAll()
        {
            return costCategoryRepository.GetAll();
        }

        public IEnumerable<CostCategory> GetByPage(int pageno, int pagesize)
        {
            return costCategoryRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return costCategoryRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return costCategoryRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return costCategoryRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            CostCategory entity = new CostCategory();
            entity = costCategoryRepository.SingleOrDefault(e => e.Id == id);
            entity.IsDeleted = true;
            entity.SetDate();
            return costCategoryRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<CostCategory> entities = new List<CostCategory>();
            entities = costCategoryRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return costCategoryRepository.RemoveRange(entities);
        }

        public CostCategory SingleOrDefault(Expression<Func<CostCategory, bool>> filter)
        {
            return costCategoryRepository.SingleOrDefault(filter);
        }

        public bool Update(CostCategory entity)
        {
            return costCategoryRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<CostCategory> entities)
        {
            return costCategoryRepository.AddRange(entities);
        }
        public bool Remove(string categoryName)
        {
            CostCategory entity = new CostCategory();
            entity = costCategoryRepository.SingleOrDefault(e => e.CostCategoryName == categoryName);
            return costCategoryRepository.Remove(entity);
        }


    }
}
