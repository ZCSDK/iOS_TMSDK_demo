//
//  ZCGuideData.m
//  SobotKitFrameworkTest
//
//  Created by zhangxy on 2020/7/16.
//  Copyright © 2020 zhichi. All rights reserved.
//

#import "ZCGuideData.h"
#import <UIKit/UIKit.h>
#import <sys/utsname.h>

#import "AppDelegate.h"

#define UIColorFromRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

@interface ZCGuideData(){
}

@property(nonatomic,strong)NSMutableArray *sectionItems;


@property(nonatomic,strong)NSMutableDictionary *configItems;


@property(nonatomic,strong)NSMutableDictionary *codeItems;

@property(nonatomic,assign)BOOL curConfigTM;


@end

@implementation ZCGuideData


+(ZCGuideData *)getZCGuideData{
    static ZCGuideData *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(_instance == nil){
            _instance = [[ZCGuideData alloc] initPrivate];
            
        }
    });
    return _instance;
}


-(id)initPrivate{
    self=[super init];
    if(self){
        _callCacheEntity = [[SobotCallCacheEntity alloc] init];
        _apiParamter = [[SobotCallApiParameter alloc] init];
        [self setDefaultValue];
        [self configSettingData];
    }
    return self;
}

-(id)init{
    return [[self class] getZCGuideData];
}


-(void)setDefaultValue{
    [SobotCallLibClient showDebug:YES];
    
    // 香港环境
//    _callApiHost = @"https://hk.sobot.com";//@"sip:192.168.1.111:5060";
//    _openApiHost = @"https://hk.sobot.com";
//    _stompSocketUri = @"wss://hk.sobot.com/v6.0.0/webmsg/cc-webmsg";
//    _janusSocketUri = @"wss://rtc.hk.sobot.cc";//@"sip:192.168.1.111:5060";
//    _sipProxy = @"sip:192.168.30.68:5060";
    
//    _ext = @"xxx";
    
}

-(NSArray *)getSectionArray{
    return @[@"初始化",@"登录操作",@"呼叫操作",@"辅助操作"];
}
-(NSArray *)getSectionListArray:(NSInteger )section{
    if(_sectionItems.count < section){
           return @[];
       }
    return _sectionItems[section];
}

-(NSArray *)getConfigItems:(NSString *) code{
    return _configItems[code];
}

-(NSArray *) getCodeStype:(NSString *)code{
    return _codeItems[code];
}


-(void)showAlertTips:(NSString *)message vc:(UIViewController *) pvc{
    [self showAlertTips:message vc:pvc blcok:nil];
}

-(void)showAlertTips:(NSString *)message vc:(UIViewController *)pvc blcok:(nonnull void (^)(int))alerClick{
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIView *subView1 = vc.view.subviews[0];
        UIView *subView2 = subView1.subviews[0];
        UIView *subView3 = subView2.subviews[0];
        UIView *subView4 = subView3.subviews[0];
        UIView *subView5 = subView4.subviews[0];
        UILabel *messageLab = subView5.subviews[1];
//    UILabel *titleLab = subView5.subviews[0];
//    titleLab.textAlignment = NSTextAlignmentCenter;
    if ([messageLab isKindOfClass:[UILabel class]]) {
        messageLab.textAlignment = NSTextAlignmentLeft;
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好的" style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if(alerClick){
            alerClick(-1);
        }
    }];
    [vc addAction:cancelAction];

    vc.popoverPresentationController.sourceView = pvc.view;
    vc.popoverPresentationController.sourceRect = CGRectMake(0,0,1.0,1.0);
    [pvc presentViewController:vc animated:YES completion:nil];
}

