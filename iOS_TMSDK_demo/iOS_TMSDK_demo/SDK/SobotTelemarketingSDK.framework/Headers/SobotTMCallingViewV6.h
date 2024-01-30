//
//  SobotTMCallingViewV6.h
//  SobotCallSDK
//
//  Created by lizh on 2023/7/11.
//

#import <UIKit/UIKit.h>
#import <SobotCommon/SobotCommon.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,SobotTMCallingType) {
    SobotTMCallingTypeAccpet     = 1, // 接听 界面
    SobotTMCallingTypeCallUp     = 2, // 拨号  拨号完成，变成挂断 拨号界面
    SobotTMCallingTypeAccpetWait = 3,//  等待接听的界面
    SobotTMCallingTypeConsult    = 4,// 被咨询
    SobotTMCallingTypeShifted    = 5,// 被转移
    SobotTMCallingTypeToCalling  = 6,// 直接拉起外呼页面 外呼，中间不在显示拨号页面
    SobotTMCallingTypeToCallBack  = 7,// 直接拉起外呼页面 不调用外呼接口，中间不在显示拨号页面  ->回拨操作
    SobotTMCallingTypeToShowTel  = 8,// 手机方式接听时，显示占位页面
};


typedef NS_ENUM(NSInteger,SobotTMCallingEventType) {
    SobotTMCallingEventTypeAnswer = 1, // 等待接听
    SobotTMCallingEventTypeAccpet = 2, // 通话中
    SobotTMCallingEventTypeMute_on = 3, // 静音
    SobotTMCallingEventTypeMute_off = 4, // 静音
    SobotTMCallingEventTypeHold_on = 5, // 会话保持
    SobotTMCallingEventTypeHold_off = 6, // 会话保持
    SobotTMCallingEventTypehf_on = 7, // 免提 开
    SobotTMCallingEventTypehf_off = 8,// 免提 关
    SobotTMCallingEventTypeCallUp = 9,// 外呼中
    SobotTMCallingEventTypeKeyboardOn = 10,// 软键盘打开
    SobotTMCallingEventTypeKeyboardOff = 11,// 软键盘关闭
    SobotTMCallingEventTypeShifted = 12,// 被转移
    SobotTMCallingEventTypeConsult_1 = 13,// 被咨询来电
    SobotTMCallingEventTypeConsult_2 = 14,// 被咨询 接听咨询来电
    SobotTMCallingEventTypeConsult_3 = 15,// 被咨询 被拉入三方会话
    SobotTMCallingEventTypeShowTel = 16,// 手机方式接听 来电显示占位页面
    SobotTMCallingEventTypeInternal = 17,// 内部通话
    SobotTMCallingEventTypeInternalAccpet = 18, // 内部通话中
};

typedef NS_ENUM(NSInteger,SobotTMCallingViewV6Status) {
    
    SobotTMCallingViewV6Status_Calling     = 1, // 呼叫中
    SobotTMCallingViewV6Status_ring     = 2, // 振铃中
    SobotTMCallingViewV6Status_Accpet   = 3, // 通话中
    SobotTMCallingViewV6Status_hold     = 4, // 保持中
};

@interface SobotTMCallingViewV6 : UIView
// 仅使用，初始化赋值
@property(nonatomic,assign) SobotTMCallingType callType;
// 呼叫任务
@property (nonatomic, strong)  id callModel;
@property(nonatomic,assign) SobotTMCallingEventType callEventType;//显示状态

@property (nonatomic, strong)  NSString *displayNumber;
@property (nonatomic, strong)  NSString *campaignName;
@property (nonatomic, strong)  NSString *taskDetailId;
@property (nonatomic, strong) NSMutableArray *statusArray;
// type =4 销毁
@property (nonatomic, strong)  void(^SobotCallingBlock) (int type);

@property(nonatomic,assign)SobotTMCallingViewV6Status viewStatus;// 记录状态 点击缩小的时候使用

@property(nonatomic,copy) NSString *callID;

@property(nonatomic,copy) NSString * tickName;  // 外呼任务的昵称
/**
 *  创建对象方法
 */
-(instancetype)initWithCallingView:(SobotTMCallingType) type callNumber:(NSString *) number hiddenFlag:(int) hiddenFlag statusArray:(NSMutableArray *)statusArray;

-(instancetype)initWithCallingView:(SobotTMCallingType) type callNumber:(NSString *) number hiddenFlag:(int) hiddenFlag statusArray:(NSMutableArray *)statusArray callModel:(id _Nullable)callModel;

-(void)handUp;

- (void)show;

- (void)dissmisMenu;

// linphone 对方接电话了
-(void)linphoneCallEventEstablished;

// 开始接听计时
-(void)startCallingTimer;

// 暂停计时
-(void)pauseCallingTimer;

// 设置外呼页面的状态
-(void)showBtnsType:(SobotTMCallingEventType)callEventType isRefresh:(BOOL)isRefresh;

// 断网重连 并且重新设置 计时器的数据
-(void)showBtnsType:(SobotTMCallingEventType)callEventType isRefresh:(BOOL)isRefresh obj:(NSDictionary *)obj;

-(void)setcallingRingMsg:(NSString *)ip nick:(NSString *)nick phoneNum:(NSString *)phone obj:(id)obj;

// 接听事件
-(void)answerBtnClick:(SobotButton * _Nullable)sender;

// 挂断事件
-(void)hangUPBtnClick:(SobotButton* _Nullable)sender;
@end

NS_ASSUME_NONNULL_END
