using OEMS.Service.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using OEMS.Models;
using System.Linq.Expressions;
using OEMS.Models.Model.Employee;
using OEMS.Repository.Repositories.Employee;

namespace OEMS.Service.Services
{
    public class EmpJobHistoryService : IService<EmpJobHistory>
    {
        private EmpJobHistoryRepository EmpJobHistoryRepository;

        public EmpJobHistoryService()
        {
            EmpJobHistoryRepository = new EmpJobHistoryRepository();
        }
        public bool Add(EmpJobHistory entity)
        {
            return EmpJobHistoryRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<EmpJobHistory> entities)
        {
            return EmpJobHistoryRepository.AddRange(entities);
        }

        public IEnumerable<EmpJobHistory> Filter(Expression<Func<EmpJobHistory, bool>> filter, Func<IQueryable<EmpJobHistory>, IOrderedQueryable<EmpJobHistory>> orderBy = null, string[] Children = null)
        {
            return EmpJobHistoryRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<EmpJobHistory, bool>> filter, Func<IQueryable<EmpJobHistory>, IOrderedQueryable<EmpJobHistory>> orderBy = null)
        {
            return EmpJobHistoryRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public EmpJobHistory Get(long id)
        {
            return EmpJobHistoryRepository.Get(id);
        }

        public IEnumerable<EmpJobHistory> GetAll()
        {
            return EmpJobHistoryRepository.GetAll();
        }

        public IEnumerable<EmpJobHistory> GetByPage(int pageno, int pagesize)
        {
            return EmpJobHistoryRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return EmpJobHistoryRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return EmpJobHistoryRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return EmpJobHistoryRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            EmpJobHistory entity = new EmpJobHistory();
            entity = EmpJobHistoryRepository.SingleOrDefault(e=>e.EmpJobId==id);
            entity.IsDeleted = true;
            entity.SetDate();
            return EmpJobHistoryRepository.Update(entity);
        }
        public bool RemoveRange(List<long> ids)
        {
            List<EmpJobHistory> entities = new List<EmpJobHistory>();
            entities = EmpJobHistoryRepository.Filter(x => ids.Contains(Convert.ToInt64(x.EmpJobId))).ToList();
            return EmpJobHistoryRepository.RemoveRange(entities);
        }
        public EmpJobHistory SingleOrDefault(Expression<Func<EmpJobHistory, bool>> filter)
        {
            return EmpJobHistoryRepository.SingleOrDefault(filter);
        }
        public bool Update(EmpJobHistory entity)
        { 
            return EmpJobHistoryRepository.Update(entity);
        }
        public bool UpdateRange(IEnumerable<EmpJobHistory> entities)
        {
            return EmpJobHistoryRepository.AddRange(entities);
        }
        public bool Remove(string Companyname)
        {
            EmpJobHistory entity = new EmpJobHistory();
            entity = EmpJobHistoryRepository.SingleOrDefault(e => e.Companyname == Companyname);
            return EmpJobHistoryRepository.Remove(entity);
        }
        public int GetBranchId(string Companyname)
        {
            int branchID = EmpJobHistoryRepository.SingleOrDefault(e => e.Companyname == Companyname).EmpJobId;
            return branchID;
        }

   
    }
}