-(void)configSettingData{
    BOOL isShowTM = ((AppDelegate *)[UIApplication sharedApplication].delegate).loginWithTM;

    
    if(isShowTM){
//        if(self.curConfigTM){
//            return;
//        }
        self.curConfigTM = YES;
        [self configSettingDataTM];
    }else{
//        if(!self.curConfigTM){
//            return;
//        }
        
        self.curConfigTM = NO;
        [self configSettingDataCall];
    }
}
-(void)configSettingDataCall{
    BOOL isShowTM = ((AppDelegate *)[UIApplication sharedApplication].delegate).loginWithTM;

    _sectionItems = [[NSMutableArray alloc] init];
    [_sectionItems addObject:@[
        @{@"index":@(ZCSectionIndex31),@"code":@"3.1",@"name":@"初始化 ",@"desc":@"执行初始化操作",@"extends":@""}
//            ,
//            @{@"index":@(ZCSectionIndex353),@"code":@"3.5.3",@"name":@"读取日志",@"desc":@"本地日志查询",@"extends":@"action"}
    ]];
    
    if (isShowTM) {
        [_sectionItems addObject:@[
                   @{@"index":@(ZCSectionIndex41),@"code":@"4.1",@"name":@"登录",@"desc":@"执行获取/保存token操作",@"extends":@""},
                   @{@"index":@(ZCSectionIndex42),@"code":@"4.2",@"name":@"签入",@"desc":@"签入",@"extends":@""},
                   @{@"index":@(ZCSectionIndex43),@"code":@"4.3",@"name":@"签出",@"desc":@"",@"extends":@"action"},
                   @{@"index":@(ZCSectionIndex44),@"code":@"4.4",@"name":@"置忙",@"desc":@"",@"extends":@""},
                   @{@"index":@(ZCSectionIndex45),@"code":@"4.5",@"name":@"置闲",@"desc":@"",@"extends":@"action"},
                   @{@"index":@(ZCSectionIndex46),@"code":@"4.6",@"name":@"查询座席可用的接听方式",@"desc":@"",@"extends":@"action"},
                   @{@"index":@(ZCSectionIndex47),@"code":@"4.7",@"name":@"查座席可用的分机号",@"desc":@"",@"extends":@"action"},
                   @{@"index":@(ZCSectionIndex48),@"code":@"4.8",@"name":@"查询座席可用的置忙原因",@"desc":@"",@"extends":@"action"},
                   @{@"index":@(ZCSectionIndex482),@"code":@"4.10",@"name":@"重置离线(退出登录)",@"desc":@"",@"extends":@"action"},
                   @{@"index":@(ZCSectionIndex483),@"code":@"4.11",@"name":@"查询座席状态列表",@"desc":@"",@"extends":@"action"},
                   @{@"index":@(ZCSectionIndex484),@"code":@"4.12",@"name":@"查询座席的签入信息",@"desc":@"",@"extends":@"action"},
               ]];
    }else{
        [_sectionItems addObject:@[
                   @{@"index":@(ZCSectionIndex41),@"code":@"4.1",@"name":@"登录",@"desc":@"执行获取/保存token操作",@"extends":@""},
                   @{@"index":@(ZCSectionIndex42),@"code":@"4.2",@"name":@"签入",@"desc":@"签入",@"extends":@""},
                   @{@"index":@(ZCSectionIndex43),@"code":@"4.3",@"name":@"签出",@"desc":@"",@"extends":@"action"},
                   @{@"index":@(ZCSectionIndex44),@"code":@"4.4",@"name":@"置忙",@"desc":@"",@"extends":@""},
                   @{@"index":@(ZCSectionIndex45),@"code":@"4.5",@"name":@"置闲",@"desc":@"",@"extends":@"action"},
                   @{@"index":@(ZCSectionIndex46),@"code":@"4.6",@"name":@"查询座席可用的接听方式",@"desc":@"",@"extends":@"action"},
                   @{@"index":@(ZCSectionIndex47),@"code":@"4.7",@"name":@"查座席可用的分机号",@"desc":@"",@"extends":@"action"},
                   @{@"index":@(ZCSectionIndex48),@"code":@"4.8",@"name":@"查询座席可用的置忙原因",@"desc":@"",@"extends":@"action"},
                   @{@"index":@(ZCSectionIndex481),@"code":@"4.9",@"name":@"查询座席可签入的技能组",@"desc":@"",@"extends":@"action"},
                   @{@"index":@(ZCSectionIndex482),@"code":@"4.10",@"name":@"重置离线(退出登录)",@"desc":@"",@"extends":@"action"},
                   @{@"index":@(ZCSectionIndex483),@"code":@"4.11",@"name":@"查询座席状态列表",@"desc":@"",@"extends":@"action"},
                   @{@"index":@(ZCSectionIndex484),@"code":@"4.12",@"name":@"查询座席的签入信息",@"desc":@"",@"extends":@"action"},
               ]];
    }

    if (isShowTM) {
        [_sectionItems addObject:@[
                   @{@"index":@(ZCSectionIndex51),@"code":@"5.1",@"name":@"外呼",@"desc":@"",@"extends":@""},
                   @{@"index":@(ZCSectionIndex52),@"code":@"5.2",@"name":@"接听",@"desc":@"",@"extends":@"action"},
                   @{@"index":@(ZCSectionIndex53),@"code":@"5.3",@"name":@"挂机",@"desc":@"",@"extends":@"action"},
                   @{@"index":@(ZCSectionIndex54),@"code":@"5.4",@"name":@"保持",@"desc":@"",@"extends":@"action"},
                   @{@"index":@(ZCSectionIndex55),@"code":@"5.5",@"name":@"保持取消",@"desc":@"",@"extends":@"action"},
                   @{@"index":@(ZCSectionIndex56),@"code":@"5.6",@"name":@"静音",@"desc":@"",@"extends":@"action"},
                   @{@"index":@(ZCSectionIndex57),@"code":@"5.7",@"name":@"静音取消",@"desc":@"",@"extends":@"action"},
                   @{@"index":@(ZCSectionIndex58),@"code":@"5.8",@"name":@"查询播放类型",@"desc":@"",@"extends":@"action"},
                   @{@"index":@(ZCSectionIndex59),@"code":@"5.9",@"name":@"切换播放类型",@"desc":@"",@"extends":@"action"},
                   @{@"index":@(ZCSectionIndex511),@"code":@"5.11",@"name":@"延长整理时长",@"desc":@"",@"extends":@""},
                   @{@"index":@(ZCSectionIndex512),@"code":@"5.12",@"name":@"结束整理",@"desc":@"",@"extends":@"action"},
                   @{@"index":@(ZCSectionIndex513),@"code":@"5.13",@"name":@"发送按键",@"desc":@"",@"extends":@""},
                   @{@"index":@(ZCSectionIndex514),@"code":@"5.14",@"name":@"结束整理并置忙",@"desc":@"",@"extends":@"action"}
               ]];
    }else{
        [_sectionItems addObject:@[
                   @{@"index":@(ZCSectionIndex51),@"code":@"5.1",@"name":@"外呼",@"desc":@"",@"extends":@""},
                   @{@"index":@(ZCSectionIndex52),@"code":@"5.2",@"name":@"接听",@"desc":@"",@"extends":@"action"},
                   @{@"index":@(ZCSectionIndex53),@"code":@"5.3",@"name":@"挂机",@"desc":@"",@"extends":@"action"},
                   @{@"index":@(ZCSectionIndex54),@"code":@"5.4",@"name":@"保持",@"desc":@"",@"extends":@"action"},
                   @{@"index":@(ZCSectionIndex55),@"code":@"5.5",@"name":@"保持取消",@"desc":@"",@"extends":@"action"},
                   @{@"index":@(ZCSectionIndex56),@"code":@"5.6",@"name":@"静音",@"desc":@"",@"extends":@"action"},
                   @{@"index":@(ZCSectionIndex57),@"code":@"5.7",@"name":@"静音取消",@"desc":@"",@"extends":@"action"},
                   @{@"index":@(ZCSectionIndex58),@"code":@"5.8",@"name":@"查询播放类型",@"desc":@"",@"extends":@"action"},
                   @{@"index":@(ZCSectionIndex59),@"code":@"5.9",@"name":@"切换播放类型",@"desc":@"",@"extends":@"action"},
                   @{@"index":@(ZCSectionIndex510),@"code":@"5.10",@"name":@"发送满意度",@"desc":@"",@"extends":@""},
                   @{@"index":@(ZCSectionIndex511),@"code":@"5.11",@"name":@"延长整理时长",@"desc":@"",@"extends":@""},
                   @{@"index":@(ZCSectionIndex512),@"code":@"5.12",@"name":@"结束整理",@"desc":@"",@"extends":@"action"},
                   @{@"index":@(ZCSectionIndex513),@"code":@"5.13",@"name":@"发送按键",@"desc":@"",@"extends":@""},
                   @{@"index":@(ZCSectionIndex514),@"code":@"5.14",@"name":@"结束整理并置忙",@"desc":@"",@"extends":@"action"}
               ]];
    }
    
    
    
    [_sectionItems addObject:@[
               @{@"index":@(ZCSectionIndex61),@"code":@"6.1",@"name":@"查询座席的外呼路由规则",@"desc":@"",@"extends":@"action"},
               @{@"index":@(ZCSectionIndex62),@"code":@"6.2",@"name":@"修改座席的外呼路由规则",@"desc":@"",@"extends":@""}
           ]];
    
    
    _configItems = [[NSMutableDictionary alloc] init];
    [_configItems setObject:@[
        @{@"index":@(ZCConfigIndex311),@"code":@"3.1.1",@"name":@"设置服务域名",@"desc":@"请输入开放接口域名,不填默认https://api.sobot.com",@"extends":@"",@"key":@"openApiHost",@"type":@"NSString",@"from":@(ZCConfigFromSobotCallCacheEntity)},
        @{@"index":@(ZCConfigIndex311),@"code":@"3.1.2",@"name":@"设置服务域名",@"desc":@"请输入域名,不填默认https://openapi.soboten.com",@"extends":@"",@"key":@"callApiHost",@"type":@"NSString",@"from":@(ZCConfigFromSobotCallCacheEntity)},
        @{@"index":@(ZCConfigIndex311),@"code":@"3.1.3",@"name":@"监听janus的uri",@"desc":@"监听janus的sip消息uri",@"extends":@"",@"key":@"janusSocketUri",@"type":@"NSString",@"from":@(ZCConfigFromSobotCallCacheEntity)},
        @{@"index":@(ZCConfigIndex311),@"code":@"3.1.4",@"name":@"janus代理服务url",@"desc":@"默认  sip:192.168.30.68:5060",@"extends":@"",@"key":@"sipProxy",@"type":@"NSString",@"from":@(ZCConfigFromSobotCallCacheEntity)},
        @{@"index":@(ZCConfigIndex311),@"code":@"3.1.5",@"name":@"监听呼叫消息uri",@"desc":@"请输入监听呼叫消息uri,不填默认wss://testopenapi.sobot.com/v6.0.0/webmsg/cc-webmsg",@"extends":@"",@"key":@"stompSocketUri",@"type":@"NSString",@"from":@(ZCConfigFromSobotCallCacheEntity)}
    ] forKey:@"3.1"];
    
    
    [_configItems setObject:@[
        @{@"index":@(ZCConfigIndex411),@"code":@"4.1.1",@"name":@"登录账户",@"desc":@"登录账户(email)",@"extends":@"",@"key":@"loginAccount",@"type":@"NSString",@"from":@(ZCConfigFromGuideData)},
        @{@"index":@(ZCConfigIndex411),@"code":@"4.1.2",@"name":@"登录密码",@"desc":@"如果使用token登录无需提供此参数",@"extends":@"",@"key":@"loginPassword",@"type":@"NSString",@"from":@(ZCConfigFromGuideData)},
        @{@"index":@(ZCConfigIndex411),@"code":@"4.1.3",@"name":@"登录",@"desc":@"使用token方式登录(无需密码，但是需要loginAcount验证token对应用户)",@"extends":@"",@"key":@"token",@"type":@"NSString",@"from":@(ZCConfigFromGuideData)}
    ] forKey:@"4.1"];
    
    // 签入
    if (isShowTM) {
        [_configItems setObject:@[
            @{@"index":@(ZCConfigIndex411),@"code":@"4.2.1",@"name":@"分机号",@"desc":@"签入分机号",@"extends":@"",@"key":@"ext",@"type":@"NSString",@"from":@(ZCConfigFromApiParameter)},
            @{@"index":@(ZCConfigIndex411),@"code":@"4.2.2",@"name":@"签入状态",@"desc":@"签入状态",@"extends":@"",@"key":@"agentStatus",@"type":@"NSString",@"from":@(ZCConfigFromApiParameter)},
            @{@"index":@(ZCConfigIndex411),@"code":@"4.2.3",@"name":@"签入方式",@"desc":@"输入2 代表SIP  输入3代表手机",@"extends":@"",@"key":@"callWay",@"type":@"NSString",@"from":@(ZCConfigFromApiParameter)},
            @{@"index":@(ZCConfigIndex411),@"code":@"4.2.4",@"name":@"绑定手机号",@"desc":@"手机模式时需要，绑定手机号",@"extends":@"",@"key":@"bindMobile",@"type":@"NSString",@"from":@(ZCConfigFromApiParameter)}
        ] forKey:@"4.2"];
    }else{
        [_configItems setObject:@[
            @{@"index":@(ZCConfigIndex411),@"code":@"4.2.1",@"name":@"分机号",@"desc":@"签入分机号",@"extends":@"",@"key":@"ext",@"type":@"NSString",@"from":@(ZCConfigFromApiParameter)},
            @{@"index":@(ZCConfigIndex411),@"code":@"4.2.2",@"name":@"签入状态",@"desc":@"签入状态",@"extends":@"",@"key":@"agentStatus",@"type":@"NSString",@"from":@(ZCConfigFromApiParameter)},
            @{@"index":@(ZCConfigIndex411),@"code":@"4.2.3",@"name":@"签入方式",@"desc":@"输入2 代表SIP  输入3代表手机",@"extends":@"",@"key":@"callWay",@"type":@"NSString",@"from":@(ZCConfigFromApiParameter)},
            @{@"index":@(ZCConfigIndex411),@"code":@"4.2.4",@"name":@"绑定手机号",@"desc":@"手机模式时需要，绑定手机号",@"extends":@"",@"key":@"bindMobile",@"type":@"NSString",@"from":@(ZCConfigFromApiParameter)},
            @{@"index":@(ZCConfigIndex411),@"code":@"4.2.5",@"name":@"节能组",@"desc":@"技能组，多个用逗号隔开",@"extends":@"",@"key":@"thisQueues",@"type":@"MNSString",@"from":@(ZCConfigFromApiParameter)}
        ] forKey:@"4.2"];
    }
    
    
    // 签出
    [_configItems setObject:@[
        @{@"index":@(ZCConfigIndex411),@"code":@"4.4.1",@"name":@"置忙原因",@"desc":@"当前登录座席ID",@"extends":@"",@"key":@"reasonCode",@"type":@"NSString",@"from":@(ZCConfigFromApiParameter)}
    ] forKey:@"4.4"];
    
    
    
    [_configItems setObject:@[
        @{@"index":@(ZCConfigIndex511),@"code":@"5.1.1",@"name":@"外呼号码",@"desc":@"外呼的号码",@"extends":@"",@"key":@"otherDN",@"type":@"NSString",@"from":@(ZCConfigFromApiParameter)},
        @{@"index":@(ZCConfigIndex511),@"code":@"5.1.2",@"name":@"加密后号码",@"desc":@"外呼加密号码",@"extends":@"",@"key":@"privacyNumber",@"type":@"NSString",@"from":@(ZCConfigFromApiParameter)},
        @{@"index":@(ZCConfigIndex511),@"code":@"5.1.3",@"name":@"外呼号码",@"desc":@"外呼企业id，可不传，不传时默认使用登录时的企业ID",@"extends":@"",@"key":@"companyId",@"type":@"NSString",@"from":@(ZCConfigFromApiParameter)},
        @{@"index":@(ZCConfigIndex511),@"code":@"5.1.4",@"name":@"指定客户侧的外显号码",@"desc":@"指定外显号码呼叫客户；指定外显号码和外呼路由编码不能全部为空",@"extends":@"",@"key":@"ani",@"type":@"NSString",@"from":@(ZCConfigFromApiParameter)},
        @{@"index":@(ZCConfigIndex511),@"code":@"5.1.5",@"name":@"自定义数据",@"desc":@"自定义数据，字典",@"extends":@"",@"key":@"userData",@"type":@"MNSString",@"from":@(ZCConfigFromApiParameter)},
        @{@"index":@(ZCConfigIndex511),@"code":@"5.1.6",@"name":@"指定客户侧的外显号码方案编码",@"desc":@"指定客户侧的外显号码方案编码",@"extends":@"",@"key":@"outboundPlanCode",@"type":@"NSString",@"from":@(ZCConfigFromApiParameter)}
    ] forKey:@"5.1"];
    
    if (!isShowTM) {
        [_configItems setObject:@[
            @{@"index":@(ZCConfigIndex511),@"code":@"5.1.10",@"name":@"发送满意度",@"desc":@"1-表示手动发送满意度；0或者不传值-自动发送满意度(如果系统设置自动发送满意度)  当需要手动发送满意度时需要设置值",@"extends":@"",@"key":@"autoSatisfy",@"type":@"NSString",@"from":@(ZCConfigFromApiParameter)}
        ] forKey:@"5.10"];
    }
       
    [_configItems setObject:@[
        @{@"index":@(ZCConfigIndex511),@"code":@"5.1.11",@"name":@"时长",@"desc":@"延长时间 (30-900秒)",@"extends":@"",@"key":@"delayTime",@"type":@"NSString",@"from":@(ZCConfigFromApiParameter)}
    ] forKey:@"5.11"];
    
    [_configItems setObject:@[
        @{@"index":@(ZCConfigIndex511),@"code":@"5.1.13",@"name":@"发送内容",@"desc":@"按键对应值(一次请求发送一个按键值，如，801#，则依次发送8、0、1、#这些按键请求,该参数不可为空)",@"extends":@"",@"key":@"dtmfDigits",@"type":@"NSString",@"from":@(ZCConfigFromApiParameter)}
    ] forKey:@"5.13"];
    
    
    [_configItems setObject:@[
        @{@"index":@(ZCConfigIndex611),@"code":@"6.1.2",@"name":@"外显规则",@"desc":@"(1：企业号码池随机匹配；2：动态外显号码方案匹配；3：座席号码池指定；单选；)",@"extends":@"",@"key":@"explicitRule",@"type":@"NSString",@"from":@(ZCConfigFromApiParameter)},
        @{@"index":@(ZCConfigIndex611),@"code":@"6.1.2",@"name":@"动态外显方案编码",@"desc":@"外显规则为动态外显号码方案时必传",@"extends":@"",@"key":@"explicitCode",@"type":@"NSString",@"from":@(ZCConfigFromApiParameter)},
        @{@"index":@(ZCConfigIndex611),@"code":@"6.1.2",@"name":@"外显号码",@"desc":@"不使用外显规则，直接指定企业的某外显号码呼叫客户，外显号码和外显规则至少需要传一个",@"extends":@"",@"key":@"explicitNumber",@"type":@"NSString",@"from":@(ZCConfigFromApiParameter)}
    ] forKey:@"6.2"];
    
    
    _codeItems = [[NSMutableDictionary alloc] init];
    [_codeItems setObject:@[
        @"https://codecenter.sobot.com/pages/050de4/#%E2%97%8F-%E5%9F%9F%E5%90%8D%E8%AE%BE%E7%BD%AE",
        @"https://codecenter.sobot.com/pages/050de4/#%E2%97%8F-%E5%88%9D%E5%A7%8B%E5%8C%96"]
      forKey:@"3.1"];
    
    [_codeItems setObject:@[
        @"https://codecenter.sobot.com/pages/050de4/#%E2%97%8F-%E7%99%BB%E5%BD%95",
    @"https://codecenter.sobot.com/pages/050de4/#%E2%97%8F-%E9%80%80%E5%87%BA%E7%99%BB%E5%BD%95"]
      forKey:@"4.1"];
    
    [_codeItems setObject:@[
    @"https://www.sobot.com/developerdocs/app_sdk/ios.html#_4-2-8-商品卡片"]
      forKey:@"4.2"];
    
    [_codeItems setObject:@[
        @"https://www.sobot.com/developerdocs/app_sdk/ios.html#_4-3-留言工单相关"]
      forKey:@"4.3"];
    
    
    [_codeItems setObject:@[
        @"https://www.sobot.com/developerdocs/app_sdk/ios.html#_4-4-评价"]
      forKey:@"4.4"];
    
    
    [_codeItems setObject:@[
        @"https://www.sobot.com/developerdocs/app_sdk/ios.html#_4-5-1-消息推送",
        @"https://www.sobot.com/developerdocs/app_sdk/ios.html#_4-5-5-链接拦截"]
      forKey:@"4.5"];
    
    
    [_codeItems setObject:@[
      @"https://codecenter.sobot.com/pages/050de4/#%E2%97%8F-%E9%80%80%E5%87%BA%E7%99%BB%E5%BD%95"]
    forKey:@"4.6"];
    [_codeItems setObject:@[
        @"https://www.sobot.com/developerdocs/app_sdk/ios.html#_4-7-2-自定义聊天记录显示时间范围"]
      forKey:@"4.7"];
      [_codeItems setObject:@[
          @"https://www.sobot.com/developerdocs/app_sdk/ios.html#_5-1-zckitinfo类说明（ui相关配置）"]
        forKey:@"5.1"];
    [_codeItems setObject:@[
            @"https://www.sobot.com/developerdocs/app_sdk/ios.html#_5-2-zclibinitinfo类说明"]
          forKey:@"5.2"];
}

