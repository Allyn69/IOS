//
//  YTOAsigurariViewController.m
//  i-asigurare
//
//  Created by Administrator on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YTOAsigurariViewController.h"

@interface YTOAsigurariViewController ()

@end

@implementation YTOAsigurariViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Asigurari", @"Asigurari");
        self.tabBarItem.image = [UIImage imageNamed:@"menu-asigurari.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    cellHeader = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
    UIImageView * imgHeader = [[UIImageView alloc] initWithFrame:CGRectMake(0, -10, 320, 59)];
    imgHeader.image = [UIImage imageNamed:@"logo.png"];
    [cellHeader addSubview:imgHeader];
    
    NSArray *topLevelObjects1 = [[NSBundle mainBundle] loadNibNamed:@"CellView_Setari" owner:self options:nil];
    cellAsigurareRca = [topLevelObjects1 objectAtIndex:0];
    
    NSArray *topLevelObjects2 = [[NSBundle mainBundle] loadNibNamed:@"CellView_Setari" owner:self options:nil];
    cellAsigurareCalatorie = [topLevelObjects2 objectAtIndex:0];
    
    NSArray *topLevelObjects3 = [[NSBundle mainBundle] loadNibNamed:@"CellView_Setari" owner:self options:nil];
    cellAsigurareLocuinta = [topLevelObjects3 objectAtIndex:0];
    
    NSArray *topLevelObjects4 = [[NSBundle mainBundle] loadNibNamed:@"CellView_Setari" owner:self options:nil];
    cellAsigurareCasco = [topLevelObjects4 objectAtIndex:0];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return 35;
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    if (indexPath.section == 0)
    {
        cell = cellHeader;
    }
    else if (indexPath.section == 1)
    {
        cell = cellAsigurareRca;
        ((UIImageView *)[cell viewWithTag:1]).image = [UIImage imageNamed:@"asigurare-rca.png"];
        ((UILabel *)[cell viewWithTag:3]).text = @"Asigurare RCA";
    }
    else if (indexPath.section == 2)
    {
        cell = cellAsigurareCalatorie;
        ((UIImageView *)[cell viewWithTag:1]).image = [UIImage imageNamed:@"asigurare-calatorie.png"];
        
        ((UILabel *)[cell viewWithTag:3]).text = @"Asigurare de calatorie";
    }
    else if (indexPath.section == 3)
    {
        cell = cellAsigurareLocuinta;
        ((UIImageView *)[cell viewWithTag:1]).image = [UIImage imageNamed:@"asigurare-locuinta.png"];
        
        
        ((UILabel *)[cell viewWithTag:3]).text = @"Asigurare de locuinta";
    }
    else
    {
        cell = cellAsigurareCasco;
        ((UIImageView *)[cell viewWithTag:1]).image = [UIImage imageNamed:@"asigurare-casco.png"];
        ((UILabel *)[cell viewWithTag:3]).text = @"Asigurare CASCO";
    }
    ((UILabel *)[cell viewWithTag:3]).font = [UIFont fontWithName:@"Arial Rounded MT" size:14];
    ((UILabel *)[cell viewWithTag:3]).textColor = [YTOUtils colorFromHexString:ColorTitlu];
    [((UILabel *)[cell viewWithTag:2]) setHidden:YES];
    cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        [self showRCAView];
    }
    else if (indexPath.section == 2)
    {
        [self showCalatorieView];
    }
    else if (indexPath.section == 3)
    {
        [self showLocuintaView];
    }
    else if (indexPath.section == 4)
    {
        [self showCascoView];
        
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)showRCAView
{
    YTOCalculatorViewController * aView = [[YTOCalculatorViewController alloc] init];
    YTOAppDelegate * appDelegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
}

- (void)showCalatorieView
{
    YTOCalatorieViewController * aView = [[YTOCalatorieViewController alloc] init];
    YTOAppDelegate * appDelegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.rcaNavigationController pushViewController:aView animated:YES];    
}

- (void)showLocuintaView
{
    YTOLocuintaViewController * aView = [[YTOLocuintaViewController alloc] init];
    YTOAppDelegate * appDelegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.rcaNavigationController pushViewController:aView animated:YES]; 
}

- (void)showCascoView
{
    YTOCASCOViewController * aView = [[YTOCASCOViewController alloc] init];
    YTOAppDelegate * appDelegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
}

@end
