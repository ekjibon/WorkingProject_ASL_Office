using OEMS.Models;
using OEMS.Models.Model.TaskManagement;
using OEMS.Repository.Repositories;
using OEMS.Service.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Service.Services
{
    public class IssueTypeService : IService<IssueType>
    {
        private IssueTypeRepository issueTypeRepository;

        public IssueTypeService()
        {
            issueTypeRepository = new IssueTypeRepository();
        }
        public bool Add(IssueType entity)
        {
            return issueTypeRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<IssueType> entities)
        {
            return issueTypeRepository.AddRange(entities);
        }

        public bool Update(IssueType entity)
        {
            //Project _entity = projectRepository.SingleOrDefault(e => e.Id == entity.Id);
            return issueTypeRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<IssueType> entities)
        {
            return issueTypeRepository.AddRange(entities);
        }

        public IEnumerable<IssueType> Filter(Expression<Func<IssueType, bool>> filter, Func<IQueryable<IssueType>, IOrderedQueryable<IssueType>> orderBy = null, string[] Children = null)
        {
            return issueTypeRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<IssueType, bool>> filter, Func<IQueryable<IssueType>, IOrderedQueryable<IssueType>> orderBy = null)
        {
            return issueTypeRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public IssueType Get(long id)
        {
            return issueTypeRepository.Get(id);
        }

        public IEnumerable<IssueType> GetAll()
        {
            return issueTypeRepository.GetAll();
        }

        public IEnumerable<IssueType> GetByPage(int pageno, int pagesize)
        {
            return issueTypeRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return issueTypeRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return issueTypeRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return issueTypeRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            IssueType entity = new IssueType();
            entity = issueTypeRepository.SingleOrDefault(e => e.Id == id);
            return issueTypeRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<IssueType> entities = new List<IssueType>();
            entities = issueTypeRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return issueTypeRepository.RemoveRange(entities);
        }

        public IssueType SingleOrDefault(Expression<Func<IssueType, bool>> filter)
        {
            return issueTypeRepository.SingleOrDefault(filter);
        }



    }
}
