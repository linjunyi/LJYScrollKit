//
//  ViewController.m
//  LSYScrollKitDemo
//
//  Created by 林君毅 on 2022/5/27.
//

#import "ViewController.h"
#import "ShareHeaderDemoVC.h"

@interface ViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *mainScrollView;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15, 50, 50, 44)];
    button.backgroundColor = [UIColor greenColor];
    [button addTarget:self action:@selector(showShareHeaderVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)showShareHeaderVC {
    ShareHeaderDemoVC *vc = [ShareHeaderDemoVC new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
