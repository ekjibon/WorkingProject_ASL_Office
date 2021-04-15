using OEMS.Models;
using OEMS.Models.Model.Attendance;
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
    public class EmpRosterService : IService<EmpRoster>
    {
        private EmpRosterRepository empRosterRepository;

        public EmpRosterService()
        {
            empRosterRepository = new EmpRosterRepository();
        }
        public bool Add(EmpRoster entity)
        {
            return empRosterRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<EmpRoster> entities)
        {
            return empRosterRepository.AddRange(entities);
        }

        public IEnumerable<EmpRoster> Filter(Expression<Func<EmpRoster, bool>> filter, Func<IQueryable<EmpRoster>, IOrderedQueryable<EmpRoster>> orderBy = null, string[] Children = null)
        {
            return empRosterRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<EmpRoster, bool>> filter, Func<IQueryable<EmpRoster>, IOrderedQueryable<EmpRoster>> orderBy = null)
        {
            return empRosterRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public EmpRoster Get(long id)
        {
            return empRosterRepository.Get(id);
        }

        public IEnumerable<EmpRoster> GetAll()
        {
            return empRosterRepository.GetAll();
        }

        public IEnumerable<EmpRoster> GetByPage(int pageno, int pagesize)
        {
            return empRosterRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return empRosterRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return empRosterRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return empRosterRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            EmpRoster entity = new EmpRoster();
            entity = empRosterRepository.SingleOrDefault(e => e.Id == id);
            return empRosterRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<EmpRoster> entities = new List<EmpRoster>();
            entities = empRosterRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return empRosterRepository.RemoveRange(entities);
        }

        public EmpRoster SingleOrDefault(Expression<Func<EmpRoster, bool>> filter)
        {
            return empRosterRepository.SingleOrDefault(filter);
        }

        public bool Update(EmpRoster entity)
        {
            return empRosterRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<EmpRoster> entities)
        {
            return empRosterRepository.AddRange(entities);
        }
    }
}
