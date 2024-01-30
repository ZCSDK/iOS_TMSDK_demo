//
//  SobotTMClient.h
//  SobotTelemarketingSDK
//
//  Created by zhangxy on 2023/12/11.
//

#import <Foundation/Foundation.h>
#import <SobotCallLib/SobotCallCacheEntity.h>
#import <SobotCallLib/SobotCallLibClient.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SobotTMClientListenerBlock)(SobotCallLibClientListener state,NSString *_Nullable message,id _Nullable obj,id _Nullable extends);// 监听事件


@protocol  SobotTMClientDelegate <NSObject>

-(void)onCallStateChanged:(SobotCallLibClientListener) state mesage:(NSString *_Nullable) message objcect:(id _Nullable )obj extends:(id _Nullable) extends;

@optional
-(void)setTabHidde:(BOOL)isHidde;

@end


@interface SobotTMClient : NSObject

@property(nonatomic,weak)id <SobotTMClientDelegate>delegate;
@property (nonatomic,copy) SobotTMClientListenerBlock tmListernerBlock;



+(SobotTMClient *)getSobotTMClient;

// 设置国际化/资源等本地化配置
-(void)initSDKWithConfig:(SobotCallCacheEntity * _Nullable)config;


// 当前登录状态
+(BOOL) isLogin;

// 获取版本
+(NSString *)sobotGetSDKVersion;

// 获取渠道
+(NSString *)sobotGetSDKChannel;

// 设置调试模式
+(void)showDebug:(BOOL) showDebug;



// 发布事件通知给外部
-(void)postTMListenerState:(SobotCallLibClientListener)state message:(NSString *_Nullable)message;
-(void)postTMListenerState:(SobotCallLibClientListener)state object:(id _Nullable)obj;
-(void)postTMListenerState:(SobotCallLibClientListener) state mesage:(NSString *_Nullable) message objcect:(id _Nullable )obj;
-(void)postTMListenerState:(SobotCallLibClientListener) state mesage:(NSString *_Nullable) message objcect:(id _Nullable )obj extends:(id _Nullable) extends;



// 如果跳过呼叫登录，直接使用V6版本呼叫，登录成功后需要调用此方法唤起呼叫消息监听
-(void)connectCallWebSocket;

// 关闭呼叫消息监听，一般无需维护
-(void)disConnectCallWebSocket;

@end
NS_ASSUME_NONNULL_END
