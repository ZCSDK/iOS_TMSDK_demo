//
//  SobotTMDragView.h
//  SobotCallSDK
//
//  Created by zhangxy on 2023/7/6.
//

#import <UIKit/UIKit.h>
#import <SobotCommon/SobotCommon.h>
#import "SobotTMCallingViewV6.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,SobotTMDragViewType) {
    SobotTMDragViewType_Nol  = 1, // 拨号按钮
    SobotTMDragViewType_Calling  = 2, // 通话中
    SobotTMDragViewType_TimeSel  = 3, // 时间选择显示
};

typedef void(^TapClickBlock)(UIView *view);

@interface SobotTMDragView : UIView


@property(nonatomic,strong)NSMutableArray *statusArray;

@property(nonatomic,copy)TapClickBlock tapClick;

@property(nonatomic,assign)SobotTMDragViewType type;

@property(nonatomic,assign)SobotTMCallingViewV6Status viewStatus;
/// 显示拖拽控件到父view上
/// - Parameter superView: 如果为空自动添加到当前window上显示
-(void)showDragView:(UIView * _Nullable) superView type:(SobotTMDragViewType)type viewStatus:(SobotTMCallingViewV6Status)viewStatus block:(TapClickBlock)block;

/// 隐藏拖拽控件
/// - Parameter removeSuper: 是否从父类中移除
-(void)hideDragView:(BOOL) removeSuper;

-(void)onleHidDragView;

-(void)openDragView;

// 销毁不显示
-(void)dismissDragView;

@property(nonatomic,strong) SobotImageView *iconImg;
@property(nonatomic,strong) UILabel *tipLab;

// 实时更新状态
-(void)updateViewStatus:(SobotTMCallingViewV6Status*)viewStatus;
@end

NS_ASSUME_NONNULL_END
