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
@property (nonatomic, strong) UIFont *normalFont;
@property (nonatomic, strong) UIFont *selectFont;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectColor;

@property (nonatomic, strong) UIColor *scrollBgColor;
@property (nonatomic, strong) UIColor *menuBgColor;
@property (nonatomic, strong) UIColor *selectedLineColor;
@property (nonatomic, strong) UIColor *bottomSeperationLineViewColor; // 高度0.5的分隔线颜色
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
