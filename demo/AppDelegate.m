//
//  AppDelegate.m
//  demo
//
//  Created by huamulou on 14-9-3.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <TAESDK/TaeSDK.h>
#import "AppDelegate.h"
#import "UIImageView+AFNetworking.h"
#import "SDWebImageManager.h"

void UncaughtExceptionHandler(NSException *exception) {
    NSArray *arr = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];

    NSString *urlStr = [NSString stringWithFormat:@"mailto://mulou.zzy@taobao.com"
                                                          "错误详情:<br>%@<br>--------------------------<br>%@<br>---------------------<br>%@",
                                                  name, reason, [arr componentsJoinedByString:@"<br>"]];

    NSLog(@"%@", urlStr);
}

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    NSMutableArray *itemsArray = [[NSMutableArray alloc] init];

    NSArray *controllerArray = [NSArray arrayWithObjects:@"MainViewController", @"CategoryViewController", @"MyViewController", nil];//类名数组
    NSArray *titleArray = [NSArray arrayWithObjects:@"首页", @"分类", @"我的", nil];//item标题数组
    NSArray *normalImageArray = [NSArray arrayWithObjects:@"tabs_main.png", @"tabs_category.png", @"tabs_my.png", nil];//item 正常状态下的背景图片
    NSArray *selectedImageArray = [NSArray arrayWithObjects:@"tabs_main_s.png", @"tabs_category_s.png", @"tabs_my_s.png", nil];//item被选中时的图片名称

    for (int i = 0; i < controllerArray.count; i++) {

        CCTabBarItemModel *itemModel = [[CCTabBarItemModel alloc] init];
        itemModel.controllerName = controllerArray[i];
        itemModel.itemTitle = titleArray[i];
        itemModel.itemImageName = normalImageArray[i];
        itemModel.selectedItemImageName = selectedImageArray[i];
        [itemsArray addObject:itemModel];
    }

    CCTabBarViewController *tabBarController = [[CCTabBarViewController alloc] initWithItemModels:itemsArray defaultSelectedIndex:0];
    [tabBarController setValue:@"#FFFFFF" forKey:@"_color"];//设置tabBar的背景图片

    self.window.rootViewController = tabBarController;

    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);


    //self.imageEngine = [[ImageEngine alloc] init];
    //[self.imageEngine useCache];

   // [UIImageView setDefaultEngine:self.imageEngine];

    // Override point for customization after application launch.
//   [[[SDWebImageManager sharedManager] imageCache] clearMemory];
//   [[[SDWebImageManager sharedManager] imageCache] clearDisk];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTintColor:VIEW_THEME_COLOR];
    
    [[TaeSDK sharedInstance] setTaeSDKEnvironment:TaeSDKEnvironmentRelease];
    //    [[TaeSDK sharedInstance] setTaeSDKEnvironment:TaeSDKEnvironmentDaily];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [[SDImageCache sharedImageCache] clearMemory];

}



- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    //改URL是否已经被TAE处理过
   [[TaeSDK sharedInstance] handleOpenURL:url];
    //开发者继续自己处理
    
    return YES;
}



@end
