//
//  YTORCAViewController.h
//  i-asigurare
//
//  Created by Andi Aparaschivei on 7/12/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTOAppDelegate.h"
#import "YTOCalculatorViewController.h"
#import "YTOAsigurariRCAViewController.h"
#import "YTODauneRCAViewController.h"

@interface YTORCAViewController : UIViewController
{

}

- (IBAction) showCalculator:(id)sender;
- (IBAction) showListaAsigurari:(id)sender;
- (IBAction) showDaune:(id)sender;
@end
