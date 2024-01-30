//
//  ViewController.m
//  SobotCallSDKDemo
//
//  Created by zhangxy on 2022/7/4.
//

#import "ViewController.h"
#import <SobotCallSDK/SobotCallSDK.h>


#import <SobotTelemarketingSDK/SobotTelemarketing.h>
#import <SobotTelemarketingSDK/SobotTMUITools.h>
#import <SobotCallSDK/SobotCallDefines.h>
#import "AppDelegate.h"

@interface ViewController ()<UITextFieldDelegate>{
    UITextField *fieldOrderId;
    UITextField *fieldUserName;
    UITextField *fieldUserId;
    
    UIButton *versionBtn;
}

@property(nonatomic,strong) UIScrollView *mainScroll;
@property(nonatomic,strong) UITextField *tf;
@end

@implementation ViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    [self createVCTitleView];
    [self setLeftTags:@[] rightTags:@[] titleView:nil];
    [self setTitleName:@"设置"];
    
    _mainScroll = [[UIScrollView alloc] init];
    [_mainScroll setFrame:self.view.bounds];
    _mainScroll.autoresizesSubviews = YES;
    _mainScroll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:_mainScroll];
    
    // Do any additional setup after loading the view.
    
//    [self createButton:0 title:@"启动layout测试页面"];
    UIButton *btn = [self createButton:1 title:@"Token启动主页面" y:108];
    CGFloat y = CGRectGetMaxY(btn.frame);
    
//    fieldOrderId = [self createTextField:11 holder:@"请输入工单id" y:y+30];
//    btn = [self createButton:3 title:@"打开指定工单" y:CGRectGetMaxY(fieldOrderId.frame)+10];
//    y = CGRectGetMaxY(btn.frame);
    
    btn = [self createButton:2 title:@"退出登录" y:y+20];
    y = CGRectGetMaxY(btn.frame);
    
    SobotLoginEntity *info = [SobotCallCache shareSobotCallCache].getLoginUser;
    NSString *key = [NSString stringWithFormat:@"%@_%@",SOBOT_CALL_SUPPORTVERSION,info.serviceEmail];
    BOOL isShowTM = ((AppDelegate *)[UIApplication sharedApplication].delegate).loginWithTM;

    if(!isShowTM){
        
        NSString *v = [SobotUserDefaults objectForKey:key];
        versionBtn = [self createButton:3 title:[NSString stringWithFormat:@"%@-%@-supportV6=%d",@"切换登录",v,[SobotCallUITools isSupportV6]] y:y+20];
        y = CGRectGetMaxY(versionBtn.frame);
        
    }
    
    [_mainScroll setContentSize:CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(btn.frame))];
    
    // 注册键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)click:(UIButton *) btn{
    
    BOOL isShowTM = ((AppDelegate *)[UIApplication sharedApplication].delegate).loginWithTM;

    if(btn.tag == 0){
//        [SobotOrderApi openTestVC:self];
    }
    // @"zhengnw@sobot.com" password:@"znw123456"
    // @"zhaowy@sobot.com" password:@"sobot123"
    //test_wang2@sobot.com Wang0901 wanglei1@sobot.com
