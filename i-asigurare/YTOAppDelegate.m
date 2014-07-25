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
#import "Crittercism.h"

#import "YTOLoginViewController.h"
#import "VerifyNet.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation YTOAppDelegate

@synthesize responseData;
@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize setariNavigationController;
@synthesize rcaNavigationController;
@synthesize alteleNavigationController;
@synthesize alerteNavigationController;
@synthesize contNavigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [self copyDatabaseIfNeeded];

   [YTOUserDefaults setLanguage:@"en"];
//    [YTOUserDefaults setLanguage:@"hu"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    //UIViewController *viewWelcome = [[YTOWelcomeViewController alloc] initWithNibName:@"YTOWelcomeViewController" bundle:nil];

    //[self syncDataFromOldVersion];
    
    UIViewController *viewController0;
    if (IS_IPHONE_5)
        viewController0 = [[YTOSetariViewController alloc] initWithNibName:@"YTOSetariViewController_R4" bundle:nil];
    else
        viewController0 = [[YTOSetariViewController alloc] initWithNibName:@"YTOSetariViewController" bundle:nil];
        
    self.setariNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController0];
    self.setariNavigationController.navigationBar.tintColor = [YTOUtils colorFromHexString:@"#4a4a4a"];
    
    
    UIViewController *viewController1;
    if (IS_IPHONE_5)
        viewController1 = [[YTOAsigurariViewController alloc] initWithNibName:@"YTOAsigurariViewController_R4" bundle:nil];
    else
        viewController1= [[YTOAsigurariViewController alloc] initWithNibName:@"YTOAsigurariViewController" bundle:nil];
    self.rcaNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController1];
    self.rcaNavigationController.navigationBar.tintColor = [YTOUtils colorFromHexString:@"#4a4a4a"];


   // self.tabBarController.tabBar.tintColor = [self colorFromHexString:@"#4a4a4a"];
    YTOAlerteViewController * viewController2;
    if (IS_IPHONE_5)
         viewController2 = [[YTOAlerteViewController alloc] initWithNibName:@"YTOAlerteViewController_R4" bundle:nil];
    else viewController2 = [[YTOAlerteViewController alloc] initWithNibName:@"YTOAlerteViewController" bundle:nil];
    //UIViewController *viewController2 = [[YTOAlerteViewController alloc] initWithNibName:@"YTOAlerteViewController" bundle:nil];
    self.alerteNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController2];
    self.alerteNavigationController.navigationBar.tintColor = [YTOUtils colorFromHexString:@"#4a4a4a"];

    UIImageView *navImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"p"]];
    [navImage setCenter:CGPointMake(0, 0)];
    [self.alerteNavigationController.navigationBar addSubview: navImage];
    
    UIViewController *viewController3 = [[YTOAlteleViewController alloc] initWithNibName:@"YTOAlteleViewController" bundle:nil];
    self.alteleNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController3];
    self.alteleNavigationController.navigationBar.tintColor = [YTOUtils colorFromHexString:@"#4a4a4a"];

    
    UIViewController *viewController4;
    if (IS_IPHONE_5)
        viewController4 = [[YTOLoginViewController alloc] initWithNibName:@"YTOLoginViewController_R4" bundle:nil];
    else viewController4 = [[YTOLoginViewController alloc] initWithNibName:@"YTOLoginViewController" bundle:nil];
    self.contNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController4];
    self.contNavigationController.navigationBar.tintColor = [YTOUtils colorFromHexString:@"#4a4a4a"];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:rcaNavigationController, setariNavigationController,alerteNavigationController,contNavigationController, alteleNavigationController, nil];
    
    
    [self setAlerteBadge];
    
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
//    if ([YTOUserDefaults IsFirstTime])
        [self showTooltip];
    //[self.window addSubview: [viewWelcome view]];
  
    // stergem badge-urile cand intra in aplicatie..indiferent
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
   //     
    
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
    
    //NU FUNCTIONEAZA   
  //  [Crittercism enableWithAppID: @"512620888cb83166c1000a68"];
    
//    [[GAITracker sharedTracker] startTrackerWithAccountID:@"UA-15609865-3"
//                                           dispatchPeriod:10
//                                                 delegate:nil];
    
    //when the user first launches the app
