//
//  YTOAppDelegate.m
//  i-asigurare
//
//  Created by Andi Aparaschivei on 7/12/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
//

#import "YTOAppDelegate.h"
#import "YTOUtils.h"
#import "YTOSetariViewController.h"
#import "YTOAsigurariViewController.h"
#import "YTOAlerteViewController.h"
#import "YTOAlteleViewController.h"
#import "YTOWelcomeViewController.h"
#import "YTOAlerta.h"
#import "YTOUserDefaults.h"

@implementation YTOAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize setariNavigationController;
@synthesize rcaNavigationController;
@synthesize alteleNavigationController;
@synthesize alerteNavigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    //UIViewController *viewWelcome = [[YTOWelcomeViewController alloc] initWithNibName:@"YTOWelcomeViewController" bundle:nil];

    //[self syncDataFromOldVersion];
    
    UIViewController *viewController0 = [[YTOSetariViewController alloc] initWithNibName:@"YTOSetariViewController" bundle:nil];
    self.setariNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController0];
    self.setariNavigationController.navigationBar.tintColor = [YTOUtils colorFromHexString:@"#4a4a4a"];
    
    UIViewController *viewController1 = [[YTOAsigurariViewController alloc] initWithNibName:@"YTOAsigurariViewController" bundle:nil];
    self.rcaNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController1];
    self.rcaNavigationController.navigationBar.tintColor = [YTOUtils colorFromHexString:@"#4a4a4a"];

   // self.tabBarController.tabBar.tintColor = [self colorFromHexString:@"#4a4a4a"];
    UIViewController *viewController2 = [[YTOAlerteViewController alloc] initWithNibName:@"YTOAlerteViewController" bundle:nil];
    self.alerteNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController2];
    self.alerteNavigationController.navigationBar.tintColor = [YTOUtils colorFromHexString:@"#4a4a4a"];
    
    UIViewController *viewController3 = [[YTOAlteleViewController alloc] initWithNibName:@"YTOAlteleViewController" bundle:nil];
    self.alteleNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController3];
    self.alteleNavigationController.navigationBar.tintColor = [YTOUtils colorFromHexString:@"#4a4a4a"];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:setariNavigationController, rcaNavigationController, alerteNavigationController, alteleNavigationController, nil];
    
    
    [self setAlerteBadge];
    
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    if ([YTOUserDefaults IsFirstTime])
        [self showTooltip];
    //[self.window addSubview: [viewWelcome view]];
  
    // stergem badge-urile cand intra in aplicatie..indiferent
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    
    [self copyDatabaseIfNeeded];
    
    id scheduledLocalNotification = nil;
    scheduledLocalNotification = 
    [launchOptions 
     valueForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    if (scheduledLocalNotification != nil){
        
        /* We received a local notification while 
         our application wasn't running. You can now typecase the
         ScheduledLocalNotification variable to UILocalNotification and
         use it in your application */
        
        // [self displayAlertWithTitle:@"i-Asigurare"
        //                     message:@"Notificare works"];
        [UIApplication sharedApplication].applicationIconBadgeNumber--;
        
    }
    
    NSLog(@"Registering for push notifications...");
    [[UIApplication sharedApplication]
     registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeAlert |
      UIRemoteNotificationTypeBadge |
      UIRemoteNotificationTypeSound)];
    
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
        
        [def setObject:versionPlist forKey:@"VersionApp"];
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

#pragma Notifications

- (void) initializeLocalNotifications:(NSDictionary *)launchOptions {
    
}

- (void)          application:(UIApplication *)application 
  didReceiveLocalNotification:(UILocalNotification *)notification{
    
    /* We will receive this message whenever our application
     is running in the background when the local notification
     is delivered. If the application is terminated and the
     local notification is viewed by the user, the
     application:didFinishLaunchingWithOptions: method will be
     called and the notification will be passed via the
     didFinishLaunchingWithOptions parameter */
    
    // [self displayAlertWithTitle:@"Local Notification"
    //                    message:@"The Local Notification is delivered."];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
}

