using OEMS.Models;
using OEMS.Models.Model.Document;
using OEMS.Repository.Repositories;
using OEMS.Service.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace OEMS.Service.Services
{
    public class PortalDocumentService :IService<PortalDocument>
    {
        private PortalDocumentRepository portalDocumentRepository;

        public PortalDocumentService()
        {
            portalDocumentRepository = new PortalDocumentRepository();
        }
        public bool Add(PortalDocument entity)
        {
            // entity.Id =   ( Convert.ToInt32( ClassInfoRepository.GetAll().ToList().Select(e => e.Id).Max()) + 1).ToString();
            var aa = HttpContext.Current.User.Identity.Name;
            return portalDocumentRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<PortalDocument> entities)
        {
            return portalDocumentRepository.AddRange(entities);
        }

        public IEnumerable<PortalDocument> Filter(Expression<Func<PortalDocument, bool>> filter, Func<IQueryable<PortalDocument>, IOrderedQueryable<PortalDocument>> orderBy = null, string[] Children = null)
        {
            return portalDocumentRepository.Filter(filter, orderBy, Children);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<PortalDocument, bool>> filter, Func<IQueryable<PortalDocument>, IOrderedQueryable<PortalDocument>> orderBy = null)
        {
            return portalDocumentRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public PortalDocument Get(long id)
        {
            return portalDocumentRepository.Get(id);
        }

        public IEnumerable<PortalDocument> GetAll()
        {
            return portalDocumentRepository.GetAll();
        }

        public IEnumerable<PortalDocument> GetByPage(int pageno, int pagesize)
        {
            return portalDocumentRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return portalDocumentRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return portalDocumentRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return portalDocumentRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            PortalDocument entity = new PortalDocument();
            entity = portalDocumentRepository.SingleOrDefault(e => e.DocumentId == id);
        
            return portalDocumentRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<PortalDocument> entities = new List<PortalDocument>();
            entities = portalDocumentRepository.Filter(x => ids.Contains(Convert.ToInt64(x.ClassId))).ToList();

            return portalDocumentRepository.RemoveRange(entities);
        }

        public PortalDocument SingleOrDefault(Expression<Func<PortalDocument, bool>> filter)
        {
            return portalDocumentRepository.SingleOrDefault(filter);
        }

        public bool Update(PortalDocument entity)
        {

            return portalDocumentRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<PortalDocument> entities)
        {
            return portalDocumentRepository.AddRange(entities);
        }



    }
}
