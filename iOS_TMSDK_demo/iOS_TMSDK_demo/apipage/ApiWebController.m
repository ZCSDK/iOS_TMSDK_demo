//
//  ApiWebController.m
//  SobotCallSDKDemo
//
//  Created by zhangxy on 2023/1/4.
//

#import "ApiWebController.h"
#import <SobotCallSDK/SobotCallSDK.h>
#import <WebKit/WebKit.h>

@interface ApiWebController ()<WKNavigationDelegate>

@property(nonatomic,strong) WKWebView *webView;
@property(nonatomic,strong) NSLayoutConstraint *wkPL;
@property(nonatomic,strong) NSLayoutConstraint *wkPR;

@end

@implementation ApiWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bundleName = CallBundelName;
    [self createVCTitleView];
    [self setNavigationBarLeft:@[@(SobotButtonClickBack)] right:nil];
    
    [self setNavTitle:@"呼叫SDK-帮助文档"];
    
    [self createSubviews];
    
    
    NSURL *url=[[ NSURL alloc ] initWithString:_webUrl];
    [_webView loadRequest:[ NSURLRequest requestWithURL:url]];
}

-(id)initWithURL:(NSString *)url{
    self=[super init];
    if(self){
        if (sobotIsUrl(url,@"")) {
            _webUrl=url;
        }
    }
    return self;
}


#pragma mark -- 添加子控件
-(void)createSubviews{
    _webView = ({
        //创建网页配置对象
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        // 创建设置对象
        WKPreferences *preference = [[WKPreferences alloc]init];
        // 设置字体大小(最小的字体大小)
        preference.minimumFontSize = 14;
        // 设置偏好设置对象
        config.preferences = preference;
        // 自适应屏幕宽度js
        NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [config.userContentController addUserScript:wkUserScript];
        WKWebView *iv = [[WKWebView alloc]initWithFrame:CGRectMake(0, 120, ScreenWidth, 300) configuration:config];
        [self.view addSubview:iv];
        iv.navigationDelegate = self;
        [iv setOpaque:NO];
        iv.backgroundColor = SobotColorFromRGB(0xF2F2F7);
        [self.view addConstraint:sobotLayoutPaddingTop(NavBarHeight, iv, self.view)];
        self.wkPL = sobotLayoutPaddingLeft(0, iv, self.view);
        self.wkPR = sobotLayoutPaddingRight(0, iv, self.view);
        [self.view addConstraint:self.wkPR];
        [self.view addConstraint:self.wkPL];
        [self.view addConstraint:sobotLayoutPaddingBottom(-XBottomBarHeight, iv, self.view)];
        iv;
    });

}




// 适配iOS 13以上的横竖屏切换
-(void)viewSafeAreaInsetsDidChange{
    [super viewSafeAreaInsetsDidChange];
    UIEdgeInsets e = self.view.safeAreaInsets;
    if (self.wkPL) {
        [self.view removeConstraint:self.wkPL];
    }
    if (self.wkPR) {
        [self.view removeConstraint:self.wkPR];
    }
    
    self.wkPR = sobotLayoutPaddingRight(-e.right, self.webView, self.view);
    self.wkPL = sobotLayoutPaddingLeft(e.left, self.webView, self.view);
    [self.view addConstraint:self.wkPR];
    [self.view addConstraint:self.wkPL];
}


#pragma mark - WK代理事件
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    [[SobotToast shareToast] showProgress:@"" with:self.view];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [[SobotToast shareToast] dismisProgress];
    //重写contentSize,防止左右滑动
    CGSize size = webView.scrollView.contentSize;
    size.width= webView.scrollView.frame.size.width;
    webView.scrollView.contentSize= size;
    NSString *jsStr = [NSString stringWithFormat:@"var script = document.createElement('script');"
                       "script.type = 'text/javascript';"
                       "script.text = \"function ResizeImages() { "
                       "var myimg,oldwidth;"
                       "var maxwidth=%lf;" //缩放系数
                       "for(i=0;i <document.images.length;i++){"
                       "myimg = document.images[i];"
                       "if(myimg.width > maxwidth){"
                       "oldwidth = myimg.width;"
                       "myimg.width = maxwidth;"
                       "}"
                       "}"
                       "}\";"
                       "document.getElementsByTagName('head')[0].appendChild(script);",ScreenWidth-16];// SCREEN_WIDTH是屏幕宽度
    [webView evaluateJavaScript:jsStr completionHandler:nil];
    [webView evaluateJavaScript:@"ResizeImages();" completionHandler:nil];
    [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'" completionHandler:nil];
    //设置颜色
    if([SobotUITools getSobotThemeMode] == SobotThemeMode_Dark){
        [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#FFFFFF'" completionHandler:nil];
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [[SobotToast shareToast] dismisProgress];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    // 如果是跳转一个新页面
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    NSString *urlString = [navigationAction.request.URL absoluteString];
    
    if ([urlString isEqualToString:@"about:blank"]) {
       decisionHandler(WKNavigationActionPolicyCancel);
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

//获取宽度已经适配于webView的html。这里的原始html也可以通过js从webView里获取
- (NSString *)htmlAdjustWithPageWidth:(CGFloat )pageWidth
                                 html:(NSString *)html
{
    NSMutableString *str = [NSMutableString stringWithString:html];
    //计算要缩放的比例
    CGFloat initialScale = _webView.frame.size.width/pageWidth;
    //将</head>替换为meta+head
    NSString *stringForReplace = [NSString stringWithFormat:@"<meta name=\"viewport\" content=\" initial-scale=%f, minimum-scale=0.1, maximum-scale=2.0, user-scalable=yes\"></head>",initialScale];
    NSRange range =  NSMakeRange(0, str.length);
    //替换
    [str replaceOccurrencesOfString:@"</head>" withString:stringForReplace options:NSLiteralSearch range:range];
    return str;
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
