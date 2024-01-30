//
//  LoginViewController.m
//  SobotOrderSDKDemo
//
//  Created by zhangxy on 2022/5/17.
//

#import "LoginViewController.h"
#import <SobotCallSDK/SobotCallSDK.h>
#import <SobotCommon/SobotCacheEntity.h>
#import <SobotCallSDK/SobotCallDefines.h>

#import "OpenApiListController.h"
#import "ApiWebController.h"

#import "AppDelegate.h"
#import <SobotCallSDK/SobotCallSDK.h>


#import <SobotTelemarketingSDK/SobotTMApi.h>

@interface LoginViewController ()<UITextFieldDelegate,UITextViewDelegate,SobotCallClientOpenDelegate>{
    UITextField *fieldHost;
    UITextField *fieldUserName;
    UITextField *fieldPassword;
    UITextField *fieldToken;
    
    
    UITextView *textViewStomp;
    UITextView *textViewJanus;
//    UITextField *openApiHost; // 获取公共接口域名
    UITextField *callApiHost; // 呼叫接口域名
    UITextField *stompSocketUri; // 监听呼叫消息uri
    UITextField *janusSocketUri; // 监听janus的sip消息uri
    
    CGFloat contentSizeHeight;
}
@property(nonatomic,strong) UIScrollView *mainScroll;
@property(nonatomic,strong) UITextField *tf;
@property(nonatomic,strong) UITextView *textV;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromCallModeColor(SobotColorBgMain);
//    self.view.backgroundColor = UIColor.whiteColor;
    _mainScroll = [[UIScrollView alloc] init];
    [_mainScroll setFrame:self.view.bounds];
    _mainScroll.autoresizesSubviews = YES;
    _mainScroll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:_mainScroll];
    
    
    SLog(@"----market----%@",[SobotTMApi getSobotTMVersion]);
    SLog(@"----call----%@",[SobotCallClient sobotGetSDKVersion]);
    
    
    UIButton *btn1 = [self createButton:5 title:@"登录呼叫并使用UI" y:108];
    CGFloat y = CGRectGetMaxY(btn1.frame);
     
    UIButton *btn2 = [self createButton:6 title:@"呼叫开放接口体验" y:y+20];
    y = CGRectGetMaxY(btn2.frame);
    
   UIButton *btn3 = [self createButton:105 title:@"登录电销UI" y:y+20];
   y = CGRectGetMaxY(btn3.frame);
    
   UIButton *btn4 = [self createButton:106 title:@"电销开放接口体验" y:y+20];
   y = CGRectGetMaxY(btn4.frame);
    
    // Do any additional setup after loading the view.
    UILabel *lab = [self createLabel:0 title:@"使用呼叫组件前请先登录\n用户名/密码 或 用户名/token可输入任意一组" y:y+20];
    [lab sizeToFit];
    y = CGRectGetMaxY(lab.frame);
    
    lab = [self createLabel:0 title:@"请输入域名,不填默认https://www.sobot.com" y:y+20];
    y = CGRectGetMaxY(lab.frame);
    fieldHost  = [self createTextField:1 holder:@"域名" y:y+5];
    y=CGRectGetMaxY(fieldHost.frame);
    
    lab = [self createLabel:0 title:@"请输入呼叫接口域名,不填默认https://testopenapi.sobot.com" y:y+20];
    y = CGRectGetMaxY(lab.frame);
    callApiHost  = [self createTextField:4 holder:@"呼叫接口域名" y:y+5];
    y=CGRectGetMaxY(callApiHost.frame);

    lab = [self createLabel:0 title:@"请输入监听呼叫消息uri,不填默认wss://testopenapi.sobot.com/v6.0.0/webmsg/cc-webmsg" y:y+20];
    y = CGRectGetMaxY(lab.frame);
    stompSocketUri  = [self createTextField:5 holder:@"监听呼叫消息uri" y:y+5];
    y=CGRectGetMaxY(stompSocketUri.frame);

    lab = [self createLabel:0 title:@"请输入监听janus的sip消息uri,不填默认wss://test-rtc.sobot.com.cn/janus" y:y+20];
    y = CGRectGetMaxY(lab.frame);
    janusSocketUri  = [self createTextField:6 holder:@"监听janus的sip消息uri" y:y+5];
    y=CGRectGetMaxY(janusSocketUri.frame);
    
    lab = [self createLabel:0 title:@"请输入账户(邮箱)" y:y+20];
    y = CGRectGetMaxY(lab.frame);
    fieldUserName  = [self createTextField:2 holder:@"登录账户" y:y+5];
    y=CGRectGetMaxY(fieldUserName.frame);
    
    lab = [self createLabel:0 title:@"请输入密码(如果有token可以不填)" y:y+20];
    y = CGRectGetMaxY(lab.frame);
    fieldPassword  = [self createTextField:3 holder:@"密码" y:y+5];
    fieldPassword.secureTextEntry = YES;
    y=CGRectGetMaxY(fieldPassword.frame);
    
    
    lab = [self createLabel:0 title:@"请输入token(有密码时可不填)" y:y+20];
    y = CGRectGetMaxY(lab.frame);
    fieldToken  = [self createTextField:4 holder:@"token" y:y+5];
    y=CGRectGetMaxY(fieldToken.frame);
    
    
    lab = [self createLabel:0 title:@"当前信息监听Stomp" y:y+20];
    y = CGRectGetMaxY(lab.frame);
    textViewStomp  = [self createTextView:7 holder:@"" y:y+5];
    y=CGRectGetMaxY(textViewStomp.frame);
    
    
    
    lab = [self createLabel:0 title:@"当前呼叫事件监听Janus" y:y+20];
    y = CGRectGetMaxY(lab.frame);
    textViewJanus = [self createTextView:8 holder:@"" y:y+5];
    y=CGRectGetMaxY(textViewJanus.frame);
    
    
    [_mainScroll setContentSize:CGSizeMake(self.view.frame.size.width, y+20+44)];
    contentSizeHeight = y+22+44;
    fieldHost.text = [SobotUserDefaults objectForKey:@"Sobot_Host"];
    fieldUserName.text = [SobotUserDefaults objectForKey:@"Sobot_LoginAccout"];
    fieldPassword.text = [SobotUserDefaults objectForKey:@"Sobot_Password"];
    fieldToken.text = [SobotUserDefaults objectForKey:@"Sobot_Token"];
    [SobotUserDefaults setObject:fieldHost.text forKey:@"Sobot_Host"];
    
    janusSocketUri.text = [SobotUserDefaults objectForKey:@"janusSocketUri"];
    stompSocketUri.text = [SobotUserDefaults objectForKey:@"stompSocketUri"];
    callApiHost.text = [SobotUserDefaults objectForKey:@"callApiHost"];
    
    fieldHost.text = @"https://hk.sobot.com";
    fieldUserName.text = @"xiang2@sobot.com";
    fieldPassword.text = @"sobot123";
}

