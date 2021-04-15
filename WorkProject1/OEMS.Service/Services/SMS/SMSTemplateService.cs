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
using OEMS.Models.Model.Student;
using OEMS.Models.Model.SMS;

namespace OEMS.Service.Services
{
    public class SMSTemplateService : IService<SMSTemplate>
    {
        private SMSTemplateRepository SMSTemplateRepository;

        public SMSTemplateService()
        {
            SMSTemplateRepository = new SMSTemplateRepository();
        }
        public bool Add(SMSTemplate entity)
        {
            return  SMSTemplateRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<SMSTemplate> entities)
        {
            return SMSTemplateRepository.AddRange(entities);
        }

        public IEnumerable<SMSTemplate> Filter(Expression<Func<SMSTemplate, bool>> filter, Func<IQueryable<SMSTemplate>, IOrderedQueryable<SMSTemplate>> orderBy = null, string[] Children = null)
        {
            return SMSTemplateRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<SMSTemplate, bool>> filter, Func<IQueryable<SMSTemplate>, IOrderedQueryable<SMSTemplate>> orderBy = null)
        {
            return SMSTemplateRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public SMSTemplate Get(long id)
        {
            return SMSTemplateRepository.Get(id);
        }

        public IEnumerable<SMSTemplate> GetAll()
        {
            return SMSTemplateRepository.GetAll();
        }

        public IEnumerable<SMSTemplate> GetByPage(int pageno, int pagesize)
        {
            return SMSTemplateRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return SMSTemplateRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return SMSTemplateRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return SMSTemplateRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            SMSTemplate entity = new SMSTemplate();
            entity = SMSTemplateRepository.SingleOrDefault(e=>e.TemplateId==id);
            entity.IsDeleted = true;
            entity.SetDate();
            return SMSTemplateRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<SMSTemplate> entities = new List<SMSTemplate>();
            entities = SMSTemplateRepository.Filter(x => ids.Contains(Convert.ToInt64(x.TemplateId))).ToList();

            return SMSTemplateRepository.RemoveRange(entities);
        }

        public SMSTemplate SingleOrDefault(Expression<Func<SMSTemplate, bool>> filter)
        {
            return SMSTemplateRepository.SingleOrDefault(filter);
        }

        public bool Update(SMSTemplate entity)
        { 
            return SMSTemplateRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<SMSTemplate> entities)
        {
            return SMSTemplateRepository.AddRange(entities);
        }
        public bool Remove(int RouteId)
        {
            SMSTemplate entity = new SMSTemplate();
            entity = SMSTemplateRepository.SingleOrDefault(e => e.TemplateId == RouteId);
            return SMSTemplateRepository.Remove(entity);
        }

        public int GetSMSTemplateId(long RouteId)
        {

            int SMSTemplateID = SMSTemplateRepository.SingleOrDefault(e => e.TemplateId == RouteId).TemplateId;
            return SMSTemplateID;
        }

       

    }
}
