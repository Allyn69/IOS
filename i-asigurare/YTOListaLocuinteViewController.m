//
//  YTOListaLocuinteViewController.m
//  i-asigurare
//
//  Created by Administrator on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YTOListaLocuinteViewController.h"
#import "YTOAppDelegate.h"
#import "YTOCalculatorViewController.h"
#import "YTOCasaViewController.h"
#import "YTOAsiguratViewController.h"
#import "YTOLocuintaViewController.h"
#import "YTOSetariViewController.h"
#import "Database.h"
#import "YTOLocuinta.h"
#import "YTOFormAlertaViewController.h"

@interface YTOListaLocuinteViewController ()

@end

@implementation YTOListaLocuinteViewController

@synthesize controller, produsAsigurare;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Lista locuinte", @"Lista locuinte");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
    listaLocuinte = [delegate Locuinte];
    
    ((UILabel *)[vwEmpty viewWithTag:11]).textColor = [YTOUtils colorFromHexString:@"#0071bc"];
    ((UILabel *)[vwEmpty viewWithTag:10]).textColor = [YTOUtils colorFromHexString:@"#4d4d4d"];

    [self verifyViewMode];
}

- (void) verifyViewMode
{
    if (listaLocuinte.count == 0)
    {
        self.navigationItem.rightBarButtonItem = nil;
        [vwEmpty setHidden:NO];
    }
    else if ([controller isKindOfClass:[YTOSetariViewController class]])
    {
        [vwEmpty setHidden:YES];
        UIBarButtonItem *btnEdit;
        if (editingMode)
            btnEdit = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"checked.png"]
                                                       style:UIBarButtonItemStylePlain
                                                      target:self
                                                      action:@selector(callEditItems)];
        else
            btnEdit = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(callEditItems)];
        self.navigationItem.rightBarButtonItem = btnEdit;
    }
}

- (void) viewWillDisappear:(BOOL)animated
{

}

- (void)viewDidUnload
{
    [super viewDidUnload];
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
    return listaLocuinte.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont fontWithName:@"Myriad Pro" size:20];
    cell.textLabel.textColor = [YTOUtils colorFromHexString:@"#3e3e3e"];
    cell.detailTextLabel.textColor = [YTOUtils colorFromHexString:@"#888888"];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Myriad Pro" size:16];
    cell.imageView.image = [UIImage imageNamed:@"icon-foto-casa-xs.png"];
    YTOLocuinta * loc = (YTOLocuinta *)[listaLocuinte objectAtIndex:indexPath.row];
    cell.textLabel.text = loc.tipLocuinta;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@, %d mp", loc.judet, loc.localitate, loc.suprafataUtila];
    
    if (indexPath.row % 2 != 0 && indexPath.row != 0) {
        CGRect frame = CGRectMake(0, 0, 320, 60);
        UIView *bgColor = [[UIView alloc] initWithFrame:frame];
        [cell addSubview:bgColor];
        [cell sendSubviewToBack:bgColor];
        bgColor.backgroundColor = [YTOUtils colorFromHexString:@"#fafafa"];
    }
    
    UIProgressView *progressv = [[UIProgressView alloc] initWithFrame:CGRectMake(8, 56, 47, 9)];
    float completedPercent =[loc CompletedPercent];
    [progressv setProgress:completedPercent];
   // progressv.progressTintColor = [YTOUtils colorFromHexString:];
    progressv.alpha=0.6;
    
    UILabel * lblPercent = [[UILabel alloc] initWithFrame:CGRectMake(8, 46, 47, 30)];
    lblPercent.font = [UIFont fontWithName:@"Arial" size:9]; lblPercent.textAlignment = UITextAlignmentCenter;
    lblPercent.text = [[NSString stringWithFormat:@"%.0f", completedPercent*100] stringByAppendingString:@" %"];
    lblPercent.backgroundColor = [UIColor clearColor];
    [cell addSubview:progressv];
    [cell addSubview:lblPercent];
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YTOAppDelegate * appDelegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    YTOLocuinta * locuinta = [listaLocuinte objectAtIndex:indexPath.row];
    
    if ([self.controller isKindOfClass:[YTOLocuintaViewController class]])
    {

        YTOLocuintaViewController * parent = (YTOLocuintaViewController *)self.controller;
        [parent setLocuinta:locuinta];
        
        [appDelegate.rcaNavigationController popViewControllerAnimated:YES];
    }
    else if ([self.controller isKindOfClass:[YTOSetariViewController class]])
    {
        YTOLocuinta * pAux = [YTOLocuinta getLocuinta:locuinta.idIntern];
        YTOCasaViewController * aView = [[YTOCasaViewController alloc] init];
        aView.controller = self;
        aView.locuinta = pAux;
        [appDelegate.setariNavigationController pushViewController:aView animated:YES];        
    }
    else if ([self.controller isKindOfClass:[YTOFormAlertaViewController class]])
    {
        YTOFormAlertaViewController * parent = (YTOFormAlertaViewController*)self.controller;
        [parent setLocuinta:locuinta];
        [appDelegate.alerteNavigationController popViewControllerAnimated:YES];
    }
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        YTOLocuinta * locuinta = [listaLocuinte objectAtIndex:indexPath.row];
        [locuinta deleteLocutina];
        [self reloadData];
    }
}

- (IBAction)adaugaLocuinta:(id)sender
{
    YTOCasaViewController * aView = [[YTOCasaViewController alloc] init];
    YTOAppDelegate * appDelegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if ([self.controller isKindOfClass:[YTOLocuintaViewController class]])
    {
        aView.controller = (YTOLocuintaViewController *)self.controller;
        [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
    }
    else if ([self.controller isKindOfClass:[YTOSetariViewController class]])
    {
        aView.controller = self;
        [appDelegate.setariNavigationController pushViewController:aView animated:YES];        
    }
}

- (void) reloadData
{
    YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
    listaLocuinte = [delegate Locuinte];
    if (listaLocuinte.count > 0)
    {
        [vwEmpty setHidden:YES];    
        if ([self.controller isKindOfClass:[YTOSetariViewController class]])
        {
            YTOSetariViewController * parent = (YTOSetariViewController *)self.controller;
            [parent reloadData];
        }
    }
    [tableView reloadData];
    [self verifyViewMode];
}

- (void) callEditItems
{
    if (!editingMode)
    {
        editingMode = YES;
        [tableView setEditing:YES];
        UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"checked.png"]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(callEditItems)];
        self.navigationItem.rightBarButtonItem = btnDone;
        [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStyleDone];
    }
    else
    {
        editingMode = NO;
        [tableView setEditing:NO];
        UIBarButtonItem *btnEdit = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(callEditItems)];
        self.navigationItem.rightBarButtonItem = btnEdit;
        [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
    }
}
@end
