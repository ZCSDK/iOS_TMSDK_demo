//
//  ZCGuideTMActionController.m
//  SobotCallSDKDemo
//
//  Created by zhangxy on 2023/12/19.
//

#import "ZCGuideTMActionController.h"
#import "ApiWebController.h"
#import "ZCGuideData.h"

#import "ZCConfigCodeCell.h"
#define cellCodeIdentifier @"ZCConfigCodeCell"


@interface ZCGuideTMActionController ()<UITableViewDelegate,UITableViewDataSource,ZCConfigCodeDelegate>{
    NSString *code;
}


@property (nonatomic,strong) UITableView * listTable;

// 事例代码
@property (nonatomic,strong) NSArray * codeUrls;

@end

@implementation ZCGuideTMActionController

-(UIButton *)createItemButton:(NSString *) title f:(CGRect) frame tag:(int) index{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setFrame:frame];
    btn.backgroundColor = UIColor.whiteColor;
    btn.layer.borderColor = UIColor.lightGrayColor.CGColor;
    btn.tag = index;
    btn.layer.borderWidth = 1.0f;
//    btn.layer.cornerRadius = 5;
    [btn setTitleColor:UIColor.blueColor forState:0];
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bundleName = CallBundelName;
    [self createVCTitleView];
    [self setNavTitle:sobotConvertToString(_sectionData[@"name"])];
    
    [self createTableView];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

