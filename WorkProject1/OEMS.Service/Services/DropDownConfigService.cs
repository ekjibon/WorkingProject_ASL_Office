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
using OEMS.Models.ViewModel;

namespace OEMS.Service.Services
{
    public class DropDownConfigService : IService<DropDownConfig>
    {
        private DropDownConfigRepository dropDownConfigRepository;

        public DropDownConfigService()
        {
            dropDownConfigRepository = new DropDownConfigRepository();
        }
        public bool Add(DropDownConfig entity)
        {         
            return  dropDownConfigRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<DropDownConfig> entities)
        {
            return dropDownConfigRepository.AddRange(entities);
        }

        public IEnumerable<DropDownConfig> Filter(Expression<Func<DropDownConfig, bool>> filter, Func<IQueryable<DropDownConfig>, IOrderedQueryable<DropDownConfig>> orderBy = null, string[] Children = null)
        {
            return dropDownConfigRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<DropDownConfig, bool>> filter, Func<IQueryable<DropDownConfig>, IOrderedQueryable<DropDownConfig>> orderBy = null)
        {
            return dropDownConfigRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public DropDownConfig Get(long id)
        {
            return dropDownConfigRepository.Get(id);
        }

        public IEnumerable<DropDownConfig> GetAll()
        {
            return dropDownConfigRepository.GetAll();
        }

        public IEnumerable<DropDownConfig> GetByPage(int pageno, int pagesize)
        {
            return dropDownConfigRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return dropDownConfigRepository.getPageResponse(pageno,pagesize);
        }
        public CommonResponse getDataSetResponseBySp(string SpName)
        {                 
            return dropDownConfigRepository.getDatasetResponseBySp(SpName);
        }
        public CommonResponse getResponseBySp(string SpName)
        {
            return dropDownConfigRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return dropDownConfigRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            DropDownConfig entity = new DropDownConfig();
            entity = dropDownConfigRepository.SingleOrDefault(e=>e.Id==id);
            return dropDownConfigRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<DropDownConfig> entities = new List<DropDownConfig>();
            entities = dropDownConfigRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return dropDownConfigRepository.RemoveRange(entities);
        }

        public DropDownConfig SingleOrDefault(Expression<Func<DropDownConfig, bool>> filter)
        {
            return dropDownConfigRepository.SingleOrDefault(filter);
        }

        public bool Update(DropDownConfig entity)
        { 
            return dropDownConfigRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<DropDownConfig> entities)
        {
            return dropDownConfigRepository.AddRange(entities);
        }
        public bool Remove(string text)
        {
            DropDownConfig entity = new DropDownConfig();
            entity = dropDownConfigRepository.SingleOrDefault(e => e.Text == text);
            return dropDownConfigRepository.Remove(entity);
        }

        public int GetDropDownConfigId(string text)
        {

            int id = dropDownConfigRepository.SingleOrDefault(e => e.Text == text).Id;
            return id;
        }

    }
}
