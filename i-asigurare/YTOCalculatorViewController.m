//
//  YTOCalculatorViewController.m
//  i-asigurare
//
//  Created by Administrator on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YTOCalculatorViewController.h"
#import "YTOAsiguratViewController.h"
#import "YTOAutovehiculViewController.h"
#import "YTONomenclatorViewController.h"
#import "YTOListaAsiguratiViewController.h"
#import "YTOListaAutoViewController.h"
#import "YTOUtils.h"

@interface YTOCalculatorViewController ()

@end

@implementation YTOCalculatorViewController

@synthesize DataInceput = _DataInceput;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Calculator", @"Calculator");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _DataInceput = [[NSDate date] dateByAddingTimeInterval:86400];
    lblDataInceput.text = [YTOUtils formatDate:_DataInceput withFormat:@"dd.MM.yyyy"];
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

- (IBAction)selectPersoana:(id)sender 
{
    YTOListaAsiguratiViewController * aView = [[YTOListaAsiguratiViewController alloc] init];
    aView.controller = self;
    YTOAppDelegate * appDelegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
//    YTONomenclatorViewController * view = [[YTONomenclatorViewController alloc] init];
//    YTOAppDelegate * appDelegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
//    [appDelegate.rcaNavigationController pushViewController:view animated:YES];
}

- (IBAction)selectAutovehicul:(id)sender 
{
    YTOAppDelegate * appDelegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    // Daca exista masini salvate, afisam lista
    if ([YTOAutovehicul Masini].count > 0)
    {
        YTOListaAutoViewController * aView = [[YTOListaAutoViewController alloc] init];
        aView.controller = self;
        [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
    }
    else {
        YTOAutovehiculViewController * aView = [[YTOAutovehiculViewController alloc] init];
        [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
    }
}

- (void)setAsigurat:(YTOPersoana *) a
{
    [btnAsigurat.titleLabel setText:a.nume];
    asigurat = a;
}
- (void)setAutovehicul:(YTOAutovehicul *)a
{
    [btnMasina.titleLabel setText:a.marcaAuto];
    masina = a;
}

-(IBAction)checkboxSelected:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    BOOL checkboxSelected = btn.selected;
    checkboxSelected = !checkboxSelected;
    [btn setSelected:checkboxSelected];
}

- (IBAction)dateStepper_Changed:(id)sender
{
    UIStepper * stepper = (UIStepper *)sender;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];    
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    // set tomorrow (0: today, -1: yesterday)
    [comps setDay:stepper.value];
    NSDate *date = [calendar dateByAddingComponents:comps 
                                                     toDate:currentDate  
                                                    options:0];
    _DataInceput = date;
    lblDataInceput.text = [YTOUtils formatDate:date withFormat:@"dd.MM.yyyy"];
}
@end