//    NSError *error;
//    if (![[GAITracker sharedTracker] trackPageview:@"/app_launched"
//                                         withError:&amperror]) {
//        // Handle error here
//    }
    
    // Optional: automatically send uncaught exceptions to Google Analytics.
    //[GAI sharedInstance].trackUncaughtExceptions = YES;
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    //[GAI sharedInstance].dispatchInterval = 20;
    // Optional: set debug to YES for extra debugging information.
//    [GAI sharedInstance].debug = NO;
//    // Create tracker instance.
//    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-8624521-11"];
//
//    [GAI sharedInstance].optOut = YES;
    
    NSLog(@"Registering for push notifications...");
    [[UIApplication sharedApplication]
     registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeAlert |
      UIRemoteNotificationTypeBadge |
      UIRemoteNotificationTypeSound)];
    
    version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    
    //NSLog(@"apel new udid");
    
    
    [YTOUserDefaults setLanguage:@"en"];
   // [YTOUserDefaults setLanguage:@"hu"];

    
    return YES;
    
}



- (void) registerUdidUpdated
{
//    NSLog(@"%@",[NSString stringWithFormat:@"Udid updated: %d, version: %@", [YTOUserDefaults isUdidUpdated], version]);
//    
//    VerifyNet * vn = [[VerifyNet alloc] init];
//    if (![YTOUserDefaults isUdidUpdated] && [vn hasConnectivity])
//    {
//        NSString * idInternRca=@"";
//        NSString * serieSasiu=@"";
//        NSString * email=@"";
//        NSString * codUnic=@"";
//        if ([self.Masini count] > 0)
//        {
//            YTOAutovehicul * masina = (YTOAutovehicul*)[self.Masini objectAtIndex:0];
//            idInternRca = masina != nil ? masina.idIntern : @"";
//            serieSasiu = masina != nil ? masina.serieSasiu : @"";
//        }
//        
//        NSString * idInternLocuinta = @"";
//        if ([self.Locuinte count] > 0)
//        {
//            YTOLocuinta * locuinta = (YTOLocuinta*)[self.Locuinte objectAtIndex:0];
//            idInternLocuinta = locuinta != nil ? locuinta.idIntern : @"";
//        }
//        
//        NSString * idInternPersoana = @"";
//        YTOPersoana * persoana = [YTOPersoana Proprietar];
//        if (persoana == nil && [self.Persoane count] > 0)
//        {
//            persoana = (YTOPersoana*)[self.Persoane objectAtIndex:0];
//        }
//        if (persoana != nil)
//        {
//            idInternPersoana = persoana != nil ? persoana.idIntern :@"";
//            email = persoana != nil ? persoana.email : @"";
//            codUnic = persoana != nil ? persoana.codUnic : @"";
//        }
//        
//        NSString * xmlRequest = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
//                                 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
//                                 "<soap:Body>"
//                                 "<RegisterNewUdid xmlns=\"http://tempuri.org/\">"
//                                 "<user>vreaurca</user>"
//                                 "<password>123</password>"
//                                 "<push_token>%@</push_token>"
//                                 "<idintern_rca>%@</idintern_rca>"
//                                 "<idintern_locuinta>%@</idintern_locuinta>"
//                                 "<idintern_persoana>%@</idintern_persoana>"
//                                 "<cod_unic>%@</cod_unic>"
//                                 "<email>%@</email>"                                 
//                                 "<serie_sasiu>%@</serie_sasiu>"
//                                 "<new_udid>%@</new_udid>"
//                                 "<platforma>%@</platforma>"
//                                 "</RegisterNewUdid>"
//                                 "</soap:Body>"
//                                 "</soap:Envelope>",
//                                 pushToken == nil ? @"" : pushToken,
//                                 idInternRca,
//                                 idInternLocuinta,
//                                 idInternPersoana, codUnic, email, serieSasiu, [[UIDevice currentDevice] xUniqueDeviceIdentifier],
//                                 [[UIDevice currentDevice].model stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
//        
//        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@sync.asmx", LinkAPI]];
//        
//        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
//                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
//                                                            timeoutInterval:10.0];
//        
//        NSString * parameters = [[NSString alloc] initWithString:xmlRequest];
//        NSLog(@"Request=%@", parameters);
//        NSString * msgLength = [NSString stringWithFormat:@"%d", [parameters length]];
//        
//        [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//        [request addValue:@"http://tempuri.org/RegisterNewUdid" forHTTPHeaderField:@"SOAPAction"];
//        [request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
//        [request setHTTPMethod:@"POST"];
//        [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
//        
//        NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//        
//        if (connection) {
//            self.responseData = [NSMutableData data];
//        }
//    }
//    else
    if (pushToken != nil && pushToken.length > 0 && hasVisitedSaveDeviceToken == NO)
    {
        [self saveDeviceToken:pushToken];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"Response: %@", [response textEncodingName]);
	[self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSLog(@"connection:DidReceiveData");
	[self.responseData appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
	NSString * responseString = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
	NSLog(@"Response string: %@", responseString);

    NSXMLParser * xmlParser = [[NSXMLParser alloc] initWithData:responseData];
	xmlParser.delegate = self;
	BOOL succes = [xmlParser parse];

    if (succes) {
        
        if ([newUdidResult isEqualToString:@"ok"])
        [YTOUserDefaults setUdidUpdated:YES];
        
    }

    if (pushToken != nil && pushToken.length > 0 && hasVisitedSaveDeviceToken == NO)
        [self saveDeviceToken:pushToken];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"connection:didFailWithError:");
	NSLog(@"%@", [error localizedDescription]);
    
    if (pushToken != nil && pushToken.length > 0 && hasVisitedSaveDeviceToken == NO)
        [self saveDeviceToken:pushToken];
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
	attributes:(NSDictionary *)attributeDict {
	
	if ([elementName isEqualToString:@"return"])
		return;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {

    if ([elementName isEqualToString:@"RegisterNewUdidResult"])
        newUdidResult = currentElementValue;
    
	currentElementValue = nil;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if(!currentElementValue)
		currentElementValue = [[NSMutableString alloc] initWithString:string];
	else
		[currentElementValue appendString:string];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
//    UIApplication *app = [UIApplication sharedApplication];
//    
//    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
//        [app endBackgroundTask:bgTask];
//        bgTask = UIBackgroundTaskInvalid;
//    }];
//    
//    UIDevice * device = [UIDevice currentDevice];
//    BOOL backgroundTasksSupported = NO;
//    
//    if ([device respondsToSelector:@selector(isMultitaskingSupported)]) {
//        backgroundTasksSupported = device.multitaskingSupported;
//    }
//    
//    if (backgroundTasksSupported) {
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        [[GAI sharedInstance] dispatch];
//        
//        [app endBackgroundTask:bgTask];
//        bgTask = UIBackgroundTaskInvalid;
//    });
//    }
//    else {
//        [[GAI sharedInstance] dispatch];
//    }
    
    
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
    YTOAsigurariViewController * view = [[YTOAsigurariViewController alloc] init];
    [view setButtonNotificariBackground ];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // stergem badge-urile cand intra in aplicatie..indiferent
  //
//  [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    
    [FBSettings publishInstall:@"437288059690040"];
//    [YTOUserDefaults setSyncronized:NO];
    [YTOUserDefaults setLanguage:@"en"];//SET LANGUAGE
    [YTOUserDefaults setIsFirstCalc:NO];
   // [YTOUserDefaults setPassword:@"4d0741ab3d52b5caf5699e8da434384d"];
    
  //  [YTOUserDefaults setLanguage:@"hu"];
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
		//NSString * versionApp = [def objectForKey:@"VersionApp"];
		//if (![versionPlist isEqualToString:versionApp]) {
		//	[def setObject:versionPlist forKey:@"VersionApp"];
			//[self writeNewDatabaseCopy];
		//}
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
    localNotif.applicationIconBadgeNumber++; //
    
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
    NSString * token = [[[str stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""];

    pushToken =token; //token;
    
   [self registerUdidUpdated];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    NSLog(@"%@",str);

    [self registerUdidUpdated];
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
        hasVisitedSaveDeviceToken = YES;
        
        NSString *  kLogCallUrl = [NSString stringWithFormat:@"%@sync.asmx", LinkAPI];
        
        NSString *	udid = [[UIDevice currentDevice] xUniqueDeviceIdentifier];
        NSString *  platforma = [[UIDevice currentDevice].model stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        //NSString *params = [NSURL URLWithString:[NSString stringWithFormat:@"udid=%@&token=%@&platforma=%@", udid,token, platforma]];
        NSLog(@"%@",token);
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
        [YTOUserDefaults setPushToken:token];
        
        NSURL * url = [NSURL URLWithString:kLogCallUrl];
        
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:30.0];
        
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
    
    if (IS_IPHONE_5) {
        UISwipeGestureRecognizer *swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(previousTooltip)];
        [swipeGestureRight setDirection:UISwipeGestureRecognizerDirectionRight];
        UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextTooltip)];
        [swipeGestureLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
        listImgTooltip = [[NSMutableArray alloc] initWithObjects:@"tooltip11.png",@"tooltip12.png", @"tooltip13.png", nil];
        viewTooltip = [[UIView alloc] initWithFrame:CGRectMake(0,68, 320, 455)];
        [viewTooltip addGestureRecognizer: swipeGestureRight];
        [viewTooltip addGestureRecognizer: swipeGestureLeft];
        UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 455)];
        img.tag = 1;
        [img setImage:[UIImage imageNamed:@"tooltip11.png"]];
        [viewTooltip addSubview:img];

        UIButton * btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
        btnClose.tag = 2;
        btnClose.frame = CGRectMake(5, 341, 85, 35);
        [btnClose addTarget:self action:@selector(previousTooltip) forControlEvents:UIControlEventTouchUpInside];
        [viewTooltip addSubview:btnClose];
        
        UIButton * btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
        btnNext.frame = CGRectMake(235, 341, 150, 35);
        [btnNext addTarget:self action:@selector(nextTooltip) forControlEvents:UIControlEventTouchUpInside];
        [viewTooltip addSubview:btnNext];
    }
    else {
        listImgTooltip = [[NSMutableArray alloc] initWithObjects:@"tooltip11.png",@"tooltip12.png", @"tooltip13.png", nil];
        UISwipeGestureRecognizer *swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(previousTooltip)];
        [swipeGestureRight setDirection:UISwipeGestureRecognizerDirectionRight];
        UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextTooltip)];
        [swipeGestureLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
        viewTooltip = [[UIView alloc] initWithFrame:CGRectMake(0, 68, 320, 416)];
        [viewTooltip addGestureRecognizer: swipeGestureRight];
        [viewTooltip addGestureRecognizer: swipeGestureLeft];
        UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
        img.tag = 1;
        [img setImage:[UIImage imageNamed:@"tooltip11.png"]];
        [viewTooltip addSubview:img];
    
    UIButton * btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    btnClose.tag = 2;
    btnClose.frame = CGRectMake(0, 320, 85, 35);
    [btnClose addTarget:self action:@selector(previousTooltip) forControlEvents:UIControlEventTouchUpInside];
    [viewTooltip addSubview:btnClose];
    
    UIButton * btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
    btnNext.frame = CGRectMake(169, 320, 150, 35);
    [btnNext addTarget:self action:@selector(nextTooltip) forControlEvents:UIControlEventTouchUpInside];
    [viewTooltip addSubview:btnNext];
    }
    
    [self.window addSubview:viewTooltip];
    
    [YTOUserDefaults setFirstTime:YES];
}


