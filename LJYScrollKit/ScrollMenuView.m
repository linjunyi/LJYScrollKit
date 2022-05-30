//
//  DropDownSelectionView.m
//  Ape_SL
//
//  Created by 林君毅 on 16/9/23.
//  Copyright © 2016年 TangQiao. All rights reserved.
//

#import <LJYScrollKit/ScrollMenuView.h>

@interface MenuItemAccessory : NSObject<NSCopying>
@property (nonatomic, strong) UIView *view;
@property (nonatomic) CGPoint offset;
+(id)menuItemAccessoryWithView:(UIView*)view offset:(CGPoint)offset;
@end

@implementation MenuItemAccessory

+(id)menuItemAccessoryWithView:(UIView*)view offset:(CGPoint)offset {
    MenuItemAccessory *acc = [[MenuItemAccessory alloc] init];
    acc.view = view;
    acc.offset = offset;
    return acc;
}

- (id)copyWithZone:(NSZone *)zone {
    MenuItemAccessory *acc = [[MenuItemAccessory alloc] init];
    acc.view = self.view;
    acc.offset = self.offset;
    return acc;
}
@end

@interface MenuItemButton : UIButton
@property (nonatomic) NSUInteger index;
@property (nonatomic, strong) ScrollMenuConfig *config;
@end

@implementation MenuItemButton

- (id)initWithTitle:(NSString *)title index:(NSUInteger)index {
    if (self = [super init]) {
        [self setTitle:title forState:UIControlStateNormal];
        _index = index;
    }
    return self;
}

- (void)setConfig:(ScrollMenuConfig*)config {
    _config = config;
    [self setTitleColor:config.normalColor forState:UIControlStateNormal];
    if (config.selectColor) {
        [self setTitleColor:config.selectColor forState:UIControlStateHighlighted];
        [self setTitleColor:config.selectColor forState:UIControlStateSelected];
    }
    if (config.selectFont) {
        [self.titleLabel setFont:self.isSelected ? config.selectFont : config.normalFont];
    }else {
        [self.titleLabel setFont:config.normalFont];
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (_config.selectFont) {
        [self.titleLabel setFont:selected ? _config.selectFont : _config.normalFont];
    }
}

- (CGSize)string:(NSString*)str getSizeWithFont:(UIFont *)font inWidth:(CGFloat)width lineBreak:(NSLineBreakMode)mode {
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = mode;
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, 100000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName: paragraphStyle} context:nil].size;
    size.width = ceilf(size.width);
    size.height = ceilf(size.height);
    return size;
}

- (void)resetWithFitSize {
    CGFloat width = [self string:self.titleLabel.text getSizeWithFont:self.titleLabel.font inWidth:CGFLOAT_MAX lineBreak:NSLineBreakByWordWrapping].width;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width + _config.menuButtonExtraWidth, self.frame.size.height);
}

- (CGFloat)resetTitleWithFitSize {
    CGFloat width = [self string:self.titleLabel.text getSizeWithFont:self.titleLabel.font inWidth:CGFLOAT_MAX lineBreak:NSLineBreakByWordWrapping].width;
    return width + 20;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake([self.titleLabel intrinsicContentSize].width+_config.menuButtonExtraWidth, UIViewNoIntrinsicMetric);
}
@end

#define UIKIT_IMAGE(image) BUNDLE_IMAGE(@"resource",image)
@implementation ScrollMenuColorConfig

@end
@implementation ScrollMenuConfig
+(instancetype)defaultConfig {
    ScrollMenuConfig *config = [[ScrollMenuConfig alloc] init];
    [self setToDefault:config];
    return config;
}

+ (void)setToDefault:(ScrollMenuConfig*)config {
    config.normalFont = [UIFont systemFontOfSize:16];
    config.selectFont = [UIFont boldSystemFontOfSize:16];
    config.normalColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    config.selectColor = [UIColor colorWithRed:0 green:153/255.0 blue:1 alpha:1.0];
    config.menuButtonExtraWidth = 36;
    config.scrollBgColor = [UIColor whiteColor];
    config.itemGapWidth = 0;
    config.selectedLineBottomOffset = 0;
    config.titleBgViewRadius = -1;
}

- (id)init {
    if (self = [super init]) {
        [[self class] setToDefault:self];
    }
    return self;
}
- (void)setColorConfig:(ScrollMenuColorConfig *)colorConfig {
    self.normalFont = colorConfig.normalFont;
    self.selectFont = colorConfig.selectFont;
    self.normalColor = colorConfig.normalColor;
    self.selectColor = colorConfig.selectColor;

    self.scrollBgColor = colorConfig.scrollBgColor;
    self.menuBgColor = colorConfig.menuBgColor;
    self.selectedLineColor = colorConfig.selectedLineColor;
    self.bottomSeperationLineViewColor = colorConfig.bottomSeperationLineViewColor;
}
@end

