//
//  SobotTMAddress.h
//  SobotTelemarketingSDK
//
//  Created by zhangxy on 2022/7/4.
//

#import <SobotCallLib/SobotCallCacheEntity.h>
#import <SobotCallLib/SobotCallCache.h>


#ifndef SobotCallAddress_h
#define SobotCallAddress_h

#define PageSize 20
#define API_BasicLogin @"basic-login"
#define API_MAIN_BASIC_CUSTOMER @"/crm-user-service/"
//#define API_MAIN_BASIC_CALL @"/call-data/"
#define API_MAIN_BASIC_SET @"/basic-set/"
#define API_MAIN_BASIC_PUBLIC @"/basic/"
#define API_MAIN_CALL_SERVICE @"/callservice/"
#define API_MAIN_TM @"tm"
#define API_MAIN_BASIC_CONFIG_SERVICE @"/basic-config-service/"

//电销由/telemarketing/v6/tm-xx   换成/callservice/tm/tm-xx/

//#define ZCNSUF [NSUserDefaults standardUserDefaults]
#define callCache [SobotCallCache shareSobotCallCache].sobotCallConfig
#define API_HOST !sobotIsNull(callCache.openApiHost)?callCache.openApiHost:@"https://api.sobot.com"


#define API_CallApiHost !sobotIsNull(callCache.callApiHost)?callCache.callApiHost:@"https://openapi.soboten.com"

// 根据登录token获取accessToken
#define API_GetAccessToken [NSString stringWithFormat:@"%@/tokens/getToken",API_CallApiHost]


// 获取呼叫wss域名地址
#define API_GetWebmsgUrls [NSString stringWithFormat:@"%@%@%@/tm-config/sip-webmsg-urls/",API_CallApiHost,API_MAIN_CALL_SERVICE,API_MAIN_TM]

// 登录
#define API_Login [NSString stringWithFormat:@"%@/%@/serviceAppLogin/4",API_HOST,API_BasicLogin]

// 退出登录
#define API_LogOut [NSString stringWithFormat:@"%@/%@/serviceLogOut/4",API_HOST,API_BasicLogin]

///
///获取登录用户信息
#define API_getLoginUserInfo  [NSString stringWithFormat:@"%@/%@/getAppServiceDataInfo/4",API_HOST,API_BasicLogin]


///  3.2.4app 对应的V6的新接口 :  v6/tm-config/exts/idle/search
///获取分机号
#define API_getAgentSipAccount  [NSString stringWithFormat:@"%@%@%@/tm-config/exts/idle/page/search",API_CallApiHost,API_MAIN_CALL_SERVICE,API_MAIN_TM]

//#define API_getAgentSipAccount  [NSString stringWithFormat:@"%@%@v6/tm-config/exts/idle/search",API_CallApiHost,API_MAIN_CALL_SERVICE]

// 查询座席可使用分机信息
#define API_getExt  [NSString stringWithFormat:@"%@%@%@/tm-config/api/agent/available-exts",API_CallApiHost,API_MAIN_CALL_SERVICE,API_MAIN_TM]
// 修改分级语言信息
#define API_updateExtLangCode  [NSString stringWithFormat:@"%@%@%@/tm-config/exts/langCode",API_CallApiHost,API_MAIN_CALL_SERVICE,API_MAIN_TM]

// 查询坐席可选技能组
#define API_getGroups  [NSString stringWithFormat:@"%@%@%@/tm-config/api/agent/available-login-queues",API_CallApiHost,API_MAIN_CALL_SERVICE,API_MAIN_TM]

///获取座席状态
#define API_getAgentStatus  [NSString stringWithFormat:@"%@%@%@/tm-config/work-benchs/login-status",API_CallApiHost,API_MAIN_CALL_SERVICE,API_MAIN_TM]

///查询座席接听方式
#define API_getAgentPhoneTypes  [NSString stringWithFormat:@"%@%@%@/tm-config/agents/phoneTypes",API_CallApiHost,API_MAIN_CALL_SERVICE,API_MAIN_TM]

///查询座席签入绑定信息
#define API_getLoginBindInfo  [NSString stringWithFormat:@"%@%@%@/tm-config/api/agent/login-binding-info",API_CallApiHost,API_MAIN_CALL_SERVICE,API_MAIN_TM]

