//
//  ZCGuideData.h
//  SobotKitFrameworkTest
//
//  Created by zhangxy on 2020/7/16.
//  Copyright © 2020 zhichi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SobotCallSDK/SobotCallSDK.h>
#import <SobotTelemarketingSDK/SobotTelemarketing.h>
#import "SobotCallApiParameter.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,ZCConfigFrom) {
    ZCConfigFromClient = 0,
    ZCConfigFromSobotCallCacheEntity,
    ZCConfigFromApiParameter,
    ZCConfigFromGuideData,
    ZCConfigFromLibInit,
    ZCConfigFromKit,
    ZCConfigFromFunction,
};

typedef NS_ENUM(NSInteger,ZCSectionIndex) {
    ZCSectionIndex31 = 0,
    ZCSectionIndex41,
    ZCSectionIndex42,
    ZCSectionIndex43,
    ZCSectionIndex44,
    ZCSectionIndex45,
    ZCSectionIndex46,
    ZCSectionIndex47,
    ZCSectionIndex48,
    ZCSectionIndex481,
    ZCSectionIndex482,
    ZCSectionIndex483,
    ZCSectionIndex484,
    ZCSectionIndex51,
    ZCSectionIndex52,
    ZCSectionIndex53,
    ZCSectionIndex54,
    ZCSectionIndex55,
    ZCSectionIndex56,
    ZCSectionIndex57,
    ZCSectionIndex58,
    ZCSectionIndex59,
    ZCSectionIndex510,
    ZCSectionIndex511,
    ZCSectionIndex512,
    ZCSectionIndex513,
    ZCSectionIndex514,
    ZCSectionIndex61,
    ZCSectionIndex62
};

typedef NS_ENUM(NSInteger,ZCConfigIndex) {
    ZCConfigIndex311 = 100,
    ZCConfigIndex411,
    ZCConfigIndex511,
    ZCConfigIndex611
};




@interface ZCGuideData : NSObject

@property(nonatomic,strong)SobotCallCacheEntity *callCacheEntity;
// 设置数据
@property(nonatomic,strong)NSString *loginAccount;
@property(nonatomic,strong)NSString *loginPassword;
@property(nonatomic,strong)NSString *token;
@property(nonatomic,strong)SobotCallApiParameter *apiParamter;


// 获取公共接口域名, 默认：https://api.sobot.com
@property(nonatomic,strong) NSString *openApiHost;

// 呼叫接口域名，默认：https://openapi.soboten.com
@property(nonatomic,strong) NSString *callApiHost;


// 监听呼叫消息uri，默认：wss://openapi.sobot.com/v6.0.0/webmsg/cc-webmsg
@property(nonatomic,strong) NSString *stompSocketUri;


// 监听janus的sip消息uri,默认：wss://rtc.sobot.com.cn/janus
@property(nonatomic,strong) NSString *janusSocketUri;

// janus 代理服务：默认  sip:192.168.30.68:5060
@property(nonatomic,strong) NSString *sipProxy;

@property(nonatomic,strong) NSString *ext;

@property(nonatomic,strong) NSString *ani;

@property(nonatomic,strong) NSString *agentStatus;
//
@property(nonatomic,strong) NSString *callWay;

@property(nonatomic,strong) NSString *sipPassword;

@property(nonatomic,strong) NSString *sipIp;

+(ZCGuideData *)getZCGuideData;

-(NSArray *)getSectionArray;
-(NSArray *)getSectionListArray:(NSInteger )section;

-(NSArray *)getConfigItems:(NSString *) code;

-(NSArray *) getCodeStype:(NSString *)code;


-(void)showAlertTips:(NSString *)message vc:(UIViewController *) vc;
-(void)showAlertTips:(NSString *)message vc:(UIViewController *) vc blcok:(void (^)(int code)) alerClick;

@end

NS_ASSUME_NONNULL_END
