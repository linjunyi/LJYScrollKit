//
//  AppDelegate.m
//  LSYScrollKitDemo
//
//  Created by 林君毅 on 2022/5/27.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "Macro.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UINavigationBar appearance] setBackgroundColor: UIColorFromRGB(0x3c7cfc)];
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window = window;
    UINavigationController *nav = [UINavigationController new];
    [nav pushViewController:[ViewController new] animated:NO];
    [window makeKeyAndVisible];
    window.rootViewController = nav;
    return YES;
}

@end
