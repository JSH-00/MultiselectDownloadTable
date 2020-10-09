//
//  AppDelegate.m
//  MultiselectDownloadTable
//
//  Created by JSH on 2020/10/5.
//

#import "AppDelegate.h"
#import "MultiselectTableViewController.h"
#import "TableViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    MultiselectTableViewController *vc1 = [[MultiselectTableViewController alloc] init];
    TableViewController * vc2 = [TableViewController new];
    UINavigationController *vc1_NA = [[UINavigationController alloc] initWithRootViewController:vc1];
    self.window.rootViewController = vc1_NA;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application{
    
}
- (void)applicationDidEnterBackground:(UIApplication *)application{
    
}
- (void)applicationWillEnterForeground:(UIApplication *)application{
    
}
- (void)applicationDidBecomeActive:(UIApplication *)application{
    
}
- (void)applicationWillTerminate:(UIApplication *)application{
    
}
@end
