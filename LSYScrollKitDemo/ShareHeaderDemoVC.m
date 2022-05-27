//
//  ShareHeaderDemoVC.m
//  LSYScrollKitDemo
//
//  Created by 林君毅 on 2022/5/28.
//

#import "ShareHeaderDemoVC.h"
#import <LJYScrollKit/LJYScrollKit.h>
#import "Macro.h"
#import "HotTextViewController.h"

static CGFloat HeaderHeight = 180;
static CGFloat FloatMenuHeight = 64;

@interface ShareHeaderDemoVC ()

@property (nonatomic, strong) ShareHeaderScrollManager *scrollManager;

@end

@implementation ShareHeaderDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)setupView {
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    if (@available(iOS 11.0, *)) {
        mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.view addSubview:mainScrollView];
    
    CGFloat viewWidth = self.view.frame.size.width;
    CGFloat viewHeight = self.view.frame.size.height;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, HeaderHeight)];
    [mainScrollView addSubview:headerView];
    [self setupHeaderView:headerView];
    
    HotTextViewController *hotTextVC = [HotTextViewController new];
    [self addChildViewController:hotTextVC];
    hotTextVC.view.frame = CGRectMake(0, HeaderHeight, viewWidth, viewHeight-FloatMenuHeight);
    [mainScrollView addSubview:hotTextVC.view];
    
    _scrollManager = [[ShareHeaderScrollManager alloc] initWithMainView:mainScrollView scrollBlock:^(UIScrollView * _Nonnull scrollView, BOOL isMainView) {
        NSLog(@"******** 滑动回调");
    }];
    _scrollManager.y_anchor = AnchorRangeMake(0, HeaderHeight-FloatMenuHeight);
    [_scrollManager addScrollViews:[hotTextVC currentScrollViews]];
}

- (void)setupHeaderView:(UIView *)headerView {
    headerView.backgroundColor = UIColorFromRGB(0xdfdfdf);
    
    UIImageView *bannerView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 64, headerView.frame.size.width-40, 44)];
    [headerView addSubview:bannerView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *bannerUrl = @"https://nodestatic-ali.fbstatic.cn/static-files/1652328091704_banner2.jpg?width=690&height=130";
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:bannerUrl]];
        if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                bannerView.image = [UIImage imageWithData:data];
            });

        }
    });
}

@end
