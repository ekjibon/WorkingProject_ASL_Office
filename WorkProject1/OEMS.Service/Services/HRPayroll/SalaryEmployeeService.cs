using OEMS.Models;
using OEMS.Models.Model.HR_PayRoll;
using OEMS.Repository.Repositories.HRPayroll;
using OEMS.Service.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Service.Services.HRPayroll
{
    public class SalaryEmployeeService : IService<SalaryEmployee>
    {
        SalaryEmployeeRepository salaryEmployeeRepository;
        public SalaryEmployeeService()
        {
            salaryEmployeeRepository = new SalaryEmployeeRepository();
        }

        public bool Add(SalaryEmployee entity)
        {
            return salaryEmployeeRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<SalaryEmployee> entities)
        {
            return salaryEmployeeRepository.AddRange(entities);
        }

        public bool Update(SalaryEmployee entity)
        {
            return salaryEmployeeRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<SalaryEmployee> entities)
        {
            return salaryEmployeeRepository.AddRange(entities);
        }

        public bool Remove(long id)
        {
            SalaryEmployee entity = new SalaryEmployee();
            entity = salaryEmployeeRepository.SingleOrDefault(e => e.Id == id);
            return salaryEmployeeRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<SalaryEmployee> entities = new List<SalaryEmployee>();
            entities = salaryEmployeeRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return salaryEmployeeRepository.RemoveRange(entities);
        }

        public SalaryEmployee Get(long id)
        {
            return salaryEmployeeRepository.Get(id);
        }

        public SalaryEmployee SingleOrDefault(Expression<Func<SalaryEmployee, bool>> filter)
        {
            return salaryEmployeeRepository.SingleOrDefault(filter);
        }


        public IEnumerable<SalaryEmployee> GetAll()
        {
            return salaryEmployeeRepository.GetAll();
        }

        public IEnumerable<SalaryEmployee> Filter(Expression<Func<SalaryEmployee, bool>> filter, Func<IQueryable<SalaryEmployee>, IOrderedQueryable<SalaryEmployee>> orderBy = null, string[] Children = null)
        {
            return salaryEmployeeRepository.Filter(filter, orderBy);
        }

        public IEnumerable<SalaryEmployee> GetByPage(int pageno, int pagesize)
        {
            return salaryEmployeeRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return salaryEmployeeRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return salaryEmployeeRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return salaryEmployeeRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<SalaryEmployee, bool>> filter, Func<IQueryable<SalaryEmployee>, IOrderedQueryable<SalaryEmployee>> orderBy = null)
        {
            return salaryEmployeeRepository.Filter(pageno, pagesize, filter, orderBy);
        }
    }
}
