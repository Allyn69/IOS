//
//  YTOListaAutoViewController.m
//  i-asigurare
//
//  Created by Andi Aparaschivei on 7/18/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
//

#import "YTOListaAutoViewController.h"
#import "YTOAppDelegate.h"
#import "YTOCalculatorViewController.h"
#import "YTOCASCOViewController.h"
#import "YTOAutovehiculViewController.h"
#import "YTOSetariViewController.h"
#import "YTOValabilitateRCAViewController.h"
#import "Database.h"
#import "YTOUtils.h"
#import "YTOImage.h"
#import "YTOFormAlertaViewController.h"
#import "YTOAsigurareViewController.h"
#import "YTOUserDefaults.h"

@interface YTOListaAutoViewController ()

@end

@implementation YTOListaAutoViewController

@synthesize controller;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedStringFromTable(@"i264", [YTOUserDefaults getLanguage],@"Lista masini");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.trackedViewName = @"YTOListaAutoViewController";
    YTOAppDelegate * appDelegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate refreshAlerte];
    tableView.allowsSelectionDuringEditing = YES;
    
    lblAdaugaAuto.text = NSLocalizedStringFromTable(@"i266", [YTOUserDefaults getLanguage],@"Adauga autovehicul");
    lblWvEmply1.text = NSLocalizedStringFromTable(@"i265", [YTOUserDefaults getLanguage],@"Nu exista masini salvate. Pentru a adauga o noua masina, apasa butonul de mai sus");
    lblWvEmply2.text = NSLocalizedStringFromTable(@"i166", [YTOUserDefaults getLanguage], @"Adauga auto");
    lblEditare.textColor = [YTOUtils colorFromHexString:@"#78a9b9"];
    lblAdauga.textColor = [YTOUtils colorFromHexString:@"#78a9b9"];
    if (IS_OS_7_OR_LATER){
        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars=NO;
        self.automaticallyAdjustsScrollViewInsets=NO;
    }else [tableView setBackgroundView: nil];
}

- (void) viewDidAppear:(BOOL)animated
{
   // editingMode = NO;
    [super viewDidAppear:animated];
    [self reloadData];
}

- (void) viewWillAppear:(BOOL)animated
{
    YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
    listaMasini = [delegate Masini];
    
    ((UILabel *)[vwEmpty viewWithTag:11]).textColor = [YTOUtils colorFromHexString:@"#009145"];
    ((UILabel *)[vwEmpty viewWithTag:10]).textColor = [YTOUtils colorFromHexString:@"#4d4d4d"];
    
    [self verifyViewMode];
    
}