//    NSString *host = [SobotUserDefaults objectForKey:@"Sobot_Host"];
    NSString *loginAccount = [SobotUserDefaults objectForKey:@"Sobot_LoginAccout"];
    NSString *password = [SobotUserDefaults objectForKey:@"Sobot_Password"];
    NSString *token = [SobotUserDefaults objectForKey:@"Sobot_Token"];
    if(btn.tag == 1){
        
        if(isShowTM){
            [SobotTMApi startWithToken:sobotConvertToString(token) viewController:self result:^(NSInteger code, id  _Nullable obj, NSString * _Nullable msg) {
                if(code == 1){
                    ((UIViewController *)obj).hidesBottomBarWhenPushed = YES;
                }
            }];
        }
        else{
            [SobotCallApi startWithToken:sobotConvertToString(token) viewController:self result:^(NSInteger code, id  _Nullable obj, NSString * _Nullable msg) {
                if(code == 1){
                    ((UIViewController *)obj).hidesBottomBarWhenPushed = YES;
                }
            }];
        }
    }
    if (btn.tag == 2) {
        
        if(isShowTM){
            [SobotTMApi outSobotUser:^(NSInteger code, id  _Nullable obj, NSString * _Nullable msg) {
                if(code == 1){
                    [((AppDelegate *)[UIApplication sharedApplication].delegate) switchRootViewController];
                }
            }];
        }else{
            
            [SobotCallApi outSobotUser:^(NSInteger code, id  _Nullable obj, NSString * _Nullable msg) {
                if(code == 1){
                    [((AppDelegate *)[UIApplication sharedApplication].delegate) switchRootViewController];
                }
            }];
        }
    }
    
    if(btn.tag == 3){
        SobotLoginEntity *info = [SobotCallCache shareSobotCallCache].getLoginUser;
        NSString *key = [NSString stringWithFormat:@"%@_%@",SOBOT_CALL_SUPPORTVERSION,info.serviceEmail];

        NSString *v = [SobotUserDefaults objectForKey:key];
        
        if(isShowTM){
            // 直接切换到V6
            if([sobotConvertToString(v) isEqual:SOBOT_CALL_V1VersionKey]){
                if([[SobotCallCache shareSobotCallCache] isLogin]){
                    [SobotTMUITools agentLogOut:^(SobotNetworkCode code, id  _Nullable obj, NSDictionary * _Nullable dict, NSString * _Nullable jsonString) {
                        // 关闭v1 linphone
                        [[SobotTMUITools shareSobotTMUITools] unRegister];
                        // 设置v6标记
                        [SobotUserDefaults setObject:SOBOT_CALL_V6VersionKey forKey:key];
                        
                        SobotLoginEntity *info = [[SobotCallCache shareSobotCallCache] getLoginUser];
                        
                        // 根据token获取accesToken，获取V6相关标记
                        [SobotTMApi loginUser:info.serviceEmail password:@"" token:info.token result:^(NSInteger code, id  _Nullable obj, NSString * _Nullable msg) {
                            if (code == CALL_CODE_SUCCEEDED) {
                              
                                //重新登录 刷新呼叫页面
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"ZCChangeCallVersion" object:nil];
                                
                                [self->versionBtn setTitle:[NSString stringWithFormat:@"%@-%@-supportV6=%d",@"切换登录",SOBOT_CALL_V6VersionKey,[SobotCallUITools isSupportV6]] forState:0];
                            }
                        }];
                    }];
                }
            }
            return;
        }
        
        if(![sobotConvertToString(v) isEqual:SOBOT_CALL_V1VersionKey]){
            // v6 切换到 v1
            if([[SobotCallCache shareSobotCallCache] isLogin]){
                // 签出V6状态
                [SobotCallUITools agentLogOut:^(SobotCallNetworkCode code, id  _Nullable obj, NSDictionary * _Nullable dict, NSString * _Nullable jsonString) {
//                    [[SobotCallCache shareSobotCallCache] getLoginUser].accessToken = @"";
                    [[SobotCallUITools shareSobotCallUITools] unRegister];
                    
                    [SobotUserDefaults setObject:SOBOT_CALL_V1VersionKey forKey:key];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZCChangeCallVersion" object:nil];
                    
                    [[SobotCallUITools shareSobotCallUITools] startLinphone];
                    
                    
                    [self->versionBtn setTitle:[NSString stringWithFormat:@"%@-%@-supportV6=%d",@"切换登录",SOBOT_CALL_V1VersionKey,[SobotCallUITools isSupportV6]] forState:0];
                    
                }];
            }
        }else{
            if([[SobotCallCache shareSobotCallCache] isLogin]){
                // 设置v1为离线状态，不是退出登录
                [SobotCallUITools agentLogOut:^(SobotCallNetworkCode code, id  _Nullable obj, NSDictionary * _Nullable dict, NSString * _Nullable jsonString) {
                    // 关闭v1 linphone
                    [[SobotCallUITools shareSobotCallUITools] unRegister];

                    // 设置v6标记
                    [SobotUserDefaults setObject:SOBOT_CALL_V6VersionKey forKey:key];

//                    NSLog(@"%@",[[SobotCallCache shareSobotCallCache] getLoginUser].accessToken);
                    
                    SobotLoginEntity *info = [[SobotCallCache shareSobotCallCache] getLoginUser];
                    
                    // 根据token获取accesToken，获取V6相关标记
                    [SobotCallApi loginUser:info.serviceEmail password:@"" token:info.token result:^(NSInteger code, id  _Nullable obj, NSString * _Nullable msg) {
                        if (code == CALL_CODE_SUCCEEDED) {
                          
                            //重新登录 刷新呼叫页面
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"ZCChangeCallVersion" object:nil];
                            
                            [self->versionBtn setTitle:[NSString stringWithFormat:@"%@-%@-supportV6=%d",@"切换登录",SOBOT_CALL_V6VersionKey,[SobotCallUITools isSupportV6]] forState:0];
                        }
                    }];
                    
                }];
                
            }
        }
    }
}

-(UIButton *) createButton:(int )tag title:(NSString *) title y:(CGFloat ) y{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:0];
    btn.tag = tag;
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:CGRectMake(20, y, self.view.frame.size.width - 40, 44)];
    btn.autoresizesSubviews = YES;
    btn.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [btn setTitleColor:UIColor.blueColor forState:0];
    [btn setBackgroundColor:UIColorFromCallModeColor(SobotColorBgLine)];
    [_mainScroll addSubview:btn];
    return btn;
}

-(UITextField *) createTextField:(int )tag holder:(NSString *) holder y:(CGFloat ) y{
    UITextField *btn = [[UITextField alloc] init];
    [btn setPlaceholder:holder];
    [btn setTextAlignment:NSTextAlignmentLeft];
    [btn setBorderStyle:UITextBorderStyleLine];
    btn.tag = tag;
    [btn setFrame:CGRectMake(20, y, self.view.frame.size.width - 40, 44)];
    btn.autoresizesSubviews = YES;
    btn.returnKeyType = UIReturnKeyDone;
    btn.delegate = self;
    btn.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [btn setTextColor:UIColor.darkTextColor];
    
    [_mainScroll addSubview:btn];
    return btn;
}
#pragma mark - textfield 代理事件
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    self.tf = nil;
    return YES;
}

-(void)textFieldDidChangeBegin:(UITextField *) textField{
    self.tf = textField;
}


- (void)keyboardWillShow:(NSNotification *)notification {
    float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat keyboardHeight = [[[notification userInfo] objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size.height;
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:[curve intValue]];
    [UIView setAnimationDelegate:self];
    {
     //设置偏移量
        UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
        CGRect rect=[self.tf convertRect: self.tf.bounds toView:window];
        CGFloat scrH = window.bounds.size.height;
        if ((scrH - keyboardHeight)< (rect.size.height + rect.origin.y)) {
            [self.mainScroll setContentOffset:CGPointMake(0, ((rect.size.height + rect.origin.y) - (scrH - keyboardHeight))) animated:YES];
        }
    }
    [UIView commitAnimations];
}

//键盘隐藏
- (void)keyboardWillHide:(NSNotification *)notification {
    float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView beginAnimations:@"bottomBarDown" context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView commitAnimations];
    [UIView animateWithDuration:0.25 animations:^{
        [self.mainScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    }];
}
@end
