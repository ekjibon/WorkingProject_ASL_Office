using OEMS.Models;
using OEMS.Models.Model.Attendance;
using OEMS.Repository.Repositories.Employee;
using OEMS.Service.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Service.Services.Employee
{
    public class EmpAttendanceService : IService<EmpAttendance>
    {
        private EmpAttendanceRepository EmpAttendanceRepository;

        public EmpAttendanceService()
        {
            EmpAttendanceRepository = new EmpAttendanceRepository();
        }
        public bool Add(EmpAttendance entity)
        {
            // entity.Id =   ( Convert.ToInt32( EmpAttendanceRepository.GetAll().ToList().Select(e => e.Id).Max()) + 1).ToString();
            return EmpAttendanceRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<EmpAttendance> entities)
        {
            return EmpAttendanceRepository.AddRange(entities);
        }

        public IEnumerable<EmpAttendance> Filter(Expression<Func<EmpAttendance, bool>> filter, Func<IQueryable<EmpAttendance>, IOrderedQueryable<EmpAttendance>> orderBy = null, string[] Children = null)
        {
            return EmpAttendanceRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<EmpAttendance, bool>> filter, Func<IQueryable<EmpAttendance>, IOrderedQueryable<EmpAttendance>> orderBy = null)
        {
            return EmpAttendanceRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public EmpAttendance Get(long id)
        {
            return EmpAttendanceRepository.Get(id);
        }

        public IEnumerable<EmpAttendance> GetAll()
        {
            return EmpAttendanceRepository.GetAll();
        }

        public IEnumerable<EmpAttendance> GetByPage(int pageno, int pagesize)
        {
            return EmpAttendanceRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return EmpAttendanceRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return EmpAttendanceRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return EmpAttendanceRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            EmpAttendance entity = new EmpAttendance();
            entity = EmpAttendanceRepository.SingleOrDefault(e => e.AttendId == id);
            return EmpAttendanceRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<EmpAttendance> entities = new List<EmpAttendance>();
            entities = EmpAttendanceRepository.Filter(x => ids.Contains(Convert.ToInt64(x.AttendId))).ToList();

            return EmpAttendanceRepository.RemoveRange(entities);
        }

        public EmpAttendance SingleOrDefault(Expression<Func<EmpAttendance, bool>> filter)
        {
            return EmpAttendanceRepository.SingleOrDefault(filter);
        }

        public bool Update(EmpAttendance entity)
        {
            return EmpAttendanceRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<EmpAttendance> entities)
        {
            return EmpAttendanceRepository.AddRange(entities);
        }
        public bool Remove(string LIEOId)
        {
            EmpAttendance entity = new EmpAttendance();
            entity = EmpAttendanceRepository.SingleOrDefault(e => e.Remarks == LIEOId);
            return EmpAttendanceRepository.Remove(entity);
        }


    }
}