- (BOOL) localNotificationWithMessage:(NSString *)paramMessage
                    actionButtonTitle:(NSString *)paramActionButtonTitle
                          launchImage:(NSString *)paramLaunchImage
                     applicationBadge:(NSInteger)paramApplicationBadge
                             fireDate:(NSDate*)date
                             userInfo:(NSDictionary *)paramUserInfo{
    
    UILocalNotification *notification = 
    [[UILocalNotification alloc] init];
    
    notification.alertBody = paramMessage;
    
    notification.alertAction = paramActionButtonTitle;
    
    if (paramActionButtonTitle != nil &&
        [paramActionButtonTitle length] > 0){
        /* Make sure we have the action button for the user to press
         to open our application */
        notification.hasAction = YES;
    } else {
        notification.hasAction = NO;
    }
    
    /* Here you have a chance to change the launch 
     image of your application when the notification's
     action is viewed by the user */
    notification.alertLaunchImage = paramLaunchImage;
    
    /* Change the badge number of the application once the
     notification is presented to the user. Even if the user
     dismisses the notification, the badge number of the
     application will change */
    notification.applicationIconBadgeNumber = paramApplicationBadge;
    
    /* This dictionary will get passed to your application
     later if and when the user decides to view this notification */
    notification.userInfo = paramUserInfo;
    
    /* We need to get the system time zone so that the alert view
     will adjust its fire date if the user's time zone changes */
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    notification.timeZone = timeZone;
    
    /* Schedule the delivery of this notification 10 seconds from
     now */
    //NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    //formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    
    //NSString * startDate = @"2011-11-18T11:40:00Z";
    //NSDate *fireDate = [NSDate date];//date;
    
    NSDate *fireDate = date;
    //[fireDate dateByAddingTimeInterval:paramHowManySecondsFromNow];
    
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    
    NSUInteger dateComponents = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    
    NSDateComponents *components = [calendar components:dateComponents
                                               fromDate:fireDate];
    [components setHour:10];
    [components setMinute:0];
    /* Here you have a chance to change these components. That's why we
     retrieved the components of the date in the first place. */
    
    fireDate = [calendar dateFromComponents:components];
    
    /* Finally set the schedule date for this notification */
    notification.fireDate = fireDate;
    
    [[UIApplication sharedApplication] 
     cancelAllLocalNotifications];
    
    [[UIApplication sharedApplication]
     scheduleLocalNotification:notification];
    
    return(YES);
    
}

- (void) setLocalNotification:(NSString *)message date:(NSDate*)date; {
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    
    // Get the current date
    NSDate *pickerDate = [date dateByAddingTimeInterval:-120*3600];
    
    // Break the date up into components
    NSDateComponents *dateComponents = [calendar components:( NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit )
												   fromDate:pickerDate];
    NSDateComponents *timeComponents = [calendar components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit )
												   fromDate:pickerDate];
    // Set up the fire time
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setDay:[dateComponents day]];
    [dateComps setMonth:[dateComponents month]];
    [dateComps setYear:[dateComponents year]];
    [dateComps setHour:13];
	// Notification will fire in one minute
    [dateComps setMinute:12];
	[dateComps setSecond:[timeComponents second]];
    NSDate *itemDate = [calendar dateFromComponents:dateComps];
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    localNotif.fireDate = itemDate;
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
	// Notification details
    localNotif.alertBody = message;
	// Set the action button
    localNotif.alertAction = @"i-Asigurare";
    
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 1;
    
	// Specify custom data for the notification
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"someValue" forKey:@"someKey"];
    localNotif.userInfo = infoDict;
    
	// Schedule the notification
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    
    //    [self localNotificationWithMessage:message
    //                     actionButtonTitle:nil
    //                           launchImage:nil
    //                      applicationBadge:1
    //                              fireDate:
    //                              userInfo:nil];
    
    // [self displayAlertWithTitle:@"i-Asigurare"
    //                     message:@"Notificarea a fost setata \
    va aparea in 30 sec."];
}

- (NSMutableArray *) Persoane
{
    YTOPersoana * p = [[YTOPersoana alloc] init];
    if (_persoane.count == 0)
        _persoane = [p getPersoane];
    return _persoane;
}

- (NSMutableArray *) Masini
{
    if (_masini.count == 0)
        _masini = [YTOAutovehicul Masini];
    return  _masini;
}

- (NSMutableArray *) Locuinte
{
    if (_locuinte.count == 0)
        _locuinte = [YTOLocuinta Locuinte];
    return  _locuinte;
}