-(void)click:(UIButton *) btn{

    if(btn.tag == 6 || btn.tag == 106){
        if(btn.tag == 106){
            ((AppDelegate *)[UIApplication sharedApplication].delegate).loginWithTM = YES;
        }else{
            ((AppDelegate *)[UIApplication sharedApplication].delegate).loginWithTM = NO;
        }
        OpenApiListController *vc = [[OpenApiListController alloc] init];
        UINavigationController *navVC = [[UINavigationController  alloc] initWithRootViewController:vc];
        navVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:navVC animated:YES completion:^{
            
        }];
    }
    if(btn.tag == 5 || btn.tag == 105){
        SobotCallCacheEntity *config = [[SobotCallCacheEntity alloc] initWithBundleName:@"SobotCall"];
        config.languageTableName = @"SobotLocalizable";
        config.languagePathInBundle = @"Localizable";
        config.colorTableName = @"SobotColor";
//        config.absoluetelanguage = @"zh-Hans";
//        config.absoluetelanguage = @"en";
//        config.defaultlanguage = @"en";
        
        
        
        // 香港环境
        config.stompSocketUri = @"wss://hk.sobot.com/v6.0.0/webmsg/cc-webmsg";
        config.openApiHost = @"https://hk.sobot.com";//@"sip:192.168.1.111:5060";
        config.janusSocketUri = @"wss://rtc.hk.sobot.cc";//@"sip:192.168.1.111:5060";
        config.sipProxy = @"sip:192.168.30.68:5060";
        config.callApiHost = @"https://hk.sobot.com";
        
        
        
        if(fieldUserName.text.length == 0){
            [SobotProgressHUD showInfoWithStatus:@"请输入登录账户"];
            return;
        }
        
        if(fieldPassword.text.length == 0 && fieldToken.text.length == 0){
            [SobotProgressHUD showInfoWithStatus:@"密码和token至少提供一个"];
            return;
        }
        [SobotUserDefaults setObject:fieldHost.text forKey:@"Sobot_Host"];
        [SobotUserDefaults setObject:fieldUserName.text forKey:@"Sobot_LoginAccout"];
        [SobotUserDefaults setObject:fieldPassword.text forKey:@"Sobot_Password"];
        [SobotUserDefaults setObject:fieldToken.text forKey:@"Sobot_Token"];
        [SobotUserDefaults setObject:callApiHost.text forKey:@"callApiHost"];
        [SobotUserDefaults setObject:stompSocketUri.text forKey:@"stompSocketUri"];
        [SobotUserDefaults setObject:janusSocketUri.text forKey:@"janusSocketUri"];
        
        
        if(btn.tag == 105){
            SobotTMParameter *kitInfo = [[SobotTMParameter alloc]init];
            kitInfo.showHomeBack = NO;
            [SobotTMApi initWithConfig:config kitInfo:kitInfo result:^(NSInteger code, id  _Nullable obj, NSString * _Nullable msg) {

            }];
            [SobotTMApi setShowDebug:YES];
            [self doLoginTM];
        }else{
            SobotCallParameter *kitInfo = [[SobotCallParameter alloc]init];
            kitInfo.showHomeBack = NO;
            [SobotCallApi initWithConfig:config kitInfo:kitInfo result:^(NSInteger code, id  _Nullable obj, NSString * _Nullable msg) {

            }];
            [SobotCallApi setShowDebug:YES];
            [self doLoginCall];
        }
        
    }
}

