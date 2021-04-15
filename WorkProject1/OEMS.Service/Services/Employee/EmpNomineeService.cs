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
    public class EmpNomineeService : IService<EmpNominee>
    {
        private EmpNomineeRepository EmpNomineeRepository;

        public EmpNomineeService()
        {
            EmpNomineeRepository = new EmpNomineeRepository();
        }
        public bool Add(EmpNominee entity)
        {
            return EmpNomineeRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<EmpNominee> entities)
        {
            return EmpNomineeRepository.AddRange(entities);
        }

        public IEnumerable<EmpNominee> Filter(Expression<Func<EmpNominee, bool>> filter, Func<IQueryable<EmpNominee>, IOrderedQueryable<EmpNominee>> orderBy = null, string[] Children = null)
        {
            return EmpNomineeRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<EmpNominee, bool>> filter, Func<IQueryable<EmpNominee>, IOrderedQueryable<EmpNominee>> orderBy = null)
        {
            return EmpNomineeRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public EmpNominee Get(long id)
        {
            return EmpNomineeRepository.Get(id);
        }

        public IEnumerable<EmpNominee> GetAll()
        {
            return EmpNomineeRepository.GetAll();
        }

        public IEnumerable<EmpNominee> GetByPage(int pageno, int pagesize)
        {
            return EmpNomineeRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return EmpNomineeRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return EmpNomineeRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return EmpNomineeRepository.getResponseBySpWithParam(SpName, parameterValues);
        }
        public bool Remove(long id)
        {
            EmpNominee entity = new EmpNominee();
            entity = EmpNomineeRepository.SingleOrDefault(e=>e.EmpNomineeID==id);
          
            return EmpNomineeRepository.Remove(entity);
        }
        public bool RemoveRange(List<long> ids)
        {
            List<EmpNominee> entities = new List<EmpNominee>();
            entities = EmpNomineeRepository.Filter(x => ids.Contains(Convert.ToInt64(x.EmpNomineeID))).ToList();

            return EmpNomineeRepository.RemoveRange(entities);
        }
        public EmpNominee SingleOrDefault(Expression<Func<EmpNominee, bool>> filter)
        {
            return EmpNomineeRepository.SingleOrDefault(filter);
        }
        public bool Update(EmpNominee entity)
        { 
            return EmpNomineeRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<EmpNominee> entities)
        {
            return EmpNomineeRepository.AddRange(entities);
        }
        public bool Remove(string ShiftName)
        {
            EmpNominee entity = new EmpNominee();
            entity = EmpNomineeRepository.SingleOrDefault(e => e.NomineeName == ShiftName);
            return EmpNomineeRepository.Remove(entity);
        }

        public int GetBranchId(string NomineeName)
        {

            int branchID = EmpNomineeRepository.SingleOrDefault(e => e.NomineeName == NomineeName).EmpNomineeID;
            return branchID;
        }

   
    }
}
