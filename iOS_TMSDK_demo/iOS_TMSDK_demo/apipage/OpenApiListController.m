//
//  OpenApiListController.m
//  SobotCallSDKDemo
//
//  Created by zhangxy on 2023/1/4.
//

#import "OpenApiListController.h"
#import "ZCGuideData.h"
#import "ZCSectionPropertyCell.h"
#define cellSetIdentifier @"ZCSectionPropertyCell"


#import "ZCConfigDetailController.h"
#import "ZCGuideActionController.h"
#import "ZCConfigTMDetailController.h"
#import "ZCGuideTMActionController.h"
#import "AppDelegate.h"

@interface OpenApiListController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITextView *textViewStomp;
    UITextView *textViewJanus;
}


@property (nonatomic,strong) UITableView * listTable;
@property (nonatomic,strong) NSMutableArray * dataArray;

@end

@implementation OpenApiListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    // Do any additional setup after loading the view.
    self.bundleName = CallBundelName;
    [self createVCTitleView];
    [self setNavigationBarLeft:@[@(SobotButtonClickBack)] right:nil];
    
    [self setNavTitle:@"呼叫SDK接口能力"];
    BOOL loginWithTM = ((AppDelegate *)[UIApplication sharedApplication].delegate).loginWithTM;
    if (loginWithTM) {
        [self setNavTitle:@"电销呼叫SDK接口能力"];
    }
    [self createTableView];
    
    // webscoket的回调
    [[SobotCallClient getSobotCallClient] setCallListenerEventBlock:^(int code, SobotCallListenerState status, id  _Nullable object, id  _Nullable msg, NSString * _Nullable obj) {
        if(status == SobotCallListenerStateOpenSipListener){
            if (!sobotIsNull(msg)) {
                // sip 的回调
                self->textViewStomp.text = [self->textViewStomp.text stringByAppendingString:[NSString stringWithFormat:@"\n%@",sobotConvertToString([self convertToJsonData:msg])]];
                if ([msg isKindOfClass:[NSDictionary class]]) {
                    if ([[msg allKeys] containsObject:@"messageID"]) {
                        NSString *msgId = sobotConvertToString([msg objectForKey:@"messageID"]);
                        if ([msgId isEqualToString:@"EventAgentLogin"]) {
    //                        [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"签入的scoket订阅消息%@",msg] vc:self];
                            UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:sobotConvertToString([self convertToJsonData:msg]) delegate:self cancelButtonTitle:@"签入的scoket订阅消息" otherButtonTitles:nil, nil];
                            [alterView show];
                        }
                        if ([msgId isEqualToString:@"RequestAgentLogout"]) {
    //                        [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"签出的scoket订阅消息%@",msg] vc:self];
                            UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:sobotConvertToString([self convertToJsonData:msg]) delegate:self cancelButtonTitle:@"scoket订阅消息" otherButtonTitles:nil, nil];
                            [alterView show];
                        }
                        if ([msgId isEqualToString:@"EventAgentNotReady"]) {
    //                        [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"置忙的scoket订阅消息%@",msg] vc:self];
                            UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:sobotConvertToString([self convertToJsonData:msg]) delegate:self cancelButtonTitle:@"置忙/结束整理scoket订阅消息" otherButtonTitles:nil, nil];
                            [alterView show];
                        }
                        if ([msgId isEqualToString:@"EventAgentReady"]) {
    //                        [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"置闲的scoket订阅消息%@",msg] vc:self];
                            UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:sobotConvertToString([self convertToJsonData:msg]) delegate:self cancelButtonTitle:@"置闲的scoket订阅消息" otherButtonTitles:nil, nil];
                            [alterView show];
                        }
                        if ([msgId isEqualToString:@"EventAgentLogout"]) {
    //                        [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"座席重置离线的scoket订阅消息%@",msg] vc:self];
                            UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:sobotConvertToString([self convertToJsonData:msg]) delegate:self cancelButtonTitle:@"scoket订阅消息" otherButtonTitles:nil, nil];
                            [alterView show];
                        }
                        if ([msgId isEqualToString:@"EventAgentHoldCall"]) {
    //                        [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"保持的scoket订阅消息%@",msg] vc:self];
                            UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:sobotConvertToString([self convertToJsonData:msg]) delegate:self cancelButtonTitle:@"保持的scoket订阅消息" otherButtonTitles:nil, nil];
                            [alterView show];
                        }
                        if ([msgId isEqualToString:@"EventAgentRetrieveCall"]) {
    //                        [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"取消保持的scoket订阅消息%@",msg] vc:self];
                            UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:sobotConvertToString([self convertToJsonData:msg]) delegate:self cancelButtonTitle:@"取消保持的scoket订阅消息" otherButtonTitles:nil, nil];
                            [alterView show];
                        }
                        if ([msgId isEqualToString:@"EventAgentMute"]) {
    //                        [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"静音的scoket订阅消息%@",msg] vc:self];
                            UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:sobotConvertToString([self convertToJsonData:msg]) delegate:self cancelButtonTitle:@"静音的scoket订阅消息" otherButtonTitles:nil, nil];
                            [alterView show];
                        }
                        if ([msgId isEqualToString:@"EventAgentUnmute"]) {
    //                        [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"取消静音的scoket订阅消息%@",msg] vc:self];
                            UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:sobotConvertToString([self convertToJsonData:msg]) delegate:self cancelButtonTitle:@"取消静音的scoket订阅消息" otherButtonTitles:nil, nil];
                            [alterView show];
                        }
                        if ([msgId isEqualToString:@"EventReleased"]) {
    //                        [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"取消静音的scoket订阅消息%@",msg] vc:self];
                            UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:sobotConvertToString([self convertToJsonData:msg]) delegate:self cancelButtonTitle:@"scoket订阅消息" otherButtonTitles:nil, nil];
                            [alterView show];
                        }
                        if ([msgId isEqualToString:@"EventDelayCallAfterWork"]) {
    //                        [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"取消静音的scoket订阅消息%@",msg] vc:self];
                            UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:sobotConvertToString([self convertToJsonData:msg]) delegate:self cancelButtonTitle:@"延长整理时长scoket订阅消息" otherButtonTitles:nil, nil];
                            [alterView show];
                        }
                        if ([msgId isEqualToString:@"EventDtmfSent"]) {
    //                        [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"取消静音的scoket订阅消息%@",msg] vc:self];
                            UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:sobotConvertToString([self convertToJsonData:msg]) delegate:self cancelButtonTitle:@"发送按键的scoket订阅消息" otherButtonTitles:nil, nil];
                            [alterView show];
                        }
                        if ([msgId isEqualToString:@"EventReleased"]) {
    //                        [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"取消静音的scoket订阅消息%@",msg] vc:self];
                            UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:sobotConvertToString([self convertToJsonData:msg]) delegate:self cancelButtonTitle:@"scoket订阅消息" otherButtonTitles:nil, nil];
                            [alterView show];
                        }
                    }
                }
            }
        }
    }];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

