using OEMS.Models;
using OEMS.Models.Model.Inventory;
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
    public class RequisitionService : IService<Requisition>
    {
        private RequisitionRepository requisitionRepository;

        public RequisitionService()
        {
            requisitionRepository = new RequisitionRepository();
        }
        public bool Add(Requisition entity)
        {
            return requisitionRepository.Add(entity);
        }
        public CommonResponse getDataSetResponseBySp(string SpName)
        {
            return requisitionRepository.getDatasetResponseBySp(SpName);
        }

        public bool AddRange(IEnumerable<Requisition> entities)
        {
            return requisitionRepository.AddRange(entities);
        }

        public IEnumerable<Requisition> Filter(Expression<Func<Requisition, bool>> filter, Func<IQueryable<Requisition>, IOrderedQueryable<Requisition>> orderBy = null, string[] Children = null)
        {
            return requisitionRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<Requisition, bool>> filter, Func<IQueryable<Requisition>, IOrderedQueryable<Requisition>> orderBy = null)
        {
            return requisitionRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public Requisition Get(long id)
        {
            return requisitionRepository.Get(id);
        }

        public IEnumerable<Requisition> GetAll()
        {
            return requisitionRepository.GetAll();
        }

        public IEnumerable<Requisition> GetByPage(int pageno, int pagesize)
        {
            return requisitionRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return requisitionRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return requisitionRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return requisitionRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            Requisition entity = new Requisition();
            entity = requisitionRepository.SingleOrDefault(e => e.RequisitionId == id);
            entity.IsDeleted = true;
            
            entity.SetDate();
            return requisitionRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<Requisition> entities = new List<Requisition>();
            entities = requisitionRepository.Filter(x => ids.Contains(Convert.ToInt64(x.RequisitionId))).ToList();

            return requisitionRepository.RemoveRange(entities);
        }

        public Requisition SingleOrDefault(Expression<Func<Requisition, bool>> filter)
        {
            return requisitionRepository.SingleOrDefault(filter);
        }

        public bool Update(Requisition entity)
        {
            return requisitionRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<Requisition> entities)
        {
            return requisitionRepository.AddRange(entities);
        }


    }
}