-(void)buttonClick:(UIButton *)sender{
    if(sender.tag == SobotButtonClickBack){
        [super buttonClick:sender];
        return;
    }
    if(![[SobotCallCache shareSobotCallCache] isLogin] &&
       ![@"5.8" isEqual:code] &&
       ![@"5.9" isEqual:code]){
        [[ZCGuideData getZCGuideData] showAlertTips:@"请先登录" vc:self];
        return;
    }
    
    if([@"4.3" isEqual:code]){
        [SobotTMOpenApi logOut:^(NSInteger code, id  _Nullable obj, NSString * _Nullable msg) {
            if(code == CALL_CODE_SUCCEEDED){
                [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"%@调用完成",sobotConvertToString(_sectionData[@"name"])]  vc:self blcok:^(int code) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else{
                [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"%@调用失败:%@",sobotConvertToString(_sectionData[@"name"]),msg] vc:self blcok:^(int code) {
                }];
            }
        }];
    }else if([@"4.5" isEqual:code]){
        [SobotTMOpenApi ready:^(NSInteger code, id  _Nullable obj, NSString * _Nullable msg) {
            if(code == CALL_CODE_SUCCEEDED){
                [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"%@调用完成",sobotConvertToString(_sectionData[@"name"])]  vc:self blcok:^(int code) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else{
                [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"%@调用失败:%@",sobotConvertToString(_sectionData[@"name"]),msg] vc:self blcok:^(int code) {
                }];
            }
        }];
    }else if([@"4.6" isEqual:code]){
        [SobotTMOpenApi queryLoginBingInfo:^(NSInteger code, id  _Nullable obj, NSString * _Nullable msg) {
            if(code == CALL_CODE_SUCCEEDED){
                [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"成功\n%@",msg]  vc:self blcok:^(int code) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else{
                [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"失败\n%@\n%@",obj,msg] vc:self];
                
            }
        }];
    }else if([@"4.7" isEqual:code]){
        [SobotTMOpenApi queryUnusedExts:^(NSInteger code, id  _Nullable obj, NSString * _Nullable msg) {
            if(code == CALL_CODE_SUCCEEDED){
                [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"成功\n%@",msg]  vc:self blcok:^(int code) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else{
                [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"失败\n%@\n%@",obj,msg] vc:self];
                
            }
        }];
    }else if([@"4.8" isEqual:code]){
        [SobotTMOpenApi queryAgentBusyStatus:^(NSInteger code, id  _Nullable obj, NSString * _Nullable msg) {
            if(code == CALL_CODE_SUCCEEDED){
                [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"成功\n%@",msg]  vc:self blcok:^(int code) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else{
                [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"失败\n%@\n%@",obj,msg] vc:self];
                
            }
        }];
    }else if([@"4.9" isEqual:code]){
        [SobotTMOpenApi queryReceptionQueues:^(NSInteger code, id  _Nullable obj, NSString * _Nullable msg) {
            if(code == CALL_CODE_SUCCEEDED){
                [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"成功\n%@",msg]  vc:self blcok:^(int code) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else{
                [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"失败\n%@\n%@",obj,msg] vc:self];
                
            }
        }];
    }else if([@"4.10" isEqual:code]){
        [SobotTMOpenApi logOut:^(NSInteger code, id  _Nullable obj, NSString * _Nullable msg) {
            if(code == CALL_CODE_SUCCEEDED){
                [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"成功\n%@",msg]  vc:self blcok:^(int code) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else{
                [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"失败\n%@\n%@",obj,msg] vc:self];
                
            }
        }];
    }else if([@"4.11" isEqual:code]){
        [SobotTMOpenApi queryStates:^(NSInteger code, id  _Nullable obj, NSString * _Nullable msg) {
            if(code == CALL_CODE_SUCCEEDED){
                [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"成功\n%@",msg]  vc:self blcok:^(int code) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else{
                [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"失败\n%@\n%@",obj,msg] vc:self];
                
            }
        }];
    }else if([@"5.2" isEqual:code]){
        [SobotTMOpenApi answer:^(NSInteger code, id  _Nullable obj, NSString * _Nullable msg) {
            if(code == CALL_CODE_SUCCEEDED){
                [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"成功\n%@",msg]  vc:self blcok:^(int code) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else{
                [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"失败\n%@\n%@",obj,msg] vc:self];
                
            }
        }];
    }else if([@"5.3" isEqual:code]){
        [SobotTMOpenApi hangup:^(NSInteger code, id  _Nullable obj, NSString * _Nullable msg) {
            if(code == CALL_CODE_SUCCEEDED){
                [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"成功\n%@",msg]  vc:self blcok:^(int code) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else{
                [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"失败\n%@\n%@",obj,msg] vc:self];
                
            }
        }];
    }else if([@"5.4" isEqual:code]){
        [SobotTMOpenApi holdCall:^(NSInteger code, id  _Nullable obj, NSString * _Nullable msg) {
            if(code == CALL_CODE_SUCCEEDED){
                [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"成功\n%@",msg]  vc:self blcok:^(int code) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else{
                [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"失败\n%@\n%@",obj,msg] vc:self];
                
            }
        }];
    }else if([@"5.5" isEqual:code]){
        [SobotTMOpenApi retrieveCall:^(NSInteger code, id  _Nullable obj, NSString * _Nullable msg) {
            if(code == CALL_CODE_SUCCEEDED){
                [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"成功\n%@",msg]  vc:self blcok:^(int code) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else{
                [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"失败\n%@\n%@",obj,msg] vc:self];
                
            }
        }];
    }else if([@"5.6" isEqual:code]){
        [SobotTMOpenApi muteCall:^(NSInteger code, id  _Nullable obj, NSString * _Nullable msg) {
            if(code == CALL_CODE_SUCCEEDED){
                [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"成功\n%@",msg]  vc:self blcok:^(int code) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else{
                [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"失败\n%@\n%@",obj,msg] vc:self];
                
            }
        }];
    }else if([@"5.7" isEqual:code]){
        [SobotTMOpenApi unmute:^(NSInteger code, id  _Nullable obj, NSString * _Nullable msg) {
            if(code == CALL_CODE_SUCCEEDED){
                [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"成功\n%@",msg]  vc:self blcok:^(int code) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else{
                [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"失败\n%@\n%@",obj,msg] vc:self];
                
            }
        }];
    }else if([@"5.8" isEqual:code]){
        NSString *str = [SobotTMOpenApi searchPlayCategory];
        [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"当前播放类型\n%@",str] vc:self];
    }else if([@"5.9" isEqual:code]){
        [SobotTMOpenApi changedPlayCategory:^(NSInteger code, id  _Nullable obj, NSString * _Nullable msg) {
            if(code == CALL_CODE_SUCCEEDED){
                [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"已切换为：\n%@",msg]  vc:self blcok:^(int code) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
        }];
    }else if([@"5.12" isEqual:code]){
        [SobotTMOpenApi completeACW:^(NSInteger code, id  _Nullable obj, NSString * _Nullable msg) {
            if(code == CALL_CODE_SUCCEEDED){
                [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"成功：\n%@",msg]  vc:self blcok:^(int code) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
        }];
    }else if([@"5.14" isEqual:code]){
        [SobotTMOpenApi completeACWToBusy:^(NSInteger code, id  _Nullable obj, NSString * _Nullable msg) {
            if(code == CALL_CODE_SUCCEEDED){
                [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"成功：\n%@",msg]  vc:self blcok:^(int code) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
        }];
    }else if([@"6.1" isEqual:code]){
        [SobotTMOpenApi queryRoutes:^(NSInteger code, id  _Nullable obj, NSString * _Nullable msg) {
            if(code == CALL_CODE_SUCCEEDED){
                [[ZCGuideData getZCGuideData] showAlertTips:[NSString stringWithFormat:@"成功：\n%@",msg]  vc:self blcok:^(int code) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
        }];
    }
}





-(void)createTableView{
    _listTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavBarHeight) style:UITableViewStylePlain];
    _listTable.delegate = self;
    _listTable.dataSource = self;
    if (@available(iOS 13.0, *)) {
        _listTable.backgroundColor = SobotColorFromRGB(0xF2F2F7);
    } else {
        // Fallback on earlier versions
        _listTable.backgroundColor = UIColor.lightGrayColor;
    }
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 15.0) {
        _listTable.sectionHeaderTopPadding = 0;
    }
    [self.view addSubview:_listTable];
    [_listTable registerClass:[ZCConfigCodeCell class] forCellReuseIdentifier:cellCodeIdentifier];
    // 注册cell
    
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 1, ScreenWidth, 64)];
    _listTable.tableFooterView = footView;
    [_listTable setSeparatorColor:SobotColorFromRGB(0xdadada)];
    [_listTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self setTableSeparatorInset];
    
    UIButton *btn = [self createItemButton:_sectionData[@"name"] f:CGRectMake(12, 10, ScreenWidth - 24, 44) tag:1];
    btn.layer.borderColor = SobotColorFromRGB(0xEDEEF0).CGColor;
    btn.layer.borderWidth = 0.5f;
    btn.layer.cornerRadius = 22.0f;
    btn.layer.masksToBounds = YES;
    [footView addSubview:btn];
    
    code = _sectionData[@"code"];
    _codeUrls = [[ZCGuideData getZCGuideData] getCodeStype:code];
}


-(void)openURLString:(NSString *)url{
    ApiWebController *web = [[ApiWebController alloc] initWithURL:url];
    UINavigationController * navc = [[UINavigationController alloc]initWithRootViewController:web];
    navc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:navc animated:YES completion:^{
        
    }];
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
    
}
#pragma mark UITableView delegate Start
// 返回section数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
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
    [lbl setTextColor:SobotColorFromRGB(0x333333)];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    // 没有更多记录的颜色
    [lbl setAutoresizesSubviews:YES];
    [lbl setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [lbl setText:@"参考文档"];
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
    return 1;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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

// table 行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

// table 行的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
