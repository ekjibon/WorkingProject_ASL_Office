using Microsoft.AspNet.Identity;
using Newtonsoft.Json;
using OEMS.AppData;
using OEMS.Models;
using OEMS.Models.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Net;
using System.Web;
using System.Web.Http;
using OEMS.Models.Model.Client;

namespace OEMS.Api.Controllers
{
    public class ClientController : ApiController
    {
        [Route("Client/GetAllClient/")]
        [HttpGet]
        public IHttpActionResult GetAllClient()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.ClientService.Filter(c => c.IsDeleted == false).ToList();
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Count > 0 ? $"{dt.Count} Data Found" : "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }
        [Route("Client/GetAllActiveClient/")]
        [HttpGet]
        public IHttpActionResult GetAllActiveClient()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.ClientService.Filter(c => c.IsDeleted == false && c.ActivityStatus=="A").ToList();
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Count > 0 ? $"{dt.Count} Data Found" : "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }
        [Route("Client/SearchClient/{SrchText}")]
        [HttpGet]
        public IHttpActionResult SearchClient(string SrchText)
        {
           
            CommonResponse cr = new CommonResponse();
            try
            {              
                cr.results = DataAccess.Instance.ClientService.SearchClient(SrchText);     
                cr.httpStatusCode = HttpStatusCode.OK;
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }
        [Route("Client/SearchClientDatabaseConfig/{SrchText}")]
        [HttpGet]
        public IHttpActionResult SearchClientDatabaseConfig(string SrchText)
        {

            CommonResponse cr = new CommonResponse();
            try
            {
                cr.results = DataAccess.Instance.ClientService.SearchClientDatabaseConfig(SrchText);
                cr.httpStatusCode = HttpStatusCode.OK;
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }

        [Route("Client/AddClient/")]
        [HttpPost]
        public IHttpActionResult AddClient(Client client)
        {
            CommonResponse cmr = new CommonResponse();
            int exist = 0;
            int exist1 = 0;
            int exist2 = 0;
            string message = "";
            try
            {
                if (client.Id == 0)
                {
                    exist = DataAccess.Instance.ClientService.Filter(c =>c.FullName == client.FullName && c.IsDeleted == false).Count();
                    exist1 = DataAccess.Instance.ClientService.Filter(c =>c.ShortName == client.ShortName && c.IsDeleted == false).Count();
                    //exist2 = DataAccess.Instance.ClientService.Filter(c => c.Code == client.Code && c.IsDeleted == false).Count();

                }
                if (exist>0)
                {
                    message = "Client Full Name already Exist..!";
                }
                else if (exist1 > 0)
                {
                    message = "Client Short Name already Exist..!";
                }
                else if (exist2 > 0)
                {
                    message = "Client Code already Exist..!";
                }
                if (exist <= 0 && exist1 <= 0 && exist2 <= 0)
                {
                    
                    client.AddBy = User.Identity.Name;
                    client.IsDeleted = false;
                    client.SetDate();
                    var response = DataAccess.Instance.ClientService.Add(client);
                    cmr.httpStatusCode = response ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cmr.message = response ? Constant.SAVED : Constant.FAILED;
                }

                else
                {
                    throw new Exception(message);
                }
            }

            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cmr);
        }

        [Route("Client/UpdateClient/")]
        [HttpPut]
        public IHttpActionResult UpdateClient(Client client)
        {
            CommonResponse cmr = new CommonResponse();
            int exist = 0;
            int exist1 = 0;
            int exist2 = 0;
            string message = "";

            try
            {
                if (client.Id != 0)
                {
                    exist = DataAccess.Instance.ClientService.Filter(c => c.Id != client.Id && c.FullName == client.FullName && c.IsDeleted == false).Count();
                    exist1 = DataAccess.Instance.ClientService.Filter(c => c.Id != client.Id && c.ShortName == client.ShortName && c.IsDeleted == false).Count();
                    //exist2 = DataAccess.Instance.ClientService.Filter(c => c.Id != client.Id && c.Code == client.Code && c.IsDeleted == false).Count();
                }
                if (exist > 0)
                {
                    message = "Client Full Name already Exist..!";
                }
                else if (exist1 > 0)
                {
                    message = "Client Short Name already Exist..!";
                }
                else if (exist2 > 0)
                {
                    message = "Client Code already Exist..!";
                }

                if (exist <= 0 && exist1 <= 0 && exist2 <= 0)
                {
                    var clientInfo = DataAccess.Instance.ClientService.Filter(e => e.IsDeleted == false && e.Id == client.Id).FirstOrDefault();

                    clientInfo.UpdateBy = User.Identity.Name;
                    clientInfo.FullName = client.FullName;
                    clientInfo.ShortName = client.ShortName;
                    clientInfo.ClientId = client.ClientId;
                    clientInfo.Code = client.Code;
                    clientInfo.LedgerId = client.LedgerId;
                    clientInfo.Address = client.Address;
                    clientInfo.BaseUrl = client.BaseUrl;
                    clientInfo.Apps = client.Apps;
                    clientInfo.WebPortal = client.WebPortal;
                    clientInfo.SMS = client.SMS;
                    clientInfo.Subscription = client.Subscription;
                    clientInfo.ActivityStatus = client.ActivityStatus;

                    clientInfo.SetDate();

                    var res = DataAccess.Instance.ClientService.Update(clientInfo);
                    cmr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cmr.message = res ? Constant.UPDATED : Constant.UPDATED_ERROR;
                }

                else
                {
                    throw new Exception(message);
                }

            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

            return Json(cmr);
        }

        [Route("Client/DeleteClient/{id}")]
        [HttpDelete]
        public IHttpActionResult DeleteClient(int id)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                Client client = new Client();
                client = DataAccess.Instance.ClientService.Get(id);
                client.UpdateBy = User.Identity.Name;
                client.IsDeleted = true;
                client.SetDate();
                //int delte = DataAccess.Instance.CommonServices.ExecuteSQL($"UPDATE dbo.CRM_Clients_db SET IsDeleted = 1 WHERE ClientId = {client.Id}");
                if (client != null)
                {
                    List<Clients_db> clientDbList = DataAccess.Instance.ClientsdbService.Filter(e=>e.ClientId== id).ToList();
                    foreach (Clients_db aClientdb in clientDbList)
                    {
                        //aClientdb.ClientsDbId != clientDb.ClientsDbId ? aClientdb.IsDefault = false : aClientdb.IsDefault = true;
                        if (aClientdb.ClientId == id)
                        {
                            aClientdb.IsDeleted = true;
                            aClientdb.UpdateBy = User.Identity.Name;
                            aClientdb.SetDate();
                        }
                       
                        var resul = DataAccess.Instance.ClientsdbService.Update(aClientdb);
                    }
                    
                }
                var resp = DataAccess.Instance.ClientService.Update(client);
                cmr.httpStatusCode = resp ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cmr.message = resp ? Constant.DELETED : Constant.FAILED;
                return Json(cmr);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [Route("Client/ChangeActivityStatus/")]
        [HttpPut]
        public IHttpActionResult ChangeActivityStatus(Client client)
        {
            CommonResponse cmr = new CommonResponse();

            try
            {
                var clientInfo = DataAccess.Instance.ClientService.Filter(e => e.IsDeleted == false && e.Id == client.Id).FirstOrDefault();

                if (client.ActivityStatus == "A")
                {
                    clientInfo.ActivityStatus = "I";
                }
                if (client.ActivityStatus == "I")
                {
                    clientInfo.ActivityStatus = "A";
                }

                clientInfo.UpdateBy = User.Identity.Name;
                clientInfo.SetDate();

                var res = DataAccess.Instance.ClientService.Update(clientInfo);
                cmr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cmr.message = res ? "Status changed successfully" : Constant.UPDATED_ERROR;
                //cmr.message = "Status changed successfully";

            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

            return Json(cmr);
        }

        #region Clients_db
        [HttpPost]
        [Route("Client/AddDatabase")]
        public IHttpActionResult AddDatabase(Clients_db clients_db)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (DataAccess.Instance.CommonServices.IsExist("CRM_Clients_db", "DbName = '" + clients_db.DbName.Replace(";", string.Empty).Replace("--", string.Empty) + "'"))
                    return BadRequest(Constant.DUPLICATE);

                clients_db.SetDate();
                clients_db.Status = "A";
                var result = DataAccess.Instance.ClientsdbService.Add(clients_db);
                cr.results = result;
                if (result)
                {
                    cr.httpStatusCode = result ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cr.message = result ? Constant.SAVED : Constant.FAILED;
                }
            }

            catch (Exception ex)
            {
                cr.message = ex.Message.ToString();
                cr.httpStatusCode = HttpStatusCode.BadRequest;
            }
            return Json(cr);

        }
        [HttpPut]
        [Route("Client/UpdateDatabase")]
        public IHttpActionResult UpdateDatabase(Clients_db clients_db)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                Clients_db ClientsDb = DataAccess.Instance.ClientsdbService.SingleOrDefault(e => e.ClientsDbId == clients_db.ClientsDbId);
                if (ClientsDb != null)
                {
                    var result = DataAccess.Instance.ClientsdbService.Update(clients_db);
                    cr.results = result;
                    if (result)
                    {
                        cr.httpStatusCode = result ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                        cr.message = result ? Constant.UPDATED : Constant.FAILED;
                    }
                }

            }
            catch (Exception ex)
            {
                cr.message = ex.Message.ToString();
                cr.httpStatusCode = HttpStatusCode.BadRequest;
            }
            return Json(cr);

        }
        [HttpGet]
        [Route("Client/GetDBByClientId/{ClientId}")]
        public IHttpActionResult GetDBByClientId(int ClientId)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var clients = DataAccess.Instance.ClientsdbService.Filter(e => e.ClientId == ClientId && e.IsDeleted == false).ToList();
                cr.results = clients;
                cr.message = Constant.SUCCESS;
            }

            catch (Exception ex)
            {
                cr.message = ex.Message.ToString();
                cr.httpStatusCode = HttpStatusCode.BadRequest;
            }
            return Json(cr);

        }

        [HttpDelete]
        [Route("Client/DeleteDatabase/{ClientsDbId}")]
        public IHttpActionResult DeleteDatabase(int ClientsDbId)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                Clients_db clientDb = DataAccess.Instance.ClientsdbService.SingleOrDefault(e => e.ClientsDbId == ClientsDbId);
                if (clientDb != null)
                {
                    clientDb.IsDeleted = true;
                    clientDb.Status = "D";
                    var result = DataAccess.Instance.ClientsdbService.Remove(ClientsDbId);
                    cr.results = result;
                    if (result)
                    {
                        cr.httpStatusCode = result ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                        cr.message = result ? Constant.DELETED : Constant.FAILED;
                    }
                }

            }
            catch (Exception ex)
            {
                cr.message = ex.Message.ToString();
                cr.httpStatusCode = HttpStatusCode.BadRequest;
            }
            return Json(cr);

        }
        [HttpPost]
        [Route("Client/SatAsDefault")]
        public IHttpActionResult SatAsDefault(Clients_db clientDb)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                //Clients client = DataAccess.Instance.ClientService.SingleOrDefault(e => e.ClientId == clientDb.ClientId); 
                Client client = DataAccess.Instance.ClientService.SingleOrDefault(e => e.Id == clientDb.ClientId);
                //var client = DataAccess.Instance.ClientService.Filter(e => e.ClientId == clientDb.ClientId, null, new string[] { "Clients_db" }).ToList();
                if (clientDb != null)
                {
                    //List<Clients_db> clientDbList = DataAccess.Instance.ClientsdbService.Filter(e=>e.ClientId==clientDb.ClientId).ToList();
                    foreach (Clients_db aClientdb in client.Clients_db)
                    {
                        //aClientdb.ClientsDbId != clientDb.ClientsDbId ? aClientdb.IsDefault = false : aClientdb.IsDefault = true;
                        if (aClientdb.ClientsDbId != clientDb.ClientsDbId)
                        {
                            aClientdb.IsDefault = false;
                        }
                        else
                        {
                            aClientdb.IsDefault = true;
                        }
                        var resul = DataAccess.Instance.ClientsdbService.Update(aClientdb);
                    }
                    client.DefaultDbId = clientDb.ClientsDbId;
                    var result = DataAccess.Instance.ClientService.Update(client);
                    cr.results = result;
                    if (result)
                    {
                        cr.httpStatusCode = result ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                        cr.message = result ? Constant.UPDATED : Constant.FAILED;
                    }
                }

            }
            catch (Exception ex)
            {
                cr.message = ex.Message.ToString();
                cr.httpStatusCode = HttpStatusCode.BadRequest;
            }
            return Json(cr);

        }
        #endregion
    }
}