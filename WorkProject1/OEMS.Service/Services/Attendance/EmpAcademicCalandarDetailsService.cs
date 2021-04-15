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
    public class EmpAcademicCalandarDetailsService : IService<EmpAcademicCalendarDetails>
    {
        private EmpAcademicCalandarDetailsRepository empAcademicCalandarDetailsRepository;

        public EmpAcademicCalandarDetailsService()
        {
            empAcademicCalandarDetailsRepository = new EmpAcademicCalandarDetailsRepository();
        }
        public bool Add(EmpAcademicCalendarDetails entity)
        {
            return empAcademicCalandarDetailsRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<EmpAcademicCalendarDetails> entities)
        {
            return empAcademicCalandarDetailsRepository.AddRange(entities);
        }

        public IEnumerable<EmpAcademicCalendarDetails> Filter(Expression<Func<EmpAcademicCalendarDetails, bool>> filter, Func<IQueryable<EmpAcademicCalendarDetails>, IOrderedQueryable<EmpAcademicCalendarDetails>> orderBy = null, string[] Children = null)
        {
            return empAcademicCalandarDetailsRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<EmpAcademicCalendarDetails, bool>> filter, Func<IQueryable<EmpAcademicCalendarDetails>, IOrderedQueryable<EmpAcademicCalendarDetails>> orderBy = null)
        {
            return empAcademicCalandarDetailsRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public EmpAcademicCalendarDetails Get(long id)
        {
            return empAcademicCalandarDetailsRepository.Get(id);
        }

        public IEnumerable<EmpAcademicCalendarDetails> GetAll()
        {
            return empAcademicCalandarDetailsRepository.GetAll();
        }

        public IEnumerable<EmpAcademicCalendarDetails> GetByPage(int pageno, int pagesize)
        {
            return empAcademicCalandarDetailsRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return empAcademicCalandarDetailsRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return empAcademicCalandarDetailsRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return empAcademicCalandarDetailsRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            EmpAcademicCalendarDetails entity = new EmpAcademicCalendarDetails();
            entity = empAcademicCalandarDetailsRepository.SingleOrDefault(e => e.Id == id);
            return empAcademicCalandarDetailsRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<EmpAcademicCalendarDetails> entities = new List<EmpAcademicCalendarDetails>();
            entities = empAcademicCalandarDetailsRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return empAcademicCalandarDetailsRepository.RemoveRange(entities);
        }
        public bool RemoveRange(int Year, int Month, int day, int CalendarId)
        {
            List<EmpAcademicCalendarDetails> entities = new List<EmpAcademicCalendarDetails>();
            entities = empAcademicCalandarDetailsRepository.Filter(x => x.Year == Year && x.Month == Month && x.Day == day && x.CalendarId == CalendarId).ToList();

            return empAcademicCalandarDetailsRepository.RemoveRange(entities);
        }

        public EmpAcademicCalendarDetails SingleOrDefault(Expression<Func<EmpAcademicCalendarDetails, bool>> filter)
        {
            return empAcademicCalandarDetailsRepository.SingleOrDefault(filter);
        }

        public bool Update(EmpAcademicCalendarDetails entity)
        {
            return empAcademicCalandarDetailsRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<EmpAcademicCalendarDetails> entities)
        {
            return empAcademicCalandarDetailsRepository.AddRange(entities);
        }


    }
}