//https://openapi.soboten.com/callservice/v6/tm-reports/maincdrs/_search
// 通话
#define API_postCallRecordV6 [NSString stringWithFormat:@"%@%@%@/tm-console/party/agents/list",API_CallApiHost,API_MAIN_CALL_SERVICE,API_MAIN_TM]

// 通话记录详情接口
//https://openapi.soboten.com/callservice/v6/tm-reports/maincdrs/{callID}/partycdrs
//#define API_getCallRecordDetailV6(callID) [NSString stringWithFormat:@"%@%@v6/tm-reports/maincdrs/%@/partycdrs",API_CallApiHost,API_MAIN_CALL_SERVICE,callID]
#define API_getCallRecordDetailV6(callID) [NSString stringWithFormat:@"%@%@%@/tm-reports/statistics/%@/details/_search",API_CallApiHost,API_MAIN_CALL_SERVICE,API_MAIN_TM,callID]

// V6登录前先调用这个接口 清理之前注册过的话机
//http://kong.call.sobot.local/v6/tm-config/opensips/clear-user
#define API_postClearUserV6 [NSString stringWithFormat:@"%@%@%@/tm-config/opensips/clear-user",API_CallApiHost,API_MAIN_CALL_SERVICE,API_MAIN_TM]

//呼叫任务
#define API_getMyAllTaskListV6  [NSString stringWithFormat:@"%@%@%@/tm-outbound/agents/campaigns",API_CallApiHost,API_MAIN_CALL_SERVICE,API_MAIN_TM]

/**
 呼叫任务详情
 
 @return
 */
#define API_getAppTaskDetailWithTaskIdV6(taskId) [NSString stringWithFormat:@"%@%@%@/tm-outbound/console/campaigns/%@/contacts",API_CallApiHost,API_MAIN_CALL_SERVICE,API_MAIN_TM,taskId]

/**
 呼叫任务外呼
 
 @return
 */
#define API_makeCallTaskV6 [NSString stringWithFormat:@"%@%@%@/tm-outbound/campaigns/_makecall",API_CallApiHost,API_MAIN_CALL_SERVICE,API_MAIN_TM]


/**
 呼叫技能组

 @return
 */
#define API_CallV1getAgentGroup  [NSString stringWithFormat:@"%@%@queryGroupListByServiceId/4",API_HOST,API_MAIN_BASIC_PUBLIC]


/**
 外呼用户信息查询

 @return
 */
#define API_CallV1getUserInfoByPhone(tel)  [NSString stringWithFormat:@"%@%@appUser/getAppUserInfoByPhoneNo/4?tel=%@",API_HOST,API_MAIN_BASIC_CUSTOMER,tel]


/**
 获取所有座席状态

 @return
 */
#define API_getCallV1ServiceStatus  [NSString stringWithFormat:@"%@%@getCallServiceStatus/4?dictCode=1028&modelFlag=2",API_HOST,API_MAIN_BASIC_SET]


#define API_postUpdateNewUserV6(customerId)  [NSString stringWithFormat:@"%@%@user/update/%@",API_HOST,API_MAIN_BASIC_CUSTOMER,customerId]

/**
 编辑客户信息

 @return
 */
#define API_postEditCustomerV1  [NSString stringWithFormat:@"%@%@appUser/updateAppUserInfo",API_HOST,API_MAIN_BASIC_CUSTOMER]

// 重连恢复座席状态
#define API_getRecoverAgentStatus(simpSessionId,currentInstanceId)    [NSString stringWithFormat:@"%@%@v6/webmsg/reconnect/recover-agent-status?simpSessionId=%@&currentInstanceId=%@",API_CallApiHost,API_MAIN_CALL_SERVICE,simpSessionId,currentInstanceId]

// 重连恢复话务状态
#define API_getRecoverCall(simpSessionId,currentInstanceId) [NSString stringWithFormat:@"%@%@v6/webmsg/reconnect/recover-agent-call-status?simpSessionId=%@&currentInstanceId=%@",API_CallApiHost,API_MAIN_CALL_SERVICE,simpSessionId,currentInstanceId]

// 查询座席的外呼路由规则
//#define API_getOutBoundRoutesV6 [NSString stringWithFormat:@"%@%@v6/tm-config/api/agents/outbound-routes/rules",API_CallApiHost,API_MAIN_CALL_SERVICE]

