//
//  ShareHeaderScrollManager.m
//  Ape_xc
//
//  Created by 林君毅 on 2022/5/16.
//  Copyright © 2022 Fenbi. All rights reserved.
//

#import "ShareHeaderScrollManager.h"
#import <objc/runtime.h>

@interface UIScrollView(ShareHeader)

@property (nonatomic, assign) BOOL forbidFixScroll;

@end

@implementation UIScrollView(ShareHeader)

- (BOOL)forbidFixScroll {
    NSNumber *num = objc_getAssociatedObject(self, @selector(forbidFixScroll));
    return [num boolValue];
}

- (void)setForbidFixScroll:(BOOL)forbidFixScroll {
    return objc_setAssociatedObject(self, @selector(forbidFixScroll), @(forbidFixScroll), OBJC_ASSOCIATION_ASSIGN);
}

@end

@interface ShareHeaderScrollManager()

@property (nonatomic, strong) UIScrollView *mainView;
@property (nonatomic, copy)   void (^scrollBlock)(UIScrollView *, BOOL);
@property (nonatomic, strong) NSMutableArray<UIScrollView *> *scrollViews;

@end
 
@implementation ShareHeaderScrollManager

- (void)dealloc {
    for (UIScrollView *scrollV in _scrollViews) {
        [scrollV removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))];
    }
    [_mainView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))];
}

- (id)initWithMainView:(UIScrollView *)mainView scrollBlock:(nullable void(^)(UIScrollView *, BOOL isMainView))scrollBlock {
    if (self = [super init]) {
        NSParameterAssert([mainView isKindOfClass:[UIScrollView class]]);
        _mainView = mainView;
        _scrollBlock = scrollBlock;
        _y_anchor = AnchorRangeMake(CGFLOAT_MIN, CGFLOAT_MAX);
        _scrollViews = [NSMutableArray new];
        
        [self setupObserveFor:_mainView];
    }
    return self;
}

- (void)addScrollViews:(NSArray<UIScrollView *> *)scrollViews {
    for (UIScrollView *scrollV in scrollViews) {
        [self addSingleScrollView:scrollV];
    }
}

- (void)addSingleScrollView:(UIScrollView *)scrollView {
    NSParameterAssert([scrollView isKindOfClass:[UIScrollView class]]);
    
    if ([_scrollViews containsObject:scrollView]) {
        return;
    }
    [_scrollViews addObject:scrollView];
    [self setupObserveFor:scrollView];
}

- (void)setupObserveFor:(UIScrollView *)scrollView {
    @synchronized (scrollView) {
        [scrollView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(contentOffset))]) {
        if ([object isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)object;
            if (scrollView.forbidFixScroll) {
                scrollView.forbidFixScroll = NO;
                return;
            }
            
            [self fixScroll:scrollView];
            if (self.scrollBlock) {
                self.scrollBlock(scrollView, scrollView == self.mainView);
            }
        }
    }
}

- (void)setY_anchor:(AnchorRange)y_anchor {
    _y_anchor = y_anchor;
    _mainView.contentSize = CGSizeMake(_mainView.contentSize.width, y_anchor.max+_mainView.frame.size.height);
}

#pragma mark -

- (CGFloat)maxContentOffsetY {
    if (_update_y_anchor) {
        AnchorRange other_y_anchor = _update_y_anchor();
        if (AnchorRangeEqual(_y_anchor, other_y_anchor) == NO) {
            [self setY_anchor:other_y_anchor];
        }
    }
    return MIN(_mainView.contentSize.height-_mainView.frame.size.height, _y_anchor.max);
}

- (CGFloat)minContentOffsetY {
    if (_update_y_anchor) {
        AnchorRange other_y_anchor = _update_y_anchor();
        if (AnchorRangeEqual(_y_anchor, other_y_anchor) == NO) {
            [self setY_anchor:other_y_anchor];
        }
    }
    return _y_anchor.min;
}

- (BOOL)canScrollUp {
    return (int)(_mainView.contentOffset.y*100) < (int)([self maxContentOffsetY] * 100);
}

- (BOOL)canScrollDown {
    return (int)(_mainView.contentOffset.y*100) > (int)([self minContentOffsetY] * 100);
}

- (BOOL)isActive:(UIScrollView *)subScrollView {
    CGRect rect = [subScrollView.superview convertRect:subScrollView.frame toView:_mainView.superview];
    return CGRectContainsPoint(_mainView.frame, CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y+rect.size.height/2));
}

- (void)noObserveUpdateOffset:(CGPoint)offset forScrollView:(UIScrollView *)scrollView {
    scrollView.forbidFixScroll = YES;
    scrollView.contentOffset = offset;
}

- (void)fixScroll:(UIScrollView *)scrollView {
    if (scrollView == _mainView) {
        [self fixScrollForMainView];
    } else {
        [self fixScrollForSubScrollView:scrollView];
    }
}

- (void)fixScrollForMainView {
    CGFloat fixOffset = _mainView.contentOffset.y + _mainView.frame.size.height - _mainView.contentSize.height;
    if (fixOffset > 0) {
        for (UIScrollView *scrollV in _scrollViews) {
            if ([self isActive:scrollV]) {
                if (fixOffset + scrollV.contentOffset.y + scrollV.frame.size.height < scrollV.contentSize.height) {
                    //此处需触发keyPath回调，从而调用fixScrollForSubScrollView修正_mainView的contentOffset。
                    scrollV.contentOffset = CGPointMake(scrollV.contentOffset.x, fixOffset+scrollV.contentOffset.y);
                }
            }
        }
    }
    
    _mainView.scrollEnabled = YES;
}

/// 特定情况下，subScrollView滑动时不动，而是触发mainView的滑动
- (void)fixScrollForSubScrollView:(UIScrollView *)subScrollView {
    CGFloat offsetY = _mainView.contentOffset.y + subScrollView.contentOffset.y;
    BOOL needFix = NO;
    if (subScrollView.contentOffset.y > 0 && [self canScrollUp]) {
        offsetY = offsetY > [self maxContentOffsetY] ? [self maxContentOffsetY] : offsetY;
        needFix = YES;
    }
    else if (subScrollView.contentOffset.y < 0 && [self canScrollDown]) {
        offsetY = offsetY < [self minContentOffsetY] ? [self minContentOffsetY] : offsetY;
        needFix = YES;
    }
    if (needFix) {
        for (UIScrollView *scrollV in _scrollViews) {
            [self noObserveUpdateOffset:CGPointMake(scrollV.contentOffset.x, 0) forScrollView:scrollV];
        }
        [self noObserveUpdateOffset:CGPointMake(_mainView.contentOffset.x, offsetY) forScrollView:_mainView];
    }
    
    if ([self canScrollUp] == NO) {
        _mainView.scrollEnabled = NO;
    } else {
        _mainView.scrollEnabled = YES;
    }
}

@end
