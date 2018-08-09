//
//  LGhangeEnvirementViewController.m
//  ClaimPlatform_RN
//
//  Created by 郭阳阳 on 2018/5/21.
//  Copyright © 2018年 sncfc. All rights reserved.
//

#import "LGhangeEnvirementViewController.h"

#import "LGAPPConfigManager.h"
#import "LGURLConfig.h"

#define LG_IPHONEX ([UIScreen mainScreen].bounds.size.height == 812)

@interface LGhangeEnvirementViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation LGhangeEnvirementViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

#pragma mark - delegate

#pragma mark -- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = [self.dataSource objectAtIndex:indexPath.row];
    if ([title isEqualToString:[LGAPPConfigManager sharedInstance].environmentName]) {
        LGLog(@"当前环境就是【%@】",title);
    }else {
        if ([[LGAPPConfigManager sharedInstance]setEnvironment:title]) {
            LGLog(@"切换成【%@】环境成功",title);
        }else {
            LGLog(@"😭切换失败啦😭");
        }
        //强制退出APP
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            exit(0);
        });
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - dataSource

#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSString *title = [self.dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = title;
    if ([title isEqualToString:[LGAPPConfigManager sharedInstance].environmentName]) {
        cell.backgroundColor = [UIColor greenColor];
    }else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}


#pragma mark - setters and getters

- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat barHeight = LG_IPHONEX ? 88 : 64;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, barHeight, self.view.bounds.size.width, self.view.bounds.size.height - barHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSArray *)dataSource {
    return [[LGAPPConfigManager sharedInstance] environmentList];
}

@end
