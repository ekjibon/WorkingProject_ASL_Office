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
    public class SMSExtNumbersService : IService<SMSExtNumbers>
    {
        private SMSExtNumbersRepository SMSExtNumbersRepository;

        public SMSExtNumbersService()
        {
            SMSExtNumbersRepository = new SMSExtNumbersRepository();
        }
        public bool Add(SMSExtNumbers entity)
        {
            return SMSExtNumbersRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<SMSExtNumbers> entities)
        {
            return SMSExtNumbersRepository.AddRange(entities);
        }

        public IEnumerable<SMSExtNumbers> Filter(Expression<Func<SMSExtNumbers, bool>> filter, Func<IQueryable<SMSExtNumbers>, IOrderedQueryable<SMSExtNumbers>> orderBy = null, string[] Children = null)
        {
            return SMSExtNumbersRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<SMSExtNumbers, bool>> filter, Func<IQueryable<SMSExtNumbers>, IOrderedQueryable<SMSExtNumbers>> orderBy = null)
        {
            return SMSExtNumbersRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public SMSExtNumbers Get(long id)
        {
            return SMSExtNumbersRepository.Get(id);
        }

        public IEnumerable<SMSExtNumbers> GetAll()
        {
            return SMSExtNumbersRepository.GetAll();
        }

        public IEnumerable<SMSExtNumbers> GetByPage(int pageno, int pagesize)
        {
            return SMSExtNumbersRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return SMSExtNumbersRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return SMSExtNumbersRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return SMSExtNumbersRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            SMSExtNumbers entity = new SMSExtNumbers();
            entity = SMSExtNumbersRepository.SingleOrDefault(e => e.GroupId == id);
            entity.IsDeleted = true;
            entity.SetDate();
            return SMSExtNumbersRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<SMSExtNumbers> entities = new List<SMSExtNumbers>();
            entities = SMSExtNumbersRepository.Filter(x => ids.Contains(Convert.ToInt64(x.GroupId))).ToList();

            return SMSExtNumbersRepository.RemoveRange(entities);
        }

        public SMSExtNumbers SingleOrDefault(Expression<Func<SMSExtNumbers, bool>> filter)
        {
            return SMSExtNumbersRepository.SingleOrDefault(filter);
        }

        public bool Update(SMSExtNumbers entity)
        {
            return SMSExtNumbersRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<SMSExtNumbers> entities)
        {
            return SMSExtNumbersRepository.AddRange(entities);
        }
        public bool Remove(int RouteId)
        {
            SMSExtNumbers entity = new SMSExtNumbers();
            entity = SMSExtNumbersRepository.SingleOrDefault(e => e.GroupId == RouteId);
            return SMSExtNumbersRepository.Remove(entity);
        }

        public int GetSMSExtNumbersId(long RouteId)
        {

            int SMSExtNumbersID = SMSExtNumbersRepository.SingleOrDefault(e => e.GroupId == RouteId).GroupId;
            return SMSExtNumbersID;
        }



    }
}
