using OEMS.Models;
using OEMS.Models.Model.Employee;
using OEMS.Repository.Repositories.Attendance;
using OEMS.Service.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Service.Services.Attendance
{
    public class EmpLeaveModifyService : IService<EmpLeaveModify>
    {
        private EmpLeaveModifyRepository EmpLeaveModifyRepository;

        public EmpLeaveModifyService()
        {
            EmpLeaveModifyRepository = new EmpLeaveModifyRepository();
        }
        public bool Add(EmpLeaveModify entity)
        {
            return EmpLeaveModifyRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<EmpLeaveModify> entities)
        {
            return EmpLeaveModifyRepository.AddRange(entities);
        }

        public IEnumerable<EmpLeaveModify> Filter(Expression<Func<EmpLeaveModify, bool>> filter, Func<IQueryable<EmpLeaveModify>, IOrderedQueryable<EmpLeaveModify>> orderBy = null, string[] Children = null)
        {
            return EmpLeaveModifyRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<EmpLeaveModify, bool>> filter, Func<IQueryable<EmpLeaveModify>, IOrderedQueryable<EmpLeaveModify>> orderBy = null)
        {
            return EmpLeaveModifyRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public EmpLeaveModify Get(long id)
        {
            return EmpLeaveModifyRepository.Get(id);
        }

        public IEnumerable<EmpLeaveModify> GetAll()
        {
            return EmpLeaveModifyRepository.GetAll();
        }

        public IEnumerable<EmpLeaveModify> GetByPage(int pageno, int pagesize)
        {
            return EmpLeaveModifyRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return EmpLeaveModifyRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return EmpLeaveModifyRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return EmpLeaveModifyRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            EmpLeaveModify entity = new EmpLeaveModify();
            entity = EmpLeaveModifyRepository.SingleOrDefault(e => e.Id == id);
            return EmpLeaveModifyRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<EmpLeaveModify> entities = new List<EmpLeaveModify>();
            entities = EmpLeaveModifyRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return EmpLeaveModifyRepository.RemoveRange(entities);
        }

        public EmpLeaveModify SingleOrDefault(Expression<Func<EmpLeaveModify, bool>> filter)
        {
            return EmpLeaveModifyRepository.SingleOrDefault(filter);
        }

        public bool Update(EmpLeaveModify entity)
        {
            return EmpLeaveModifyRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<EmpLeaveModify> entities)
        {
            return EmpLeaveModifyRepository.AddRange(entities);
        }
    }
}
