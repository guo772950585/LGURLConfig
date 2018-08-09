//
//  LGUrlConfigManager.m
//
//
//  Created by gyy on 2018/8/9.
//  Copyright © 2018 sncfc. All rights reserved.
//

#import "LGUrlConfigManager.h"

@interface LGUrlConfigManager()

@property (nonatomic, readwrite) NSMutableDictionary *urlConfigDic;

@end

@implementation LGUrlConfigManager

#pragma mark -- private methods

- (void)__initUrlConfig
{
    NSParameterAssert(self.urlConfigFilePath);
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:self.urlConfigFilePath];
    
    NSDictionary *source_urlConfigDic = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:0
                                                                          error:nil];
    
    self.urlConfigDic = [NSMutableDictionary dictionary];
    
    if (!source_urlConfigDic)
    {
        return;
    }
    
    if (source_urlConfigDic[@"Base"])
    {
        [self.urlConfigDic addEntriesFromDictionary:source_urlConfigDic[@"Base"]];
    }
    
    if (source_urlConfigDic[@"Environment"])
    {
        [self.urlConfigDic addEntriesFromDictionary:source_urlConfigDic[@"Environment"]];
    }
}

#pragma mark -- public methods

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static LGUrlConfigManager *instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (NSString *)serverHostWithIdentity:(NSString *)identity
{
    NSParameterAssert(identity);
    NSParameterAssert(self.environmentName);

    NSString *hostKey = @"SERVER_HOST_URL";
    
    NSString *host = self.urlConfigDic[self.environmentName][identity][hostKey];
    if (host)
    {
        return host;
    }
    
    host = self.urlConfigDic[identity][hostKey];
    if (host)
    {
        return host;
    }
    
    host = self.urlConfigDic[self.environmentName][hostKey];
    return host;
}

- (NSString *)serverPathWithIdentity:(NSString *)identity
{
    NSParameterAssert(identity);
    NSParameterAssert(self.environmentName);

    NSString *pathKey = @"SERVER_PATH_URL";
    
    NSString *path = self.urlConfigDic[self.environmentName][identity][pathKey];
    if (path)
    {
        return path;
    }
    
    path = self.urlConfigDic[identity][pathKey];
    return path;
}

- (NSString *)serverUrl:(NSString *)identity
{
    NSParameterAssert(identity);
    
    NSString *urlString = [[self serverHostWithIdentity:identity] stringByAppendingString:[self serverPathWithIdentity:identity]];
    return urlString;
}

- (NSObject *)valueWithKey:(NSString *)identity
{
    NSParameterAssert(identity);
    NSParameterAssert(self.environmentName);

    NSObject *value = self.urlConfigDic[self.environmentName][identity];
    if (value)
    {
        return value;
    }
    
    value = self.urlConfigDic[identity];
    
    if (value)
    {
        return value;
    }
    
    return nil;
}

#pragma mark - getter and setter

- (void)setUrlConfigFilePath:(NSString *)urlConfigFilePath
{
    _urlConfigFilePath = urlConfigFilePath;
    [self __initUrlConfig];
}

@end
