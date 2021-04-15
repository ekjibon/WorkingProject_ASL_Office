using OEMS.Models;
using OEMS.Models.Model;
using OEMS.Models.Model.Account;
using OEMS.Repository.Repositories;
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
    
    public  class CostCenterService : IService<CostCenter>
    {
        private CostCenterRepository costCenterRepository;
        private CommonRepository commonRepository = new CommonRepository();

        public CostCenterService()
        {
            costCenterRepository = new CostCenterRepository();
        }
        public bool Add(CostCenter entity)
        {
            return costCenterRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<CostCenter> entities)
        {
            return costCenterRepository.AddRange(entities);
        }

        public IEnumerable<CostCenter> Filter(Expression<Func<CostCenter, bool>> filter, Func<IQueryable<CostCenter>, IOrderedQueryable<CostCenter>> orderBy = null, string[] Children = null)
        {
            return costCenterRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<CostCenter, bool>> filter, Func<IQueryable<CostCenter>, IOrderedQueryable<CostCenter>> orderBy = null)
        {
            return costCenterRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public CostCenter Get(long id)
        {
            return costCenterRepository.Get(id);
        }

        public IEnumerable<CostCenter> GetAll()
        {
            return costCenterRepository.GetAll();
        }

        public IEnumerable<CostCenter> GetByPage(int pageno, int pagesize)
        {
            return costCenterRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return costCenterRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return costCenterRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return costCenterRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            CostCenter entity = new CostCenter();
            entity = costCenterRepository.SingleOrDefault(e => e.Id == id);
            entity.IsDeleted = true;
            entity.SetDate();
            return costCenterRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<CostCenter> entities = new List<CostCenter>();
            entities = costCenterRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return costCenterRepository.RemoveRange(entities);
        }

        public CostCenter SingleOrDefault(Expression<Func<CostCenter, bool>> filter)
        {
            return costCenterRepository.SingleOrDefault(filter);
        }

        public bool Update(CostCenter entity)
        {
            return costCenterRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<CostCenter> entities)
        {
            return costCenterRepository.AddRange(entities);
        }
        public bool Remove(string categoryName)
        {
            CostCenter entity = new CostCenter();
            entity = costCenterRepository.SingleOrDefault(e => e.CostCenterName == categoryName);
            return costCenterRepository.Remove(entity);
        }
        public List<DropDownConfig> GetCostCenterforTransaction(string SrchText,int LedgerId)
        {
            var dt = commonRepository.GetBySpWithParam("GetCostCenterforTransaction", new object[] { SrchText, LedgerId });
            return CommonRepository.ConvertDataTable<DropDownConfig>(dt);
        }

    }
}
