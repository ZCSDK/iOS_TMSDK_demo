//
//  SobotMTHomeBaseController.h
//  SobotCallSDK
//
//  Created by zhangxy on 2023/7/10.
//

#import <UIKit/UIKit.h>
#import <SobotCallLib/SobotCallLibDefines.h>
#import "SobotTMUITools.h"
NS_ASSUME_NONNULL_BEGIN

@interface SobotTMHomeBaseController : SobotBaseController

@property(nonatomic,assign)BOOL isAddInTab;// 首页是否嵌入到uitabbarviewcorll
// 登录参数
@property(nonatomic,strong) SobotBaseController * curController;
@property(nonatomic,assign) BOOL isShowPage;


/// 执行登录，静默登录外部会调用
-(void)doLogin;

// 判断是否添加自定义状态，v6版本，并且不是腾讯云全部使用接口返回
-(BOOL) checkAddSysStatus;

/// 销毁页面，执行离线时调用
-(void)destroyView;


/// 刷新页面数据
-(void)refreshData;


/// 修改导航
/// 更改导航，切换分机号等
-(void)refreshNav;

@end

NS_ASSUME_NONNULL_END
