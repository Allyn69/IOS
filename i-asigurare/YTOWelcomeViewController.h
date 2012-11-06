//
//  YTOWelcomeViewController.h
//  i-asigurare
//
//  Created by Administrator on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YTOWelcomeViewController : UIViewController
{
    IBOutlet UIImageView * imgLoading;
}

- (void) startLoadingAnimantion;
- (void) stopLoadingAnimantion;

@end