-(void)doLoginCall{
    ((AppDelegate *)[UIApplication sharedApplication].delegate).loginWithTM = NO;
    [SobotCallApi setSobotCallListener:^(int code, SobotCallListenerState status, id  _Nullable object, id  _Nullable obj, NSString * _Nullable msg) {
        if (status == SobotCallListenerStatePageClosed) {
            // 离线并退出SDK 切换到当前页面
            [((AppDelegate *)[UIApplication sharedApplication].delegate) goLogin];
        }
        if(status == SobotCallListenerStateOpenSipListener){
            // webscoket的回调
            // 开放接口websocket 监听 传的是第二个对象有值
            if (!sobotIsNull(obj)) {
                self->textViewStomp.text = [self->textViewStomp.text stringByAppendingString:[NSString stringWithFormat:@"\n%@",sobotConvertToString([self convertToJsonData:obj])]];
            }
        }
    }];
    
    [[SobotLoginTools shareSobotLoginTools] doAppLogin:fieldUserName.text pwd:fieldPassword.text appVersin:@"3.1.9" status:1 appRegion:0 result:^(NSInteger code, NSDictionary * _Nullable dict, NSString * _Nullable msg) {
        [[[SobotLoginTools shareSobotLoginTools] getLoginInfo] checkModule:SOBOT_LOGIN_MODULE_KEY_ORDER];
        if (code == 0 && sobotConvertToString(msg).length > 0) {
            [SobotProgressHUD showInfoWithStatus:sobotConvertToString(msg)];
        }
        [self loginResult:code];
    }];
}

