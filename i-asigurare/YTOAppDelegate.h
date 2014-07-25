//
//  YTOAppDelegate.h
//  i-asigurare
//
//  Created by Andi Aparaschivei on 7/12/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iRate.h"

@interface YTOAppDelegate : UIResponder <NSXMLParserDelegate, UIApplicationDelegate, UITabBarControllerDelegate>
{
    NSMutableArray * _persoane;
    NSMutableArray * _masini;
    NSMutableArray * _locuinte;    
    NSMutableArray * _alerte;
    
    UIView * viewTooltip;
    int indexTooltip;
    NSMutableArray * listImgTooltip;
    

    NSString * version;
    NSString * pushToken;
    NSMutableData * responseData;
	NSMutableString * currentElementValue;
    
    NSString * newUdidResult;
    
    UIBackgroundTaskIdentifier  bgTask;
    BOOL hasVisitedSaveDeviceToken;
}

@property (nonatomic, retain) NSMutableData * responseData;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (nonatomic, strong) UINavigationController * setariNavigationController;
@property (nonatomic, strong) UINavigationController * rcaNavigationController;
@property (nonatomic, strong) UINavigationController * alerteNavigationController;
@property (nonatomic, strong) UINavigationController * contNavigationController;
@property (nonatomic, strong) UINavigationController * alteleNavigationController;

- (void) writeNewDatabaseCopy;
- (void) copyDatabaseIfNeeded;
- (NSString *) getDBPath;

- (void) showTooltip;
- (void) refreshPersoane;
- (void) refreshMasini;
- (void) refreshLocuinte;
- (void) refreshAlerte;


- (NSMutableArray *) Masini;
- (NSMutableArray *) Persoane;
- (NSMutableArray *) Locuinte;
- (NSMutableArray *) Alerte;

- (void) syncDataFromOldVersion;
- (void) setAlerteBadge;

@end
