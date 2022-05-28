//
//  ShareHeaderDemoVC.m
//  LSYScrollKitDemo
//
//  Created by 林君毅 on 2022/5/28.
//

#import "ShareHeaderDemoVC.h"
#import <LJYScrollKit/LJYScrollKit.h>
#import "Macro.h"
#import "ChildDemoVC.h"

static CGFloat HeaderHeight = 180;
static CGFloat FloatMenuHeight = 64;
static NSInteger kButtonTag = 500;

@interface ShareHeaderDemoVC ()

@property (nonatomic, strong) ShareHeaderScrollManager *scrollManager;

@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSMutableArray *buttonAry;

@end

@implementation ShareHeaderDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupView];
}

- (void)setupView {
    _mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    if (@available(iOS 11.0, *)) {
        _mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.view insertSubview:_mainScrollView atIndex:0];
    
    CGFloat viewWidth = self.view.frame.size.width;
    CGFloat viewHeight = self.view.frame.size.height;
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, HeaderHeight)];
    [_mainScrollView addSubview:_headerView];
    [self setupHeaderView];
    
    _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, HeaderHeight, viewWidth*3, viewHeight-FloatMenuHeight)];
    [_mainScrollView addSubview:_containerView];
    [self setupContainerView];
    
    [self selectIndex:0];
}

- (void)setupHeaderView {
    _headerView.backgroundColor = UIColorFromRGB(0xdfdfdf);
 
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, 60)];
    titleLbl.text = @"一个父ScrollView嵌套多个子ScrollView";
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.font = [UIFont boldSystemFontOfSize:15];
    titleLbl.textColor = UIColorFromRGB(0x3c464f);
    [_headerView addSubview:titleLbl];
    
    CGFloat x = 80;
    CGFloat y = _headerView.frame.size.height - 40;
    _buttonAry = [NSMutableArray new];
    for (NSInteger i = 0; i < 3; i++) {
        UIButton *button = [self createBtnWith:[NSString stringWithFormat:@"列表%zd", i+1]];
        button.tag = kButtonTag + i;
        button.frame = CGRectMake(x, y, 50, 30);
        [_headerView addSubview:button];
        [_buttonAry addObject:button];
        
        x += button.frame.size.width + 10;
    }
}

- (void)setupContainerView {
    CGFloat x = 0;
    
    ChildDemoVC *subVC1 = [[ChildDemoVC alloc] initWithIndex:1 listCount:20];
    [self addChildViewController:subVC1];
    subVC1.view.frame = CGRectMake(x, 0, self.view.frame.size.width, _containerView.frame.size.height);
    [_containerView addSubview:subVC1.view];
    x += subVC1.view.frame.size.width;
    
    ChildDemoVC *subVC2 = [[ChildDemoVC alloc] initWithIndex:2 listCount:50];
    [self addChildViewController:subVC2];
    subVC2.view.frame = CGRectMake(x, 0, self.view.frame.size.width, _containerView.frame.size.height);
    [_containerView addSubview:subVC2.view];
    x += subVC2.view.frame.size.width;
    
    ChildDemoVC *subVC3 = [[ChildDemoVC alloc] initWithIndex:3 listCount:3];
    [self addChildViewController:subVC3];
    subVC3.view.frame = CGRectMake(x, 0, self.view.frame.size.width, _containerView.frame.size.height);
    [_containerView addSubview:subVC3.view];
    
    _scrollManager = [[ShareHeaderScrollManager alloc] initWithMainView:_mainScrollView scrollBlock:
                      ^(UIScrollView * _Nonnull scrollView, BOOL isMainView) {
        // 滑动回调
    }];
    // mainView的竖直偏移在min~max的范围内时，Header View才会与下方的ScrollView联动。
    // max最大值内部限制为mainView.content.height-mainView.height。
    _scrollManager.y_anchor = AnchorRangeMake(0, HeaderHeight-FloatMenuHeight);
    // 动态获取y_anchor
    // _scrollManager.update_y_anchor = ^AnchorRange{
    //     return AnchorRangeMake(0, _headerView.frame.origin.x+_headerView.frame.size.height-FloatMenuHeight);
    // };
    [_scrollManager addScrollViews:@[
        [subVC1 currentScrollView],
        [subVC2 currentScrollView],
        [subVC3 currentScrollView],
    ]];
}

#pragma mark -

- (void)selectIndex:(NSInteger)index {
    for (UIButton *btn in _buttonAry) {
        if (index == btn.tag-kButtonTag) {
            btn.backgroundColor = UIColorFromRGB(0x3c7cfc);
        } else {
            btn.backgroundColor = [UIColor whiteColor];
        }
    }
    [UIView animateWithDuration:.3 animations:^{
        _containerView.frame = CGRectMake(-index*self.view.frame.size.width, _containerView.frame.origin.y, _containerView.frame.size.width, _containerView.frame.size.height);
    }];
}

- (UIButton *)createBtnWith:(NSString *)title {
    UIButton *btn = [UIButton new];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:UIColorFromRGB(0x3c464f) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    btn.backgroundColor = [UIColor whiteColor];
    btn.clipsToBounds = YES;
    btn.layer.cornerRadius = 8;
    btn.layer.borderColor = UIColorFromRGB(0xdfdfdf).CGColor;
    btn.layer.borderWidth = 1.0;
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)btnClicked:(UIButton *)btn {
    NSInteger index = btn.tag - kButtonTag;
    [self selectIndex:index];
}

@end
