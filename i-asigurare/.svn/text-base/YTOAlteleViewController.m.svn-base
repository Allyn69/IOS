//
//  YTOAlteleViewController.m
//  i-asigurare
//
//  Created by Andi Aparaschivei on 7/17/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
//

#import "YTOAlteleViewController.h"
#import "YTOAppDelegate.h"
#import "YTOUtils.h"
#import "YTOValabilitateRCAViewController.h"
#import "YTOTrimiteMesajViewController.h"
#import "YTOFAQViewController.h"
#import "YTOTermeniViewController.h"
#import "YTOPromotiiViewController.h"
#import "YTOSocietatiViewController.h"
#import "YTOContactViewController.h"

@interface YTOAlteleViewController ()

@end

@implementation YTOAlteleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Altele", @"Altele");
        self.tabBarItem.image = [UIImage imageNamed:@"menu-altele.png"];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"Myriad Pro" size:20];
    cell.textLabel.textColor = [YTOUtils colorFromHexString:@"#3e3e3e"];
    cell.detailTextLabel.textColor = [YTOUtils colorFromHexString:@"#888888"];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Myriad Pro" size:16];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == 0) {
        cell.textLabel.text = @"PROMOTII";
        cell.detailTextLabel.text = @"ofertele i-Asigurare";
        cell.imageView.image = [UIImage imageNamed:@"promotii.png"];
    }
    else if (indexPath.row == 1) {
        cell.textLabel.text = @"VREI SA NE SPUI CEVA?";
        cell.detailTextLabel.text = @"trimite-ne un mesaj";        
        cell.imageView.image = [UIImage imageNamed:@"trimite-mesaj.png"];
    }
//    else if (indexPath.row == 2) {
//        cell.textLabel.text = @"INTREBARI FRECVENTE";
//        cell.detailTextLabel.text = @"totul despre asigurari";    
//        cell.imageView.image = [UIImage imageNamed:@"faq.png"];
//    }
//    else if (indexPath.row == 2) {
//        cell.textLabel.text = @"COMPANII ASIGURARE";
//        cell.detailTextLabel.text = @"date de contact";        
//        cell.imageView.image = [UIImage imageNamed:@"contact-companii.png"];        
//    }
    else if (indexPath.row == 2) {
        cell.textLabel.text = @"VALABILITATE RCA";
        cell.detailTextLabel.text = @"verifica polita ta RCA";        
        cell.imageView.image = [UIImage imageNamed:@"valabilitate-rca.png"];
    }
    else if (indexPath.row == 3) {
        cell.textLabel.text = @"TERMENI & CONDITII";
        cell.detailTextLabel.text = @"citeste regulile";        
        cell.imageView.image = [UIImage imageNamed:@"termeni.png"];
    }
    else if (indexPath.row == 4) {
        cell.textLabel.text = @"CONTACT";
        cell.detailTextLabel.text = @"cum ne gasesti";
        cell.imageView.image = [UIImage imageNamed:@"contact-iasigurare.png"];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YTOAppDelegate * appDelegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (indexPath.row == 0)
    {
        YTOPromotiiViewController * aView = [[YTOPromotiiViewController alloc] init];
        [appDelegate.alteleNavigationController pushViewController:aView animated:YES];
    }
    else if (indexPath.row == 1)
    {
        YTOTrimiteMesajViewController * aView;
        if (IS_IPHONE_5)
            aView = [[YTOTrimiteMesajViewController alloc] initWithNibName:@"YTOTrimiteMesajViewController_R4" bundle:nil];
        else aView = [[YTOTrimiteMesajViewController alloc] initWithNibName:@"YTOTrimiteMesajViewController" bundle:nil];
        [appDelegate.alteleNavigationController pushViewController:aView animated:YES];
    }
//    else if (indexPath.row == 2)
//    {
//        YTOFAQViewController * aView = [[YTOFAQViewController alloc] init];
//        [appDelegate.alteleNavigationController pushViewController:aView animated:YES];
//    }
//    else if (indexPath.row == 2)
//    {
//        YTOSocietatiViewController * aView = [[YTOSocietatiViewController alloc] init];
//        [appDelegate.alteleNavigationController pushViewController:aView animated:YES];
//    }
    else if (indexPath.row == 2)
    {
        YTOValabilitateRCAViewController * aView;
        if (IS_IPHONE_5)
            aView = [[YTOValabilitateRCAViewController alloc] initWithNibName:@"YTOValabilitateRCAViewController_R4" bundle:nil];
        else aView = [[YTOValabilitateRCAViewController alloc] initWithNibName:@"YTOValabilitateRCAViewController" bundle:nil];
        [appDelegate.alteleNavigationController pushViewController:aView animated:YES];
    }
    else if (indexPath.row == 3)
    {
        YTOTermeniViewController * aView;
        if (IS_IPHONE_5)
            aView = [[YTOTermeniViewController alloc] initWithNibName:@"YTOTermeniViewController_R4" bundle:nil];
        else aView = [[YTOTermeniViewController alloc] initWithNibName:@"YTOTermeniViewController" bundle:nil];
        [appDelegate.alteleNavigationController pushViewController:aView animated:YES];
    }
    else if (indexPath.row == 4)
    {
        YTOContactViewController * aView;
        if (IS_IPHONE_5)
            aView = [[YTOContactViewController alloc] initWithNibName:@"YTOContactViewController_R4" bundle:nil];
        else aView = [[YTOContactViewController alloc] initWithNibName:@"YTOContactViewController" bundle:nil];
        [appDelegate.alteleNavigationController pushViewController:aView animated:YES];
    }
}

@end
