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
    public class EmpLeaveTypeService : IService<EmpLeaveType>
    {
        private EmpLeaveTypeRepository EmpLeaveTypeRepository;

        public EmpLeaveTypeService()
        {
            EmpLeaveTypeRepository = new EmpLeaveTypeRepository();
        }
        public bool Add(EmpLeaveType entity)
        {
            return EmpLeaveTypeRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<EmpLeaveType> entities)
        {
            return EmpLeaveTypeRepository.AddRange(entities);
        }

        public IEnumerable<EmpLeaveType> Filter(Expression<Func<EmpLeaveType, bool>> filter, Func<IQueryable<EmpLeaveType>, IOrderedQueryable<EmpLeaveType>> orderBy = null, string[] Children = null)
        {
            return EmpLeaveTypeRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<EmpLeaveType, bool>> filter, Func<IQueryable<EmpLeaveType>, IOrderedQueryable<EmpLeaveType>> orderBy = null)
        {
            return EmpLeaveTypeRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public EmpLeaveType Get(long id)
        {
            return EmpLeaveTypeRepository.Get(id);
        }

        public IEnumerable<EmpLeaveType> GetAll()
        {
            return EmpLeaveTypeRepository.GetAll();
        }

        public IEnumerable<EmpLeaveType> GetByPage(int pageno, int pagesize)
        {
            return EmpLeaveTypeRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return EmpLeaveTypeRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return EmpLeaveTypeRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return EmpLeaveTypeRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            EmpLeaveType entity = new EmpLeaveType();
            entity = EmpLeaveTypeRepository.SingleOrDefault(e=>e.EmpLeaveTypeId==id);
            entity.IsDeleted = true;
            entity.SetDate();
            return EmpLeaveTypeRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<EmpLeaveType> entities = new List<EmpLeaveType>();
            entities = EmpLeaveTypeRepository.Filter(x => ids.Contains(Convert.ToInt64(x.EmpLeaveTypeId))).ToList();

            return EmpLeaveTypeRepository.RemoveRange(entities);
        }

        public EmpLeaveType SingleOrDefault(Expression<Func<EmpLeaveType, bool>> filter)
        {
            return EmpLeaveTypeRepository.SingleOrDefault(filter);
        }

        public bool Update(EmpLeaveType entity)
        { 
            return EmpLeaveTypeRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<EmpLeaveType> entities)
        {
            return EmpLeaveTypeRepository.AddRange(entities);
        }
        public bool Remove(string TypeName)
        {
            EmpLeaveType entity = new EmpLeaveType();
            entity = EmpLeaveTypeRepository.SingleOrDefault(e => e.TypeName == TypeName);
            return EmpLeaveTypeRepository.Remove(entity);
        }

        public int GetBranchId(string TypeName)
        {

            int branchID = EmpLeaveTypeRepository.SingleOrDefault(e => e.TypeName == TypeName).EmpLeaveTypeId;
            return branchID;
        }

   
    }
}
