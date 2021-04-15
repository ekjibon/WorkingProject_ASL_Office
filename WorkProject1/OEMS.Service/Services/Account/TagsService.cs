using OEMS.Service.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using OEMS.Models;
using System.Linq.Expressions;
using OEMS.Models.Model.Account;
using OEMS.Repository.Repositories.Account;

namespace OEMS.Service.Services.Account
{
    public class TagsService : IService<Tags>
    {
        private TagsRepository tagsRepository;

        public TagsService()
        {
            tagsRepository = new TagsRepository();
        }        
        public bool Add(Tags entity)
        {        
          return  tagsRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<Tags> entities)
        {
            return tagsRepository.AddRange(entities);
        }

        public IEnumerable<Tags> Filter(Expression<Func<Tags, bool>> filter, Func<IQueryable<Tags>, IOrderedQueryable<Tags>> orderBy = null, string[] Children = null)
        {
            return tagsRepository.Filter(filter,orderBy,Children);
        }

        
        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<Tags, bool>> filter, Func<IQueryable<Tags>, IOrderedQueryable<Tags>> orderBy = null)
        {
            return tagsRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public Tags Get(long id)
        {
            return tagsRepository.Get(id);
        }

        public IEnumerable<Tags> GetAll()
        {
            return tagsRepository.GetAll();
        }      
        public IEnumerable<Tags> GetByPage(int pageno, int pagesize)
        {
            return tagsRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return tagsRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return tagsRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return tagsRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            Tags entity = new Tags();
            entity = tagsRepository.SingleOrDefault(e=>e.TagId==id);
            return tagsRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<Tags> entities = new List<Tags>();
            entities = tagsRepository.Filter(x => ids.Contains(Convert.ToInt64(x.TagId))).ToList();

            return tagsRepository.RemoveRange(entities);
        }

        public Tags SingleOrDefault(Expression<Func<Tags, bool>> filter)
        {
            return tagsRepository.SingleOrDefault(filter);
        }

        //public bool UpdatePairSubjectID(Tags entity)
        //{
        //    Tags _entity = TagsRepository.SingleOrDefault(e => e.SubID == entity.SubID); 
        //    _entity.PairSubjectID = entity.PairSubjectID;
        //    _entity.SetDate();
        //    _entity.UpdateBy = entity.UpdateBy;

        //    return TagsRepository.Update(_entity);             
        //}

        //public bool UpdateDeleteStatus(Tags entity)
        //{
        //    Tags _entity = TagsRepository.SingleOrDefault(e => e.SubID == entity.SubID);
        //    _entity.IsDeleted = entity.IsDeleted;
        //    _entity.SetDate();
        //    _entity.UpdateBy = entity.UpdateBy;

        //    return TagsRepository.Update(_entity);
        //}
        public bool Update(Tags entity)
        { 
            return tagsRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<Tags> entities)
        {
            return tagsRepository.UpdateRange(entities);
        }
        public bool Remove(string Title)
        {
            Tags entity = new Tags();
            entity = tagsRepository.SingleOrDefault(e => e.Title == Title);
            return tagsRepository.Remove(entity);
        }

        public int GetTagsId(int TagId)
        {
            int TagsID = tagsRepository.SingleOrDefault(e => e.TagId == TagId).TagId;
            return TagsID;
        }

    }
}
