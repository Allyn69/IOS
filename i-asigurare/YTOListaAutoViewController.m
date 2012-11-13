//
//  YTOListaAutoViewController.m
//  i-asigurare
//
//  Created by Administrator on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YTOListaAutoViewController.h"
#import "YTOAppDelegate.h"
#import "YTOCalculatorViewController.h"
#import "YTOAutovehiculViewController.h"
#import "YTOSetariViewController.h"
#import "YTOValabilitateRCAViewController.h"
#import "Database.h"
#import "YTOUtils.h"
#import "YTOImage.h"
#import "YTOFormAlertaViewController.h"

@interface YTOListaAutoViewController ()

@end

@implementation YTOListaAutoViewController

@synthesize controller;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Lista masini", @"Lista masini");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    listaMasini = [YTOAutovehicul Masini];
    
    ((UILabel *)[vwEmpty viewWithTag:11]).textColor = [YTOUtils colorFromHexString:@"#009145"];
    ((UILabel *)[vwEmpty viewWithTag:10]).textColor = [YTOUtils colorFromHexString:@"#4d4d4d"];
    
    [self verifyViewMode];
}

- (void) verifyViewMode
{
    if (listaMasini.count == 0)
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
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return listaMasini.count;
}

//- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"CellView_String"];
//    if (cell == nil) {
//        // Create a temporary UIViewController to instantiate the custom cell.
//        UIViewController *temporaryController = [[UIViewController alloc] initWithNibName:@"CellView_String" bundle:nil];
//        // Grab a pointer to the custom cell.
//        cell = (YTOCellView_String *)temporaryController.view;
//        // Release the temporary UIViewController.
//    }
//    
//    return cell;
//}

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
    
    cell.textLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    cell.textLabel.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    cell.detailTextLabel.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Arial" size:16];
    YTOAutovehicul * a = (YTOAutovehicul *)[listaMasini objectAtIndex:indexPath.row];
    if (a.idImage && a.idImage.length > 0)
    {
        YTOImage *objImage = [YTOImage getImage:a.idImage];
        cell.imageView.image = objImage.image;
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    else
        cell.imageView.image = [UIImage imageNamed:@"marca-auto.png"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [a.marcaAuto uppercaseString];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", a.modelAuto, a.nrInmatriculare];
    
    if (indexPath.row % 2 != 0 && indexPath.row != 0) {
        CGRect frame = CGRectMake(0, 0, 320, 60);
        UIView *bgColor = [[UIView alloc] initWithFrame:frame];
        [cell addSubview:bgColor];
        [cell sendSubviewToBack:bgColor];
        bgColor.backgroundColor = [YTOUtils colorFromHexString:@"#fafafa"];
    }
    
    UIProgressView *progressv = [[UIProgressView alloc] initWithFrame:CGRectMake(8, 56, 47, 9)];
    float completedPercent =[a CompletedPercent];
    [progressv setProgress:completedPercent];
    progressv.progressTintColor = [YTOUtils colorFromHexString:ColorVerde];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YTOAutovehicul * masina = [listaMasini objectAtIndex:indexPath.row];
    
    YTOAppDelegate * appDelegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    if ([self.controller isKindOfClass:[YTOCalculatorViewController class]])
    {
        YTOCalculatorViewController * parent = (YTOCalculatorViewController *)self.controller;
        
        // TRUE -  Daca masina este valida, se poate
        //         folosi pentru calculatia RCA
        // FALSE - Se incarca formularul de masina, iar la
        //         salvare, se afiseaza calculatorul RCA
        if ([masina isValidForRCA])
        {
            [parent setAutovehicul:masina];
            [appDelegate.rcaNavigationController popViewControllerAnimated:YES];
        }
        else 
        {
            YTOAutovehiculViewController * aView = [[YTOAutovehiculViewController alloc] init];
            aView.controller = self.controller;
            aView.autovehicul = masina;
            [appDelegate.rcaNavigationController pushViewController:aView animated:YES];        
        }
    }
    else if ([self.controller isKindOfClass:[YTOSetariViewController class]])
    {
        YTOAutovehiculViewController * aView = [[YTOAutovehiculViewController alloc] init];
        aView.controller = self;
        aView.autovehicul = masina;
        [appDelegate.setariNavigationController pushViewController:aView animated:YES];        
    }
    else if ([self.controller isKindOfClass:[YTOValabilitateRCAViewController class]])
    {
        YTOValabilitateRCAViewController * parent = (YTOValabilitateRCAViewController *)self.controller;
        [parent setAutovehicul:masina];
        [appDelegate.alteleNavigationController popViewControllerAnimated:YES];
    }
    else if ([self.controller isKindOfClass:[YTOFormAlertaViewController class]])
    {
        YTOFormAlertaViewController * parent = (YTOFormAlertaViewController*)self.controller;
        [parent setAutovehicul:masina];
        [appDelegate.alerteNavigationController popViewControllerAnimated:YES];
    }
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        YTOAutovehicul * masina = [listaMasini objectAtIndex:indexPath.row];
        [masina deleteAutovehicul];
        [self reloadData];
    }
}

- (IBAction)adaugaAutovehicul:(id)sender
{
    editingMode = NO;
     [tableView setEditing:NO];
    
    YTOAutovehiculViewController * aView = [[YTOAutovehiculViewController alloc] init];
    YTOAppDelegate * appDelegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    if ([self.controller isKindOfClass:[YTOCalculatorViewController class]])
    {
        aView.controller = (YTOCalculatorViewController *)self.controller;
        [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
    }
    else if ([self.controller isKindOfClass:[YTOSetariViewController class]])
    {
        aView.controller = self;
        [appDelegate.setariNavigationController pushViewController:aView animated:YES];        
    }
    else if ([self.controller isKindOfClass:[YTOValabilitateRCAViewController class]])
    {
        aView.controller = self;
        [appDelegate.alteleNavigationController pushViewController:aView animated:YES];
    }
}

- (void) reloadData
{
    listaMasini = [YTOAutovehicul Masini];
    if (listaMasini.count > 0)
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
