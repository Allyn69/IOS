//
//  YTOListaLocuinteViewController.m
//  i-asigurare
//
//  Created by Andi Aparaschivei on 8/2/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
//

#import "YTOListaLocuinteViewController.h"
#import "YTOAppDelegate.h"
#import "YTOCalculatorViewController.h"
#import "YTOCasaMeaViewController.h"
#import "YTOCasaViewController.h"
#import "YTOAsiguratViewController.h"
#import "YTOLocuintaViewController.h"
#import "YTOSetariViewController.h"
#import "Database.h"
#import "YTOLocuinta.h"
#import "YTOFormAlertaViewController.h"
#import "YTOAsigurareViewController.h"
#import "YTOUserDefaults.h"
#import "UILabel+dynamicSizeMe.h"

@interface YTOListaLocuinteViewController ()

@end

@implementation YTOListaLocuinteViewController

@synthesize controller, produsAsigurare;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedStringFromTable(@"i361", [YTOUserDefaults getLanguage],@"Lista locuinte");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IS_OS_7_OR_LATER){
        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars=NO;
        self.automaticallyAdjustsScrollViewInsets=NO;
    }else [tableView setBackgroundView: nil];
    //self.trackedViewName = @"YTOListaLocuinteViewController";

    YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
    listaLocuinte = [delegate Locuinte];
    
    ((UILabel *)[vwEmpty viewWithTag:11]).textColor = [YTOUtils colorFromHexString:@"#0071bc"];
    ((UILabel *)[vwEmpty viewWithTag:10]).textColor = [YTOUtils colorFromHexString:@"#4d4d4d"];
    lblEditeaza.textColor = [YTOUtils colorFromHexString:@"#78a9b9"];
    lblAdauga.textColor = [YTOUtils colorFromHexString:@"#78a9b9"];
    lblWvEmpty1.text = NSLocalizedStringFromTable(@"i362", [YTOUserDefaults getLanguage],@"Nu exista locuinte salvate. Pentru a adauga o noua locuinta, apasa butonul de mai sus "Adauga locuinta"");
    lblWvEmpty2.text = NSLocalizedStringFromTable(@"i167", [YTOUserDefaults getLanguage],@"Adauga locuinta");
    lblAdaugaLocuinta.text =  NSLocalizedStringFromTable(@"i363", [YTOUserDefaults getLanguage],@"Adauga locuinta");
    [lblAdaugaLocuinta resizeToFit];

    [self verifyViewMode];
    [YTOUtils rightImageVodafone:self.navigationItem];
    tableView.allowsSelectionDuringEditing = YES;
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
    if (![controller isKindOfClass:[YTOSetariViewController class]])
        [YTOUtils rightImageVodafone:self.navigationItem];
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
    if (!editingMode){
        cell.textLabel.font = [UIFont fontWithName:@"Arial-Regular" size:20];
    }else{
        cell.textLabel.font = [UIFont fontWithName:@"Arial-ItalicMT" size:17];
    }
    cell.textLabel.textColor = [YTOUtils colorFromHexString:@"#3e3e3e"];
    cell.detailTextLabel.textColor = [YTOUtils colorFromHexString:@"#888888"];
    if (!editingMode){
        cell.detailTextLabel.font = [UIFont fontWithName:@"Arial" size:16];
    }else{
        cell.detailTextLabel.font = [UIFont fontWithName:@"Arial-ItalicMT" size:16];
    }
    cell.imageView.image = [UIImage imageNamed:@"icon-foto-casa-xs.png"];
    YTOLocuinta * loc = (YTOLocuinta *)[listaLocuinte objectAtIndex:indexPath.row];

    if ([loc.tipLocuinta isEqualToString:@"apartament-in-bloc"])
        cell.textLabel.text = NSLocalizedStringFromTable(@"i377", [YTOUserDefaults getLanguage],@"Apartament in bloc");
    else if ([loc.tipLocuinta isEqualToString:@"casa-vila-comuna"])
        cell.textLabel.text = NSLocalizedStringFromTable(@"i378", [YTOUserDefaults getLanguage],@"Casa - vila comuna");
    else if ([loc.tipLocuinta isEqualToString:@"casa-vila-individuala"])
        cell.textLabel.text = NSLocalizedStringFromTable(@"i379", [YTOUserDefaults getLanguage],@"Casa - vila individuala");
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@, %d mp", loc.judet, loc.localitate, loc.suprafataUtila];
    
    if (indexPath.row % 2 != 0 && indexPath.row != 0) {
        CGRect frame = CGRectMake(0, 0, 320, 60);
        UIView *bgColor = [[UIView alloc] initWithFrame:frame];
        [cell addSubview:bgColor];
        [cell sendSubviewToBack:bgColor];
        bgColor.backgroundColor = [YTOUtils colorFromHexString:@"#fafafa"];
    }
    
    UIProgressView *progressv ;
    if(IS_OS_7_OR_LATER) progressv = [[UIProgressView alloc] initWithFrame:CGRectMake(16, 56, 47, 9)];
    else progressv= [[UIProgressView alloc] initWithFrame:CGRectMake(8, 56, 47, 9)];
    float completedPercent =[loc CompletedPercent];
    [progressv setProgress:completedPercent];
   // progressv.progressTintColor = [YTOUtils colorFromHexString:];
    progressv.alpha=0.6;
    
    UILabel * lblPercent;
    if (IS_OS_7_OR_LATER) lblPercent = [[UILabel alloc] initWithFrame:CGRectMake(16, 46, 47, 30)];
    else lblPercent = [[UILabel alloc] initWithFrame:CGRectMake(8, 46, 47, 30)];
    lblPercent.font = [UIFont fontWithName:@"Arial" size:9]; lblPercent.textAlignment = UITextAlignmentCenter;
    lblPercent.text = [[NSString stringWithFormat:@"%.0f", completedPercent*100] stringByAppendingString:@" %"];
    lblPercent.backgroundColor = [UIColor clearColor];
    if (!IS_OS_7_OR_LATER){
        [cell addSubview:progressv];
        [cell addSubview:lblPercent];
    }
    if (editingMode)
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
    if (!editingMode && ([self.controller isKindOfClass:[YTOCasaMeaViewController class]] || [self.controller isKindOfClass:[YTOCasaMeaViewController class]]))
    {
        YTOCasaViewController * aView;
        if (IS_IPHONE_5)
            aView = [[YTOCasaViewController alloc] initWithNibName:@"YTOCasaViewController_R4" bundle:nil];
        else aView = [[YTOCasaViewController alloc] initWithNibName:@"YTOCasaViewController" bundle:nil];
        aView.controller = self.controller;
        aView.locuinta = locuinta;
        [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
    }else if ([self.controller isKindOfClass:[YTOSetariViewController class]])
    {
        YTOLocuinta * pAux = [YTOLocuinta getLocuinta:locuinta.idIntern];
        YTOCasaViewController * aView;
        if (IS_IPHONE_5)
            aView = [[YTOCasaViewController alloc] initWithNibName:@"YTOCasaViewController_R4" bundle:nil];
        else aView = [[YTOCasaViewController alloc] initWithNibName:@"YTOCasaViewController" bundle:nil];
        aView.controller = self;
        aView.locuinta = pAux;
        [appDelegate.setariNavigationController pushViewController:aView animated:YES];
    }
    else if ([self.controller isKindOfClass:[YTOLocuintaViewController class]])
    {

        YTOLocuintaViewController * parent = (YTOLocuintaViewController *)self.controller;
        
        if (!editingMode && [locuinta isValidForLocuinta]) {
            [parent setLocuinta:locuinta];
            [appDelegate.rcaNavigationController popViewControllerAnimated:YES];
        }
        else {
            YTOCasaViewController * aView;
            if (IS_IPHONE_5)
                aView = [[YTOCasaViewController alloc] initWithNibName:@"YTOCasaViewController_R4" bundle:nil];
            else aView = [[YTOCasaViewController alloc] initWithNibName:@"YTOCasaViewController" bundle:nil];
            aView.controller = self.controller;
            aView.locuinta = locuinta;
            [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
        }
    }else if ([self.controller isKindOfClass:[YTOCasaMeaViewController class]])
    {
        
        YTOCasaMeaViewController * parent = (YTOCasaMeaViewController *)self.controller;
        
        if (!editingMode && [locuinta isValidForGothaer]) {
            parent.locuinta = locuinta;
            [appDelegate.rcaNavigationController popViewControllerAnimated:YES];
        }
        else {
            YTOCasaViewController * aView;
            if (IS_IPHONE_5)
                aView = [[YTOCasaViewController alloc] initWithNibName:@"YTOCasaViewController_R4" bundle:nil];
            else aView = [[YTOCasaViewController alloc] initWithNibName:@"YTOCasaViewController" bundle:nil];
            aView.controller = self.controller;
            aView.locuinta = locuinta;
            [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
        }
    }
    else if ([self.controller isKindOfClass:[YTOSetariViewController class]])
    {
        YTOLocuinta * pAux = [YTOLocuinta getLocuinta:locuinta.idIntern];
        YTOCasaViewController * aView;
        if (IS_IPHONE_5)
            aView = [[YTOCasaViewController alloc] initWithNibName:@"YTOCasaViewController_R4" bundle:nil];
        else aView = [[YTOCasaViewController alloc] initWithNibName:@"YTOCasaViewController" bundle:nil];
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
    else if ([self.controller isKindOfClass:[YTOAsigurareViewController class]])
    {
        YTOAsigurareViewController * parent = (YTOAsigurareViewController*)self.controller;
        [parent setLocuinta:locuinta];
        [appDelegate.setariNavigationController popViewControllerAnimated:YES];
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
    editingMode = NO;
    [tableView setEditing:NO];
    
    YTOCasaViewController * aView;
    if (IS_IPHONE_5)
        aView = [[YTOCasaViewController alloc] initWithNibName:@"YTOCasaViewController_R4" bundle:nil];
    else aView = [[YTOCasaViewController alloc] initWithNibName:@"YTOCasaViewController" bundle:nil];
    YTOAppDelegate * appDelegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if ([self.controller isKindOfClass:[YTOLocuintaViewController class]] || [self.controller isKindOfClass:[YTOCasaMeaViewController class]])
    {
        aView.controller = (YTOLocuintaViewController *)self.controller;
        [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
    }
    else if ([self.controller isKindOfClass:[YTOSetariViewController class]])
    {
        aView.controller = self;
        [appDelegate.setariNavigationController pushViewController:aView animated:YES];        
    }
    else if ([self.controller isKindOfClass:[YTOAsigurareViewController class]])
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
    if (listaLocuinte.count > 0)
        [YTOUtils rightImageVodafone:self.navigationItem];
    [tableView reloadData];
    [self verifyViewMode];
}

- (IBAction) callEditItems
{
    if (!editingMode)
    {
        editingMode = YES;
        [tableView setEditing:YES];
         [tableView reloadData];
        UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"checked.png"]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(callEditItems)];
        self.navigationItem.rightBarButtonItem = btnDone;
        [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStyleDone];
        lblEditeaza.font = [UIFont fontWithName:@"ChalkboardSE-Bold" size:14];
    }
    else
    {
        editingMode = NO;
        [tableView setEditing:NO];
        [tableView reloadData];
   //     UIBarButtonItem *btnEdit = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(callEditItems)];
//        self.navigationItem.rightBarButtonItem = btnEdit;
        [YTOUtils rightImageVodafone:self.navigationItem];
        lblEditeaza.font = [UIFont fontWithName:@"ChalkboardSE-Regular" size:14];
        [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
    }
}
@end
