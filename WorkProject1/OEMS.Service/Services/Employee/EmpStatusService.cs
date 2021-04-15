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
    public class EmpStatusService : IService<EmpStatus>
    {
        private EmpStatusRepository EmpStatusRepository;

        public EmpStatusService()
        {
            EmpStatusRepository = new EmpStatusRepository();
        }
        public bool Add(EmpStatus entity)
        {
            return EmpStatusRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<EmpStatus> entities)
        {
            return EmpStatusRepository.AddRange(entities);
        }

        public IEnumerable<EmpStatus> Filter(Expression<Func<EmpStatus, bool>> filter, Func<IQueryable<EmpStatus>, IOrderedQueryable<EmpStatus>> orderBy = null, string[] Children = null)
        {
            return EmpStatusRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<EmpStatus, bool>> filter, Func<IQueryable<EmpStatus>, IOrderedQueryable<EmpStatus>> orderBy = null)
        {
            return EmpStatusRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public EmpStatus Get(long id)
        {
            return EmpStatusRepository.Get(id);
        }

        public IEnumerable<EmpStatus> GetAll()
        {
            return EmpStatusRepository.GetAll();
        }

        public IEnumerable<EmpStatus> GetByPage(int pageno, int pagesize)
        {
            return EmpStatusRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return EmpStatusRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return EmpStatusRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return EmpStatusRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            EmpStatus entity = new EmpStatus();
            entity = EmpStatusRepository.SingleOrDefault(e=>e.StatusID==id);
            entity.IsDeleted = true;
            entity.SetDate();
            return EmpStatusRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<EmpStatus> entities = new List<EmpStatus>();
            entities = EmpStatusRepository.Filter(x => ids.Contains(Convert.ToInt64(x.StatusID))).ToList();

            return EmpStatusRepository.RemoveRange(entities);
        }

        public EmpStatus SingleOrDefault(Expression<Func<EmpStatus, bool>> filter)
        {
            return EmpStatusRepository.SingleOrDefault(filter);
        }

        public bool Update(EmpStatus entity)
        { 
            return EmpStatusRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<EmpStatus> entities)
        {
            return EmpStatusRepository.AddRange(entities);
        }
        public bool Remove(string StatusName)
        {
            EmpStatus entity = new EmpStatus();
            entity = EmpStatusRepository.SingleOrDefault(e => e.StatusName == StatusName);
            return EmpStatusRepository.Remove(entity);
        }

        public int GetBranchId(string StatusName)
        {

            int branchID = EmpStatusRepository.SingleOrDefault(e => e.StatusName == StatusName).StatusID;
            return branchID;
        }

   
    }
}
