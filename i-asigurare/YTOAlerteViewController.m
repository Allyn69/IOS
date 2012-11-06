//
//  YTOSecondViewController.m
//  i-asigurare
//
//  Created by Administrator on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YTOAlerteViewController.h"
#import "YTOAppDelegate.h"
#import "YTOFormAlertaViewController.h"
#import "YTOAlerta.h"
#import "YTOUtils.h"
#import "CellAlertaCustom.h"
#import <QuartzCore/QuartzCore.h>
#import "YTOAutovehicul.h"

@interface YTOAlerteViewController ()

@end

@implementation YTOAlerteViewController

@synthesize controller;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Alerte", @"Alerte");
        self.tabBarItem.image = [UIImage imageNamed:@"menu-alerte.png"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    listAlerte = [YTOAlerta Alerte];
    [self verifyViewMode];
}

- (void) verifyViewMode
{
    if (listAlerte.count == 0)
    {
        [tableView setHidden:YES];
        [vwEmpty setHidden:NO];
    }
    else
    {
        [tableView setHidden:NO];
        [vwEmpty setHidden:YES];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table view data source

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return listAlerte.count;
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}

//- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"1 ianuarie 2013";
//}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 300, 15)];
    label.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:12];
    label.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    label.backgroundColor = [UIColor clearColor];
    
    YTOAlerta * a = (YTOAlerta *)[listAlerte objectAtIndex:section];
    label.text = [YTOUtils formatDate:a.dataAlerta withFormat:@"dd.MM.yyyy"];
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
//    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor whiteColor] CGColor], nil];
    gradient.colors = [NSArray arrayWithObjects:(id)[[YTOUtils colorFromHexString:@"#f5f5f5"] CGColor], (id)[[YTOUtils colorFromHexString:@"#e0e1e2"] CGColor], nil];
    [view.layer insertSublayer:gradient atIndex:0];
    //view.backgroundColor = [YTOUtils colorFromHexString:@"#e0e1e2"];
    [view addSubview:label];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellView_Alerta";
    
    CellAlertaCustom *cell = (CellAlertaCustom *)[tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (CellAlertaCustom *)[nib objectAtIndex:0];
    }
    
    YTOAlerta * alerta = [listAlerte objectAtIndex:indexPath.section];
    YTOAutovehicul * masina;
    YTOLocuinta * locuinta;
    
    if (alerta.idObiect)
    {
        if (alerta.tipAlerta == 5)
            locuinta = [YTOLocuinta getLocuinta:alerta.idObiect];
        else
            masina = [YTOAutovehicul getAutovehicul:alerta.idObiect];
    }

    // Configure the cell...
    NSString * tipAlerta = [YTOUtils getValueList:[YTOUtils GETTipAlertaList] forKey:alerta.tipAlerta];
    
    [cell setTipAlerta:[NSString stringWithFormat:@"%@", tipAlerta]];
    
    NSString * val = @"";
    NSString * detaliu = @"";
    UIImage * img = nil;
    if (alerta.tipAlerta == 1) // RCA
    {
        detaliu = @"expirare polita";
        val = masina ? masina.nrInmatriculare : @"";
        img = [UIImage imageNamed:@"alerte-bulina-verde-rca.png"];
    }
    else if (alerta.tipAlerta == 2) // ITP
    {
        detaliu = @"expirare ITP";
        val = masina ? masina.nrInmatriculare : @"";
        img = [UIImage imageNamed:@"alerte-bulina-albastru-generic.png"];
    }
    else if (alerta.tipAlerta == 3) // Rovinieta
    {
        detaliu = @"expirare Rovinieta";
        val = masina ? masina.nrInmatriculare : @"";
        img = [UIImage imageNamed:@"alerte-bulina-albastru-generic.png"];
    }
    else if (alerta.tipAlerta == 4) // CASCO
    {
        detaliu = @"casco";
        val = masina ? masina.nrInmatriculare : @"";
        img = [UIImage imageNamed:@"alerte-bulina-portocaliu-casco.png"];
    }
    else if (alerta.tipAlerta == 5) // Locuinta
    {
        detaliu = @"locuinta";
        val = [NSString stringWithFormat:@"%@, %d mp2", locuinta.judet, locuinta.suprafataUtila];
        img = [UIImage imageNamed:@"alerte-bulina-albastru-locuinta.png"];
    }
    else
    {
        detaliu = @"plata rata";
        val = @"340 lei";
        img = [UIImage imageNamed:@"alerte-bulina-portocaliu-generic.png"];        
    }
    [cell setDetaliuAlerta:detaliu];
    [cell setNumar:val];
    [cell setAlertaImage:img];
    
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
    YTOFormAlertaViewController * aView = [[YTOFormAlertaViewController alloc] init];
    aView.controller = self;
    aView.alerta = [listAlerte objectAtIndex:indexPath.section];
    YTOAppDelegate * appDelegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.alerteNavigationController pushViewController:aView animated:YES];
}


#pragma METHODS

- (void) reloadData
{
    listAlerte = [YTOAlerta Alerte];
    if (listAlerte.count > 0)
    {
        [vwEmpty setHidden:YES];
    }
    [tableView reloadData];
    [self verifyViewMode];
}

- (IBAction)adaugaAlerta:(id)sender
{
    YTOFormAlertaViewController * aView = [[YTOFormAlertaViewController alloc] init];
    aView.controller = self;
    YTOAppDelegate * appDelegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.alerteNavigationController pushViewController:aView animated:YES];
}
@end
