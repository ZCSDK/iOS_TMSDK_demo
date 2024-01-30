//
//  ZCConfigDetailController.m
//  SobotKitFrameworkTest
//
//  Created by zhangxy on 2020/7/16.
//  Copyright © 2020 zhichi. All rights reserved.
//

#import "ZCConfigDetailController.h"

#import "ZCGuideData.h"
#import "ZCConfigBaseCell.h"
#define cellSetIdentifier @"ZCConfigBaseCell"
#import "ZCConfigDetailController.h"

#import "ZCConfigCodeCell.h"
#define cellCodeIdentifier @"ZCConfigCodeCell"

#import "EntityConvertUtils.h"
#import "ApiWebController.h"

@interface ZCConfigDetailController ()<UITableViewDelegate,UITableViewDataSource,ZCConfigBaseCellDelegate,ZCConfigCodeDelegate>{
    UITextField *_tempTextField;
    UITextView *_tempTextView;
    
    CGPoint        contentoffset;// 记录list的偏移量
    
}


@property (nonatomic,strong) UITableView * listTable;
@property (nonatomic,strong) NSMutableArray * dataArray;

// 事例代码
@property (nonatomic,strong) NSArray * codeUrls;

@end

@implementation ZCConfigDetailController



- (void)allHideKeyBoard
{
    for (UIWindow* window in [UIApplication sharedApplication].windows)
    {
        for (UIView* view in window.subviews)
        {
            [self dismissAllKeyBoardInView:view];
        }
    }
}

-(BOOL) dismissAllKeyBoardInView:(UIView *)view
{
    if([view isFirstResponder])
    {
        [view resignFirstResponder];
        return YES;
    }
    for(UIView *subView in view.subviews)
    {
        if([self dismissAllKeyBoardInView:subView])
        {
            return YES;
        }
    }
    return NO;
}


-(void)tapHideKeyboard{
    if(_tempTextView!=nil){
        [_tempTextView resignFirstResponder];
        _tempTextView = nil;
    }else if(_tempTextField!=nil){
        [_tempTextField resignFirstResponder];
        _tempTextField  = nil;
    }else{
        [self allHideKeyBoard];
    }
    
}

- (void) hideKeyboard {
    if(_tempTextView!=nil){
        [_tempTextView resignFirstResponder];
        _tempTextView = nil;
    }else if(_tempTextField!=nil){
        [_tempTextField resignFirstResponder];
        _tempTextField  = nil;
    }else{
        [self allHideKeyBoard];
    }
    
    if(contentoffset.x != 0 || contentoffset.y != 0){
        // 隐藏键盘，还原偏移量
        [_listTable setContentOffset:contentoffset];
    }
}



