//
//  YTOAppDelegate.h
//  i-asigurare
//
//  Created by Administrator on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YTOAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>
{

}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

@property (nonatomic, strong) UINavigationController * rcaNavigationController;

@end
