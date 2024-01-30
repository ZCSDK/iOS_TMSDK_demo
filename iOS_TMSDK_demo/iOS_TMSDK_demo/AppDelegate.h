//
//  AppDelegate.h
//  SobotOrderSDKDemo
//
//  Created by zhangxy on 2022/3/18.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic,strong)UIWindow *window;

// 登录电销
@property (nonatomic,assign)BOOL loginWithTM;



- (void)switchRootViewController;

-(void)goLogin;

@end

