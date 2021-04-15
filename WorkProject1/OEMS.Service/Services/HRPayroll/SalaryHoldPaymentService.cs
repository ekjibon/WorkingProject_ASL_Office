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
    public class SalaryHoldPaymentService : IService<SalaryHoldPayment>
    {
        SalaryHoldPaymentRepository salaryHoldPaymentRepository;
        public SalaryHoldPaymentService()
        {
            salaryHoldPaymentRepository = new SalaryHoldPaymentRepository();
        }

        public bool Add(SalaryHoldPayment entity)
        {
            return salaryHoldPaymentRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<SalaryHoldPayment> entities)
        {
            return salaryHoldPaymentRepository.AddRange(entities);
        }

        public bool Update(SalaryHoldPayment entity)
        {
            return salaryHoldPaymentRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<SalaryHoldPayment> entities)
        {
            return salaryHoldPaymentRepository.AddRange(entities);
        }

        public bool Remove(long id)
        {
            SalaryHoldPayment entity = new SalaryHoldPayment();
            entity = salaryHoldPaymentRepository.SingleOrDefault(e => e.Id == id);
            return salaryHoldPaymentRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<SalaryHoldPayment> entities = new List<SalaryHoldPayment>();
            entities = salaryHoldPaymentRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return salaryHoldPaymentRepository.RemoveRange(entities);
        }

        public SalaryHoldPayment Get(long id)
        {
            return salaryHoldPaymentRepository.Get(id);
        }

        public SalaryHoldPayment SingleOrDefault(Expression<Func<SalaryHoldPayment, bool>> filter)
        {
            return salaryHoldPaymentRepository.SingleOrDefault(filter);
        }


        public IEnumerable<SalaryHoldPayment> GetAll()
        {
            return salaryHoldPaymentRepository.GetAll();
        }

        public IEnumerable<SalaryHoldPayment> Filter(Expression<Func<SalaryHoldPayment, bool>> filter, Func<IQueryable<SalaryHoldPayment>, IOrderedQueryable<SalaryHoldPayment>> orderBy = null, string[] Children = null)
        {
            return salaryHoldPaymentRepository.Filter(filter, orderBy);
        }

        public IEnumerable<SalaryHoldPayment> GetByPage(int pageno, int pagesize)
        {
            return salaryHoldPaymentRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return salaryHoldPaymentRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return salaryHoldPaymentRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return salaryHoldPaymentRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<SalaryHoldPayment, bool>> filter, Func<IQueryable<SalaryHoldPayment>, IOrderedQueryable<SalaryHoldPayment>> orderBy = null)
        {
            return salaryHoldPaymentRepository.Filter(pageno, pagesize, filter, orderBy);
        }
    }
}
