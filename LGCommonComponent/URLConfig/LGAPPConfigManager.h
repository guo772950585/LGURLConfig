//
//  LGAPPConfigManager.h
//
//
//  Created by gyy on 2018/8/9.
//  Copyright © 2018 sncfc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGAPPConfigManager : NSObject
// appconfig.json文件地址
@property (nonatomic, copy)     NSString *appConfigFilePath;
// appconfig.json数据
@property (nonatomic, readonly) NSDictionary *appConfig;
// 当前环境
@property (nonatomic, readonly) NSString *environmentName;
// 支持的环境列表
@property (nonatomic, readonly) NSArray *environmentList;

+ (instancetype)sharedInstance;
// 切换环境（只能是appconfig.json中EnvironmentNameValueList中的值）
- (BOOL)setEnvironment:(NSString *)currentEnv;
// 获取上次切换的环境值
- (NSString *)getEnvironment;
// 删除切换环境的本地缓存值
- (BOOL)clearEnvironment;
// 是否是生产环境
- (BOOL)isProduct;
@end
