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
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) NSMutableArray *buttonAry;

@end

@implementation ShareHeaderDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    _mainScrollView.frame = self.view.bounds;
    
    CGFloat viewWidth = self.view.frame.size.width;
    CGFloat viewHeight = self.view.frame.size.height;
    _headerView.frame = CGRectMake(0, 0, viewWidth, HeaderHeight);
    _containerView.frame = CGRectMake(0, HeaderHeight, viewWidth*3, viewHeight-FloatMenuHeight);
    _titleLbl.frame = CGRectMake(0, 80, viewWidth, 60);
    CGFloat x = 0;
    for (UIView *sv in _containerView.subviews) {
        sv.frame = CGRectMake(x, 0, viewWidth, _containerView.frame.size.height);
        x += sv.frame.size.width;
    }
}

- (void)setupView {
    _mainScrollView = [[UIScrollView alloc] init];
    if (@available(iOS 11.0, *)) {
        _mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.view insertSubview:_mainScrollView atIndex:0];
    
    _headerView = [[UIView alloc] init];
    [_mainScrollView addSubview:_headerView];
    [self setupHeaderView];
    
    _containerView = [[UIView alloc] init];
    [_mainScrollView addSubview:_containerView];
    [self setupContainerView];
    
    [self selectIndex:0];
}

- (void)setupHeaderView {
    _headerView.backgroundColor = UIColorFromRGB(0xdfdfdf);
 
    _titleLbl = [[UILabel alloc] init];
    _titleLbl.text = @"一个父ScrollView嵌套多个子ScrollView";
    _titleLbl.textAlignment = NSTextAlignmentCenter;
    _titleLbl.font = [UIFont boldSystemFontOfSize:15];
    _titleLbl.textColor = UIColorFromRGB(0x3c464f);
    [_headerView addSubview:_titleLbl];
    
    CGFloat x = 80;
    CGFloat y = HeaderHeight - 40;
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
    ChildDemoVC *subVC1 = [[ChildDemoVC alloc] initWithIndex:1 listCount:20];
    [self addChildViewController:subVC1];
    [_containerView addSubview:subVC1.view];
    
    ChildDemoVC *subVC2 = [[ChildDemoVC alloc] initWithIndex:2 listCount:50];
    [self addChildViewController:subVC2];
    [_containerView addSubview:subVC2.view];
    
    ChildDemoVC *subVC3 = [[ChildDemoVC alloc] initWithIndex:3 listCount:3];
    [self addChildViewController:subVC3];
    [_containerView addSubview:subVC3.view];
    
    _scrollManager = [[ShareHeaderScrollManager alloc] initWithMainView:_mainScrollView scrollBlock:
                      ^(UIScrollView * _Nonnull scrollView, BOOL isMainView) {
        // 滑动回调
    }];
    
    // mainView的竖直偏移在min~max的范围内时，Header View才会与下方的ScrollView联动。
    // max最大值内部限制为mainView.content.height-mainView.height。
     _scrollManager.update_y_anchor = ^AnchorRange{
         return AnchorRangeMake(0, _headerView.frame.origin.x+_headerView.frame.size.height-FloatMenuHeight);
     };
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
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:.3 animations:^{
        weakSelf.containerView.frame = CGRectMake(-index*weakSelf.view.frame.size.width, weakSelf.containerView.frame.origin.y, weakSelf.containerView.frame.size.width, weakSelf.containerView.frame.size.height);
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
