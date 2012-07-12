//
//  YTORCAViewController.m
//  i-asigurare
//
//  Created by Administrator on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YTORCAViewController.h"

@interface YTORCAViewController ()

@end

@implementation YTORCAViewController

@synthesize calculatorViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"RCA", @"RCA");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction) showCalculator:(id)sender {
	YTOCalculatorViewController * aView = [[YTOCalculatorViewController alloc] init];
    YTOAppDelegate * appDelegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
}

@end
