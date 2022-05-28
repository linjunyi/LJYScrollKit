# LJYScrollKit
LJYScrollKi用于处理单页面添加多个scrollView的复杂应用场景。

## 实现功能
### ShareHeaderScrollManager
* 一个父ScrollView嵌套若干个子ScrollView, 实现父子ScrollView联动，且滑动到一定范围时顶部悬浮窗。

```objc
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
```

![ShareHeaderDemo](https://user-images.githubusercontent.com/10485682/170821348-0830cc26-df99-40d1-9b27-7ea1b9fbeef1.gif)