-(void)createTableView{
    _dataArray = [[NSMutableArray alloc] init];
    
    _listTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavBarHeight) style:UITableViewStylePlain];
    _listTable.delegate = self;
    _listTable.dataSource = self;
    if (@available(iOS 13.0, *)) {
        _listTable.backgroundColor = UIColor.systemGroupedBackgroundColor;
    } else {
        // Fallback on earlier versions
        _listTable.backgroundColor = UIColor.lightGrayColor;
    }
    [self.view addSubview:_listTable];
    
    [_listTable registerClass:[ZCConfigBaseCell class] forCellReuseIdentifier:cellSetIdentifier];
    [_listTable registerClass:[ZCConfigCodeCell class] forCellReuseIdentifier:cellCodeIdentifier];
    // 注册cell
    
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 1, ScreenWidth, 64)];
    _listTable.tableFooterView = footView;
    [_listTable setSeparatorColor:SobotColorFromRGB(0xdadada)];
    [_listTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self setTableSeparatorInset];
    
    
    NSArray *arr = [[ZCGuideData getZCGuideData] getConfigItems:_sectionData[@"code"]];
    _codeUrls = [[ZCGuideData getZCGuideData] getCodeStype:_sectionData[@"code"]];
    
    for (NSDictionary *item in arr) {
        // 交换赋值
        NSMutableDictionary *muldict = [NSMutableDictionary dictionaryWithDictionary:item];
        NSString *value = @"";
        NSInteger from = [item[@"from"] integerValue];
        NSString *key = convertToString(item[@"key"]);
        NSString *ptype = item[@"type"];
        
     
           if(from == ZCConfigFromSobotCallCacheEntity){
               if([@"MNSString" isEqual:ptype]){
                   value = [EntityConvertUtils DataTOjsonString:[[ZCGuideData getZCGuideData].callCacheEntity valueForKey:key]];
               }else if([@"NSString" isEqual:ptype]){
                   value = convertToString([[ZCGuideData getZCGuideData].callCacheEntity valueForKey:key]);
               }
               
               if(sobotConvertToString(value).length == 0){
                   value = sobotConvertToString([[ZCGuideData getZCGuideData] valueForKey:key]);
               }
           }
        
        if(from == ZCConfigFromGuideData){
            if([@"NSString" isEqual:ptype]){
                if([@"loginAccount" isEqual:item[@"key"]]){
                    value = convertToString([ZCGuideData getZCGuideData].loginAccount);
                }else if([@"loginPassword" isEqual:item[@"key"]]){
                    value = convertToString([ZCGuideData getZCGuideData].loginPassword);
                }else if([@"token" isEqual:item[@"key"]]){
                    value = convertToString([ZCGuideData getZCGuideData].token);
                }            }
        }
        
        muldict[@"value"] = value;
        [_dataArray addObject:muldict];
    }
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    self.bundleName = CallBundelName;
    [self createVCTitleView];
    [self setNavTitle:convertToString(_sectionData[@"name"])];
    self.navItemsSource = @{@(SobotButtonClickCommit):@{@"title":@"保存"}};
    [self setNavigationBarLeft:@[@(SobotButtonClickBack)] right:@[@(SobotButtonClickCommit)]];
    
    
    [self createTableView];
    
}

