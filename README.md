# LJYScrollKit
LJYScrollKi用于处理单页面添加多个页面的复杂应用场景，包括
 - 多级scrollview嵌套
 - 为任意view添加左右翻页功能
 - 自定义样式menu
 - 单页面包含多个子功能页面

## 实现功能
### ShareHeaderScrollManager
一个父ScrollView嵌套若干个子ScrollView, 实现父子ScrollView联动，且滑动到一定范围时顶部悬浮。

```objc
    _scrollManager = [[ShareHeaderScrollManager alloc] initWithMainView:_mainScrollView scrollBlock:
                      ^(UIScrollView * _Nonnull scrollView, BOOL isMainView) {
        // 滑动回调
    }];
    
    // mainView的竖直偏移在min~max的范围内时，Header View才会与下方的ScrollView联动。
    // max最大值内部限制为mainView.content.height-mainView.height。
    // 动态获取y_anchor
    _scrollManager.update_y_anchor = ^AnchorRange{
        return AnchorRangeMake(0, _headerView.frame.origin.x+_headerView.frame.size.height-FloatMenuHeight);
    };
    [_scrollManager addScrollViews:@[
        [subVC1 currentScrollView],
        [subVC2 currentScrollView],
        [subVC3 currentScrollView],
    ]];
```

![ShareHeaderDemo](https://user-images.githubusercontent.com/10485682/170923492-3b68158c-33a7-472f-8c6b-f029ba1c280b.gif)

### ScrollPageHandler
将view等分成若干页面，并为其添加左右翻页功能。

```objc
    _scrollPageHandler = [[ScrollPageHandler alloc] initWithContentView:_containerView 
                                                              pageWidth:pageWidth 
                                                       currentPageIndex:0 
                                                              pageCount:3];
    _scrollPageHandler.scrollPageWillChangePage = ^(BOOL animated) {
        //翻页前调用
    };
    _scrollPageHandler.scrollPageDidPageChanged = ^(BOOL animated) {
        //翻页后调用
    };
    
    /// 若单页面的宽度发生变化（例如横竖屏切换导致的重布局）,需调用-updatePageWidth:更新pageWidth，
    /// 且方法内部会根据currentPageIndex重新计算contentView的偏移位置。
    [_scrollPageHandler updatePageWidth:nPageWidth];
```

![ScrollPageHandlerDemo](https://user-images.githubusercontent.com/10485682/170923091-3468dffc-c3ef-455c-accf-6e8b85be9275.gif)

### ScrollMenuView
自定义样式menu

```objc
    /// 初始化config
    ScrollMenuConfig *config = [[ScrollMenuConfig alloc] init];
    config.normalFont = [UIFont systemFontOfSize:15];
    config.selectFont = [UIFont italicSystemFontOfSize:19];
    config.selectColor = UIColorFromRGB(0x14161A);
    config.normalColor = UIColorFromRGB(0x73757B);
    config.selectedPosition = ScrollMenuSelectedItemPositionMiddle;
    
    // 生成menuView
    ScrollMenuView *menuView = [[ScrollMenuView alloc] initWithTitleArray:titles config:config];
    menuView.frame = CGRectMake(0, 100, self.view.frame.size.width, 44);
    [self.view addSubview:menuView];
```

![ScrollMenuDemo](https://user-images.githubusercontent.com/10485682/170922754-99fbe598-de4c-463e-ae11-3fcc4d45165c.gif)
