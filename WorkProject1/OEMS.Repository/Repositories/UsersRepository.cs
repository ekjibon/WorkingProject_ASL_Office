using OEMS.Models;
using OEMS.Models.Model;
using OEMS.Repository.Helpers;
using OEMS.Repository.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Repository.Repositories
{
    public class UsersRepository : BaseRepository<AspNetUser>,  IDisposable
    {
        public static ModelDbContext _context = new ModelDbContext();
        CommonRepository Common = new CommonRepository();
        public UsersRepository() : base(_context = new ModelDbContext())
        {
         
        }
        
       public CommonResponse GetUsetList(int pageno, int pagesize,string  searchtext)
        {
            // Set.Local.Clear();
            CommonResponse cr = new CommonResponse();
            cr.pageno = pageno;
            cr.pagesize = pagesize;
            cr.totalcount = GetCount();
            List<AspNetUser> result = new List<AspNetUser>();
            IEnumerable<AspNetUser> _res;
            
            if (pagesize != -1)
            {
          //    CommonRepository
                result = Set.AsNoTracking().Include("AspNetRoles").ToList().Skip(pagesize * (pageno - 1)).Take(pagesize).ToList();
                cr.results = result;
            }
            else
            {
                _res = Set.AsNoTracking().Include("AspNetRoles").ToList().Select(e => new AspNetUser
                {
                    Address = e.Address,
                    Email = e.Email,
                    FullName = e.FullName,
                    Id = e.Id,
                    MobileNo = e.MobileNo,
                    UserName = e.UserName,
                    PhoneNumber =e.PhoneNumber,
                    AccessFailedCount = e.AccessFailedCount,
                    LockoutEnabled = e.LockoutEnabled,
                    EmailConfirmed =e.EmailConfirmed,
                    TwoFactorEnabled =e.TwoFactorEnabled
                });
                cr.results = _res.ToList();


            }
            if (!string.IsNullOrEmpty(searchtext))
            {
                result = result.Where(e => e.Email.Contains(searchtext) || e.FullName.Contains(searchtext)).ToList();
                cr.totalcount = result.Count();
            }

            cr.httpStatusCode = HttpStatusCode.OK;
            cr.totalSum = 0;
            cr.message = string.Empty;
            // cr.results = result;

            return cr;
        }


        #region IDisposable Support
        private bool disposedValue = false; // To detect redundant calls

        protected virtual void Dispose(bool disposing)
        {
            if (!disposedValue)
            {
                if (disposing)
                {
                    // TODO: dispose managed state (managed objects).

                    _context.Dispose();
                   // _context = null;
                }

                // TODO: free unmanaged resources (unmanaged objects) and override a finalizer below.
                // TODO: set large fields to null.

                disposedValue = true;
            }
        }

        // TODO: override a finalizer only if Dispose(bool disposing) above has code to free unmanaged resources.
        ~UsersRepository()
        {
            // Do not change this code. Put cleanup code in Dispose(bool disposing) above.
            Dispose(true);
        }

        // This code added to correctly implement the disposable pattern.
        public void Dispose()
        {
            // Do not change this code. Put cleanup code in Dispose(bool disposing) above.
            Dispose(true);
            // TODO: uncomment the following line if the finalizer is overridden above.
            // GC.SuppressFinalize(this);
        }
        #endregion
    }
}