-(void)buttonClick:(UIButton *)sender{
    [self hideKeyboard];
    
    if(sender.tag == SobotButtonClickBack){
        [super buttonClick:sender];
        return;
    }
    
    NSString *tips=@"保存信息\n";
    for (NSDictionary *item in _dataArray) {
        if([item.allKeys containsObject:@"value"]){
            NSString *value = item[@"value"];
            NSInteger from = [item[@"from"] integerValue];
            if(from == ZCConfigFromGuideData){
                    if([@"loginAccount" isEqual:item[@"key"]]){
                        [ZCGuideData getZCGuideData].loginAccount = convertToString(value);
                    }else if([@"loginPassword" isEqual:item[@"key"]]){
                        [ZCGuideData getZCGuideData].loginPassword = convertToString(value);
                    }else if([@"token" isEqual:item[@"key"]]){
                        [ZCGuideData getZCGuideData].token = convertToString(value);
                    }
            }

            NSString *ptype = item[@"type"];
            if(from == ZCConfigFromSobotCallCacheEntity){
                if([@"MNSString" isEqual:ptype]){
                    id obj = [EntityConvertUtils dictionaryWithJsonString:value];
                    [[ZCGuideData getZCGuideData].callCacheEntity setValue:obj forKey:item[@"key"]];
                }
                if([@"NSString" isEqual:ptype]){
                    [[ZCGuideData getZCGuideData].callCacheEntity setValue:value forKey:item[@"key"]];
                }
            }
            
            if(from == ZCConfigFromApiParameter){
                if([@"MNSString" isEqual:ptype]){
                    id obj = [EntityConvertUtils dictionaryWithJsonString:value];
                    [[ZCGuideData getZCGuideData].apiParamter setValue:obj forKey:item[@"key"]];
                }
                if([@"NSString" isEqual:ptype]){
                    [[ZCGuideData getZCGuideData].apiParamter setValue:value forKey:item[@"key"]];
                }
            }
            
            tips = [tips stringByAppendingFormat:@"%@：%@\n",item[@"name"],item[@"value"]];
        }
    }
    
    if(sobotIsNull([ZCGuideData getZCGuideData].callCacheEntity)){
        [[ZCGuideData getZCGuideData] showAlertTips:tips vc:self];
    }else{
        [[ZCGuideData getZCGuideData] showAlertTips:tips vc:self blcok:^(int code) {
            ZCSectionIndex sectionIndex = (ZCSectionIndex)[self->_sectionData[@"index"] integerValue];
            if(sectionIndex == ZCSectionIndex31){
                // 初始化
                [SobotCallOpenApi initWithConfig:[ZCGuideData getZCGuideData].callCacheEntity result:^(NSInteger code, id  _Nullable obj, NSString * _Nullable msg) {
                    if(code == CALL_CODE_SUCCEEDED){
                        [[ZCGuideData getZCGuideData] showAlertTips:self->_sectionData[@"name"] vc:self blcok:^(int code) {
                            [self.navigationController popViewControllerAnimated:YES];
                        }];
                    }else{
                        
                        [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"失败\n%@\n%@",obj,msg] vc:self];
                        
                    }
                }];
            }else if(sectionIndex == ZCSectionIndex41){
                // 登录
                [SobotCallOpenApi loginWithAcount:[ZCGuideData getZCGuideData].loginAccount password:[ZCGuideData getZCGuideData].loginPassword token:[ZCGuideData getZCGuideData].token result:^(NSInteger code, id  _Nullable obj, NSString * _Nullable msg) {
                    if(code == CALL_CODE_SUCCEEDED){
                        [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:SobotCallLocalString(@"登录成功")] vc:self blcok:^(int code) {
                            [self.navigationController popViewControllerAnimated:YES];
                        }];
                    }else{
                        
                        [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"失败\n%@\n%@",obj,msg] vc:self];
                        
                    }
                }];
            }else if(sectionIndex == ZCSectionIndex42){
                // 开发接口签入
                [SobotCallOpenApi agentLoginWithExt:[ZCGuideData getZCGuideData].apiParamter.ext agentStatus:[ZCGuideData getZCGuideData].apiParamter.agentStatus callWay:[ZCGuideData getZCGuideData].apiParamter.callWay bindMobile:[ZCGuideData getZCGuideData].apiParamter.bindMobile thisQueues:[ZCGuideData getZCGuideData].apiParamter.thisQueues ResultBlock:^(NSInteger code, id  _Nullable obj, NSString * _Nullable msg) {
                    if(code == CALL_CODE_SUCCEEDED){
                        [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"成功\n%@",msg] vc:self blcok:^(int code) {
                            [self.navigationController popViewControllerAnimated:YES];
                        }];
                    }else{
                        [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"失败\n%@\n%@",obj,msg] vc:self];
                    }
                }];
            }else if(sectionIndex == ZCSectionIndex44){
                // 置忙
                [SobotCallOpenApi noReady:[ZCGuideData getZCGuideData].apiParamter.reasonCode resultBlock:^(NSInteger code, id  _Nullable obj, NSString * _Nullable msg) {
                    if(code == CALL_CODE_SUCCEEDED){
                        [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"成功\n%@",msg] vc:self blcok:^(int code) {
                            [self.navigationController popViewControllerAnimated:YES];
                        }];
                    }else{
                        [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"失败\n%@\n%@",obj,msg] vc:self];
                        
                    }
                }];
            }else if (sectionIndex == ZCSectionIndex481){
                // 查询可签入的技能组
                [SobotCallOpenApi queryReceptionQueues:^(NSInteger code, id  _Nullable obj, NSString * _Nullable msg) {
                    if(code == CALL_CODE_SUCCEEDED){
                        [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"成功\n%@",msg] vc:self blcok:^(int code) {
                            [self.navigationController popViewControllerAnimated:YES];
                        }];
                    }else{
                        [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"失败\n%@\n%@",obj,msg] vc:self];
                        
                    }
                }];
            }else if (sectionIndex == ZCSectionIndex482){
                // 重置离线
                [SobotCallOpenApi logOut:^(NSInteger code, id  _Nullable obj, NSString * _Nullable msg) {
                    if(code == CALL_CODE_SUCCEEDED){
                        [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"成功\n%@",msg] vc:self blcok:^(int code) {
                            [self.navigationController popViewControllerAnimated:YES];
                        }];
                    }else{
                        [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"失败\n%@\n%@",obj,msg] vc:self];
                    }
                }];
            }else if (sectionIndex == ZCSectionIndex483){
                [SobotCallOpenApi queryStates:^(NSInteger code, id  _Nullable obj, NSString * _Nullable msg) {
                    if(code == CALL_CODE_SUCCEEDED){
                        [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"成功\n%@",msg] vc:self blcok:^(int code) {
                            [self.navigationController popViewControllerAnimated:YES];
                        }];
                    }else{
                        [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"失败\n%@\n%@",obj,msg] vc:self];
                    }
                }];
            }else if (sectionIndex == ZCSectionIndex484){
                [SobotCallOpenApi queryPhoneType:^(NSInteger code, id  _Nullable obj, NSString * _Nullable msg) {
                    if(code == CALL_CODE_SUCCEEDED){
                        [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"成功\n%@",msg] vc:self blcok:^(int code) {
                            [self.navigationController popViewControllerAnimated:YES];
                        }];
                    }else{
                        [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"失败\n%@\n%@",obj,msg] vc:self];
                    }
                }];
            }else if(sectionIndex == ZCSectionIndex51){
                // 外呼
                [SobotCallOpenApi makeCallWithotherDN:[ZCGuideData getZCGuideData].apiParamter.otherDN privacyNumber:[ZCGuideData getZCGuideData].apiParamter.privacyNumber companyId:[ZCGuideData getZCGuideData].apiParamter.companyId ani:[ZCGuideData getZCGuideData].apiParamter.ani userData:[ZCGuideData getZCGuideData].apiParamter.userData outboundPlanCode:[ZCGuideData getZCGuideData].apiParamter.outboundPlanCode ResultBlock:^(NSInteger code, id  _Nullable obj, NSString * _Nullable msg) {
                    if(code == CALL_CODE_SUCCEEDED){
                        [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"成功\n%@",msg] vc:self blcok:^(int code) {
                            [self.navigationController popViewControllerAnimated:YES];
                        }];
                    }else{
                        [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"失败\n%@\n%@",obj,msg] vc:self];
                        
                    }
                }];
                
            }else if(sectionIndex == ZCSectionIndex510){
                // 发送满意度
                [SobotCallOpenApi sendSatisfy:^(NSInteger code, id  _Nullable obj, NSString * _Nullable msg) {
                    if(code == CALL_CODE_SUCCEEDED){
                        [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"成功\n%@",msg] vc:self blcok:^(int code) {
                            [self.navigationController popViewControllerAnimated:YES];
                        }];
                    }else{
                        [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"失败\n%@\n%@",obj,msg] vc:self];
                        
                    }
                }];
            }else if(sectionIndex == ZCSectionIndex511){
                // 延迟整理时长
                [SobotCallOpenApi delayACW:[ZCGuideData getZCGuideData].apiParamter.delayTime ResultBlock:^(NSInteger code, id  _Nullable obj, NSString * _Nullable msg) {
                    if(code == CALL_CODE_SUCCEEDED){
                        [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"成功\n%@",msg] vc:self blcok:^(int code) {
                            [self.navigationController popViewControllerAnimated:YES];
                        }];
                    }else{
                        [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"失败\n%@\n%@",obj,msg] vc:self];
                        
                    }
                }];
            }else if(sectionIndex == ZCSectionIndex513){
                // 延迟整理时长
                [SobotCallOpenApi agentSendDtmf:[ZCGuideData getZCGuideData].apiParamter.dtmfDigits ResultBlock:^(NSInteger code, id  _Nullable obj, NSString * _Nullable msg) {
                    if(code == CALL_CODE_SUCCEEDED){
                        [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"成功\n%@",msg] vc:self blcok:^(int code) {
                            [self.navigationController popViewControllerAnimated:YES];
                        }];
                    }else{
                        [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"失败\n%@\n%@",obj,msg] vc:self];
                        
                    }
                }];
            }else if(sectionIndex == ZCSectionIndex62){
                // 延迟整理时长
                [SobotCallOpenApi agentSetRouteExplicitRule:[ZCGuideData getZCGuideData].apiParamter.explicitRule explicitCode:[ZCGuideData getZCGuideData].apiParamter.explicitCode explicitNumber:[ZCGuideData getZCGuideData].apiParamter.explicitNumber resultBlock:^(NSInteger code, id  _Nullable obj, NSString * _Nullable msg) {
                    if(code == CALL_CODE_SUCCEEDED){
                        [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"成功\n%@",msg] vc:self blcok:^(int code) {
                            [self.navigationController popViewControllerAnimated:YES];
                        }];
                    }else{
                        [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"失败\n%@\n%@",obj,msg] vc:self];
                        
                    }
                }];
            }
        }];
        
    }
}



