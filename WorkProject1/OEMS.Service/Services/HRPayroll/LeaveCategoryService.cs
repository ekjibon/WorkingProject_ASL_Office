using OEMS.Models;
using OEMS.Models.Model.HR_PayRoll;
using OEMS.Repository.Repositories.HRPayroll;
using OEMS.Service.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Service.Services.HRPayroll
{
    public class LeaveCategoryService:IService<LeaveCategory>
    {
        LeaveCategoryRepository leaveCategoryRepository;
        public LeaveCategoryService()
        {
            leaveCategoryRepository = new LeaveCategoryRepository();
        }

        public bool Add(LeaveCategory entity)
        {
            return leaveCategoryRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<LeaveCategory> entities)
        {
            return leaveCategoryRepository.AddRange(entities);
        }

        public bool Update(LeaveCategory entity)
        {
            return leaveCategoryRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<LeaveCategory> entities)
        {
            return leaveCategoryRepository.AddRange(entities);
        }

        public bool Remove(long id)
        {
            LeaveCategory entity = new LeaveCategory();
            entity = leaveCategoryRepository.SingleOrDefault(e => e.Id == id);
            return leaveCategoryRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<LeaveCategory> entities = new List<LeaveCategory>();
            entities = leaveCategoryRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return leaveCategoryRepository.RemoveRange(entities);
        }

        public LeaveCategory Get(long id)
        {
            return leaveCategoryRepository.Get(id);
        }

        public LeaveCategory SingleOrDefault(Expression<Func<LeaveCategory, bool>> filter)
        {
            return leaveCategoryRepository.SingleOrDefault(filter);
        }


        public IEnumerable<LeaveCategory> GetAll()
        {
            return leaveCategoryRepository.GetAll();
        }

        public IEnumerable<LeaveCategory> Filter(Expression<Func<LeaveCategory, bool>> filter, Func<IQueryable<LeaveCategory>, IOrderedQueryable<LeaveCategory>> orderBy = null, string[] Children = null)
        {
            return leaveCategoryRepository.Filter(filter, orderBy);
        }

        public IEnumerable<LeaveCategory> GetByPage(int pageno, int pagesize)
        {
            return leaveCategoryRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return leaveCategoryRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return leaveCategoryRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return leaveCategoryRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<LeaveCategory, bool>> filter, Func<IQueryable<LeaveCategory>, IOrderedQueryable<LeaveCategory>> orderBy = null)
        {
            return leaveCategoryRepository.Filter(pageno, pagesize, filter, orderBy);
        }
    }
}
