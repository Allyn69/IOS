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
        self.title = NSLocalizedString(@"Incheie Asigurare", @"Incheie Asigurare");
        self.tabBarItem.image = [UIImage imageNamed:@"menu-asigurari.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    cellHeader = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
    UIImageView * imgHeader = [[UIImageView alloc] initWithFrame:CGRectMake(0, -10, 320, 68)];
    imgHeader.image = [UIImage imageNamed:@"header-second-screen.png"];
    UILabel * lblLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 58, 320, 1)];
    [lblLine setBackgroundColor:[YTOUtils colorFromHexString:@"#b3b3b3"]];
    [cellHeader addSubview:imgHeader];
    [cellHeader addSubview:lblLine];
    
    /*
    NSArray *topLevelObjects1 = [[NSBundle mainBundle] loadNibNamed:@"CellView_Setari" owner:self options:nil];
    cellAsigurareRca = [topLevelObjects1 objectAtIndex:0];
    
    NSArray *topLevelObjects2 = [[NSBundle mainBundle] loadNibNamed:@"CellView_Setari" owner:self options:nil];
    cellAsigurareCalatorie = [topLevelObjects2 objectAtIndex:0];
    
    NSArray *topLevelObjects3 = [[NSBundle mainBundle] loadNibNamed:@"CellView_Setari" owner:self options:nil];
    cellAsigurareLocuinta = [topLevelObjects3 objectAtIndex:0];
    
    NSArray *topLevelObjects4 = [[NSBundle mainBundle] loadNibNamed:@"CellView_Setari" owner:self options:nil];
    cellAsigurareCasco = [topLevelObjects4 objectAtIndex:0];
     */
    
    cellRow1 =[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
    UIButton * btnRca = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRca.frame = CGRectMake(28, 5, 123, 121);
    [btnRca setBackgroundImage:[UIImage imageNamed:@"asig-rca-123.png"] forState:UIControlStateNormal];
    [btnRca addTarget:self action:@selector(showRCAView) forControlEvents:UIControlEventTouchUpInside];
    UIButton * btnCasco = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCasco.frame = CGRectMake(164, 5, 123, 121);
    [btnCasco setBackgroundImage:[UIImage imageNamed:@"asig-casco-123.png"] forState:UIControlStateNormal];
    [btnCasco addTarget:self action:@selector(showCascoView) forControlEvents:UIControlEventTouchUpInside];
    
    [cellRow1 addSubview:btnRca];
    [cellRow1 addSubview:btnCasco];
    
    cellRow2 =[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
    UIButton * btnCalatorie = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCalatorie.frame = CGRectMake(28, 5, 123, 121);
    [btnCalatorie setBackgroundImage:[UIImage imageNamed:@"asig-calatorie-123.png"] forState:UIControlStateNormal];
    [btnCalatorie addTarget:self action:@selector(showCalatorieView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * btnLocuinta = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLocuinta.frame = CGRectMake(164, 5, 123, 121);
    [btnLocuinta setBackgroundImage:[UIImage imageNamed:@"asig-locuinte-123.png"] forState:UIControlStateNormal];
    [btnLocuinta addTarget:self action:@selector(showLocuintaView) forControlEvents:UIControlEventTouchUpInside];
    
    [cellRow2 addSubview:btnCalatorie];
    [cellRow2 addSubview:btnLocuinta];
    
    cellFooter = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 26)];
    UIImageView * imgFooter = [[UIImageView alloc] initWithFrame:CGRectMake(99, 10, 123, 26)];
    imgFooter.image = [UIImage imageNamed:@"logo-123.png"];
    [cellFooter addSubview:imgFooter];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return 40;
    else if (indexPath.section == 3)
        return 30;
    
    return 105;
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
        cell = cellRow1;
    else if  (indexPath.section == 2)
        cell = cellRow2;
    else cell = cellFooter;
    /*
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
    
     */
    
    cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
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
        
    }*/
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