@implementation ScrollMenuView {
    UIScrollView  *_scrollView;
    NSArray *_titles;
    UIView *_bottomLine;
    UIView *_selectedBottomLine;
    NSInteger _selectIdx;

    NSMutableDictionary *_accessoryInfos;
    UIView  *_titleBgView;

    MenuItemButton *_lastSelect;
    __weak MenuItemButton *_lastUnSelect;
}

- (id)initWithTitleArray:(NSArray *)titles {
    return [self initWithTitleArray:titles config:nil];
}

- (id)initWithTitleArray:(NSArray *)titles config:(ScrollMenuConfig*)config {
    if (self = [super init]) {
        _titles = titles;
        _accessoryInfos = [NSMutableDictionary dictionary];
        if (config == nil) {
            config = [ScrollMenuConfig defaultConfig];
        }
        _config = config;
        [self setupView];
    }
    return self;
}

- (void)resortWithTitles:(NSArray *)titleAry {
    if ([titleAry count] == [_titles count]) {
        _titles = titleAry;
        [self clearAllAccessory];
        [self setupView];
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
}

- (void)resetWithTitles:(NSArray *)titleAry {
    _titles = titleAry;
    [self clearAllAccessory];
    [self setupView];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)clearAllAccessory {
    for (MenuItemAccessory *acc in [_accessoryInfos allValues]) {
        [acc.view removeFromSuperview];
    }
    [_accessoryInfos removeAllObjects];
}

- (void)setAccessoryView:(UIView*)view offset:(CGPoint)offset index:(NSUInteger)index {
    BOOL changed = false;
    MenuItemAccessory *current = _accessoryInfos[@(index)];
    if (current) {
        changed = true;
        [current.view removeFromSuperview];
    }

    if (view) {
        changed = true;
        MenuItemAccessory *acc = [MenuItemAccessory menuItemAccessoryWithView:view offset:offset];
        [_accessoryInfos setObject:acc forKey:@(index)];
        [_scrollView addSubview:view];
    } else {
        [_accessoryInfos removeObjectForKey:@(index)];
    }

    if (changed) {
        [self updateItemsFrameAndContentSize];
        [self adjustOffsetWithSelectedItem:_lastSelect animated:NO];
    }
}

//#define BUTTON_ITEM_W (IS_IPHONE ? (APP_SCREEN_WIDTH / 5) : 75)
- (void)setupView {
    if (_config.menuBgColor) {
        self.backgroundColor = _config.menuBgColor;
    }
    for (UIView *v in [self subviews]) {
        [v removeFromSuperview];
    }
    _lastSelect = nil;
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.backgroundColor = _config.scrollBgColor;
    _scrollView.showsHorizontalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self addSubview:_scrollView];

    BOOL haveTitleBg = (_config.titleBgViewColor && _config.titleBgViewHeight > 0)?YES:NO;
    if(haveTitleBg){
        _titleBgView = [[UIView alloc] initWithFrame:CGRectZero];
        _titleBgView.userInteractionEnabled = YES;
        _titleBgView.backgroundColor = _config.titleBgViewColor;
        _titleBgView.layer.masksToBounds = YES;
        [_scrollView addSubview:_titleBgView];
    }

    UIView *lastView = nil;
    NSUInteger i = 0;
    for (NSString *t in _titles) {
        MenuItemButton *btn = [[MenuItemButton alloc] initWithTitle:t index:i];
        btn.frame = CGRectMake(0, 0, 0, _scrollView.bounds.size.height);
        btn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [btn setConfig:_config];

        if (i == _selectIdx) {
            btn.selected = YES;
            _lastSelect = btn;
        } else {
            btn.selected = NO;
        }
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(menuItemButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [btn resetWithFitSize];

        [_scrollView addSubview:btn];

        lastView = btn;
        i++;
    }

    _selectedBottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-_config.selectedLineHeight?:3-_config.selectedLineBottomOffset, _config.selectedLineWidth?:25, _config.selectedLineHeight?:3)];
    _selectedBottomLine.layer.cornerRadius = _config.selectedLineRadius?:1.5;
    _selectedBottomLine.clipsToBounds = YES;
    _selectedBottomLine.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _selectedBottomLine.backgroundColor = _config.selectedLineColor ?: _config.selectColor;
    [_scrollView addSubview:_selectedBottomLine];

    _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-4.5, self.bounds.size.width, 0.5)];
    _bottomLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _bottomLine.backgroundColor = _config.bottomSeperationLineViewColor?: [UIColor grayColor];
    [self addSubview:_bottomLine];

    [self updateItemsFrameAndContentSize];
    [self adjustSelectedBottomLine:NO];
}