- (NSMutableArray *) Alerte
{
    if (_alerte.count == 0)
        _alerte = [YTOAlerta Alerte];
    return  _alerte;
}

- (void) refreshPersoane
{
    _persoane = nil;
}

- (void) refreshMasini
{
    _masini = nil;
}

- (void) refreshLocuinte
{
    _locuinte = nil;
}

- (void) refreshAlerte
{
    _alerte = nil;
}

- (void) syncDataFromOldVersion
{
   
}


#pragma PUSH NOTIFICATION
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *str = [NSString
                     stringWithFormat:@"%@",deviceToken];
    [self saveDeviceToken:[[[str stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""]];
    
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    NSLog(@"%@",str);
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    for (id key in userInfo) {
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }    
    
}

-(void)saveDeviceToken:(NSString *)token
{
    @autoreleasepool
    {
        NSString *  kLogCallUrl = [NSString stringWithFormat:@"%@sync.asmx", LinkAPI];
        
        NSString *	udid = [UIDevice currentDevice].uniqueIdentifier;
        NSString *  platforma = [[UIDevice currentDevice].model stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        //NSString *params = [NSURL URLWithString:[NSString stringWithFormat:@"udid=%@&token=%@&platforma=%@", udid,token, platforma]];
        
        NSString * xml = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
        "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
            "<soap:Body>"
                "<SaveDeviceToken xmlns=\"http://tempuri.org/\">"
                "<user>vreaurca</user>"
                "<password>123</password>"
                "<udid>%@</udid>"
                "<token>%@</token>"
                "<platforma>%@</platforma>"
                "</SaveDeviceToken>"
            "</soap:Body>"
        "</soap:Envelope>", udid, token, platforma];
        
        NSURL * url = [NSURL URLWithString:kLogCallUrl];
        
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:15.0];
        
        NSString * parameters = [[NSString alloc] initWithString:xml];
        NSLog(@"Request=%@", parameters);
        NSString * msgLength = [NSString stringWithFormat:@"%d", [parameters length]];
        
        [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request addValue:@"http://tempuri.org/SaveDeviceToken" forHTTPHeaderField:@"SOAPAction"];
        [request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        if (connection) {
            NSLog(@"%@",[NSMutableData data]);
        }
    }
}

- (void) showTooltip
{
    indexTooltip = 0;
    listImgTooltip = [[NSMutableArray alloc] initWithObjects:@"tooltip1.png",@"tooltip2.png", @"tooltip3.png", nil];
    
    viewTooltip = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    img.tag = 1;
    [img setImage:[UIImage imageNamed:@"tooltip1.png"]];
    [viewTooltip addSubview:img];
    
    UIButton * btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    btnClose.tag = 2;
    btnClose.frame = CGRectMake(16, 397, 67, 37);
    [btnClose addTarget:self action:@selector(closeTooltip) forControlEvents:UIControlEventTouchUpInside];
    [viewTooltip addSubview:btnClose];
    
    UIButton * btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
    btnNext.frame = CGRectMake(95, 397, 67, 37);
    [btnNext addTarget:self action:@selector(nextTooltip) forControlEvents:UIControlEventTouchUpInside];
    [viewTooltip addSubview:btnNext];
    
    [self.window addSubview:viewTooltip];
    
    [YTOUserDefaults setFirstTime:YES];
}

- (void)nextTooltip
{
    indexTooltip++;
    if (indexTooltip == 2)
    {
        UIButton * btnClose = (UIButton *)[viewTooltip viewWithTag:2];
        btnClose.frame = CGRectMake(245, 397, 67, 37);
    }
    UIImageView * img = (UIImageView *)[viewTooltip viewWithTag:1];
    img.image = [UIImage imageNamed:[listImgTooltip objectAtIndex:indexTooltip]];
    
}

- (void) closeTooltip
{
    [viewTooltip removeFromSuperview];
}

- (void) setAlerteBadge
{
    int nrAlerte = [YTOAlerta GetNrAlerteScadente];
    if (nrAlerte>0)
        [[[self.tabBarController.tabBar items] objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%d", nrAlerte]];
    else
        [[[self.tabBarController.tabBar items] objectAtIndex:2] setBadgeValue:nil];
}

@end
