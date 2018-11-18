﻿//------------------------------------------------------------------------------
// <auto-generated>
//     此代码已从模板生成。
//
//     手动更改此文件可能导致应用程序出现意外的行为。
//     如果重新生成代码，将覆盖对此文件的手动更改。
// </auto-generated>
//------------------------------------------------------------------------------

namespace Apps.Models
{
    using System;
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    using System.Data.Entity.Core.Objects;
    using System.Linq;
    using Apps.Common;
    
    public partial class DBContainer : DbContext
    {
        public DBContainer()
            : base(ConfigPara.EFDBConnection)
            //: base("name=DBContainer")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<SysAreas> SysAreas { get; set; }
        public virtual DbSet<SysException> SysException { get; set; }
        public virtual DbSet<SysLog> SysLog { get; set; }
        public virtual DbSet<SysModule> SysModule { get; set; }
        public virtual DbSet<SysModuleOperate> SysModuleOperate { get; set; }
        public virtual DbSet<SysPosition> SysPosition { get; set; }
        public virtual DbSet<SysRight> SysRight { get; set; }
        public virtual DbSet<SysRightOperate> SysRightOperate { get; set; }
        public virtual DbSet<SysRole> SysRole { get; set; }
        public virtual DbSet<SysSample> SysSample { get; set; }
        public virtual DbSet<SysSettings> SysSettings { get; set; }
        public virtual DbSet<SysStruct> SysStruct { get; set; }
        public virtual DbSet<SysUserConfig> SysUserConfig { get; set; }
        public virtual DbSet<SysUser> SysUser { get; set; }
        public virtual DbSet<MIS_Article> MIS_Article { get; set; }
        public virtual DbSet<MIS_Article_Albums> MIS_Article_Albums { get; set; }
        public virtual DbSet<MIS_Article_Category> MIS_Article_Category { get; set; }
        public virtual DbSet<MIS_Article_Comment> MIS_Article_Comment { get; set; }
        public virtual DbSet<MIS_WebIM_CommonTalk> MIS_WebIM_CommonTalk { get; set; }
        public virtual DbSet<MIS_WebIM_Message> MIS_WebIM_Message { get; set; }
        public virtual DbSet<MIS_WebIM_Message_Rec> MIS_WebIM_Message_Rec { get; set; }
        public virtual DbSet<MIS_WebIM_RecentContact> MIS_WebIM_RecentContact { get; set; }
        public virtual DbSet<JOB_TASKJOBS> JOB_TASKJOBS { get; set; }
        public virtual DbSet<JOB_TASKJOBS_LOG> JOB_TASKJOBS_LOG { get; set; }
        public virtual DbSet<WC_MessageResponse> WC_MessageResponse { get; set; }
        public virtual DbSet<WC_OfficalAccounts> WC_OfficalAccounts { get; set; }
        public virtual DbSet<WC_ResponseLog> WC_ResponseLog { get; set; }
        public virtual DbSet<WC_Group> WC_Group { get; set; }
        public virtual DbSet<WC_User> WC_User { get; set; }
        public virtual DbSet<SysModuleDataFilter> SysModuleDataFilter { get; set; }
        public virtual DbSet<SysRightDataFilter> SysRightDataFilter { get; set; }
        public virtual DbSet<SysCalendarPlan> SysCalendarPlan { get; set; }
        public virtual DbSet<Flow_External> Flow_External { get; set; }
        public virtual DbSet<Flow_Form> Flow_Form { get; set; }
        public virtual DbSet<Flow_FormAttr> Flow_FormAttr { get; set; }
        public virtual DbSet<Flow_FormContent> Flow_FormContent { get; set; }
        public virtual DbSet<Flow_FormContentStepCheck> Flow_FormContentStepCheck { get; set; }
        public virtual DbSet<Flow_FormContentStepCheckState> Flow_FormContentStepCheckState { get; set; }
        public virtual DbSet<Flow_Seal> Flow_Seal { get; set; }
        public virtual DbSet<Flow_Step> Flow_Step { get; set; }
        public virtual DbSet<Flow_StepRule> Flow_StepRule { get; set; }
        public virtual DbSet<Flow_Type> Flow_Type { get; set; }
        public virtual DbSet<Spl_ContactCompany> Spl_ContactCompany { get; set; }
        public virtual DbSet<Spl_ContactCompanyCategory> Spl_ContactCompanyCategory { get; set; }
        public virtual DbSet<Spl_EarlyWareingGood> Spl_EarlyWareingGood { get; set; }
        public virtual DbSet<Spl_InOutCategory> Spl_InOutCategory { get; set; }
        public virtual DbSet<Spl_Person> Spl_Person { get; set; }
        public virtual DbSet<Spl_Product> Spl_Product { get; set; }
        public virtual DbSet<Spl_ProductCategory> Spl_ProductCategory { get; set; }
        public virtual DbSet<Spl_TestClass> Spl_TestClass { get; set; }
        public virtual DbSet<Spl_TestStudents> Spl_TestStudents { get; set; }
        public virtual DbSet<Spl_WareCategory> Spl_WareCategory { get; set; }
        public virtual DbSet<Spl_WareCheckTotal> Spl_WareCheckTotal { get; set; }
        public virtual DbSet<Spl_WareDetails> Spl_WareDetails { get; set; }
        public virtual DbSet<Spl_Warehouse> Spl_Warehouse { get; set; }
        public virtual DbSet<Spl_WarehouseAllocation> Spl_WarehouseAllocation { get; set; }
        public virtual DbSet<Spl_WarehouseAllocationDetails> Spl_WarehouseAllocationDetails { get; set; }
        public virtual DbSet<Spl_WarehouseCategory> Spl_WarehouseCategory { get; set; }
        public virtual DbSet<Spl_WarehouseWarrant> Spl_WarehouseWarrant { get; set; }
        public virtual DbSet<Spl_WarehouseWarrantDetails> Spl_WarehouseWarrantDetails { get; set; }
        public virtual DbSet<Spl_WarehouseWarrantDetailsOUT> Spl_WarehouseWarrantDetailsOUT { get; set; }
        public virtual DbSet<Spl_WarehouseWarrantOUT> Spl_WarehouseWarrantOUT { get; set; }
        public virtual DbSet<Spl_WareStockPile> Spl_WareStockPile { get; set; }
        public virtual DbSet<Spl_WareUnitConvert> Spl_WareUnitConvert { get; set; }
        public virtual DbSet<SysSequence> SysSequence { get; set; }
        public virtual DbSet<SysTNum> SysTNum { get; set; }
        public virtual DbSet<WMS_Part> WMS_Part { get; set; }
    