- (void)updateTitleBgViewCons:(MenuItemButton *)itemButton animated:(BOOL)animated{
    if(_titleBgView == nil){
        return;
    }
    
    
    CGFloat width =  [_lastSelect resetTitleWithFitSize];
    CGFloat height =  _config.titleBgViewHeight;
    _titleBgView.layer.cornerRadius = _config.titleBgViewRadius >= 0 ? _config.titleBgViewRadius : height*0.5;
    CGFloat centerX = self->_lastSelect.frame.origin.x+self->_lastSelect.frame.size.width/2;
    CGFloat centerY = self->_lastSelect.frame.origin.y+self->_lastSelect.frame.size.height/2;
    _titleBgView.frame = CGRectMake(centerX-width/2, centerY-height/2, width, height);

    if(animated){
        [UIView animateWithDuration:0.2 animations:^{
            [self->_scrollView layoutIfNeeded];
            [self->_scrollView setNeedsLayout];
        }];
    }
}


- (void)resetMenuConfig:(ScrollMenuColorConfig *)config {
    [_config setColorConfig:config];
    _bottomLine.backgroundColor = _config.bottomSeperationLineViewColor?:[UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0  alpha:1.0];
    _selectedBottomLine.backgroundColor = _config.selectedLineColor ?: _config.selectColor;
    _scrollView.backgroundColor = _config.scrollBgColor;
    for(int i = 0; i < [_titles count]; i++) {
        MenuItemButton *btn = (MenuItemButton*)[_scrollView viewWithTag:100+i];
        [btn setConfig:_config];
    }
}
- (CGFloat)itemGapWidth {
    return _config.itemGapWidth;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _scrollView.frame = CGRectMake(_config.leftPadding, 0, self.frame.size.width-(_config.leftPadding + _config.rightPadding), self.frame.size.height);
    [self updateTitleBgViewCons:_lastSelect animated:NO];
    
    [self adjustOffsetWithSelectedItem:_lastSelect animated:NO];
}

- (void)updateItemsFrameAndContentSize {
    CGFloat contentWidth = 0;
    [_lastSelect resetWithFitSize];
    if (_lastUnSelect != _lastSelect) {
        [_lastUnSelect resetWithFitSize];
    }

    UIView *last = nil;
    CGFloat gapW = [self itemGapWidth];
    for(int i = 0; i < [_titles count]; i++) {
        MenuItemButton *btn = (MenuItemButton*)[_scrollView viewWithTag:100+i];
        if (last) {
            btn.frame = CGRectMake(contentWidth, btn.frame.origin.y, btn.frame.size.width, btn.frame.size.height);
        } else {
            btn.frame = CGRectMake(gapW, btn.frame.origin.y, btn.frame.size.width, btn.frame.size.height);
        }
        CGFloat append = 0;
        MenuItemAccessory *acc = _accessoryInfos[@(i)];
        if (acc) {
            CGFloat accViewX = btn.frame.origin.x + btn.frame.size.width + acc.offset.x;
            CGFloat accViewY = btn.frame.origin.y + btn.frame.size.height/2 + acc.offset.y - acc.view.frame.size.height/2;
            acc.view.frame = CGRectMake(accViewX, accViewY, acc.view.frame.size.width, acc.view.frame.size.height);
            append = acc.view.frame.size.width;
        }
        contentWidth = btn.frame.origin.x + btn.frame.size.width + gapW + append;
        last = btn;
    }
    _scrollView.contentSize = CGSizeMake(contentWidth, _scrollView.frame.size.height);
}

- (UIView *)gettingBottomLine{
    return _bottomLine;
}

- (void)adjustSelectedBottomLine:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            self->_selectedBottomLine.center = CGPointMake(self->_lastSelect.frame.origin.x + self->_lastSelect.bounds.size.width/2, self.bounds.size.height-self->_selectedBottomLine.bounds.size.height/2-self->_config.selectedLineBottomOffset);
        }];
    } else {
        _selectedBottomLine.center = CGPointMake(_lastSelect.frame.origin.x + _lastSelect.bounds.size.width/2, self.bounds.size.height-_selectedBottomLine.bounds.size.height/2-_config.selectedLineBottomOffset);
    }
}

