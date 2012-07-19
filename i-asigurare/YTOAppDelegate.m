//
//  YTOAppDelegate.m
//  i-asigurare
//
//  Created by Administrator on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YTOAppDelegate.h"
#import "YTOUtils.h"
#import "YTOSetariViewController.h"
#import "YTOAsigurariViewController.h"
#import "YTOAlerteViewController.h"
#import "YTOAlteleViewController.h"

@implementation YTOAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize setariNavigationController;
@synthesize rcaNavigationController;
@synthesize alteleNavigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    UIViewController *viewController0 = [[YTOSetariViewController alloc] initWithNibName:@"YTOSetariViewController" bundle:nil];
    self.setariNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController0];
    self.setariNavigationController.navigationBar.tintColor = [YTOUtils colorFromHexString:@"#4a4a4a"];
    
    UIViewController *viewController1 = [[YTOAsigurariViewController alloc] initWithNibName:@"YTOAsigurariViewController" bundle:nil];
    self.rcaNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController1];
    self.rcaNavigationController.navigationBar.tintColor = [YTOUtils colorFromHexString:@"#4a4a4a"];

   // self.tabBarController.tabBar.tintColor = [self colorFromHexString:@"#4a4a4a"];
    UIViewController *viewController2 = [[YTOAlerteViewController alloc] initWithNibName:@"YTOAlerteViewController" bundle:nil];
    
    UIViewController *viewController3 = [[YTOAlteleViewController alloc] initWithNibName:@"YTOAlteleViewController" bundle:nil];
    self.alteleNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController3];
    self.alteleNavigationController.navigationBar.tintColor = [YTOUtils colorFromHexString:@"#4a4a4a"];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:setariNavigationController,rcaNavigationController, viewController2, alteleNavigationController, nil];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    [self copyDatabaseIfNeeded];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

#pragma SQLITE Stuff
- (void) copyDatabaseIfNeeded {
	
	//Using NSFileManager we can perform many file system operations.
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSString *dbPath = [self getDBPath];
	BOOL success = [fileManager fileExistsAtPath:dbPath]; 
	
	NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
	NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
	NSString* versionPlist = [infoDict objectForKey:@"CFBundleVersion"];
	
	if(!success) {
		
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"vreau_rca.sqlite"];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
		
		if (!success) 
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}
	else {
		NSString * versionApp = [def objectForKey:@"VersionApp"];
		if (![versionPlist isEqualToString:versionApp]) {
			[def setObject:versionPlist forKey:@"VersionApp"];		
			[self writeNewDatabaseCopy];
		}
	}
}

- (void) writeNewDatabaseCopy {
	
	//Using NSFileManager we can perform many file system operations.
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSString *dbPath = [self getDBPath];
	[fileManager removeItemAtPath:dbPath error:NULL];
	BOOL success = [fileManager fileExistsAtPath:dbPath]; 
	
	if(!success) {
		
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"vreau_rca.sqlite"];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
		
		if (!success) 
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}	
}

- (NSString *) getDBPath {
	
	//Search for standard documents using NSSearchPathForDirectoriesInDomains
	//First Param = Searching the documents directory
	//Second Param = Searching the Users directory and not the System
	//Expand any tildes and identify home directories.
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:@"vreau_rca.sqlite"];
}

@end
