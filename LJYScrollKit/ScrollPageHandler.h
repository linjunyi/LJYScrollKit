//
//  ScrollPageHandler.h
//  Ape_uni
//
//  Created by 林君毅 on 2019/11/5.
//  Copyright © 2019 Fenbi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 将容器view (contentView) 划分成若干页面，支持左右滑动，并自定义回调处理。
/// Note: contentView应该预先使用Masonry做好布局约束
@interface ScrollPageHandler : NSObject

/// 容器view
@property (nonatomic, strong, readonly) UIView *contentView;

/// 每个页面的宽度
@property (nonatomic, assign, readonly) CGFloat pageWidth;

/// return current page index
@property (nonatomic, assign, readonly) NSInteger currentPageIndex;

/// return page count
@property (nonatomic, assign, readonly) NSInteger pageCount;

/// return contentView's frame.origin.x at the current time
@property (nonatomic, assign, readonly) CGFloat currentOffsetX;

/// contentView是否支持滑动，默认为 YES，若设置为 NO， 内部滑动手势将被禁用。
@property (nonatomic, assign) BOOL scrollEnabled;

/// called when page will change
@property (nonatomic, strong, nullable) void(^scrollPageWillChangePage)(BOOL animated);

/// called when page did changed
@property (nonatomic, strong, nullable) void(^scrollPageDidPageChanged)(BOOL animated);

/**
 * 初始化ScrollPageHandler
 *
 * @param contentView 设置容器view
 * @param pageWidth 每个页面的宽度，用于内部滑动使用
 * @param currentPageIndex 设置初始pageIndex
 * @param pageCount 设置划分页面数
 *
 * @note contentView不能为UIScrollView，否则会与内部滑动手势冲突。contentView的宽度应等于pageWidth*pageCount
 */
- (ScrollPageHandler *)initWithContentView:(UIView *)contentView
                                 pageWidth:(CGFloat)pageWidth
                          currentPageIndex:(NSInteger)currentPageIndex
                                 pageCount:(NSInteger)pageCount;

- (void)scrollToPage:(NSInteger)page animated:(BOOL)animated;

/// 当页面宽度需要变化时调用。例如横竖屏切换时，contentView的宽度发生变化，此时需刷新pageWidth。
/// 同时方法内部会根据currentPageIndex重新计算contentView的偏移位置。
- (void)updatePageWidth:(CGFloat)pageWidth;

@end

NS_ASSUME_NONNULL_END