-(void)createTableView{
    _dataArray =  [NSMutableArray arrayWithArray:[ZCGuideData getZCGuideData].getSectionArray];
    CGFloat w = self.view.frame.size.width;
    _listTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, w, ScreenHeight - NavBarHeight) style:UITableViewStyleGrouped];
    _listTable.delegate = self;
    _listTable.dataSource = self;
    if (@available(iOS 13.0, *)) {
        _listTable.backgroundColor = SobotColorFromRGB(0xF2F2F7);
    } else {
        // Fallback on earlier versions
        _listTable.backgroundColor = UIColor.lightGrayColor;
    }
    self.view.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.view.autoresizesSubviews = YES;
    [self.view addSubview:_listTable];
    
    [_listTable registerClass:[ZCSectionPropertyCell class] forCellReuseIdentifier:cellSetIdentifier];
    // 注册cell
    
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 1, w, 0)];
    footView.backgroundColor = SobotColorFromRGB(0xEFF3FA);
    _listTable.tableFooterView = footView;
    [_listTable setSeparatorColor:SobotColorFromRGB(0xdadada)];
    [_listTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
     [self setTableSeparatorInset];
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 15.0) {
        _listTable.sectionHeaderTopPadding = 0;
    }
}

/**
 *  设置UITableView分割线空隙
 */
