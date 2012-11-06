//
//  YTOWelcomeViewController.m
//  i-asigurare
//
//  Created by Administrator on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YTOWelcomeViewController.h"
#import "YTOSetariViewController.h"
#import "YTOAppDelegate.h"

@interface YTOWelcomeViewController ()

@end

@implementation YTOWelcomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self startLoadingAnimantion];
    
    [self performSelector:@selector(stopLoadingAnimantion) withObject:nil afterDelay:2.8];
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

- (void) startLoadingAnimantion
{
    NSArray * imgs = [NSArray arrayWithObjects: [UIImage imageNamed:@"1.png"], 
                      [UIImage imageNamed:@"2.png"],
                      [UIImage imageNamed:@"3.png"],
                      [UIImage imageNamed:@"4.png"],
                      [UIImage imageNamed:@"5.png"],
                      [UIImage imageNamed:@"6.png"],
                      [UIImage imageNamed:@"7.png"],
                      [UIImage imageNamed:@"8.png"],
                      [UIImage imageNamed:@"9.png"],
                      [UIImage imageNamed:@"10.png"],
                      [UIImage imageNamed:@"11.png"],
                      [UIImage imageNamed:@"12.png"],
                      [UIImage imageNamed:@"13.png"],
                      [UIImage imageNamed:@"14.png"],
                      [UIImage imageNamed:@"15.png"],
                      [UIImage imageNamed:@"16.png"],
                      [UIImage imageNamed:@"17.png"],
                      [UIImage imageNamed:@"18.png"],
                      [UIImage imageNamed:@"19.png"],
                      [UIImage imageNamed:@"20.png"],
                      [UIImage imageNamed:@"21.png"],
                      [UIImage imageNamed:@"22.png"],
                      [UIImage imageNamed:@"23.png"],
                      [UIImage imageNamed:@"24.png"],
                      [UIImage imageNamed:@"25.png"],
                      [UIImage imageNamed:@"26.png"],
                      [UIImage imageNamed:@"26.png"],
                      [UIImage imageNamed:@"26.png"],
                      [UIImage imageNamed:@"26.png"],
                      [UIImage imageNamed:@"26.png"],
                      [UIImage imageNamed:@"26.png"],
                      [UIImage imageNamed:@"26.png"],
                      [UIImage imageNamed:@"26.png"],
                      [UIImage imageNamed:@"26.png"],
                      [UIImage imageNamed:@"26.png"],
                      [UIImage imageNamed:@"26.png"],
                      [UIImage imageNamed:@"26.png"],
                      [UIImage imageNamed:@"26.png"],
                      [UIImage imageNamed:@"26.png"], nil];
    
    imgLoading.animationDuration = 2.8;
    imgLoading.animationRepeatCount = 1;
    imgLoading.animationImages = imgs;
    [imgLoading startAnimating];
}

- (void) stopLoadingAnimantion
{
//    YTOAppDelegate * appDelegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
//    [appDelegate.tabBarController setViewControllers:appDelegate.tabBarItems animated:YES];
// 
//    [self.tabBarController.tabBar setHidden:NO];
//    self.hidesBottomBarWhenPushed = NO;
//    
//    YTOSetariViewController *aView = [[YTOSetariViewController alloc] init];
//    [appDelegate.setariNavigationController pushViewController:aView animated:NO];
   // [self dismissModalViewControllerAnimated:NO];
    [self.view removeFromSuperview];
}

@end
