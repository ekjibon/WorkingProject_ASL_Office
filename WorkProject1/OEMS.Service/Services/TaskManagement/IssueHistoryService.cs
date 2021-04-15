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
using UI.Admin.Models.Task;

namespace OEMS.Service.Services
{
    public class IssueHistoryService : IService<IssueHistory>
    {
        private IssueHistoryRepository issueHistoryRepository;

        public IssueHistoryService()
        {
            issueHistoryRepository = new IssueHistoryRepository();
        }
        public bool Add(IssueHistory entity)
        {
            return issueHistoryRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<IssueHistory> entities)
        {
            return issueHistoryRepository.AddRange(entities);
        }

        public bool Update(IssueHistory entity)
        {
            //Project _entity = projectRepository.SingleOrDefault(e => e.Id == entity.Id);
            return issueHistoryRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<IssueHistory> entities)
        {
            return issueHistoryRepository.AddRange(entities);
        }

        public IEnumerable<IssueHistory> Filter(Expression<Func<IssueHistory, bool>> filter, Func<IQueryable<IssueHistory>, IOrderedQueryable<IssueHistory>> orderBy = null, string[] Children = null)
        {
            return issueHistoryRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<IssueHistory, bool>> filter, Func<IQueryable<IssueHistory>, IOrderedQueryable<IssueHistory>> orderBy = null)
        {
            return issueHistoryRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public IssueHistory Get(long id)
        {
            return issueHistoryRepository.Get(id);
        }

        public IEnumerable<IssueHistory> GetAll()
        {
            return issueHistoryRepository.GetAll();
        }

        public IEnumerable<IssueHistory> GetByPage(int pageno, int pagesize)
        {
            return issueHistoryRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return issueHistoryRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return issueHistoryRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return issueHistoryRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            IssueHistory entity = new IssueHistory();
            entity = issueHistoryRepository.SingleOrDefault(e => e.HistoryId == id);
            return issueHistoryRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
           List<IssueHistory> entities = new List<IssueHistory>();
            entities = issueHistoryRepository.Filter(x => ids.Contains(Convert.ToInt64(x.HistoryId))).ToList();

            return issueHistoryRepository.RemoveRange(entities);
        }

        public IssueHistory SingleOrDefault(Expression<Func<IssueHistory, bool>> filter)
        {
            return issueHistoryRepository.SingleOrDefault(filter);
        }



    }
}
