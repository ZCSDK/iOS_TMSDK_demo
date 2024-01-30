//
//  SobotCallApiParameter.h
//  SobotCallSDKDemo
//
//  Created by zhangxy on 2023/1/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SobotCallApiParameter : NSObject

@property(nonatomic,strong)NSString *agentId;

// 签入
// 分机号
@property(nonatomic,strong)NSString *ext;
// 签入状态
@property(nonatomic,assign)int agentStatus;
// 签入方式
@property(nonatomic,assign)int callWay;
// 手机时绑定手机号
@property(nonatomic,strong)NSString *bindMobile;

// 置忙原因
@property(nonatomic,assign)int reasonCode;

// sip 注册的密码
@property(nonatomic,copy)NSString *sipPassword;

// sip 注册的域名
@property(nonatomic,copy)NSString *sipIp;

// 技能组，需要设置时传入，已逗号隔开
@property(nonatomic,strong)NSArray *thisQueues;

// 外呼号码
@property(nonatomic,strong)NSString *otherDN;
// 可用加密号码
@property(nonatomic,strong)NSString *privacyNumber;
// 公司id
@property(nonatomic,strong)NSString *companyId;
@property(nonatomic,strong)NSDictionary *userData;

@property(nonatomic,strong)NSString *outboundPlanCode;// 指定客户侧的外显号码方案编码

// 是否发送满意度
@property(nonatomic,strong)NSString *autoSatisfy;

// 延迟整理时间
@property(nonatomic,assign)int delayTime;


// 按键对应值(一次请求发送一个按键值，如，801#，则依次发送8、0、1、#这些按键请求,该参数不可为空)
@property(nonatomic,strong)NSString *dtmfDigits;

//外显规则 (1：企业号码池随机匹配；2：动态外显号码方案匹配；3：座席号码池指定；单选；)
@property(nonatomic,strong)NSString *explicitRule;

//动态外显方案编码  外显规则为动态外显号码方案时必传
@property(nonatomic,strong)NSString *explicitCode;

//外显号码  不使用外显规则，直接指定企业的某外显号码呼叫客户，外显号码和外显规则至少需要传一个
@property(nonatomic,strong)NSString *explicitNumber;
// 外显号码
@property(nonatomic,strong)NSString *ani;

@end

NS_ASSUME_NONNULL_END
