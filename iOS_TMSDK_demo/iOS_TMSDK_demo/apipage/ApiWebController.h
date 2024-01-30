//
//  ApiWebController.h
//  SobotCallSDKDemo
//
//  Created by zhangxy on 2023/1/4.
//

#import <SobotCommon/SobotCommon.h>

NS_ASSUME_NONNULL_BEGIN

@interface ApiWebController : SobotBaseController

@property(nonatomic,strong) NSString *webUrl;

-(id)initWithURL:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