- (void)adjustOffsetWithSelectedItem:(MenuItemButton*)sender animated:(BOOL)animated {
    switch (_config.selectedPosition) {
        case ScrollMenuSelectedItemPositionMiddle:
        {
            CGFloat senderCenterX = sender.frame.origin.x + sender.frame.size.width/2;
            CGFloat minOffset = (_scrollView.frame.size.width/2 + _config.xOffset);
            CGFloat maxOffset = _scrollView.contentSize.width - _scrollView.frame.size.width/2 + _config.xOffset;

            if (animated) {
                [UIView animateWithDuration:0.3 animations:^{
                    if(senderCenterX < minOffset || self->_scrollView.contentSize.width <= self->_scrollView.frame.size.width) {//最左边的情况或者不满一屏，无法移动到中间的情况
                        [self->_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
                    } else if(senderCenterX > maxOffset && maxOffset > minOffset) {//最右边的情况，无法移动到中间的情况
                        [self->_scrollView setContentOffset:CGPointMake(self->_scrollView.contentSize.width-self->_scrollView.frame.size.width, 0) animated:NO];
                    } else {
                        [self->_scrollView setContentOffset:CGPointMake((senderCenterX-self->_scrollView.frame.size.width/2-self->_config.xOffset), 0) animated:NO];
                    }
                }];
            } else {
                if(senderCenterX < minOffset || _scrollView.contentSize.width <= _scrollView.frame.size.width) {//最左边的情况，无法移动到中间的情况
                    [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
                } else if(senderCenterX > maxOffset && maxOffset > minOffset) {//最右边的情况，无法移动到中间的情况
                    [_scrollView setContentOffset:CGPointMake(_scrollView.contentSize.width-_scrollView.frame.size.width, 0) animated:NO];
                } else {
                    [_scrollView setContentOffset:CGPointMake((senderCenterX-_scrollView.frame.size.width/2-_config.xOffset), 0) animated:NO];
                }
            }
        }
            break;
        case ScrollMenuSelectedItemPositionVisible:
        {
            if (animated) {
                [UIView animateWithDuration:0.3 animations:^{
                    if (sender.frame.origin.x < self->_scrollView.contentOffset.x) {
                        [self->_scrollView setContentOffset:CGPointMake(sender.frame.origin.x, 0) animated:NO];
                    } else if(self->_scrollView.contentOffset.x + self->_scrollView.frame.size.width < (sender.frame.origin.x + sender.frame.size.width)) {
                        [self->_scrollView setContentOffset:CGPointMake(sender.frame.origin.x + sender.frame.size.width -self->_scrollView.frame.size.width, 0) animated:NO];
                    }
                }];
            } else {
                if (sender.frame.origin.x < _scrollView.contentOffset.x) {
                    [_scrollView setContentOffset:CGPointMake(sender.frame.origin.x, 0) animated:NO];
                } else if(_scrollView.contentOffset.x + _scrollView.frame.size.width < (sender.frame.origin.x + sender.frame.size.width)) {
                    [_scrollView setContentOffset:CGPointMake(sender.frame.origin.x + sender.frame.size.width -_scrollView.frame.size.width, 0) animated:NO];
                }
            }

        }
        default:

            break;
    }
    [self adjustSelectedBottomLine:animated];
}

- (void)menuItemButtonPressed:(MenuItemButton*)sender {

    if (sender.index != _selectIdx) {
        _lastSelect.selected = NO;
        _lastUnSelect = _lastSelect;
        _selectIdx = sender.index;
        sender.selected = YES;
        _lastSelect = sender;
        [self updateItemsFrameAndContentSize];
        [self adjustOffsetWithSelectedItem:sender animated:YES];

        [self updateTitleBgViewCons:_lastSelect animated:YES];

        if ([self.delegate respondsToSelector:@selector(didSelectItem:)]) {
            [self.delegate didSelectItem:_selectIdx];
        }
    }
}

- (void)setSelectedIndex:(NSUInteger)index {
    [self setSelectedIndex:index animated:NO];
}

- (void)setSelectedIndex:(NSUInteger)index animated:(BOOL)animated {
    if (index < [_titles count]) {
        _lastSelect.selected = NO;
        _lastUnSelect = _lastSelect;
        _selectIdx = index;
        MenuItemButton *sender = (MenuItemButton*)[self viewWithTag:100+index];
        sender.selected = YES;
        _lastSelect = sender;
        [self updateItemsFrameAndContentSize];
        [self adjustOffsetWithSelectedItem:sender animated:animated];
        [self updateTitleBgViewCons:_lastSelect animated:animated];
    }
}
- (UIView *)getSelectBottomLine {
    return _selectedBottomLine;
}

@end
