//
//  LGAPPConfigManager.m
//
//
//  Created by gyy on 2018/8/9.
//  Copyright © 2018 sncfc. All rights reserved.
//



#import "LGAPPConfigManager.h"

#import "LGURLConfig.h"

#define  LG_DebugEnvironmentPath [NSString stringWithFormat:@"%@/LGDocuments/%@", NSHomeDirectory(), @"DebugEnvironment.txt"]

@interface LGAPPConfigManager()

@property (nonatomic, readwrite) NSDictionary *appConfig;
@property (nonatomic, readwrite) NSString *environmentName;
@property (nonatomic, readwrite) NSArray *environmentList;

@end

@implementation LGAPPConfigManager

#pragma mark -- private methods

- (void)__initAppConfig
{
    
    NSParameterAssert(self.appConfigFilePath != nil);
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:self.appConfigFilePath];
    
    self.appConfig = [NSJSONSerialization JSONObjectWithData:data
                                                     options:0
                                                       error:nil];
    // 环境切换功能
    if (self.appConfig && self.appConfig[@"ChangeEnvironment"] && [self.appConfig[@"ChangeEnvironment"]  isEqualToString: @"1"])
    {
        // 可切换环境
        NSString *lastEnv = [self getEnvironment];
        if (lastEnv && lastEnv.length != 0)
        {
            self.environmentName = lastEnv;
        }
        else
        {
            self.environmentName = self.appConfig[@"EnvironmentName"];
        }
        self.environmentList = self.appConfig[@"EnvironmentNameValueList"];
    }
    else
    {
        // 不可切换环境
        self.environmentName = self.appConfig[@"EnvironmentName"];
        self.environmentList = @[];
    }
}

#pragma mark -- public methods

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static LGAPPConfigManager *instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (BOOL)setEnvironment:(NSString *)currentEnv
{
    NSParameterAssert(currentEnv);
    NSArray *envList = self.environmentList;
    if (![envList containsObject:currentEnv]) {
        LGLog(@"LGAPPConfig: 请设置EnvironmentNameValueList里面的环境");
        return NO;
    }
    NSString *dir = [NSHomeDirectory() stringByAppendingPathComponent:@"LGDocuments"];
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir;
    if (![fm fileExistsAtPath:dir isDirectory:&isDir] || !isDir) {
        if(![fm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil]) {
            return NO;
        }
    }
    NSString *path = [dir stringByAppendingPathComponent:@"DebugEnvironment.txt"];
    BOOL success = [currentEnv writeToFile:path atomically:YES encoding:NSUTF8StringEncoding  error:nil];
    return success;
}

- (NSString *)getEnvironment
{
    NSString *envPath = LG_DebugEnvironmentPath;
    NSString *str = [NSString stringWithContentsOfFile:envPath encoding:NSUTF8StringEncoding error:nil];
    return str;
}

- (BOOL)clearEnvironment
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    NSString *envPath = LG_DebugEnvironmentPath;
    [fm removeItemAtPath:envPath error:&error];
    if (error)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (BOOL)isProduct
{
    if (self.environmentName && [self.environmentName isEqualToString:@"Product"]) {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - getter and setter

- (void)setAppConfigFilePath:(NSString *)appConfigFilePath
{
    _appConfigFilePath = appConfigFilePath;
    [self __initAppConfig];
}

@end