- (void)nextTooltip
{
    if (indexTooltip >= 2){
        [viewTooltip removeFromSuperview];
        return;
    }
    indexTooltip++;
    UIImageView * img = (UIImageView *)[viewTooltip viewWithTag:1];
    img.image = [UIImage imageNamed:[listImgTooltip objectAtIndex:indexTooltip]];
    
}



- (void) previousTooltip
{
    if (indexTooltip == 0){
        return;
    }
    indexTooltip--;
    UIImageView * img = (UIImageView *)[viewTooltip viewWithTag:1];
    img.image = [UIImage imageNamed:[listImgTooltip objectAtIndex:indexTooltip]];
}

- (void) setAlerteBadge
{
    int nrAlerte = [YTOAlerta GetNrAlerteScadente];
    if (nrAlerte>0)
        [[[self.tabBarController.tabBar items] objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%d", nrAlerte]];
    else
        [[[self.tabBarController.tabBar items] objectAtIndex:2] setBadgeValue:nil];
}

+ (void)initialize
{
    //configure iRate
    [iRate sharedInstance].appStoreID = 451967152;

    //[iRate sharedInstance].debug = YES;
    [iRate sharedInstance].previewMode = NO;
    [iRate sharedInstance].onlyPromptIfLatestVersion = NO;
    [iRate sharedInstance].usesCount ++;
    [iRate sharedInstance].eventCount=0;
    [iRate sharedInstance].promptAtLaunch = NO;
}


@end

@implementation UINavigationBar(MyNavigationBar)
- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed: @"powered_by_vdf.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
@end