#define API_getOutBoundRoutesV6(agents) [NSString stringWithFormat:@"%@%@%@/tm-config/agents/%@/outbound-routes/rules?agentType=1",API_CallApiHost,API_MAIN_CALL_SERVICE,API_MAIN_TM,agents]

// 修改座席的外呼路由规则
#define API_updateModOutBoundRoutesV6 [NSString stringWithFormat:@"%@%@%@/tm-config/api/agents/outbound-routes/rules",API_CallApiHost,API_MAIN_CALL_SERVICE,API_MAIN_TM]

// 查询座席可用的置忙原因
#define API_postQueryAgentBusyStatusV6 [NSString stringWithFormat:@"%@%@%@/tm-config/api/agent/busy-statuses",API_CallApiHost,API_MAIN_CALL_SERVICE,API_MAIN_TM]


// 查询座席的接待技能组
#define API_postAgentReceptionQueuesV6 [NSString stringWithFormat:@"%@%@%@/tm-config/api/agent/reception-queues",API_CallApiHost,API_MAIN_CALL_SERVICE,API_MAIN_TM]

// 查询座席可签入的技能组
#define API_LoginQueuesV6 [NSString stringWithFormat:@"%@%@%@/tm-config/api/agent/available-login-queues",API_CallApiHost,API_MAIN_CALL_SERVICE,API_MAIN_TM]


// 查询电话区号   get    tm-config/regionalGroup/callingCode/_search
#define API_SearchCallingCodeV6 [NSString stringWithFormat:@"%@%@%@/tm-config/regionalGroup/callingCode/_search",API_CallApiHost,API_MAIN_CALL_SERVICE,API_MAIN_TM]

// 查询电话区号列表   https://hk.sobot.com/callservice/v6/tm-config/regionalGroup/area/search/list get
#define API_SearchAreaListV6 [NSString stringWithFormat:@"%@%@%@/tm-config/regionalGroup/area/search/list",API_CallApiHost,API_MAIN_CALL_SERVICE,API_MAIN_TM]

// 修改电话区号   XX/tm-config/callingCode/_update  put请求
#define API_UpdateAreaV6 [NSString stringWithFormat:@"%@%@%@/tm-config/regionalGroup/callingCode/_update",API_CallApiHost,API_MAIN_CALL_SERVICE,API_MAIN_TM]

// 关联客户
//https://openapi.soboten.com/callservice/v6/tm-console/workbench-screen/cdrinfo?callID=094b1bc003a5dN46c17997fKae5c9300fd4e&customerID=f5744bbb1e2d46e0bb81b882b8b65e3d
#define API_RecordLinkSysUser(callID,customerID) [NSString stringWithFormat:@"%@%@%@/tm-console/workbench-screen/cdrinfo?callID=%@&customerID=%@",API_CallApiHost,API_MAIN_CALL_SERVICE,API_MAIN_TM,callID,customerID]

// 查询用户信息
#define API_SearchAppUser(customerId) [NSString stringWithFormat:@"%@%@user/detail/%@",API_HOST,API_MAIN_BASIC_CUSTOMER,customerId]
#define API_AddAppUser [NSString stringWithFormat:@"%@%@user/save",API_HOST,API_MAIN_BASIC_CUSTOMER]
//https://www.soboten.com/crm-user-service/user/listByPage?pageNo=1&pageSize=50&isblack=0&searchType=1&searchValue=王&searchFlag=0
#define API_SearchAppUserList(pageNo,pageSize,value,searchType)  [NSString stringWithFormat:@"%@%@user/listByPage?pageNo=%d&pageSize=%@&isblack=0&searchType=%d&searchValue=%@&searchFlag=0",API_HOST,API_MAIN_BASIC_CUSTOMER,pageNo,pageSize,searchType,value]

// 获取v6服务总结配置callservice/v6/tm-config/summary/config
#define API_CommitConfigV6   [NSString stringWithFormat:@"%@%@%@/tm-config/summary/config",API_CallApiHost,API_MAIN_CALL_SERVICE,API_MAIN_TM]

// 查询服务总结分类
#define API_SearchSummaryTypes(planType) [NSString stringWithFormat:@"%@%@%@/tm-config/summary-classifies?planType=%d",API_CallApiHost,API_MAIN_CALL_SERVICE,API_MAIN_TM,planType]


