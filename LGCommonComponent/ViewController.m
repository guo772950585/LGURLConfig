//
//  ViewController.m
//  LGCommonComponent
//
//  Created by 郭阳阳 on 2018/8/9.
//  Copyright © 2018年 郭阳阳. All rights reserved.
//

#import "ViewController.h"

#import "LGAPPConfigManager.h"
#import "LGhangeEnvirementViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *currentEnvLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentEnvLabel.text = [NSString stringWithFormat:@"当前环境是：%@", [[LGAPPConfigManager sharedInstance] environmentName]];
}

- (IBAction)gotoChangeEnvVC:(id)sender {
    LGhangeEnvirementViewController *vc = [[LGhangeEnvirementViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