        public virtual int P_JOB_DeleteTaskJobs(string sno)
        {
            var snoParameter = sno != null ?
                new ObjectParameter("sno", sno) :
                new ObjectParameter("sno", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("P_JOB_DeleteTaskJobs", snoParameter);
        }
    
        public virtual int P_JOB_ENTERY(string sno)
        {
            var snoParameter = sno != null ?
                new ObjectParameter("sno", sno) :
                new ObjectParameter("sno", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("P_JOB_ENTERY", snoParameter);
        }
    
        public virtual ObjectResult<P_JOB_GetUnTrackTask_Result> P_JOB_GetUnTrackTask()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<P_JOB_GetUnTrackTask_Result>("P_JOB_GetUnTrackTask");
        }
    
        public virtual int P_JOB_U1(string cUSTOMERID)
        {
            var cUSTOMERIDParameter = cUSTOMERID != null ?
                new ObjectParameter("CUSTOMERID", cUSTOMERID) :
                new ObjectParameter("CUSTOMERID", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("P_JOB_U1", cUSTOMERIDParameter);
        }
    
        public virtual int P_JOB_UpdateState(string sno, Nullable<int> state, string result)
        {
            var snoParameter = sno != null ?
                new ObjectParameter("sno", sno) :
                new ObjectParameter("sno", typeof(string));
    
            var stateParameter = state.HasValue ?
                new ObjectParameter("state", state) :
                new ObjectParameter("state", typeof(int));
    
            var resultParameter = result != null ?
                new ObjectParameter("result", result) :
                new ObjectParameter("result", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("P_JOB_UpdateState", snoParameter, stateParameter, resultParameter);
        }
    
        public virtual ObjectResult<P_QRTZ_GetJobExecuteTime_Result> P_QRTZ_GetJobExecuteTime(string id)
        {
            var idParameter = id != null ?
                new ObjectParameter("id", id) :
                new ObjectParameter("id", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<P_QRTZ_GetJobExecuteTime_Result>("P_QRTZ_GetJobExecuteTime", idParameter);
        }
    
        public virtual int P_Sys_ClearUnusedRightOperate()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("P_Sys_ClearUnusedRightOperate");
        }
    
        public virtual int P_Sys_DeleteSysRoleSysUserByRoleId(string roleId)
        {
            var roleIdParameter = roleId != null ?
                new ObjectParameter("roleId", roleId) :
                new ObjectParameter("roleId", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("P_Sys_DeleteSysRoleSysUserByRoleId", roleIdParameter);
        }
    
        public virtual int P_Sys_DeleteSysRoleSysUserByUserId(string userId)
        {
            var userIdParameter = userId != null ?
                new ObjectParameter("userId", userId) :
                new ObjectParameter("userId", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("P_Sys_DeleteSysRoleSysUserByUserId", userIdParameter);
        }
    
        public virtual ObjectResult<P_Sys_GetModule_RoleRight_Result> P_Sys_GetModule_RoleRight(string moduleId)
        {
            var moduleIdParameter = moduleId != null ?
                new ObjectParameter("moduleId", moduleId) :
                new ObjectParameter("moduleId", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<P_Sys_GetModule_RoleRight_Result>("P_Sys_GetModule_RoleRight", moduleIdParameter);
        }
    
        public virtual ObjectResult<P_Sys_GetModule_UserRight_Result> P_Sys_GetModule_UserRight(string moduleId)
        {
            var moduleIdParameter = moduleId != null ?
                new ObjectParameter("moduleId", moduleId) :
                new ObjectParameter("moduleId", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<P_Sys_GetModule_UserRight_Result>("P_Sys_GetModule_UserRight", moduleIdParameter);
        }
    
        public virtual ObjectResult<P_Sys_GetRightByRole_Result> P_Sys_GetRightByRole(string roleId)
        {
            var roleIdParameter = roleId != null ?
                new ObjectParameter("roleId", roleId) :
                new ObjectParameter("roleId", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<P_Sys_GetRightByRole_Result>("P_Sys_GetRightByRole", roleIdParameter);
        }
    
        public virtual ObjectResult<P_Sys_GetRightByRoleAndModule_Result> P_Sys_GetRightByRoleAndModule(string roleId, string moduleId)
        {
            var roleIdParameter = roleId != null ?
                new ObjectParameter("roleId", roleId) :
                new ObjectParameter("roleId", typeof(string));
    
            var moduleIdParameter = moduleId != null ?
                new ObjectParameter("moduleId", moduleId) :
                new ObjectParameter("moduleId", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<P_Sys_GetRightByRoleAndModule_Result>("P_Sys_GetRightByRoleAndModule", roleIdParameter, moduleIdParameter);
        }
    
        public virtual ObjectResult<P_Sys_GetRightByUser_Result> P_Sys_GetRightByUser(string userId)
        {
            var userIdParameter = userId != null ?
                new ObjectParameter("userId", userId) :
                new ObjectParameter("userId", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<P_Sys_GetRightByUser_Result>("P_Sys_GetRightByUser", userIdParameter);
        }
    
        public virtual ObjectResult<P_Sys_GetRightOperate_Result> P_Sys_GetRightOperate(string userId, string url)
        {
            var userIdParameter = userId != null ?
                new ObjectParameter("userId", userId) :
                new ObjectParameter("userId", typeof(string));
    
            var urlParameter = url != null ?
                new ObjectParameter("url", url) :
                new ObjectParameter("url", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<P_Sys_GetRightOperate_Result>("P_Sys_GetRightOperate", userIdParameter, urlParameter);
        }
    
        public virtual ObjectResult<P_Sys_GetRoleByUserId_Result> P_Sys_GetRoleByUserId(string userId)
        {
            var userIdParameter = userId != null ?
                new ObjectParameter("UserId", userId) :
                new ObjectParameter("UserId", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<P_Sys_GetRoleByUserId_Result>("P_Sys_GetRoleByUserId", userIdParameter);
        }
    
        public virtual ObjectResult<P_Sys_GetUserByDepId_Result> P_Sys_GetUserByDepId(string depId)
        {
            var depIdParameter = depId != null ?
                new ObjectParameter("DepId", depId) :
                new ObjectParameter("DepId", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<P_Sys_GetUserByDepId_Result>("P_Sys_GetUserByDepId", depIdParameter);
        }
    
        public virtual ObjectResult<P_Sys_GetUserByRoleId_Result> P_Sys_GetUserByRoleId(string roleId, string depId)
        {
            var roleIdParameter = roleId != null ?
                new ObjectParameter("RoleId", roleId) :
                new ObjectParameter("RoleId", typeof(string));
    
            var depIdParameter = depId != null ?
                new ObjectParameter("DepId", depId) :
                new ObjectParameter("DepId", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<P_Sys_GetUserByRoleId_Result>("P_Sys_GetUserByRoleId", roleIdParameter, depIdParameter);
        }
    
        public virtual ObjectResult<Nullable<int>> P_Sys_GetUserCountByDepId(string depId)
        {
            var depIdParameter = depId != null ?
                new ObjectParameter("DepId", depId) :
                new ObjectParameter("DepId", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<Nullable<int>>("P_Sys_GetUserCountByDepId", depIdParameter);
        }
    
        public virtual int P_Sys_InsertSysRight()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("P_Sys_InsertSysRight");
        }
    
        public virtual int P_Sys_UpdateSysRightRightFlag(string moduleId, string roleId)
        {
            var moduleIdParameter = moduleId != null ?
                new ObjectParameter("moduleId", moduleId) :
                new ObjectParameter("moduleId", typeof(string));
    
            var roleIdParameter = roleId != null ?
                new ObjectParameter("roleId", roleId) :
                new ObjectParameter("roleId", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("P_Sys_UpdateSysRightRightFlag", moduleIdParameter, roleIdParameter);
        }
    
        public virtual int P_Sys_UpdateSysRoleSysUser(string roleId, string userId)
        {
            var roleIdParameter = roleId != null ?
                new ObjectParameter("roleId", roleId) :
                new ObjectParameter("roleId", typeof(string));
    
            var userIdParameter = userId != null ?
                new ObjectParameter("userId", userId) :
                new ObjectParameter("userId", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("P_Sys_UpdateSysRoleSysUser", roleIdParameter, userIdParameter);
        }
    
        public virtual ObjectResult<P_Sys_WebPart_Result> P_WebPart_GetInfo(Nullable<int> rows, string userId)
        {
            var rowsParameter = rows.HasValue ?
                new ObjectParameter("Rows", rows) :
                new ObjectParameter("Rows", typeof(int));
    
            var userIdParameter = userId != null ?
                new ObjectParameter("UserId", userId) :
                new ObjectParameter("UserId", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<P_Sys_WebPart_Result>("P_WebPart_GetInfo", rowsParameter, userIdParameter);
        }
    
        public virtual int P_MIS_CreateMessage(string id, string message, string sender, string receiver, string receiverTitle)
        {
            var idParameter = id != null ?
                new ObjectParameter("id", id) :
                new ObjectParameter("id", typeof(string));
    
            var messageParameter = message != null ?
                new ObjectParameter("message", message) :
                new ObjectParameter("message", typeof(string));
    
            var senderParameter = sender != null ?
                new ObjectParameter("sender", sender) :
                new ObjectParameter("sender", typeof(string));
    
            var receiverParameter = receiver != null ?
                new ObjectParameter("receiver", receiver) :
                new ObjectParameter("receiver", typeof(string));
    
            var receiverTitleParameter = receiverTitle != null ?
                new ObjectParameter("receiverTitle", receiverTitle) :
                new ObjectParameter("receiverTitle", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("P_MIS_CreateMessage", idParameter, messageParameter, senderParameter, receiverParameter, receiverTitleParameter);
        }
    
        public virtual int P_MIS_DeleteMessageAllByReceiver(string receiver)
        {
            var receiverParameter = receiver != null ?
                new ObjectParameter("receiver", receiver) :
                new ObjectParameter("receiver", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("P_MIS_DeleteMessageAllByReceiver", receiverParameter);
        }
    
        public virtual int P_MIS_DeleteMessageAllBySender(string sender)
        {
            var senderParameter = sender != null ?
                new ObjectParameter("sender", sender) :
                new ObjectParameter("sender", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("P_MIS_DeleteMessageAllBySender", senderParameter);
        }
    
        public virtual int P_MIS_DeleteMessageByReceiver(string id, string receiver)
        {
            var idParameter = id != null ?
                new ObjectParameter("id", id) :
                new ObjectParameter("id", typeof(string));
    
            var receiverParameter = receiver != null ?
                new ObjectParameter("receiver", receiver) :
                new ObjectParameter("receiver", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("P_MIS_DeleteMessageByReceiver", idParameter, receiverParameter);
        }
    
        public virtual int P_MIS_DeleteMessageBySender(string id)
        {
            var idParameter = id != null ?
                new ObjectParameter("id", id) :
                new ObjectParameter("id", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("P_MIS_DeleteMessageBySender", idParameter);
        }
    
        public virtual ObjectResult<MIS_WebIM_Message> P_MIS_GetMessage(string user, Nullable<int> pageno, Nullable<int> rows, ObjectParameter rowscount)
        {
            var userParameter = user != null ?
                new ObjectParameter("user", user) :
                new ObjectParameter("user", typeof(string));
    
            var pagenoParameter = pageno.HasValue ?
                new ObjectParameter("pageno", pageno) :
                new ObjectParameter("pageno", typeof(int));
    
            var rowsParameter = rows.HasValue ?
                new ObjectParameter("rows", rows) :
                new ObjectParameter("rows", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<MIS_WebIM_Message>("P_MIS_GetMessage", userParameter, pagenoParameter, rowsParameter, rowscount);
        }
    
        public virtual ObjectResult<MIS_WebIM_Message> P_MIS_GetMessage(string user, Nullable<int> pageno, Nullable<int> rows, ObjectParameter rowscount, MergeOption mergeOption)
        {
            var userParameter = user != null ?
                new ObjectParameter("user", user) :
                new ObjectParameter("user", typeof(string));
    
            var pagenoParameter = pageno.HasValue ?
                new ObjectParameter("pageno", pageno) :
                new ObjectParameter("pageno", typeof(int));
    
            var rowsParameter = rows.HasValue ?
                new ObjectParameter("rows", rows) :
                new ObjectParameter("rows", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<MIS_WebIM_Message>("P_MIS_GetMessage", mergeOption, userParameter, pagenoParameter, rowsParameter, rowscount);
        }
    
        public virtual ObjectResult<P_MIS_GetSenderByReceiver_Result> P_MIS_GetSenderByReceiver(string receiver)
        {
            var receiverParameter = receiver != null ?
                new ObjectParameter("receiver", receiver) :
                new ObjectParameter("receiver", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<P_MIS_GetSenderByReceiver_Result>("P_MIS_GetSenderByReceiver", receiverParameter);
        }
    
        public virtual int P_MIS_Info_EduMessage(Nullable<int> id, string infoId, string body, string userId)
        {
            var idParameter = id.HasValue ?
                new ObjectParameter("Id", id) :
                new ObjectParameter("Id", typeof(int));
    
            var infoIdParameter = infoId != null ?
                new ObjectParameter("InfoId", infoId) :
                new ObjectParameter("InfoId", typeof(string));
    
            var bodyParameter = body != null ?
                new ObjectParameter("Body", body) :
                new ObjectParameter("Body", typeof(string));
    
            var userIdParameter = userId != null ?
                new ObjectParameter("UserId", userId) :
                new ObjectParameter("UserId", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("P_MIS_Info_EduMessage", idParameter, infoIdParameter, bodyParameter, userIdParameter);
        }
    
        public virtual int P_MIS_Info_GetFavoriteByUserId(string userId, string whereSQL)
        {
            var userIdParameter = userId != null ?
                new ObjectParameter("UserId", userId) :
                new ObjectParameter("UserId", typeof(string));
    
            var whereSQLParameter = whereSQL != null ?
                new ObjectParameter("WhereSQL", whereSQL) :
                new ObjectParameter("WhereSQL", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("P_MIS_Info_GetFavoriteByUserId", userIdParameter, whereSQLParameter);
        }
    
        public virtual int P_MIS_Info_GetICanManage(string whereSQL, Nullable<int> rows, Nullable<int> pageNo, ObjectParameter rowsCount)
        {
            var whereSQLParameter = whereSQL != null ?
                new ObjectParameter("WhereSQL", whereSQL) :
                new ObjectParameter("WhereSQL", typeof(string));
    
            var rowsParameter = rows.HasValue ?
                new ObjectParameter("Rows", rows) :
                new ObjectParameter("Rows", typeof(int));
    
            var pageNoParameter = pageNo.HasValue ?
                new ObjectParameter("PageNo", pageNo) :
                new ObjectParameter("PageNo", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("P_MIS_Info_GetICanManage", whereSQLParameter, rowsParameter, pageNoParameter, rowsCount);
        }
    
        public virtual int P_MIS_Info_GetICanRead(string userId, string whereSQL, Nullable<int> rows, Nullable<int> pageNo, ObjectParameter rowsCount)
        {
            var userIdParameter = userId != null ?
                new ObjectParameter("UserId", userId) :
                new ObjectParameter("UserId", typeof(string));
    
            var whereSQLParameter = whereSQL != null ?
                new ObjectParameter("WhereSQL", whereSQL) :
                new ObjectParameter("WhereSQL", typeof(string));
    
            var rowsParameter = rows.HasValue ?
                new ObjectParameter("Rows", rows) :
                new ObjectParameter("Rows", typeof(int));
    
            var pageNoParameter = pageNo.HasValue ?
                new ObjectParameter("PageNo", pageNo) :
                new ObjectParameter("PageNo", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("P_MIS_Info_GetICanRead", userIdParameter, whereSQLParameter, rowsParameter, pageNoParameter, rowsCount);
        }
    
        public virtual int P_MIS_Info_GetPostInfoByUserId(string userId, string whereSQL)
        {
            var userIdParameter = userId != null ?
                new ObjectParameter("UserId", userId) :
                new ObjectParameter("UserId", typeof(string));
    
            var whereSQLParameter = whereSQL != null ?
                new ObjectParameter("WhereSQL", whereSQL) :
                new ObjectParameter("WhereSQL", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("P_MIS_Info_GetPostInfoByUserId", userIdParameter, whereSQLParameter);
        }
    
        public virtual int P_MIS_SetMessageHasReadById(string receiver, string id)
        {
            var receiverParameter = receiver != null ?
                new ObjectParameter("receiver", receiver) :
                new ObjectParameter("receiver", typeof(string));
    
            var idParameter = id != null ?
                new ObjectParameter("id", id) :
                new ObjectParameter("id", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("P_MIS_SetMessageHasReadById", receiverParameter, idParameter);
        }
    
        public virtual int P_MIS_SetMessageHasReadByReceiver(string receiver)
        {
            var receiverParameter = receiver != null ?
                new ObjectParameter("receiver", receiver) :
                new ObjectParameter("receiver", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("P_MIS_SetMessageHasReadByReceiver", receiverParameter);
        }
    
        public virtual int P_MIS_SetMessageHasReadFromSenderToReceiver(string sender, string receiver)
        {
            var senderParameter = sender != null ?
                new ObjectParameter("sender", sender) :
                new ObjectParameter("sender", typeof(string));
    
            var receiverParameter = receiver != null ?
                new ObjectParameter("receiver", receiver) :
                new ObjectParameter("receiver", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("P_MIS_SetMessageHasReadFromSenderToReceiver", senderParameter, receiverParameter);
        }
    
        public virtual int P_Flow_ResetCheckStepState(string stepCheckId, string contentId, Nullable<int> checkState, Nullable<int> checkFlag)
        {
            var stepCheckIdParameter = stepCheckId != null ?
                new ObjectParameter("stepCheckId", stepCheckId) :
                new ObjectParameter("stepCheckId", typeof(string));
    
            var contentIdParameter = contentId != null ?
                new ObjectParameter("ContentId", contentId) :
                new ObjectParameter("ContentId", typeof(string));
    
            var checkStateParameter = checkState.HasValue ?
                new ObjectParameter("CheckState", checkState) :
                new ObjectParameter("CheckState", typeof(int));
    
            var checkFlagParameter = checkFlag.HasValue ?
                new ObjectParameter("CheckFlag", checkFlag) :
                new ObjectParameter("CheckFlag", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("P_Flow_ResetCheckStepState", stepCheckIdParameter, contentIdParameter, checkStateParameter, checkFlagParameter);
        }
    
        public virtual ObjectResult<P_Sys_GetAllUsers_Result> P_Sys_GetAllUsers()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<P_Sys_GetAllUsers_Result>("P_Sys_GetAllUsers");
        }
    
        public virtual ObjectResult<P_WC_GetResponseContent_Result> P_WC_GetResponseContent(string officalAccountId, string matchKey)
        {
            var officalAccountIdParameter = officalAccountId != null ?
                new ObjectParameter("officalAccountId", officalAccountId) :
                new ObjectParameter("officalAccountId", typeof(string));
    
            var matchKeyParameter = matchKey != null ?
                new ObjectParameter("matchKey", matchKey) :
                new ObjectParameter("matchKey", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<P_WC_GetResponseContent_Result>("P_WC_GetResponseContent", officalAccountIdParameter, matchKeyParameter);
        }
    
        public virtual ObjectResult<Nullable<int>> P_Spl_GetWareCountByCategoryId(string categoryId)
        {
            var categoryIdParameter = categoryId != null ?
                new ObjectParameter("CategoryId", categoryId) :
                new ObjectParameter("CategoryId", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<Nullable<int>>("P_Spl_GetWareCountByCategoryId", categoryIdParameter);
        }
    
        public virtual ObjectResult<P_Sys_GetRightDataByRoleAndModule_Result> P_Sys_GetRightDataByRoleAndModule(string roleId, string moduleId)
        {
            var roleIdParameter = roleId != null ?
                new ObjectParameter("roleId", roleId) :
                new ObjectParameter("roleId", typeof(string));
    
            var moduleIdParameter = moduleId != null ?
                new ObjectParameter("moduleId", moduleId) :
                new ObjectParameter("moduleId", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<P_Sys_GetRightDataByRoleAndModule_Result>("P_Sys_GetRightDataByRoleAndModule", roleIdParameter, moduleIdParameter);
        }
    
        public virtual int P_Spl_UpdateWareStockPileAllocation(string warehouseAllocationId)
        {
            var warehouseAllocationIdParameter = warehouseAllocationId != null ?
                new ObjectParameter("WarehouseAllocationId", warehouseAllocationId) :
                new ObjectParameter("WarehouseAllocationId", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("P_Spl_UpdateWareStockPileAllocation", warehouseAllocationIdParameter);
        }
    
        public virtual int P_Spl_UpdateWareStockPileCheck(string id)
        {
            var idParameter = id != null ?
                new ObjectParameter("Id", id) :
                new ObjectParameter("Id", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("P_Spl_UpdateWareStockPileCheck", idParameter);
        }
    
        public virtual int P_Spl_UpdateWareStockPileIn(string warehouseWarrantId)
        {
            var warehouseWarrantIdParameter = warehouseWarrantId != null ?
                new ObjectParameter("WarehouseWarrantId", warehouseWarrantId) :
                new ObjectParameter("WarehouseWarrantId", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("P_Spl_UpdateWareStockPileIn", warehouseWarrantIdParameter);
        }
    
        public virtual int P_Spl_UpdateWareStockPileOut(string warehouseWarrantId)
        {
            var warehouseWarrantIdParameter = warehouseWarrantId != null ?
                new ObjectParameter("WarehouseWarrantId", warehouseWarrantId) :
                new ObjectParameter("WarehouseWarrantId", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("P_Spl_UpdateWareStockPileOut", warehouseWarrantIdParameter);
        }
    
        public virtual int P_Sys_SwiftNum(string day, string tabName, ObjectParameter num)
        {
            var dayParameter = day != null ?
                new ObjectParameter("Day", day) :
                new ObjectParameter("Day", typeof(string));
    
            var tabNameParameter = tabName != null ?
                new ObjectParameter("TabName", tabName) :
                new ObjectParameter("TabName", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("P_Sys_SwiftNum", dayParameter, tabNameParameter, num);
        }
    }
}
