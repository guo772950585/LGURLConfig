
# CommonComponent

## URLConfig

### LGAPPConfig.json

```
{
 "EnvironmentNameValueList": ["Product", "Preproduct", "Development"],
 "EnvironmentName": "Development",
 "ChangeEnvironment": "1"
}
```

环境配置文件：里面包含可配置的所有环境列表、当前配置的环境和是否可以切换环境（0不可以，1可以）

### LGUrlConfig.json
URL、全局变量等配置文件：可以根据不同环境配置不同的value值，也可以对于所有环境配置统一的值，

具体包含两个部分：

* Base
    不区分环境，里面配置所有key的value值在各个环境下都一样
    
* Environment
    区分环境，在每个环境下配置各个key对应的value值

具体看下面的配置

```
{
    "Base": {
        "LGMainComponent_getAdvertisement": {
            "SERVER_PATH_URL": "main/getAdvertisement"
        }
        "LGMainComponent_getMainList": {
            "SERVER_PATH_URL": "main/getMainList"
        },
        "LGDemo_demoKey": "demoKey"
    },
    "Environment": {
        "Product": {
            "SERVER_HOST_URL": "https://www.product.com",
            "LGMainComponent_getMainList": {
                "SERVER_HOST_URL": "https://www.customProduct.com"
            },
            "LGDemo_webViewURL": "https://www.webViewProduct.com"
        },
        "Preproduct": {
            "SERVER_HOST_URL": "https://www.preproduct.com",
            "LGMainComponent_getMainList": {
                "SERVER_HOST_URL": "https://www.customPreproduct.com"
            },
            "LGDemo_webViewURL": "https://www.webViewPreproduct.com"
        },
        "Development": {
            "SERVER_HOST_URL": "https://www.development.com",
            "LGMainComponent_getMainList": {
                "SERVER_HOST_URL": "https://www.customPreproduct.com"
            },
            "LGDemo_webViewURL": "https://www.webViewDevelopment.com"
        }
    }
}
```

#### 全局变量
* LGDemo_demoKey

对于所有的环境value都是`"demoKey"`

* LGDemo_webViewURL

对于每个环境的value都不一样：

1. Product中value: `https://www.webViewProduct.com`
2. Preproduct中value: `https://www.webViewPreproduct.com`
3. Development中value: `https://www.webViewDevelopment.com`


### URL
首先URL对应的key-value格式如下:

```
"LGDemoComponent_demo": {
    "SERVER_HOST_URL": "https://www.demo.com",
    "SERVER_PATH_URL": "demo/demoList"
}
```
每个URL的key对一个有着SERVER_HOST_URL和SERVER_PATH_URL两个属性的对象

* SERVER_HOST_URL（host）

  默认情况下，每个环境下大多数请求的host都是一样的，所以会在每个环境下会默认配置一个统一的host,如下：

```  
 "Product": {
    "SERVER_HOST_URL": "https://www.product.com"       
 },
 "Preproduct": {
    "SERVER_HOST_URL": "https://www.preproduct.com"
 },
 "Development": {
    "SERVER_HOST_URL": "https://www.development.com"
 }
```
 如果某个请求有自己特定的host,如`LGMainComponent_getMainList`请求，则可以在每个**Environment**中的每个环境下自己配置自己的host：
 
```
 "Product": {
        "SERVER_HOST_URL": "https://www.product.com",
        "LGMainComponent_getMainList": {
            "SERVER_HOST_URL": "https://www.customProduct.com"
        }
 },
 "Preproduct": {
        "SERVER_HOST_URL": "https://www.preproduct.com",
        "LGMainComponent_getMainList": {
                "SERVER_HOST_URL": "https://www.customPreproduct.com"
        }
 },
 "Development": {
        "SERVER_HOST_URL": "https://www.development.com",
        "LGMainComponent_getMainList": {
            "SERVER_HOST_URL": "https://www.customPreproduct.com"
        }
 }
```
但是它的path一般是不区分环境的，所以我们配置在了**Base**里面：

```
"Base": {
    "LGMainComponent_getMainList": {
        "SERVER_PATH_URL": "main/getMainList"
    }
}
```
* SERVER_PATH_URL（path）

上面的`LGMainComponent_getMainList`列子其实已经包含了，path一般是不区分环境的，所以我们默认都配置在**Base**中。

### LGUrlConfigManager

URL配置文件工具类，主要对于URL：提供host、path、url三个个获取方法，对于通用的配置（全局变量）等：提供根据key获取value接口
外面只需设置`environmentName`和`urlConfigFilePath`两个属性即可

```
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
```
* serverHostWithIdentity

   1. 先从Environment的当前环境对象中获取key为identity的对象，再在它里面获取key为SERVER_HOST_URL的value值，有就返回，没有继续下一步
   2. 再从Base对象中获取key为identity的对象，再在它里面获取key为SERVER_HOST_URL的value值，有就返回，没有继续下一步
   3. 最后再从Environment的当前环境对象中获取key为SERVER_HOST_URL的值，有就返回，没有返回空
  
* serverPathWithIdentity

  1. 先从Environment的当前环境对象中获取key为identity的对象，再在它里面获取key为SERVER_PATH_URL的value值，有就返回，没有继续下一步
  2. 再从Base对象中获取key为identity的对象，再在它里面获取key为SERVER_PATH_URL的value值，有就返回，没有继续下一步
  
* serverUrl
  返回`serverHostWithIdentity`和`serverPathWithIdentity`返回值拼接的URL

* valueWithKey

   1. 先从Environment的当前环境对象中获取key为identity的值，有就返回，没有继续下一步
   2. 再从Base对象中获取key为identity的值，有就返回，没有继续下一步

### LGAPPConfigManager

环境配置工具类，包含环境切换功能API

```
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
```
外面只需设置`appConfigFilePath`属性即可

### LGhangeEnvirementViewController

通用引用上面的框架做成的环境切换页面，可以自己定义，只是提供个思路


