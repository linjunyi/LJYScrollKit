//
//  HotTextViewController.h
//  LSYScrollKitDemo
//
//  Created by 林君毅 on 2022/5/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChildDemoVC : UIViewController

- (id)initWithIndex:(NSInteger)index listCount:(NSInteger)listCount;

- (UIScrollView *)currentScrollView;

@end

NS_ASSUME_NONNULL_END
