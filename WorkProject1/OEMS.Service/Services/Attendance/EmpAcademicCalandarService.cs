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
    public class EmpAcademicCalandarService : IService<EmpAcademicCalandar>
    {
        private EmpAcademicCalandarRepository empAcademicCalandarRepository;

        public EmpAcademicCalandarService()
        {
            empAcademicCalandarRepository = new Repository.Repositories.Attendance.EmpAcademicCalandarRepository();
        }
        public bool Add(EmpAcademicCalandar entity)
        {
            return empAcademicCalandarRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<EmpAcademicCalandar> entities)
        {
            return empAcademicCalandarRepository.AddRange(entities);
        }

        public IEnumerable<EmpAcademicCalandar> Filter(Expression<Func<EmpAcademicCalandar, bool>> filter, Func<IQueryable<EmpAcademicCalandar>, IOrderedQueryable<EmpAcademicCalandar>> orderBy = null, string[] Children = null)
        {
            return empAcademicCalandarRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<EmpAcademicCalandar, bool>> filter, Func<IQueryable<EmpAcademicCalandar>, IOrderedQueryable<EmpAcademicCalandar>> orderBy = null)
        {
            return empAcademicCalandarRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public EmpAcademicCalandar Get(long id)
        {
            return empAcademicCalandarRepository.Get(id);
        }

        public IEnumerable<EmpAcademicCalandar> GetAll()
        {
            return empAcademicCalandarRepository.GetAll();
        }

        public IEnumerable<EmpAcademicCalandar> GetByPage(int pageno, int pagesize)
        {
            return empAcademicCalandarRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return empAcademicCalandarRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return empAcademicCalandarRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return empAcademicCalandarRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            EmpAcademicCalandar entity = new EmpAcademicCalandar();
            entity = empAcademicCalandarRepository.SingleOrDefault(e => e.Id == id);
            entity.IsDeleted = true;
            return empAcademicCalandarRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<EmpAcademicCalandar> entities = new List<EmpAcademicCalandar>();
            entities = empAcademicCalandarRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return empAcademicCalandarRepository.RemoveRange(entities);
        }

        public EmpAcademicCalandar SingleOrDefault(Expression<Func<EmpAcademicCalandar, bool>> filter)
        {
            return empAcademicCalandarRepository.SingleOrDefault(filter);
        }

        public bool Update(EmpAcademicCalandar entity)
        {
            return empAcademicCalandarRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<EmpAcademicCalandar> entities)
        {
            return empAcademicCalandarRepository.AddRange(entities);
        }
    }
}
