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

namespace OEMS.Service.Services
{
    public class AspNetPageService : IService<AspNetPage>
    {
        private AspNetPageRepository aspNetPageRepository;

        public AspNetPageService()
        {
            aspNetPageRepository = new AspNetPageRepository();
        }
        public bool Add(AspNetPage entity)
        {
        // entity.Id =   ( Convert.ToInt32( navbarRepository.GetAll().ToList().Select(e => e.Id).Max()) + 1).ToString();
          return  aspNetPageRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<AspNetPage> entities)
        {
            return aspNetPageRepository.AddRange(entities);
        }

        public IEnumerable<AspNetPage> Filter(Expression<Func<AspNetPage, bool>> filter, Func<IQueryable<AspNetPage>, IOrderedQueryable<AspNetPage>> orderBy = null, string[] Children = null)
        {
            return aspNetPageRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<AspNetPage, bool>> filter, Func<IQueryable<AspNetPage>, IOrderedQueryable<AspNetPage>> orderBy = null)
        {
            return aspNetPageRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public AspNetPage Get(long id)
        {
            return aspNetPageRepository.Get(id);
        }

        public IEnumerable<AspNetPage> GetAll()
        {
            return aspNetPageRepository.GetAll();
        }
        public IEnumerable<AspNetPage> GetEMPAll()
        {
            List<AspNetPage> asplist = new List<AspNetPage>();
            asplist.Add(new AspNetPage() { PageID = 1, ParentID = 0, NameOption_En = "Dashboard", Action = "Dashboard", Controller = "Employee", Displayorder = 1, IconClass = "fas fa-address-card", ModuleId = 0 });
            asplist.Add(new AspNetPage() { PageID = 2, ParentID = 0, NameOption_En = "EmployeeProfile", Action = "EmployeeProfile", Controller = "Employee", Displayorder = 1, IconClass = "fas fa-user-tie", ModuleId = 0 });
            asplist.Add(new AspNetPage() { PageID = 3, ParentID = 0, NameOption_En = "Mark Submission", Displayorder = 1, IconClass = "fas fa-address-card", ModuleId = 0 });
            asplist.Add(new AspNetPage() { PageID = 31, ParentID = 3, NameOption_En = "TeacherExamList", Action = "TeacherExamList", Controller = "Result", Displayorder = 1, IconClass = "fas fa-user-tie", ModuleId = 0 });
            asplist.Add(new AspNetPage() { PageID = 32, ParentID = 3, NameOption_En = "TeacherMarksEntrySubjectList", Action = "TeacherMarksEntrySubjectList", Controller = "Employee", Displayorder = 1, IconClass = "fas fa-user-tie", ModuleId = 0 });
            asplist.Add(new AspNetPage() { PageID = 4, ParentID = 0, NameOption_En = "EmployeeRequest", Action = "EmployeeRequest", Controller = "Employee", Displayorder = 1, IconClass = "fas fa-bullhorn", ModuleId = 0 });
            asplist.Add(new AspNetPage() { PageID = 5, ParentID = 0, NameOption_En = "ParentsMeeting", Action = "ParentsMeeting", Controller = "Employee", Displayorder = 1, IconClass = "fas fa-handshake", ModuleId = 0 });
            asplist.Add(new AspNetPage() { PageID = 6, ParentID = 0, NameOption_En = "Newsletter", Action = "Newsletter", Controller = "Notice", Displayorder = 1, IconClass = "fas fa-newspaper", ModuleId = 0 });
            asplist.Add(new AspNetPage() { PageID = 7, ParentID = 0, NameOption_En = "ECAList", Action = "ECAList", Controller = "ECA", Displayorder = 1, IconClass = "fas fa-road", ModuleId = 0 });
            asplist.Add(new AspNetPage() { PageID = 8, ParentID = 0, NameOption_En = "Routine", Action = "Routine", Controller = "Employee", Displayorder = 1, IconClass = "fas fa-road", ModuleId = 0 });
            asplist.Add(new AspNetPage() { PageID = 9, ParentID = 0, NameOption_En = "Payroll", Action = "Payroll", Controller = "Employee", Displayorder = 1, IconClass = "fas fa-road", ModuleId = 0 });
         

            return asplist;
        }
        public IEnumerable<AspNetPage> GetByPage(int pageno, int pagesize)
        {
            return aspNetPageRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return aspNetPageRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return aspNetPageRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return aspNetPageRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            AspNetPage entity = new AspNetPage();
            entity = aspNetPageRepository.SingleOrDefault(e=>e.PageID==id);
            return aspNetPageRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<AspNetPage> entities = new List<AspNetPage>();
            entities = aspNetPageRepository.Filter(x => ids.Contains(Convert.ToInt64(x.PageID))).ToList();

            return aspNetPageRepository.RemoveRange(entities);
        }

        public AspNetPage SingleOrDefault(Expression<Func<AspNetPage, bool>> filter)
        {
            return aspNetPageRepository.SingleOrDefault(filter);
        }

        public bool Update(AspNetPage entity)
        {
            //AspNetPage _entity = navbarRepository.SingleOrDefault(e => e.Id == entity.Id);
            //_entity.Name = entity.Name;

            return aspNetPageRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<AspNetPage> entities)
        {
            return aspNetPageRepository.AddRange(entities);
        }
        

    }
}
