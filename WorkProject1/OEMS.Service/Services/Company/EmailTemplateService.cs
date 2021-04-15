using OEMS.Service.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using OEMS.Models;
using System.Linq.Expressions;
using OEMS.Models.Model.Account;
using OEMS.Repository.Repositories.Account;
using OEMS.Models.Model.Company;
using OEMS.Repository.Repositories.Company;

namespace OEMS.Service.Services.Account
{
    public class EmailTemplateService : IService<EmailTemplate>
    {
        private EmailTemplateRepository AcBranchRepository;

        public EmailTemplateService()
        {
            AcBranchRepository = new EmailTemplateRepository();
        }        
        public bool Add(EmailTemplate entity)
        {        
          return AcBranchRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<EmailTemplate> entities)
        {
            return AcBranchRepository.AddRange(entities);
        }

        public IEnumerable<EmailTemplate> Filter(Expression<Func<EmailTemplate, bool>> filter, Func<IQueryable<EmailTemplate>, IOrderedQueryable<EmailTemplate>> orderBy = null, string[] Children = null)
        {
            return AcBranchRepository.Filter(filter,orderBy,Children);
        }

        
        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<EmailTemplate, bool>> filter, Func<IQueryable<EmailTemplate>, IOrderedQueryable<EmailTemplate>> orderBy = null)
        {
            return AcBranchRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public EmailTemplate Get(long id)
        {
            return AcBranchRepository.Get(id);
        }

        public IEnumerable<EmailTemplate> GetAll()
        {
            return AcBranchRepository.GetAll();
        }      
        public IEnumerable<EmailTemplate> GetByPage(int pageno, int pagesize)
        {
            return AcBranchRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return AcBranchRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return AcBranchRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return AcBranchRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            EmailTemplate entity = new EmailTemplate();
            entity = AcBranchRepository.SingleOrDefault(a=>a.Id==id);
            return AcBranchRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<EmailTemplate> entities = new List<EmailTemplate>();
            entities = AcBranchRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return AcBranchRepository.RemoveRange(entities);
        }

        public EmailTemplate SingleOrDefault(Expression<Func<EmailTemplate, bool>> filter)
        {
            return AcBranchRepository.SingleOrDefault(filter);
        }
        
        public bool Update(EmailTemplate entity)
        { 
            return AcBranchRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<EmailTemplate> entities)
        {
            return AcBranchRepository.UpdateRange(entities);
        }
       

    }
}
