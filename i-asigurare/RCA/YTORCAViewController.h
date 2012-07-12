//
//  YTORCAViewController.h
//  i-asigurare
//
//  Created by Administrator on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTOAppDelegate.h"
#import "YTOCalculatorViewController.h"

@interface YTORCAViewController : UIViewController
{
    YTOCalculatorViewController * calculatorViewController;
}

@property (nonatomic, retain) YTOCalculatorViewController * calculatorViewController;

- (IBAction) showCalculator:(id)sender;
- (IBAction) showListaAsigurari:(id)sender;

@end