-(void)setTableSeparatorInset{
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 10, 0, 0);
    if ([_listTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [_listTable setSeparatorInset:inset];
    }
    
    if ([_listTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [_listTable setLayoutMargins:inset];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
#pragma mark UITableView delegate Start
// 返回section数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

// 返回section高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}

// 返回section 的View
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    [view setBackgroundColor:[UIColor clearColor]];
    
    UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth-40, 40)];
    
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = SobotColorFromRGB(0x333333);
    [lbl setTextAlignment:NSTextAlignmentLeft];
    // 没有更多记录的颜色
    [lbl setAutoresizesSubviews:YES];
    [lbl setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [lbl setText:_dataArray[section]];
    [view addSubview:lbl];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 3) {
        return 400;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 3) {
        UIView *testfootView = [[UIView alloc]init];
        CGFloat y = 0;
        UILabel *lab1 = [self createLabel:0 title:@"当前信息监听Stomp" y:y+20 superView:testfootView];
        y = CGRectGetMaxY(lab1.frame);
        textViewStomp  = [self createTextView:7 holder:@"" y:y+5 superView:testfootView];
        y=CGRectGetMaxY(textViewStomp.frame);
        
//        textViewStomp.text = @"1344";
            
        UILabel *lab2 = [self createLabel:0 title:@"当前呼叫事件监听Janus" y:y+20 superView:testfootView];
        y = CGRectGetMaxY(lab2.frame);
        textViewJanus = [self createTextView:8 holder:@"" y:y+5 superView:testfootView];
    //    y=CGRectGetMaxY(textViewJanus.frame);
        
//        textViewJanus.text = @"1344sss";
        return testfootView;
    }
    return [UIView new];
    
}

// 返回section下得行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[ZCGuideData getZCGuideData] getSectionListArray:section].count;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZCSectionPropertyCell   *cell = [tableView dequeueReusableCellWithIdentifier:cellSetIdentifier];
    if (cell == nil) {
        cell = [[ZCSectionPropertyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellSetIdentifier];
    }
    
    [cell setBackgroundColor:SobotColorFromRGB(0xffffff)];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    NSArray *arr = [[ZCGuideData getZCGuideData] getSectionListArray:indexPath.section];
    NSDictionary *item = arr[indexPath.row];
    if(item){
        [cell initWithNSDictionary:item];
    }
    
    return cell;
}

// table 行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

// table 行的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    NSArray *arr = [[ZCGuideData getZCGuideData] getSectionListArray:indexPath.section];
    NSDictionary *item = arr[indexPath.row];
    //    ZCSectionIndex code = (ZCSectionIndex)[item[@"index"] integerValue];
    //    if(code == ZCSectionIndex31 ||code == ZCSectionIndex41 || code == ZCSectionIndex46){
    
    BOOL isShowTM = ((AppDelegate *)[UIApplication sharedApplication].delegate).loginWithTM;
    
    NSString *extends = item[@"extends"];
    if([@"action" isEqual:extends]){
        if(isShowTM){
            
            ZCGuideTMActionController *vc = [[ZCGuideTMActionController alloc] init];
            vc.sectionData = item;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            ZCGuideActionController *vc = [[ZCGuideActionController alloc] init];
            vc.sectionData = item;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        if(isShowTM){
            
            ZCConfigTMDetailController *vc = [[ZCConfigTMDetailController alloc] init];
            vc.sectionData = item;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            ZCConfigDetailController *vc = [[ZCConfigDetailController alloc] init];
            vc.sectionData = item;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    //    }
    
}


-(UITextView *) createTextView:(int )tag holder:(NSString *) holder y:(CGFloat ) y superView:(UIView *)superView {
    UITextView *btn = [[UITextView alloc] init];
    [btn setTextAlignment:NSTextAlignmentLeft];
    btn.tag = tag;
    [btn setFrame:CGRectMake(20, y, 300, 104)];
    btn.autoresizesSubviews = YES;
    btn.layer.borderColor = UIColor.grayColor.CGColor;
    btn.layer.borderWidth = 1.0f;
//    btn.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [btn setTextColor:UIColor.darkTextColor];
    btn.returnKeyType = UIReturnKeyDone;
    btn.delegate = self;
    [superView addSubview:btn];
    return btn;
}

-(UILabel *) createLabel:(int )tag title:(NSString *) title y:(CGFloat )y superView:(UIView *)superView {
    UILabel *btn = [[UILabel alloc] init];
    [btn setText:title];
    [btn setTextAlignment:NSTextAlignmentLeft];
    btn.numberOfLines = 0;
    btn.tag = tag;
    [btn setFrame:CGRectMake(20, y, 300, 44)];
    btn.autoresizesSubviews = YES;
//    btn.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [btn setTextColor:UIColor.darkTextColor];
    [superView addSubview:btn];
    return btn;
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

