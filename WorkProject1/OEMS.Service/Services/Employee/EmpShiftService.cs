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
    public class EmpShiftService : IService<EmpShift>
    {
        private EmpShiftRepository EmpShiftRepository;

        public EmpShiftService()
        {
            EmpShiftRepository = new EmpShiftRepository();
        }
        public bool Add(EmpShift entity)
        {
            return EmpShiftRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<EmpShift> entities)
        {
            return EmpShiftRepository.AddRange(entities);
        }

        public IEnumerable<EmpShift> Filter(Expression<Func<EmpShift, bool>> filter, Func<IQueryable<EmpShift>, IOrderedQueryable<EmpShift>> orderBy = null, string[] Children = null)
        {
            return EmpShiftRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<EmpShift, bool>> filter, Func<IQueryable<EmpShift>, IOrderedQueryable<EmpShift>> orderBy = null)
        {
            return EmpShiftRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public EmpShift Get(long id)
        {
            return EmpShiftRepository.Get(id);
        }

        public IEnumerable<EmpShift> GetAll()
        {
            return EmpShiftRepository.GetAll();
        }

        public IEnumerable<EmpShift> GetByPage(int pageno, int pagesize)
        {
            return EmpShiftRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return EmpShiftRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return EmpShiftRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return EmpShiftRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            EmpShift entity = new EmpShift();
            entity = EmpShiftRepository.SingleOrDefault(e=>e.ShiftID==id);
            entity.IsDeleted = true;
            entity.SetDate();
            return EmpShiftRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<EmpShift> entities = new List<EmpShift>();
            entities = EmpShiftRepository.Filter(x => ids.Contains(Convert.ToInt64(x.ShiftID))).ToList();

            return EmpShiftRepository.RemoveRange(entities);
        }

        public EmpShift SingleOrDefault(Expression<Func<EmpShift, bool>> filter)
        {
            return EmpShiftRepository.SingleOrDefault(filter);
        }

        public bool Update(EmpShift entity)
        { 
            return EmpShiftRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<EmpShift> entities)
        {
            return EmpShiftRepository.AddRange(entities);
        }
        public bool Remove(string ShiftName)
        {
            EmpShift entity = new EmpShift();
            entity = EmpShiftRepository.SingleOrDefault(e => e.ShiftName == ShiftName);
            return EmpShiftRepository.Remove(entity);
        }

        public int GetBranchId(string ShiftName)
        {

            int branchID = EmpShiftRepository.SingleOrDefault(e => e.ShiftName == ShiftName).ShiftID;
            return branchID;
        }

   
    }
}
