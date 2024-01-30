//
//  SobotTMDialViewV6.h
//  SobotCallSDK
//  V6呼叫拨号页面
//  Created by lizh on 2023/7/13.
//

#import <UIKit/UIKit.h>
#import "SobotTMCallingViewV6.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,SobotDialViewEvent) {
    SobotDialViewEventBack  = 1, // 返回
    SobotDialViewEventCall  = 2, // 呼叫
};

@protocol  SobotTMDialViewV6Delegate <NSObject>
@optional
-(void)dialViewBtnClick:(SobotDialViewEvent)type phoneNum:(NSString*)phone obj:(id)object;
@end

@interface SobotTMDialViewV6 : UIView

@property(nonatomic,weak)id<SobotTMDialViewV6Delegate> delegate;
@property(nonatomic,strong)NSString *callName;// 客户昵称
@property(nonatomic,strong)id callModel;
@property(nonatomic,strong)NSMutableArray *statusArray;
// 仅使用，初始化赋值
@property(nonatomic,assign) SobotTMCallingType callType;
@property(nonatomic,copy)NSString *callPhoneStr;// 外呼界面显示的电话号码
@property(nonatomic,assign)int hiddenFlag;//是否显示掩码

@property(nonatomic,strong) UITextField *labPhone;// 电话号码

-(instancetype)initWithCallingView:(int)code  callNumber:(NSString *)number;

-(void)show;
@end

NS_ASSUME_NONNULL_END
