//
//  AppDelegate.m
//  SobotOrderSDKDemo
//
//  Created by zhangxy on 2022/3/18.
//


#import "AppDelegate.h"
#import <SobotCallSDK/SobotCallSDK.h>
#import <SobotCommon/SobotCacheEntity.h>
#import "RootDemoController.h"
#import "LoginViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (void)switchRootViewController
{
    // 版本号相同：这次打开和上次打开的是同一个版本
    
    if (![SobotCallClient isLogin]) {
        [self goLogin];
    } else {
        [self goHome];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[SobotLoginTools shareSobotLoginTools] removeExpiresToken];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [self registerUserNotificationSettingsForIOS80];
    
    [self switchRootViewController];
    return YES;
}

-(void)goLogin{
    LoginViewController * login = [[LoginViewController alloc] init];
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:login];
    nav.navigationBarHidden=YES;
    self.window.backgroundColor = UIColor.whiteColor;
    self.window.rootViewController=nav;
}

-(void)goHome{
    UIStoryboard *stryBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.window.rootViewController=[stryBoard instantiateInitialViewController];
}

-(void)applicationDidEnterBackground:(UIApplication *)application{
    // 进入后台。若没有后台任务，创建后台任务。（如果有后台任务，不再创建后台任务）
    NSLog(@"*********************进入后台");
}


-(void)applicationDidBecomeActive:(UIApplication *)application{
}

#pragma mark - UISceneSession lifecycle


//- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
//    // Called when a new scene session is being created.
//    // Use this method to select a configuration to create the new scene with.
//    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
//}
//
//
//- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
//    // Called when the user discards a scene session.
//    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSString *message = [[userInfo objectForKey:@"aps"]objectForKey:@"alert"];
    NSLog(@"userInfo == %@\n%@",userInfo,message);
}

// 本地的通知回调事件
- (void)application:(UIApplication *)application didReceiveLocalNotification:(nonnull UILocalNotification *)notification{
    NSLog(@"userInfo == %@",notification.userInfo);
}
//====================For iOS 10====================

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    NSLog(@"Userinfo %@",notification.request.content.userInfo);
    //功能：可设置是否在应用内弹出通知
    completionHandler(UNNotificationPresentationOptionAlert);
}

//点击推送消息后回调
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^_Nonnull __strong)())completionHandler{
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if([userInfo[@"pushType"] hasPrefix:@"leavereply"]){
        
    }
    if([@"sobot" isEqual:userInfo[@"msgfrom"]]){
        
    }
    NSLog(@"Userinfo %@",userInfo);
}

-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)(void))completionHandler{
    if([identifier isEqualToString:@"yes"])
        {
            NSLog(@"yes");
            // 外抛接听方法
            [[SobotCallUITools shareSobotCallUITools] answerClickV6];
        }
        else if ([identifier isEqualToString:@"no"])
        {
            NSLog(@"no");
            // 外抛挂断方法
            [[SobotCallUITools shareSobotCallUITools] hangUPClickV6];
        }
        
        if(completionHandler)
        {
            completionHandler();
        }
}

- (void)registerUserNotificationSettingsForIOS80 {
    // iOS8.0 适配
//    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        // categories: 推送消息的附加操作，可以为nil,此时值显示消息，如果不为空，可以在推送消息的后面增加几个按钮（如同意、不同意）

        UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
//        category.identifier = @"choose";
        category.identifier = @"choose";
        // 同意
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"yes";
        action1.title = @"接听";
        action1.activationMode = UIUserNotificationActivationModeForeground;  // 点击按钮是否进入前台
        action1.authenticationRequired = true;
        action1.destructive = false;

        // 不同意
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];
        action2.identifier = @"no";
        action2.title = @"挂断";
        action2.activationMode = UIUserNotificationActivationModeBackground;  // 后台模式，点击了按钮就完了
        action2.authenticationRequired = false;
        action2.destructive = false;
//        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
//            action2.behavior = UIUserNotificationActionBehaviorTextInput;
//            action2.parameters = @{UIUserNotificationTextInputActionButtonTitleKey: @"拒绝原因"};
//        }
        [category setActions:@[action1, action2] forContext:UIUserNotificationActionContextDefault];
        NSSet<UIUserNotificationCategory *> *categories = [NSSet setWithObjects:category, nil];
        UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
//    }
}


@end
