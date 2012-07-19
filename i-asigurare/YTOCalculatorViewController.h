//
//  YTOCalculatorViewController.h
//  i-asigurare
//
//  Created by Administrator on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTOAppDelegate.h"
#import "YTOPersoana.h"
#import "YTOAutovehicul.h"

@interface YTOCalculatorViewController : UIViewController
{
    IBOutlet UILabel * lblDataInceput;
    IBOutlet UIStepper * dateStepper;
    IBOutlet UIButton * btnAsigurat;
    IBOutlet UIButton * btnMasina; 
    YTOPersoana * asigurat;
    YTOAutovehicul * masina;
}

@property (nonatomic, retain) NSDate * DataInceput;

- (IBAction)selectPersoana:(id)sender;
- (IBAction)selectAutovehicul:(id)sender;
- (void)setAsigurat:(YTOPersoana *) a;
- (void)setAutovehicul:(YTOAutovehicul *)a;
- (IBAction)checkboxSelected:(id)sender;
- (IBAction)dateStepper_Changed:(id)sender;
@end
