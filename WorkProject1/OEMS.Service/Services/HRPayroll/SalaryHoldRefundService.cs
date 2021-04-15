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
    public class SalaryHoldRefundService : IService<SalaryHoldRefund>
    {
        SalaryHoldRefundRepository salaryHoldRefundRepository;
        public SalaryHoldRefundService()
        {
            salaryHoldRefundRepository = new SalaryHoldRefundRepository();
        }

        public bool Add(SalaryHoldRefund entity)
        {
            return salaryHoldRefundRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<SalaryHoldRefund> entities)
        {
            return salaryHoldRefundRepository.AddRange(entities);
        }

        public bool Update(SalaryHoldRefund entity)
        {
            return salaryHoldRefundRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<SalaryHoldRefund> entities)
        {
            return salaryHoldRefundRepository.AddRange(entities);
        }

        public bool Remove(long id)
        {
            SalaryHoldRefund entity = new SalaryHoldRefund();
            entity = salaryHoldRefundRepository.SingleOrDefault(e => e.Id == id);
            return salaryHoldRefundRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<SalaryHoldRefund> entities = new List<SalaryHoldRefund>();
            entities = salaryHoldRefundRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return salaryHoldRefundRepository.RemoveRange(entities);
        }

        public SalaryHoldRefund Get(long id)
        {
            return salaryHoldRefundRepository.Get(id);
        }

        public SalaryHoldRefund SingleOrDefault(Expression<Func<SalaryHoldRefund, bool>> filter)
        {
            return salaryHoldRefundRepository.SingleOrDefault(filter);
        }


        public IEnumerable<SalaryHoldRefund> GetAll()
        {
            return salaryHoldRefundRepository.GetAll();
        }

        public IEnumerable<SalaryHoldRefund> Filter(Expression<Func<SalaryHoldRefund, bool>> filter, Func<IQueryable<SalaryHoldRefund>, IOrderedQueryable<SalaryHoldRefund>> orderBy = null, string[] Children = null)
        {
            return salaryHoldRefundRepository.Filter(filter, orderBy);
        }

        public IEnumerable<SalaryHoldRefund> GetByPage(int pageno, int pagesize)
        {
            return salaryHoldRefundRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return salaryHoldRefundRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return salaryHoldRefundRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return salaryHoldRefundRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<SalaryHoldRefund, bool>> filter, Func<IQueryable<SalaryHoldRefund>, IOrderedQueryable<SalaryHoldRefund>> orderBy = null)
        {
            return salaryHoldRefundRepository.Filter(pageno, pagesize, filter, orderBy);
        }
    }
}
