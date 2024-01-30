//
//  SobotTMHomeV6Controller.h
//  SobotCallSDK
//  呼叫重构v6版本以后，新的v6功能页面，此页面仅实现v6相关功能
//
//  Created by zhangxy on 2023/7/5.
//

#import "SobotTMHomeBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SobotTMHomeV6Controller : SobotTMHomeBaseController
@property(nonatomic,assign) BOOL exitWhenTokenInvalided;

// 登录参数
@property(nonatomic,copy) NSString * email;
@property(nonatomic,copy) NSString * password;
@property(nonatomic,copy) NSString * token;

@property(nonatomic,assign)BOOL isAddInTab;// 首页是否嵌入到uitabbarviewcorll
@property(nonatomic,strong)UIViewController *userVC;// 用户传入的VC

// 获取新的token从新登录
-(void)doLogin;

//app  登录成功后重新刷新数据
-(void)reloadInitData;

-(void)setV6Flag:(int)callV6Flag;

@end

NS_ASSUME_NONNULL_END