#pragma mark --- 电销版本
-(void)configSettingDataTM{
    _sectionItems = [[NSMutableArray alloc] init];
    [_sectionItems addObject:@[
        @{@"index":@(ZCSectionIndex31),@"code":@"3.1",@"name":@"初始化 ",@"desc":@"执行初始化操作",@"extends":@""}
//            ,
//            @{@"index":@(ZCSectionIndex353),@"code":@"3.5.3",@"name":@"读取日志",@"desc":@"本地日志查询",@"extends":@"action"}
    ]];
    
    [_sectionItems addObject:@[
               @{@"index":@(ZCSectionIndex41),@"code":@"4.1",@"name":@"登录",@"desc":@"执行获取/保存token操作",@"extends":@""},
               @{@"index":@(ZCSectionIndex42),@"code":@"4.2",@"name":@"签入",@"desc":@"签入",@"extends":@""},
               @{@"index":@(ZCSectionIndex43),@"code":@"4.3",@"name":@"签出",@"desc":@"",@"extends":@"action"},
               @{@"index":@(ZCSectionIndex44),@"code":@"4.4",@"name":@"置忙",@"desc":@"",@"extends":@""},
               @{@"index":@(ZCSectionIndex45),@"code":@"4.5",@"name":@"置闲",@"desc":@"",@"extends":@"action"},
               @{@"index":@(ZCSectionIndex46),@"code":@"4.6",@"name":@"查询座席可用的接听方式",@"desc":@"",@"extends":@"action"},
               @{@"index":@(ZCSectionIndex47),@"code":@"4.7",@"name":@"查座席可用的分机号",@"desc":@"",@"extends":@"action"},
               @{@"index":@(ZCSectionIndex48),@"code":@"4.8",@"name":@"查询座席可用的置忙原因",@"desc":@"",@"extends":@"action"},
               @{@"index":@(ZCSectionIndex482),@"code":@"4.10",@"name":@"重置离线(退出登录)",@"desc":@"",@"extends":@"action"},
               @{@"index":@(ZCSectionIndex483),@"code":@"4.11",@"name":@"查询座席状态列表",@"desc":@"",@"extends":@"action"},
               @{@"index":@(ZCSectionIndex484),@"code":@"4.12",@"name":@"查询座席的签入信息",@"desc":@"",@"extends":@"action"},
//               @{@"index":@(ZCSectionIndex485),@"code":@"4.13",@"name":@"退出登录",@"desc":@"",@"extends":@""},
           ]];
    
    
    [_sectionItems addObject:@[
               @{@"index":@(ZCSectionIndex51),@"code":@"5.1",@"name":@"外呼",@"desc":@"",@"extends":@""},
               @{@"index":@(ZCSectionIndex52),@"code":@"5.2",@"name":@"接听",@"desc":@"",@"extends":@"action"},
               @{@"index":@(ZCSectionIndex53),@"code":@"5.3",@"name":@"挂机",@"desc":@"",@"extends":@"action"},
               @{@"index":@(ZCSectionIndex54),@"code":@"5.4",@"name":@"保持",@"desc":@"",@"extends":@"action"},
               @{@"index":@(ZCSectionIndex55),@"code":@"5.5",@"name":@"保持取消",@"desc":@"",@"extends":@"action"},
               @{@"index":@(ZCSectionIndex56),@"code":@"5.6",@"name":@"静音",@"desc":@"",@"extends":@"action"},
               @{@"index":@(ZCSectionIndex57),@"code":@"5.7",@"name":@"静音取消",@"desc":@"",@"extends":@"action"},
               @{@"index":@(ZCSectionIndex58),@"code":@"5.8",@"name":@"查询播放类型",@"desc":@"",@"extends":@"action"},
               @{@"index":@(ZCSectionIndex59),@"code":@"5.9",@"name":@"切换播放类型",@"desc":@"",@"extends":@"action"},
               @{@"index":@(ZCSectionIndex511),@"code":@"5.11",@"name":@"延长整理时长",@"desc":@"",@"extends":@""},
               @{@"index":@(ZCSectionIndex512),@"code":@"5.12",@"name":@"结束整理",@"desc":@"",@"extends":@"action"},
               @{@"index":@(ZCSectionIndex513),@"code":@"5.13",@"name":@"发送按键",@"desc":@"",@"extends":@""},
               @{@"index":@(ZCSectionIndex514),@"code":@"5.14",@"name":@"结束整理并置忙",@"desc":@"",@"extends":@"action"}
           ]];
    
    
    
    [_sectionItems addObject:@[
               @{@"index":@(ZCSectionIndex61),@"code":@"6.1",@"name":@"查询座席的外呼路由规则",@"desc":@"",@"extends":@"action"},
               @{@"index":@(ZCSectionIndex62),@"code":@"6.2",@"name":@"修改座席的外呼路由规则",@"desc":@"",@"extends":@""}
           ]];
    
    
    _configItems = [[NSMutableDictionary alloc] init];
    [_configItems setObject:@[
        @{@"index":@(ZCConfigIndex311),@"code":@"3.1.1",@"name":@"设置服务域名",@"desc":@"请输入开放接口域名,不填默认https://api.sobot.com",@"extends":@"",@"key":@"openApiHost",@"type":@"NSString",@"from":@(ZCConfigFromSobotCallCacheEntity)},
        @{@"index":@(ZCConfigIndex311),@"code":@"3.1.2",@"name":@"设置服务域名",@"desc":@"请输入域名,不填默认https://openapi.soboten.com",@"extends":@"",@"key":@"callApiHost",@"type":@"NSString",@"from":@(ZCConfigFromSobotCallCacheEntity)},
        @{@"index":@(ZCConfigIndex311),@"code":@"3.1.3",@"name":@"监听janus的uri",@"desc":@"监听janus的sip消息uri",@"extends":@"",@"key":@"janusSocketUri",@"type":@"NSString",@"from":@(ZCConfigFromSobotCallCacheEntity)},
        @{@"index":@(ZCConfigIndex311),@"code":@"3.1.4",@"name":@"janus代理服务url",@"desc":@"默认  sip:192.168.30.68:5060",@"extends":@"",@"key":@"sipProxy",@"type":@"NSString",@"from":@(ZCConfigFromSobotCallCacheEntity)},
        @{@"index":@(ZCConfigIndex311),@"code":@"3.1.5",@"name":@"监听呼叫消息uri",@"desc":@"请输入监听呼叫消息uri,不填默认wss://testopenapi.sobot.com/v6.0.0/webmsg/cc-webmsg",@"extends":@"",@"key":@"stompSocketUri",@"type":@"NSString",@"from":@(ZCConfigFromSobotCallCacheEntity)}
    ] forKey:@"3.1"];
    
    
    [_configItems setObject:@[
        @{@"index":@(ZCConfigIndex411),@"code":@"4.1.1",@"name":@"登录账户",@"desc":@"登录账户(email)",@"extends":@"",@"key":@"loginAccount",@"type":@"NSString",@"from":@(ZCConfigFromGuideData)},
        @{@"index":@(ZCConfigIndex411),@"code":@"4.1.2",@"name":@"登录密码",@"desc":@"如果使用token登录无需提供此参数",@"extends":@"",@"key":@"loginPassword",@"type":@"NSString",@"from":@(ZCConfigFromGuideData)},
        @{@"index":@(ZCConfigIndex411),@"code":@"4.1.3",@"name":@"登录",@"desc":@"使用token方式登录(无需密码，但是需要loginAcount验证token对应用户)",@"extends":@"",@"key":@"token",@"type":@"NSString",@"from":@(ZCConfigFromGuideData)}
    ] forKey:@"4.1"];
    
    // 签入
    [_configItems setObject:@[
        @{@"index":@(ZCConfigIndex411),@"code":@"4.2.1",@"name":@"分机号",@"desc":@"签入分机号",@"extends":@"",@"key":@"ext",@"type":@"NSString",@"from":@(ZCConfigFromApiParameter)},
        @{@"index":@(ZCConfigIndex411),@"code":@"4.2.2",@"name":@"签入状态",@"desc":@"签入状态",@"extends":@"",@"key":@"agentStatus",@"type":@"NSString",@"from":@(ZCConfigFromApiParameter)},
        @{@"index":@(ZCConfigIndex411),@"code":@"4.2.3",@"name":@"签入方式",@"desc":@"输入2 代表SIP  输入3代表手机",@"extends":@"",@"key":@"callWay",@"type":@"NSString",@"from":@(ZCConfigFromApiParameter)},
        @{@"index":@(ZCConfigIndex411),@"code":@"4.2.4",@"name":@"绑定手机号",@"desc":@"手机模式时需要，绑定手机号",@"extends":@"",@"key":@"bindMobile",@"type":@"NSString",@"from":@(ZCConfigFromApiParameter)}
    ] forKey:@"4.2"];
    
    // 签出
    [_configItems setObject:@[
        @{@"index":@(ZCConfigIndex411),@"code":@"4.4.1",@"name":@"置忙原因",@"desc":@"当前登录座席ID",@"extends":@"",@"key":@"reasonCode",@"type":@"NSString",@"from":@(ZCConfigFromApiParameter)}
    ] forKey:@"4.4"];
    
    
    
    [_configItems setObject:@[
        @{@"index":@(ZCConfigIndex511),@"code":@"5.1.1",@"name":@"外呼号码",@"desc":@"外呼的号码",@"extends":@"",@"key":@"otherDN",@"type":@"NSString",@"from":@(ZCConfigFromApiParameter)},
        @{@"index":@(ZCConfigIndex511),@"code":@"5.1.2",@"name":@"加密后号码",@"desc":@"外呼加密号码",@"extends":@"",@"key":@"privacyNumber",@"type":@"NSString",@"from":@(ZCConfigFromApiParameter)},
        @{@"index":@(ZCConfigIndex511),@"code":@"5.1.3",@"name":@"外呼号码",@"desc":@"外呼企业id，可不传，不传时默认使用登录时的企业ID",@"extends":@"",@"key":@"companyId",@"type":@"NSString",@"from":@(ZCConfigFromApiParameter)},
        @{@"index":@(ZCConfigIndex511),@"code":@"5.1.4",@"name":@"指定客户侧的外显号码",@"desc":@"指定外显号码呼叫客户；指定外显号码和外呼路由编码不能全部为空",@"extends":@"",@"key":@"ani",@"type":@"NSString",@"from":@(ZCConfigFromApiParameter)},
        @{@"index":@(ZCConfigIndex511),@"code":@"5.1.5",@"name":@"自定义数据",@"desc":@"自定义数据，字典",@"extends":@"",@"key":@"userData",@"type":@"MNSString",@"from":@(ZCConfigFromApiParameter)},
        @{@"index":@(ZCConfigIndex511),@"code":@"5.1.6",@"name":@"指定客户侧的外显号码方案编码",@"desc":@"指定客户侧的外显号码方案编码",@"extends":@"",@"key":@"outboundPlanCode",@"type":@"NSString",@"from":@(ZCConfigFromApiParameter)}
    ] forKey:@"5.1"];
    
    [_configItems setObject:@[
        @{@"index":@(ZCConfigIndex511),@"code":@"5.1.11",@"name":@"时长",@"desc":@"延长时间 (30-900秒)",@"extends":@"",@"key":@"delayTime",@"type":@"NSString",@"from":@(ZCConfigFromApiParameter)}
    ] forKey:@"5.11"];
    
    [_configItems setObject:@[
        @{@"index":@(ZCConfigIndex511),@"code":@"5.1.13",@"name":@"发送内容",@"desc":@"按键对应值(一次请求发送一个按键值，如，801#，则依次发送8、0、1、#这些按键请求,该参数不可为空)",@"extends":@"",@"key":@"dtmfDigits",@"type":@"NSString",@"from":@(ZCConfigFromApiParameter)}
    ] forKey:@"5.13"];
    
    
    [_configItems setObject:@[
        @{@"index":@(ZCConfigIndex611),@"code":@"6.1.2",@"name":@"外显规则",@"desc":@"(1：企业号码池随机匹配；2：动态外显号码方案匹配；3：座席号码池指定；单选；)",@"extends":@"",@"key":@"explicitRule",@"type":@"NSString",@"from":@(ZCConfigFromApiParameter)},
        @{@"index":@(ZCConfigIndex611),@"code":@"6.1.2",@"name":@"动态外显方案编码",@"desc":@"外显规则为动态外显号码方案时必传",@"extends":@"",@"key":@"explicitCode",@"type":@"NSString",@"from":@(ZCConfigFromApiParameter)},
        @{@"index":@(ZCConfigIndex611),@"code":@"6.1.2",@"name":@"外显号码",@"desc":@"不使用外显规则，直接指定企业的某外显号码呼叫客户，外显号码和外显规则至少需要传一个",@"extends":@"",@"key":@"explicitNumber",@"type":@"NSString",@"from":@(ZCConfigFromApiParameter)}
    ] forKey:@"6.2"];
    
    
    _codeItems = [[NSMutableDictionary alloc] init];
    [_codeItems setObject:@[
        @"https://codecenter.sobot.com/pages/050de4/#%E2%97%8F-%E5%9F%9F%E5%90%8D%E8%AE%BE%E7%BD%AE",
        @"https://codecenter.sobot.com/pages/050de4/#%E2%97%8F-%E5%88%9D%E5%A7%8B%E5%8C%96"]
      forKey:@"3.1"];
    
    [_codeItems setObject:@[
        @"https://codecenter.sobot.com/pages/050de4/#%E2%97%8F-%E7%99%BB%E5%BD%95",
    @"https://codecenter.sobot.com/pages/050de4/#%E2%97%8F-%E9%80%80%E5%87%BA%E7%99%BB%E5%BD%95"]
      forKey:@"4.1"];
    
    [_codeItems setObject:@[
    @"https://www.sobot.com/developerdocs/app_sdk/ios.html#_4-2-8-商品卡片"]
      forKey:@"4.2"];
    
    [_codeItems setObject:@[
        @"https://www.sobot.com/developerdocs/app_sdk/ios.html#_4-3-留言工单相关"]
      forKey:@"4.3"];
    
    
    [_codeItems setObject:@[
        @"https://www.sobot.com/developerdocs/app_sdk/ios.html#_4-4-评价"]
      forKey:@"4.4"];
    
    
    [_codeItems setObject:@[
        @"https://www.sobot.com/developerdocs/app_sdk/ios.html#_4-5-1-消息推送",
        @"https://www.sobot.com/developerdocs/app_sdk/ios.html#_4-5-5-链接拦截"]
      forKey:@"4.5"];
    
    
    [_codeItems setObject:@[
      @"https://codecenter.sobot.com/pages/050de4/#%E2%97%8F-%E9%80%80%E5%87%BA%E7%99%BB%E5%BD%95"]
    forKey:@"4.6"];
    [_codeItems setObject:@[
        @"https://www.sobot.com/developerdocs/app_sdk/ios.html#_4-7-2-自定义聊天记录显示时间范围"]
      forKey:@"4.7"];
      [_codeItems setObject:@[
          @"https://www.sobot.com/developerdocs/app_sdk/ios.html#_5-1-zckitinfo类说明（ui相关配置）"]
        forKey:@"5.1"];
    [_codeItems setObject:@[
            @"https://www.sobot.com/developerdocs/app_sdk/ios.html#_5-2-zclibinitinfo类说明"]
          forKey:@"5.2"];
}

@end
