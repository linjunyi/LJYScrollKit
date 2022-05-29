//
//  ScrollPageHandler.m
//  Ape_uni
//
//  Created by 林君毅 on 2019/11/5.
//  Copyright © 2019 Fenbi. All rights reserved.
//

#import "ScrollPageHandler.h"

@implementation ScrollPageHandler {
    UIPanGestureRecognizer *_pan;
}

- (ScrollPageHandler *)initWithContentView:(UIView *)contentView pageWidth:(CGFloat)pageWidth currentPageIndex:(NSInteger)currentPageIndex pageCount:(NSInteger)pageCount {
    if (self = [super init]) {
        NSAssert([contentView isKindOfClass:[UIScrollView class]]==NO, @"⚠️⚠️ScrollPageHandler's contentView can't be UIScrollView");
        NSAssert(pageCount>0, @"⚠️⚠️ScrollPageHandler's page count must be greater than 0");
        _contentView = contentView;
        _pageWidth = pageWidth;
        _currentPageIndex = currentPageIndex;
        _pageCount = pageCount;
        self.scrollEnabled = YES;
        [self initContentView];
    }
    return self;
}

- (void)initContentView {
    [self scrollToPage:_currentPageIndex animated:NO];
}

- (void)setScrollEnabled:(BOOL)scrollEnabled {
    _scrollEnabled = scrollEnabled;
    if (_scrollEnabled) {
        if (_pan == nil) {
            _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRecognizer:)];
            [_contentView addGestureRecognizer:_pan];
        }
    } else {
        if (_pan) {
            [_contentView removeGestureRecognizer:_pan];
            _pan = nil;
        }
    }
}

- (void)scrollToPage:(NSInteger)page animated:(BOOL)animated {
    if (page >= 0 && page < _pageCount) {
        _currentPageIndex = page;
        [UIView animateWithDuration:animated ? .3 : 0 animations:^{
            _contentView.frame = CGRectMake(-_pageWidth * _currentPageIndex, _contentView.frame.origin.y, _contentView.frame.size.width, _contentView.frame.size.height);
        } completion:^(BOOL finished) {
            if (_scrollPageDidPageChanged) {
                _scrollPageDidPageChanged(animated);
            }
        }];
        if (_scrollPageWillChangePage) {
            _scrollPageWillChangePage(animated);
        }
    }
}

- (void)updatePageWidth:(CGFloat)pageWidth {
    _pageWidth = pageWidth;
    [self scrollToPage:_currentPageIndex animated:NO];
}

- (void)handlePanGestureRecognizer:(UIPanGestureRecognizer*)recognizer {
    if (_scrollEnabled == NO) {
        return;
    }
    CGPoint point = [recognizer translationInView:recognizer.view];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _currentOffsetX = _contentView.frame.origin.x;
        _currentPageIndex = -_contentView.frame.origin.x / _pageWidth;
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        [self updateContainerOffset:point.x state:UIGestureRecognizerStateChanged];
    } else if (recognizer.state == UIGestureRecognizerStateEnded ||
               recognizer.state == UIGestureRecognizerStateCancelled) {
        [self updateContainerOffset:point.x state:recognizer.state];
    }
}

- (void)updateContainerOffset:(CGFloat)offsetX state:(UIGestureRecognizerState)state {
    if (state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateCancelled ) {
        if (fabs(offsetX) >= 60) {
            if (offsetX > 0 && [self canLeft]) {
                [self leftRight:YES];
            } else if(offsetX < 0 && [self canRight]){
                [self leftRight:NO];
            }
        }
        [self scrollToPage:_currentPageIndex animated:YES];
    } else {

        BOOL update = false;
        if (offsetX > 0 && [self canLeft]) {
            update =  true;
        } else if(offsetX < 0 && [self canRight]){
            update = true;
        }
        if (update) {
            _contentView.frame = CGRectMake(_currentOffsetX+offsetX, _contentView.frame.origin.y, _contentView.frame.size.width, _contentView.frame.size.height);
        }
    }
}

- (BOOL)canLeft {
    return _currentPageIndex > 0;
}

- (BOOL)canRight {
    return _currentPageIndex < _pageCount - 1;
}

- (void)leftRight:(BOOL)left {
    if (left) {
        _currentPageIndex--;
    } else {
        _currentPageIndex++;
    }
}


@end