-(void)doLoginTM{
    ((AppDelegate *)[UIApplication sharedApplication].delegate).loginWithTM = YES;
    [SobotTMApi setSobotCallListener:^(SobotCallLibClientListener state, NSString * _Nullable message, id  _Nullable obj, id  _Nullable extends) {
        if (state == SobotCallListenerStatePageClosed) {
            // 离线并退出SDK 切换到当前页面
            [((AppDelegate *)[UIApplication sharedApplication].delegate) goLogin];
        }
        if(state == SobotCallListenerStateOpenSipListener){
            // webscoket的回调
            // 开放接口websocket 监听 传的是第二个对象有值
            if (!sobotIsNull(obj)) {
                self->textViewStomp.text = [self->textViewStomp.text stringByAppendingString:[NSString stringWithFormat:@"\n%@",sobotConvertToString([self convertToJsonData:obj])]];
            }
        }
    }];
    
    
    [[SobotLoginTools shareSobotLoginTools] doAppLogin:fieldUserName.text pwd:fieldPassword.text appVersin:@"3.1.9" status:1 appRegion:0 result:^(NSInteger code, NSDictionary * _Nullable dict, NSString * _Nullable msg) {
        [[[SobotLoginTools shareSobotLoginTools] getLoginInfo] checkModule:SOBOT_LOGIN_MODULE_KEY_ORDER];
        if (code == 0 && sobotConvertToString(msg).length > 0) {
            [SobotProgressHUD showInfoWithStatus:sobotConvertToString(msg)];
        }
        [self loginResult:code];
    }];
}


-(void)loginResult:(NSInteger) code{
    if(code == 1){
        [((AppDelegate *)[UIApplication sharedApplication].delegate) switchRootViewController];
        [[SobotCallClient getSobotCallClient] connectCallWebSocket];
    }
}

-(UIButton *) createButton:(int )tag title:(NSString *) title y:(CGFloat) y{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:0];
    btn.tag = tag;
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:CGRectMake(20, y, self.view.frame.size.width - 40, 44)];
    btn.autoresizesSubviews = YES;
    btn.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [btn setTitleColor:UIColor.blueColor forState:0];
    [btn setBackgroundColor:UIColor.lightGrayColor];
    [_mainScroll addSubview:btn];
    return btn;
}

-(UILabel *) createLabel:(int )tag title:(NSString *) title y:(CGFloat )y{
    UILabel *btn = [[UILabel alloc] init];
    [btn setText:title];
    [btn setTextAlignment:NSTextAlignmentLeft];
    btn.numberOfLines = 0;
    btn.tag = tag;
    [btn setFrame:CGRectMake(20, y, self.view.frame.size.width - 40, 44)];
    btn.autoresizesSubviews = YES;
    btn.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [btn setTextColor:UIColor.darkTextColor];
    
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
    btn.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [btn setTextColor:UIColor.darkTextColor];
    btn.returnKeyType = UIReturnKeyDone;
    btn.delegate = self;
    [_mainScroll addSubview:btn];
    return btn;
}



-(UITextView *) createTextView:(int )tag holder:(NSString *) holder y:(CGFloat ) y{
    UITextView *btn = [[UITextView alloc] init];
    [btn setTextAlignment:NSTextAlignmentLeft];
    btn.tag = tag;
    [btn setFrame:CGRectMake(20, y, self.view.frame.size.width - 40, 104)];
    btn.autoresizesSubviews = YES;
    btn.layer.borderColor = UIColor.grayColor.CGColor;
    btn.layer.borderWidth = 1.0f;
    btn.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [btn setTextColor:UIColor.darkTextColor];
    btn.returnKeyType = UIReturnKeyDone;
    btn.delegate = self;
    [_mainScroll addSubview:btn];
    return btn;
}

- (void)textViewDidChange:(UITextView *)textView{
    self.textV = textView;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    self.tf = nil;
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.tf = textField;
    return YES;
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
            [self.mainScroll setContentSize:CGSizeMake(ScreenWidth, contentSizeHeight+keyboardHeight)];
            [self.mainScroll setContentOffset:CGPointMake(0,(rect.size.height + rect.origin.y)- (scrH - keyboardHeight) + 150) animated:YES];
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
        [self.mainScroll setContentSize:CGSizeMake(ScreenWidth, self->contentSizeHeight)];
    }];
}

#pragma mark - 代理事件
-(void)sobotCallOpenListenerobject:(id _Nullable)obj{
//    SLog(@"%@", obj);
}


-(NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }

    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}
@end
