//
//  YTOCalculatorViewController.h
//  i-asigurare
//
//  Created by Administrator on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YTOCalculatorViewController : UIViewController
{
    IBOutlet UILabel * lblDataInceput;
    IBOutlet UIStepper * dateStepper;
}

@property (nonatomic, retain) NSDate * DataInceput;

- (IBAction)changeDataInceput:(id)sender;
@end
