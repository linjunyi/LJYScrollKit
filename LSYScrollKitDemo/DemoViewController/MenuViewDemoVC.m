//
//  MenuViewDemoVC.m
//  LSYScrollKitDemo
//
//  Created by 林君毅 on 2022/5/29.
//

#import "MenuViewDemoVC.h"
#import <LJYScrollKit/LJYScrollKit.h>
#import "Macro.h"

@interface MenuViewDemoVC ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation MenuViewDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _scrollView.frame = self.view.bounds;
    _scrollView.contentSize = CGSizeMake(0, 1000);
}

- (void)setupView {
    self.view.backgroundColor = UIColorFromRGB(0xdfdfdf);
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    _scrollView = scrollView;
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.view insertSubview:scrollView atIndex:0];
    
    [self addMenuView:80 titles:@[@"列表一", @"列表二", @"列表三"] config:nil];
    
    ScrollMenuConfig *config = [[ScrollMenuConfig alloc] init];
    config.normalFont = [UIFont systemFontOfSize:13];
    config.selectFont = [UIFont boldSystemFontOfSize:16];
    config.selectColor = UIColorFromRGB(0x14161A);
    config.normalColor = UIColorFromRGB(0x73757B);
    config.selectedLineColor = UIColorFromRGB(0xdfdfdf);
    config.selectedLineWidth = 30;
    config.selectedLineHeight = 4;
    config.scrollBgColor = [UIColor whiteColor];
    config.menuButtonExtraWidth = 20;
    [self addMenuView:160 titles:@[@"列表一", @"列表二", @"列表三", @"列表四"] config:config];
    
    config = [[ScrollMenuConfig alloc] init];
    config.normalFont = [UIFont systemFontOfSize:15];
    config.selectFont = [UIFont italicSystemFontOfSize:19];
    config.selectColor = UIColorFromRGB(0x14161A);
    config.normalColor = UIColorFromRGB(0x73757B);
    config.selectedLineColor = UIColorFromRGBA(0x0, 0);
    config.selectedLineWidth = 52;
    config.selectedLineHeight = 6;
    config.selectedLineBottomOffset = 10;
    config.scrollBgColor = [UIColor systemYellowColor];
    config.menuBgColor = [UIColor greenColor];
    config.menuButtonExtraWidth = 20;
    ScrollMenuView *scrollMenuView = [self addMenuView:240 titles:@[@"列表一", @"列表二", @"列表三", @"列表一", @"列表二", @"列表三", @"列表一", @"列表二", @"列表三"] config:config];
    
    [scrollMenuView gettingBottomLine].hidden = YES;
    UIView *selectedLine = [scrollMenuView getSelectBottomLine];
    [selectedLine.superview sendSubviewToBack:selectedLine];
    UIImageView *lineIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"homeScrollMenuLine"]];
    [selectedLine addSubview:lineIV];
    [self addConstraintForView:lineIV attribute:NSLayoutAttributeLeading];
    [self addConstraintForView:lineIV attribute:NSLayoutAttributeTrailing];
    [self addConstraintForView:lineIV attribute:NSLayoutAttributeTop];
    [self addConstraintForView:lineIV attribute:NSLayoutAttributeBottom];
}

- (ScrollMenuView *)addMenuView:(CGFloat)y titles:(NSArray *)titles config:(ScrollMenuConfig *)config {
    ScrollMenuView *menuView = [[ScrollMenuView alloc] initWithTitleArray:titles config:config];
    menuView.frame = CGRectMake(0, y, 320, 44);
    [_scrollView addSubview:menuView];
    return menuView;
}

- (void)addConstraintForView:(UIView *)view attribute:(NSLayoutAttribute)attribute  {
    NSLayoutConstraint *cons = [NSLayoutConstraint constraintWithItem:view attribute:attribute relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:attribute multiplier:1.0 constant:0];
    [view.superview addConstraint:cons];
    
}


@end
