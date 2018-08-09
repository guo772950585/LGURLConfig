//
//  LGUrlConfigManager.h
//
//
//  Created by gyy on 2018/8/9.
//  Copyright © 2018 sncfc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGUrlConfigManager : NSObject
// 当前环境
@property (nonatomic, copy) NSString *environmentName;
// urlConfig.json文件路径
@property (nonatomic, strong) NSString *urlConfigFilePath;
// urlConfig.json数据
@property (nonatomic, readonly) NSMutableDictionary *urlConfigDic;

+ (instancetype)sharedInstance;
// 获取host
- (NSString *)serverHostWithIdentity:(NSString *)identity;
// 获取path
- (NSString *)serverPathWithIdentity:(NSString *)identity;
// 获取url
- (NSString *)serverUrl:(NSString *)identity;
// 获取value（通用的配置）
- (NSObject *)valueWithKey:(NSString *)identity;

@end
