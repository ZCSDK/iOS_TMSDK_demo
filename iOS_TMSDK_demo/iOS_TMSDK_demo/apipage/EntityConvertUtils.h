//
//  EntityConvertUtils.h
//  SobotKitFrameworkTest
//
//  Created by 张新耀 on 2020/1/8.
//  Copyright © 2020 zhichi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SobotCommon/SobotCommon.h>
#import <SobotCallSDK/SobotCallSDK.h>


NS_ASSUME_NONNULL_BEGIN

@interface EntityConvertUtils : NSObject

@property(nonatomic,strong) SobotCallCacheEntity *callCacheEntity;


+(EntityConvertUtils *)getEntityConvertUtils;


-(void)saveMessageToEntity:(NSString *) jsonString;

-(NSString *)getJsonStringByTooldsByKeys:(NSArray *) keys;

-(void)setDefaultConfiguration;

// UIColor转#ffffff格式的字符串
+ (NSString *)hexStringFromColor:(UIColor *)color;
+ (UIColor *) colorWithHexString: (NSString *) hexString;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+(NSString*)DataTOjsonString:(id)object;

NSString *convertToString(id object);
@end

NS_ASSUME_NONNULL_END
