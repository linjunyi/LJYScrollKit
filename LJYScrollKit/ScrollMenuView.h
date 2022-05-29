//
//  DropDownSelectionView.h
//  Ape_SL
//
//  Created by 林君毅 on 16/9/23.
//  Copyright © 2016年 TangQiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ScrollMenuSelectedItemPosition) {
    ScrollMenuSelectedItemPositionMiddle = 0,
    ScrollMenuSelectedItemPositionVisible,
};

@protocol ScrollMenuViewDelegate <NSObject>

- (void)didSelectItem:(NSUInteger)index;

@end
@interface ScrollMenuColorConfig :NSObject
/// 未选中标题字体
@property (nonatomic, strong) UIFont *normalFont;
/// 选中标题字体
@property (nonatomic, strong) UIFont *selectFont;
/// 未选中标题颜色
@property (nonatomic, strong) UIColor *normalColor;
/// 选中标题颜色
@property (nonatomic, strong) UIColor *selectColor;
/// menu view可滑动区域背景色
@property (nonatomic, strong) UIColor *scrollBgColor;
/// menu view背景色
@property (nonatomic, strong) UIColor *menuBgColor;
/// 选中条颜色
@property (nonatomic, strong) UIColor *selectedLineColor;
/// 底部分割线颜色
@property (nonatomic, strong) UIColor *bottomSeperationLineViewColor;
@end

@interface ScrollMenuConfig : ScrollMenuColorConfig

@property (nonatomic) ScrollMenuSelectedItemPosition selectedPosition;
@property (nonatomic) CGFloat xOffset;//used when selectedPosition == Middle
@property (nonatomic) CGFloat menuButtonExtraWidth;
@property (nonatomic) CGFloat itemGapWidth;

@property (nonatomic) CGFloat selectedLineWidth;
@property (nonatomic) CGFloat selectedLineHeight;
@property (nonatomic) CGFloat selectedLineRadius;
@property (nonatomic) CGFloat selectedLineBottomOffset;// Default 0

@property (nonatomic) CGFloat leftPadding;// Default 0
@property (nonatomic) CGFloat rightPadding;// Default 0

@property (nonatomic) UIColor *titleBgViewColor;
@property (nonatomic) CGFloat titleBgViewHeight;

- (void)setColorConfig:(ScrollMenuColorConfig *)colorConfig;
@end

@interface ScrollMenuView : UIView

@property (nonatomic, weak) id <ScrollMenuViewDelegate> delegate;
@property (nonatomic, strong, readonly) ScrollMenuConfig *config;
- (id)initWithTitleArray:(NSArray *)titleAry;
- (id)initWithTitleArray:(NSArray *)titleAry config:(ScrollMenuConfig*)config;
- (void)resortWithTitles:(NSArray *)titleAry;
- (void)resetWithTitles:(NSArray *)titleAry;

- (void)setAccessoryView:(UIView*)view offset:(CGPoint)offset index:(NSUInteger)index;
- (void)clearAllAccessory;

- (void)setSelectedIndex:(NSUInteger)index;
- (void)setSelectedIndex:(NSUInteger)index animated:(BOOL)animated;

- (UIView *)gettingBottomLine;
- (UIView *)getSelectBottomLine;
- (void)resetMenuConfig:(ScrollMenuColorConfig *)config;
@end
