//
//  RootDemoController.m
//  SobotOrderSDKDemo
//
//  Created by zhangxy on 2022/5/17.
//

#import "RootDemoController.h"
#import <SobotCallSDK/SobotCallHomeController.h>
#import <SobotCallSDK/SobotCallApi.h>
#import <SobotCommon/SobotCacheEntity.h>
#import "ViewController.h"
#import "LoginViewController.h"
#import "OpenApiListController.h"
#import <SobotCallSDK/SobotCallClient.h>
#import <SobotTelemarketingSDK/SobotTMHomeV6Controller.h>
#import <SobotTelemarketingSDK/SobotTMClient.h>


#import "AppDelegate.h"
@interface RootDemoController ()<SobotCallClientDelegate,SobotTMClientDelegate>
@property(nonatomic,strong)  SobotCallHomeController *callHomeVC;
@property(nonatomic,strong)  SobotTMHomeV6Controller *tmHomeVC;
@end

@implementation RootDemoController

- (void)setTabBarItem:(UITabBarItem *)tabbarItem
                Title:(NSString *)title
        selectedImage:(NSString *)selectedImage
      unselectedImage:(NSString *)unselectedImage{
    
    //设置图片
    tabbarItem = [tabbarItem initWithTitle:title image:[[UIImage imageNamed:unselectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BOOL isShowTM = ((AppDelegate *)[UIApplication sharedApplication].delegate).loginWithTM;
    
    UINavigationBar * bar2 = [UINavigationBar appearance];
    bar2.barTintColor = [UIColor whiteColor];// 0x39B9C2
    
    //未选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromCallModeColor(SobotColorTextNav),NSFontAttributeName:[UIFont systemFontOfSize:10.0f]} forState:UIControlStateNormal];
    
    //选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromCallModeColor(SobotColorBanner),NSFontAttributeName:[UIFont systemFontOfSize:10.0f]} forState:UIControlStateSelected];

    
    if ([[UIDevice currentDevice].systemVersion doubleValue]>=15.0) {
        UITabBarAppearance *tabbarAppearance = [[UITabBarAppearance alloc] init];
        tabbarAppearance.backgroundColor = [UIColor whiteColor];
        self.tabBar.scrollEdgeAppearance = tabbarAppearance;
        self.tabBar.standardAppearance = tabbarAppearance;
        // 设置选中文字颜色 iOS13 中对应的label的属性 textColorFollowsTintColor 默认为true  iOS13之前的版本默认false
        self.tabBar.tintColor = UIColorFromCallModeColor(SobotColorBanner);
    }
    
    UINavigationController * navc5 = nil;
    UINavigationController * navc4 = nil;
    if(isShowTM){
        _tmHomeVC = [[SobotTMHomeV6Controller alloc]init];
        _tmHomeVC.exitWhenTokenInvalided = YES;
        _tmHomeVC.isAddInTab = YES;
        [SobotTMClient getSobotTMClient].delegate = self;
        [self setTabBarItem:_tmHomeVC.tabBarItem Title:@"电销" selectedImage:@"root_menu2" unselectedImage:@"root_menu2_nor"];
        navc5 = [[UINavigationController alloc] initWithRootViewController:_tmHomeVC];
        navc5.navigationBarHidden = NO;
    }else{
        // Do any additional setup after loading the view.
    //    self.navigationController.navigationBarHidden = YES;
        _callHomeVC = [[SobotCallHomeController alloc]init];
        _callHomeVC.exitWhenTokenInvalided = YES;
    //    orderHomeVC.email = @"test_wang2@sobot.com";
    //    orderHomeVC.password = @"Wang0901";
    //    orderHomeVC.isFirstPage = YES;
        _callHomeVC.isAddInTab = YES;
        [SobotCallClient getSobotCallClient].delegate = self;
    //    orderHomeVC.tabHeight = self.tabBar.frame.size.height;
        [self setTabBarItem:_callHomeVC.tabBarItem Title:@"呼叫" selectedImage:@"root_menu2" unselectedImage:@"root_menu2_nor"];
        navc4 = [[UINavigationController alloc] initWithRootViewController:_callHomeVC];
        navc4.navigationBarHidden = NO;
    }
    
    
    ViewController * viewController = [[ViewController alloc]init];
    [self setTabBarItem:viewController.tabBarItem Title:@"设置" selectedImage:@"root_menu4" unselectedImage:@"root_menu4_nor"];
    UINavigationController * navc1 = [[UINavigationController alloc]initWithRootViewController:viewController];
    navc1.navigationBarHidden = NO;
    
    
    OpenApiListController * viewController2 = [[OpenApiListController alloc]init];
    [self setTabBarItem:viewController2.tabBarItem Title:@"开放接口" selectedImage:@"root_menu4" unselectedImage:@"root_menu4_nor"];
    UINavigationController * navc2 = [[UINavigationController alloc]initWithRootViewController:viewController2];
    navc2.navigationBarHidden = NO;
    if(navc5!=nil){
        
        self.viewControllers = @[navc1,navc5,navc2];
    }else{
        
        self.viewControllers = @[navc1,navc4,navc2];
    }
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.hidesBottomBarWhenPushed = YES;
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
//    self.hidesBottomBarWhenPushed = NO;
}

-(void)setTabHidde:(BOOL)isHidde{
    if (_callHomeVC.isAddInTab) {
        [self.tabBar setHidden:isHidde];
    }
    if(_tmHomeVC.isAddInTab){
        [self.tabBar setHidden:isHidde];
    }
}

- (void)onCallStateChanged:(SobotCallListenerState)state objcect:(id _Nullable)obj { 
    
}


- (void)onCallStateChanged:(SobotCallLibClientListener)state mesage:(NSString * _Nullable)message objcect:(id _Nullable)obj extends:(id _Nullable)extends { 
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
