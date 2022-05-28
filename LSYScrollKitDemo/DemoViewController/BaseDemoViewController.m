//
//  BaseDemoViewController.m
//  LSYScrollKitDemo
//
//  Created by 林君毅 on 2022/5/28.
//

#import "BaseDemoViewController.h"

@interface BaseDemoViewController ()

@end

@implementation BaseDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 24, 40, 40)];
    [returnBtn setImage:[UIImage imageNamed:@"returnBtn"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(returnBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnBtn];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)returnBtnPressed:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