-(void)itemChangedCellOnClick:(NSString *)value dict:(NSDictionary *)dict indexPath:(NSIndexPath *)indexPath{

    // 交换赋值
    NSMutableDictionary *muldict = [NSMutableDictionary dictionaryWithDictionary:dict];
    muldict[@"value"] = value;
    _dataArray[indexPath.row] = muldict;
}

-(void)didKeyboardWillShow:(NSIndexPath *)indexPath view1:(UITextView *)textview view2:(UITextField *)textField{
    _tempTextView = textview;
    _tempTextField = textField;
    
    //获取当前cell在tableview中的位置
    CGRect rectintableview=[_listTable rectForRowAtIndexPath:indexPath];
    
    //获取当前cell在屏幕中的位置
    CGRect rectinsuperview = [_listTable convertRect:rectintableview fromView:[_listTable superview]];
    
    contentoffset = _listTable.contentOffset;
    
    if ((rectinsuperview.origin.y+50 - _listTable.contentOffset.y)>200) {
        
        [_listTable setContentOffset:CGPointMake(_listTable.contentOffset.x,((rectintableview.origin.y-_listTable.contentOffset.y)-150)+  _listTable.contentOffset.y) animated:YES];
        
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
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //    [self hideKeyboard];
    [self allHideKeyBoard];
}
#pragma mark UITableView delegate Start
// 返回section数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
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
    [lbl setTextAlignment:NSTextAlignmentLeft];
    // 没有更多记录的颜色
    [lbl setAutoresizesSubviews:YES];
    [lbl setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    if(section == 1){
        [lbl setText:@"参考文档"];
    }else{
        [lbl setText:_sectionData[@"name"]];
    }
    [view addSubview:lbl];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

// 返回section下得行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 1){
        return 1;
    }
    return _dataArray.count;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){

        ZCConfigCodeCell   *cell = [tableView dequeueReusableCellWithIdentifier:cellCodeIdentifier];
        if (cell == nil) {
            cell = [[ZCConfigCodeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellCodeIdentifier];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell setBackgroundColor:[UIColor whiteColor]];
        cell.delegate = self;
        [cell dataToView:_codeUrls];
        return cell;
    }
    ZCConfigBaseCell   *cell = [tableView dequeueReusableCellWithIdentifier:cellSetIdentifier];
    if (cell == nil) {
        cell = [[ZCConfigBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellSetIdentifier];
    }
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell setBackgroundColor:[UIColor whiteColor]];
    NSDictionary *item = _dataArray[indexPath.row];
   
    
    if(item){
        [cell dataToView:item];
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
    
    
    
    NSDictionary *item = _dataArray[indexPath.row];
    NSString *code = item[@"code"];
    
    if([@"4.5.1.1" isEqual:code]){
//        [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"当前消息数:%d",[ZCSobotApi getUnReadMessage]] vc:self];
    }
    if([@"4.5.1.2" isEqual:code]){
//        [ZCSobotApi clearUnReadNumber:[ZCLibClient getZCLibClient].libInitInfo.partnerid];
//        [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"已清理%@的当前消息数",[ZCGuideData getZCGuideData].libInitInfo.partnerid] vc:self];
    }
    
}
-(void)openURLString:(NSString *)url{
    ApiWebController *web = [[ApiWebController alloc] initWithURL:url];
    UINavigationController * navc = [[UINavigationController alloc]initWithRootViewController:web];
    navc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:navc animated:YES completion:^{
        
    }];
}



@end
