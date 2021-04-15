using OEMS.Models.Model;
using OEMS.Service.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using OEMS.Models;
using System.Linq.Expressions;
using OEMS.Repository.Repositories;
using UI.Admin.Models.Task;

namespace OEMS.Service.Services
{
    public class TestSiteService : IService<TestSite>
    {
        private TestSiteRepository testSiteRepository;

        public TestSiteService()
        {
            testSiteRepository = new TestSiteRepository();
        }
        public bool Add(TestSite entity)
        {
        // entity.Id =   ( Convert.ToInt32( SessionRepository.GetAll().ToList().Select(e => e.Id).Max()) + 1).ToString();
          return  testSiteRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<TestSite> entities)
        {
            return testSiteRepository.AddRange(entities);
        }

        public bool Update(TestSite entity)
        {
            return testSiteRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<TestSite> entities)
        {
            return testSiteRepository.AddRange(entities);
        }

        public IEnumerable<TestSite> Filter(Expression<Func<TestSite, bool>> filter, Func<IQueryable<TestSite>, IOrderedQueryable<TestSite>> orderBy = null, string[] Children = null)
        {
            return testSiteRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<TestSite, bool>> filter, Func<IQueryable<TestSite>, IOrderedQueryable<TestSite>> orderBy = null)
        {
            return testSiteRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public TestSite Get(long id)
        {
            return testSiteRepository.Get(id);
        }

        public IEnumerable<TestSite> GetAll()
        {
            return testSiteRepository.GetAll();
        }

        public IEnumerable<TestSite> GetByPage(int pageno, int pagesize)
        {
            return testSiteRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return testSiteRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return testSiteRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return testSiteRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            TestSite entity = new TestSite();
            entity = testSiteRepository.SingleOrDefault(e=>e.Id==id);
            return testSiteRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<TestSite> entities = new List<TestSite>();
            entities = testSiteRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return testSiteRepository.RemoveRange(entities);
        }

        public TestSite SingleOrDefault(Expression<Func<TestSite, bool>> filter)
        {
            return testSiteRepository.SingleOrDefault(filter);
        }

        
       

    }
}
