using OEMS.Models;
using OEMS.Models.Model;
using OEMS.Models.Model.Inventory;
using OEMS.Repository;
using OEMS.Repository.Repositories;
using OEMS.Repository.Repositories.Inventory;
using OEMS.Service.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Service.Services.Inventory
{

    public class CustomerService : IService<Customer>
    {
        private CustomerRepository customerRepository;
        private CommonRepository commonRepository = new CommonRepository();

        public CustomerService()
        {
            customerRepository = new CustomerRepository();
        }
        public bool Add(Customer entity)
        {
            return customerRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<Customer> entities)
        {
            return customerRepository.AddRange(entities);
        }

        public IEnumerable<Customer> Filter(Expression<Func<Customer, bool>> filter, Func<IQueryable<Customer>, IOrderedQueryable<Customer>> orderBy = null, string[] Children = null)
        {
            return customerRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<Customer, bool>> filter, Func<IQueryable<Customer>, IOrderedQueryable<Customer>> orderBy = null)
        {
            return customerRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public Customer Get(long id)
        {
            return customerRepository.Get(id);
        }

        public IEnumerable<Customer> GetAll()
        {
            return customerRepository.GetAll();
        }

        public IEnumerable<Customer> GetByPage(int pageno, int pagesize)
        {
            return customerRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return customerRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return customerRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return customerRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            Customer entity = new Customer();
            entity = customerRepository.SingleOrDefault(e => e.CustomerId == id);
            entity.IsDeleted = true;
            entity.SetDate();
            return customerRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<Customer> entities = new List<Customer>();
            entities = customerRepository.Filter(x => ids.Contains(Convert.ToInt64(x.CustomerId))).ToList();

            return customerRepository.RemoveRange(entities);
        }

        public Customer SingleOrDefault(Expression<Func<Customer, bool>> filter)
        {
            return customerRepository.SingleOrDefault(filter);
        }

        public bool Update(Customer entity)
        {
            return customerRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<Customer> entities)
        {
            return customerRepository.AddRange(entities);
        }
        public List<DropDownConfig> SearchLedger(string SrchText)
        {
            var dt = commonRepository.GetBySpWithParam("GetTypeHeadForInventoryLedger", new object[] { SrchText, 1 });
            return CommonRepository.ConvertDataTable<DropDownConfig>(dt);
        }

    }
}
