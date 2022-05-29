//
//  ScrollPageHandlerDemoVC.m
//  LSYScrollKitDemo
//
//  Created by 林君毅 on 2022/5/29.
//

#import "ScrollPageHandlerDemoVC.h"
#import "ChildDemoVC.h"
#import "Macro.h"
#import <LJYScrollKit/LJYScrollKit.h>

@interface ScrollPageHandlerDemoVC ()

@property (nonatomic, strong) ScrollPageHandler *scrollPageHandler;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *containerView;

@end

@implementation ScrollPageHandlerDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupView];
}

// 布局代码，建议使用Masonry
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat viewWidth = self.view.frame.size.width;
    CGFloat viewHeight = self.view.frame.size.height;
    _headerView.frame = CGRectMake(0, 0, viewWidth, 100);
    _containerView.frame = CGRectMake(_containerView.frame.origin.x, 100, viewWidth*3, viewHeight-100);
    CGFloat x = 0;
    for (UIView *view in _containerView.subviews) {
        view.frame = CGRectMake(x, 0, viewWidth, _containerView.frame.size.height);
        x += viewWidth;
    }
    
    [_scrollPageHandler updatePageWidth:viewWidth];
}

- (void)setupView {
    self.view.clipsToBounds = YES;
    
    _headerView = [[UIView alloc] init];
    _headerView.backgroundColor = UIColorFromRGB(0xdfdfdf);
    [self.view insertSubview:_headerView atIndex:0];
    
    _containerView = [[UIView alloc] init];
    [self.view addSubview:_containerView];
   
    ChildDemoVC *subVC1 = [[ChildDemoVC alloc] initWithIndex:1 listCount:20];
    [self addChildViewController:subVC1];
    [_containerView addSubview:subVC1.view];
    
    ChildDemoVC *subVC2 = [[ChildDemoVC alloc] initWithIndex:2 listCount:50];
    [self addChildViewController:subVC2];
    [_containerView addSubview:subVC2.view];

    ChildDemoVC *subVC3 = [[ChildDemoVC alloc] initWithIndex:3 listCount:3];
    [self addChildViewController:subVC3];
    [_containerView addSubview:subVC3.view];
    
    _scrollPageHandler = [[ScrollPageHandler alloc] initWithContentView:_containerView pageWidth:self.view.frame.size.width currentPageIndex:0 pageCount:3];
    _scrollPageHandler.scrollPageWillChangePage = ^(BOOL animated) {
        //翻页前调用
    };
    _scrollPageHandler.scrollPageDidPageChanged = ^(BOOL animated) {
        //翻页后调用
    };
}


@end
