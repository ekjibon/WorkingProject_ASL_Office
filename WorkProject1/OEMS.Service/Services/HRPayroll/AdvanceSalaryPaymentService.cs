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
    public class AdvanceSalaryPaymentService : IService<AdvanceSalaryPayment>
    {
        AdvanceSalaryPaymentRepository advanceSalaryPaymentRepository;
        public AdvanceSalaryPaymentService()
        {
            advanceSalaryPaymentRepository = new AdvanceSalaryPaymentRepository();
        }

        public bool Add(AdvanceSalaryPayment entity)
        {
            return advanceSalaryPaymentRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<AdvanceSalaryPayment> entities)
        {
            return advanceSalaryPaymentRepository.AddRange(entities);
        }

        public bool Update(AdvanceSalaryPayment entity)
        {
            return advanceSalaryPaymentRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<AdvanceSalaryPayment> entities)
        {
            return advanceSalaryPaymentRepository.AddRange(entities);
        }

        public bool Remove(long id)
        {
            AdvanceSalaryPayment entity = new AdvanceSalaryPayment();
            entity = advanceSalaryPaymentRepository.SingleOrDefault(e => e.Id == id);
            return advanceSalaryPaymentRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<AdvanceSalaryPayment> entities = new List<AdvanceSalaryPayment>();
            entities = advanceSalaryPaymentRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return advanceSalaryPaymentRepository.RemoveRange(entities);
        }

        public AdvanceSalaryPayment Get(long id)
        {
            return advanceSalaryPaymentRepository.Get(id);
        }

        public AdvanceSalaryPayment SingleOrDefault(Expression<Func<AdvanceSalaryPayment, bool>> filter)
        {
            return advanceSalaryPaymentRepository.SingleOrDefault(filter);
        }


        public IEnumerable<AdvanceSalaryPayment> GetAll()
        {
            return advanceSalaryPaymentRepository.GetAll();
        }

        public IEnumerable<AdvanceSalaryPayment> Filter(Expression<Func<AdvanceSalaryPayment, bool>> filter, Func<IQueryable<AdvanceSalaryPayment>, IOrderedQueryable<AdvanceSalaryPayment>> orderBy = null, string[] Children = null)
        {
            return advanceSalaryPaymentRepository.Filter(filter, orderBy);
        }

        public IEnumerable<AdvanceSalaryPayment> GetByPage(int pageno, int pagesize)
        {
            return advanceSalaryPaymentRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return advanceSalaryPaymentRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return advanceSalaryPaymentRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return advanceSalaryPaymentRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<AdvanceSalaryPayment, bool>> filter, Func<IQueryable<AdvanceSalaryPayment>, IOrderedQueryable<AdvanceSalaryPayment>> orderBy = null)
        {
            return advanceSalaryPaymentRepository.Filter(pageno, pagesize, filter, orderBy);
        }
    }
}
