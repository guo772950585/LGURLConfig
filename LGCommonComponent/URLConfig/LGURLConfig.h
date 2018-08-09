//
//  LGURLConfig.m
//  LGCommonComponent
//
//  Created by 郭阳阳 on 2018/8/9.
//  Copyright © 2018年 郭阳阳. All rights reserved.
//

#ifdef DEBUG
    #define LGLog(fmt, ...) NSLog(@" %s line:%d\n----------- YZTURLLog -----------\n" fmt @"\n", __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
    #define LGLog(fmt, ...)
#endif