// 查询服务总结自定义字段
// businessType = 1用户，=3会话总结
#define API_SearchBasicFields(businessType) [NSString stringWithFormat:@"%@%@customField/queryFieldInfoList?openFlag=1&businessType=%d",API_HOST,API_MAIN_BASIC_CONFIG_SERVICE,businessType]

// 查询会话总结模板
#define API_SearchSummaryTemplete [NSString stringWithFormat:@"%@%@%@/tm-config/templates",API_CallApiHost,API_MAIN_CALL_SERVICE,API_MAIN_TM]

// 查询会话总结模板
#define API_SaveSummaryInfo [NSString stringWithFormat:@"%@%@%@/tm-console/workbench-screen/cdr/service-summary",API_CallApiHost,API_MAIN_CALL_SERVICE,API_MAIN_TM]

// 查询服务总结信息
#define API_SearchSummaryInfo(callId) [NSString stringWithFormat:@"%@%@%@/tm-console/workbench-screen/cdr/%@/service-summary",API_CallApiHost,API_MAIN_CALL_SERVICE,API_MAIN_TM,callId]



// 查询服务总结信息
#define API_SearchSummaryInfo(callId) [NSString stringWithFormat:@"%@%@%@/tm-console/workbench-screen/cdr/%@/service-summary",API_CallApiHost,API_MAIN_CALL_SERVICE,API_MAIN_TM,callId]

/**
 查询企业列表

 @param page
 @return
 */
#define API_GetEnterpriseList(page,enterpriseName) [NSString stringWithFormat:@"%@%@appEnterprise/getAppEnterpriseList?searchType=3&pageNo=%d&pageSize=50&searchValue=%@",API_HOST,API_MAIN_BASIC_CUSTOMER,page,enterpriseName]

/**
 获取VIP等级

 @return
 */
#define API_GetVIPLevelList  [NSString stringWithFormat:@"%@%@getAppUserLevelDataInfo/4",API_HOST,API_MAIN_BASIC_CONFIG_SERVICE]


/**
 获取录音文件路径

 @return
 */
#define API_GetRecordURL(recordID)  [NSString stringWithFormat:@"%@%@%@/tm-audios/recordings/%@",API_CallApiHost,API_MAIN_CALL_SERVICE,API_MAIN_TM,recordID]



#pragma mark - 获取国家信息
#define API_GetCallCountryList  [NSString stringWithFormat:@"%@%@/customField/getCountryList",API_HOST,API_MAIN_BASIC_CONFIG_SERVICE]
#pragma mark - 通过国家id查询州信息
#define API_GetCallProvinceList(countryId) [NSString stringWithFormat:@"%@%@/customField/getProvinceListByCountryId?countryId=%@",API_HOST,API_MAIN_BASIC_CONFIG_SERVICE,countryId]
#pragma mark - 通过省id查询城市
#define API_GetCallCityList(provinceId) [NSString stringWithFormat:@"%@%@/customField/getCityList?provinceId=%@",API_HOST,API_MAIN_BASIC_CONFIG_SERVICE,provinceId]
#pragma mark - 通过城市id查询地区
#define API_GetCallAreaList(cityId) [NSString stringWithFormat:@"%@%@/customField/getAreaList?cityId=%@",API_HOST,API_MAIN_BASIC_CONFIG_SERVICE,cityId]

#pragma mark -- 通过callID 查询用户通话中信息
#define API_PostCallUserData(CallID) [NSString stringWithFormat:@"%@%@/%@/tm-reports/statistics/%@/details/_search",API_HOST,API_MAIN_CALL_SERVICE,API_MAIN_TM,CallID]

#pragma mark -- 通过外呼电话号查询关联用户
#define API_GetSearchCallUsers(number,text) [NSString stringWithFormat:@"%@%@/crm-user-service/user/listByPage?pageNo=1&pageSize=15&isblack=0&searchType=4&searchValue=%@&searchFlag=0",API_CallApiHost,text,number]

#pragma mark -- 回拨接口
#define API_GetCallBack(CallID,sourceId,sourceType) [NSString stringWithFormat:@"%@/callservice/tm/tm-console/callbacks?fromCallID=%@&sourceType=%@&sourceId=%@&switchCurrentTabs=AutoJump",API_CallApiHost,CallID,sourceType,sourceId]