- (void) verifyViewMode
{
    if (listaMasini.count == 0)
    {
        //self.navigationItem.rightBarButtonItem = nil;
        [YTOUtils rightImageVodafone:self.navigationItem];
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
        [YTOUtils rightImageVodafone:self.navigationItem];
    }
    if (![controller isKindOfClass:[YTOSetariViewController class]])
        [YTOUtils rightImageVodafone:self.navigationItem];
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
    
    if (!editingMode){
        cell.textLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    }else{
        cell.textLabel.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:20];
    }
    cell.textLabel.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    cell.detailTextLabel.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    if (!editingMode){
        cell.detailTextLabel.font = [UIFont fontWithName:@"Arial" size:16];
    }else{
        cell.detailTextLabel.font = [UIFont fontWithName:@"Arial-ItalicMT" size:16];
    }
    YTOAutovehicul * a = (YTOAutovehicul *)[listaMasini objectAtIndex:indexPath.row];
    if (a.idImage && a.idImage.length > 0)
    {
        YTOImage *objImage = [YTOImage getImage:a.idImage];
        cell.imageView.image = objImage.image;
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    else
        cell.imageView.image = [UIImage imageNamed:@"marca-auto.png"];
    
    cell.textLabel.text = [a.marcaAuto uppercaseString];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", a.modelAuto, a.nrInmatriculare];
    
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
    float completedPercent =[a CompletedPercent];
    [progressv setProgress:completedPercent];
    progressv.progressTintColor = [YTOUtils colorFromHexString:ColorVerde];
    progressv.alpha=0.8;
    
    UILabel * lblPercent ;
    if (IS_OS_7_OR_LATER) lblPercent = [[UILabel alloc] initWithFrame:CGRectMake(16, 46, 47, 30)];
    else lblPercent = [[UILabel alloc] initWithFrame:CGRectMake(8, 46, 47, 30)];
    lblPercent.font = [UIFont fontWithName:@"Arial" size:9]; lblPercent.textAlignment = UITextAlignmentCenter;
    lblPercent.text = [[NSString stringWithFormat:@"%.0f", completedPercent*100] stringByAppendingString:@" %"];
    lblPercent.backgroundColor = [UIColor clearColor];
    if (!IS_OS_7_OR_LATER){
        [cell addSubview:progressv];
        [cell addSubview:lblPercent];
    }
//    if (editingMode)
//    {
//        cell.editingAccessoryType = UITableViewCellEditingStyleDelete;
//    }else {
//        cell.editingAccessoryType = UITableViewCellStyleDefault;
//    }
    if (completedPercent < 1 || editingMode)
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YTOAutovehicul * masina = [listaMasini objectAtIndex:indexPath.row];
    
    YTOAppDelegate * appDelegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (editingMode && [self.controller isKindOfClass:[YTOCalculatorViewController class]])
    {
        YTOAutovehiculViewController * aView;
        if (IS_IPHONE_5)
            aView = [[YTOAutovehiculViewController alloc] initWithNibName:@"YTOAutovehiculViewController_R4" bundle:nil];
        else aView = [[YTOAutovehiculViewController alloc] initWithNibName:@"YTOAutovehiculViewController" bundle:nil];
        aView.controller = self;
        aView.autovehicul = masina;
        [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
    }else if ([self.controller isKindOfClass:[YTOSetariViewController class]])
    {
        YTOAutovehiculViewController * aView;
        if (IS_IPHONE_5)
            aView = [[YTOAutovehiculViewController alloc] initWithNibName:@"YTOAutovehiculViewController_R4" bundle:nil];
        else aView = [[YTOAutovehiculViewController alloc] initWithNibName:@"YTOAutovehiculViewController" bundle:nil];
        aView.controller = self;
        aView.autovehicul = masina;
        [appDelegate.setariNavigationController pushViewController:aView animated:YES];
    }else if (!editingMode && [self.controller isKindOfClass:[YTOValabilitateRCAViewController class]])
    {
        YTOValabilitateRCAViewController * parent = (YTOValabilitateRCAViewController *)self.controller;
        [parent setAutovehicul:masina];
        [appDelegate.alteleNavigationController popViewControllerAnimated:YES];
    }else if (editingMode && [self.controller isKindOfClass:[YTOValabilitateRCAViewController class]])
    {
        YTOAutovehiculViewController * aView;
        if (IS_IPHONE_5)
            aView = [[YTOAutovehiculViewController alloc] initWithNibName:@"YTOAutovehiculViewController_R4" bundle:nil];
        else aView = [[YTOAutovehiculViewController alloc] initWithNibName:@"YTOAutovehiculViewController" bundle:nil];
        aView.controller = self.controller;
        aView.autovehicul = masina;
        [appDelegate.alteleNavigationController pushViewController:aView animated:YES];
    }
    else if ([self.controller isKindOfClass:[YTOCalculatorViewController class]])
    {
        YTOCalculatorViewController * parent = (YTOCalculatorViewController *)self.controller;
        
        // TRUE -  Daca masina este valida, se poate
        //         folosi pentru calculatia RCA
        // FALSE - Se incarca formularul de masina, iar la
        //         salvare, se afiseaza calculatorul RCA
        if ([masina isValidForRCA] && !editingMode)
        {
            [parent setAutovehicul:masina];
            [appDelegate.rcaNavigationController popViewControllerAnimated:YES];
        }
        else
        {
            YTOAutovehiculViewController * aView;
            if (IS_IPHONE_5)
                aView = [[YTOAutovehiculViewController alloc] initWithNibName:@"YTOAutovehiculViewController_R4" bundle:nil];
            else aView = [[YTOAutovehiculViewController alloc] initWithNibName:@"YTOAutovehiculViewController" bundle:nil];
            aView.controller = self.controller;
            aView.autovehicul = masina;
            [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
        }
    }
//    else if (editingMode &&[self.controller isKindOfClass:[YTOCASCOViewController class]])
//    {
//        YTOCASCOViewController * parent = (YTOCASCOViewController *)self.controller;
//        
//        // TRUE -  Daca masina este valida, se poate
//        //         folosi pentru calculatia RCA
//        // FALSE - Se incarca formularul de masina, iar la
//        //         salvare, se afiseaza calculatorul RCA
//        if ([masina isValidForRCA])
//        {
//            [parent setAutovehicul:masina];
//            [appDelegate.rcaNavigationController popViewControllerAnimated:YES];
//        }
//        else
//        {
//            YTOAutovehiculViewController * aView;
//            if (IS_IPHONE_5)
//                aView = [[YTOAutovehiculViewController alloc] initWithNibName:@"YTOAutovehiculViewController_R4" bundle:nil];
//            else aView = [[YTOAutovehiculViewController alloc] initWithNibName:@"YTOAutovehiculViewController" bundle:nil];
//            aView.controller = self.controller;
//            aView.autovehicul = masina;
//            [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
//        }
//    }
    else if ([self.controller isKindOfClass:[YTOSetariViewController class]])
    {
        YTOAutovehiculViewController * aView;
        if (IS_IPHONE_5)
            aView = [[YTOAutovehiculViewController alloc] initWithNibName:@"YTOAutovehiculViewController_R4" bundle:nil];
        else aView = [[YTOAutovehiculViewController alloc] initWithNibName:@"YTOAutovehiculViewController" bundle:nil];
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
    else if ([self.controller isKindOfClass:[YTOAsigurareViewController class]])
    {
        YTOAsigurareViewController * parent = (YTOAsigurareViewController*)self.controller;
        [parent setAutovehicul:masina];
        [appDelegate.setariNavigationController popViewControllerAnimated:YES];
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
    
    YTOAutovehiculViewController * aView;
    if (IS_IPHONE_5)
        aView = [[YTOAutovehiculViewController alloc] initWithNibName:@"YTOAutovehiculViewController_R4" bundle:nil];
    else aView = [[YTOAutovehiculViewController alloc] initWithNibName:@"YTOAutovehiculViewController" bundle:nil];
    YTOAppDelegate * appDelegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    if ([self.controller isKindOfClass:[YTOCalculatorViewController class]])
    {
        aView.controller = self;
        [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
    }
    if ([self.controller isKindOfClass:[YTOCASCOViewController class]])
    {
        aView.controller = (YTOCASCOViewController *)self.controller;
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
    else if ([self.controller isKindOfClass:[YTOAsigurareViewController class]])
    {
        aView.controller = self;
        [appDelegate.setariNavigationController pushViewController:aView animated:YES];
    }
}

- (void) reloadData
{
    YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
    listaMasini = [delegate Masini];
    
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



- (IBAction) callEditItems
{
    if (!editingMode)
    {
        editingMode = YES;
        [tableView setEditing:editingMode];
        [tableView reloadData];
        
        UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"checked.png"]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(callEditItems)];
        self.navigationItem.rightBarButtonItem = btnDone;
      //  [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStyleDone];
        lblEditare.font = [UIFont fontWithName:@"ChalkboardSE-Bold" size:14];
    }
    else
    {
        editingMode = NO;
         [tableView setEditing:editingMode];
        [tableView reloadData];
        UIBarButtonItem *btnEdit = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(callEditItems)];
        self.navigationItem.rightBarButtonItem = btnEdit;
    //    [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
         [YTOUtils rightImageVodafone:self.navigationItem];
           lblEditare.font = [UIFont fontWithName:@"ChalkboardSE-Regular" size:14];
        
    }
}
@end
