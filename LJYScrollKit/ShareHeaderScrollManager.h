//
//  ShareHeaderScrollManager.h
//  Ape_xc
//
//  Created by 林君毅 on 2022/5/16.
//  Copyright © 2022 Fenbi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct {
    CGFloat min;
    CGFloat max;
} AnchorRange;

static inline AnchorRange AnchorRangeMake(CGFloat min, CGFloat max) {
    AnchorRange r; r.min=min; r.max=max; return r;
}

static inline bool AnchorRangeEqual(AnchorRange r1, AnchorRange r2) {
    return r1.min == r2.min && r1.max == r2.max;
}

/// 多个ScrollView共享一个Header View，当ScrollView滑动时，Header View联动
@interface ShareHeaderScrollManager : NSObject

/// y坐标滑动的锚点
///
///  - mainView的竖直偏移在min~max的范围内时，Header View才会与下方的ScrollView联动。
///
/// @note max最大值内部限制为mainView.content.height-mainView.height。
@property (nonatomic, assign) AnchorRange y_anchor;

/// 若不为nil，则外部设置的y_anchor将失效。锚点由block动态返回
@property (nonatomic, copy, nullable) AnchorRange(^update_y_anchor)();

/// 初始化方法，使用-init不能正常工作
///
/// @param mainView 多个ScrollView和单一HeaderView的共同superView
/// @param scrollBlock 滑动时调用，isMainView:是否是mainView在滑动
///
/// @note 外部无需设置mainView的contentSize，内部会自动设置
- (id)initWithMainView:(UIScrollView *)mainView scrollBlock:(nullable void(^)(UIScrollView *scrollView, BOOL isMainView))scrollBlock;

- (void)addScrollViews:(NSArray<UIScrollView *> *)scrollViews;
- (void)addSingleScrollView:(UIScrollView *)scrollView;

@end

NS_ASSUME_NONNULL_END