#pragma mark -- 查询是否开启签入技能组
#define API_GetQueueCheckin [NSString stringWithFormat:@"%@%@%@/tm-config/work-benchs/call-function/queue-checkin",API_CallApiHost,API_MAIN_CALL_SERVICE,API_MAIN_TM]

#pragma mark -- 查询是否是主通话 服务总结使用
#define API_GetCdrAgent(callID) [NSString stringWithFormat:@"%@%@%@/tm-console/workbench-screen/main/cdr/agent?callID=%@",API_CallApiHost,API_MAIN_CALL_SERVICE,API_MAIN_TM,callID]

#pragma mark -- 获取用户电话对应的 城市 （海外版使用）
//https://us.sobot.com/callservice/v6/tm-console/call/8acdd56b0fdf8N41639b114S70653973327e/customer/number/info
#define API_GetUserCity(callID) [NSString stringWithFormat:@"%@%@%@/tm-console/call/%@/customer/number/info",API_CallApiHost,API_MAIN_CALL_SERVICE,API_MAIN_TM,callID]



#pragma mark -- 呼叫任务V6版本相关
// GET
#define API_getTaskDetailInfoV6(campaignId,recordId) [NSString stringWithFormat:@"%@%@%@/tm-outbound/campaigns/%@/details/%@",API_CallApiHost,API_MAIN_CALL_SERVICE,API_MAIN_TM,campaignId,recordId]
// patch
// dataFields
#define API_updateTaskDetailInfoV6(campaignId,recordId) [NSString stringWithFormat:@"%@%@%@/tm-outbound/campaigns/%@/details/%@",API_CallApiHost,API_MAIN_CALL_SERVICE,API_MAIN_TM,campaignId,recordId]

// get
#define API_getTaskSummaryV6(campaignId,recordId) [NSString stringWithFormat:@"%@%@%@/tm-outbound/campaigns/%@/template-summary/%@",API_CallApiHost,API_MAIN_CALL_SERVICE,API_MAIN_TM,campaignId,recordId]
// patch
#define API_updateTaskSummaryV6(campaignId,recordId) [NSString stringWithFormat:@"%@%@%@/tm-outbound/campaigns/%@/template-summary/%@",API_CallApiHost,API_MAIN_CALL_SERVICE,API_MAIN_TM,campaignId,recordId]

// 外呼任务通话记录查询 POST
//campaignId                         String                           任务id
//campaignRecordId                   String                           任务明细id
#define API_getTaskRecordV6 [NSString stringWithFormat:@"%@%@%@/tm-reports/campaigns/maincdrs/_search",API_CallApiHost,API_MAIN_CALL_SERVICE,API_MAIN_TM]


//查询客服工作台任务明细列表post
///tm-outbound/console/campaigns/67d449ad0a3ceN4688A9c38R1c75be15fccc/contacts
#define API_PostTaskContactsList(campaignId) [NSString stringWithFormat:@"%@%@%@/tm-outbound/console/campaigns/%@/contacts",API_CallApiHost,API_MAIN_CALL_SERVICE,API_MAIN_TM,campaignId]

//https://api-c.soboten.com/callservice/v6/cc-console/follow-ups   post     {"callID":"5537c47a0ab70O11ee184155525400785b43","followUpStatus":"Closed","lastFollowupAgent":"","lastFollowupComment":"aaaa"}
// 跟进记录提交
// 保存话单备注
//url  ：/telemarketing/v6/tm-console/workbench-screen/cdr/remark
//method : POST
#define API_PostFollowUps [NSString stringWithFormat:@"%@%@%@/tm-console/workbench-screen/cdr/remark",API_CallApiHost,API_MAIN_CALL_SERVICE,API_MAIN_TM]

// 查询话单备注
//url  ：/telemarketing/v6/tm-consoleworkbench-screen/cdr/{callID}/remark
//method : GET
//header  :  正常传token
//response : 看实际返回值
#define API_GetCdrRemark(callID) [NSString stringWithFormat:@"%@%@%@/tm-console/workbench-screen/cdr/%@/remark",API_CallApiHost,API_MAIN_CALL_SERVICE,API_MAIN_TM,callID]

#endif /* SobotCallAddress_h */


