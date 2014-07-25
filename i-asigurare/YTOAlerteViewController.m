//
//  YTOSecondViewController.m
//  i-asigurare
//
//  Created by Andi Aparaschivei on 7/12/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
//

#import "YTOAlerteViewController.h"
#import "YTOAppDelegate.h"
#import "YTOFormAlertaViewController.h"
#import "YTOAlerta.h"
#import "YTOUtils.h"
#import "CellAlertaCustom.h"
#import <QuartzCore/QuartzCore.h>
#import "YTOUserDefaults.h"
#import "YTOAutovehicul.h"
#import "UILabel+dynamicSizeMe.h"

@interface YTOAlerteViewController ()

@end

@implementation YTOAlerteViewController

@synthesize controller;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if ([[YTOUserDefaults getLanguage] isEqualToString:@"hu"])
            self.title = @"Riasztások";
        else if ([[YTOUserDefaults getLanguage] isEqualToString:@"en"])
            self.title = @"See alerts";
        else self.title = @"Vezi alerte";
        self.tabBarItem.image = [UIImage imageNamed:@"menu-alerte.png"];
    }
    return self;
}
							
- (void) viewDidLoad
{
    [super viewDidLoad];
  //  //self.trackedViewName = @"YTOAlerteViewController";
    lblPentruAlerte.text = NSLocalizedStringFromTable(@"i475", [YTOUserDefaults getLanguage],@"Pentru a salva alerte trebuie sa completezi informatiile in \"Datele Mele\".");
    lblZeroAlerte.text = NSLocalizedStringFromTable(@"i207", [YTOUserDefaults getLanguage],@"Nu exista alerte setate.\nPoti salva alerte pentru masini si\nlocuinte in \"Datele mele\"");
    lblCumAlerte.text = NSLocalizedStringFromTable(@"i803", [YTOUserDefaults getLanguage],@"Cum editezi alerte?");
    lblCumAlerte.textColor = [YTOUtils colorFromHexString:verde];
    [YTOUtils rightImageVodafone:self.navigationItem];
    [lblZeroAlerte resizeToFit];
    
    if (IS_OS_7_OR_LATER){
        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars=NO;
        self.automaticallyAdjustsScrollViewInsets=NO;
    }else [tableView setBackgroundView: nil];

}

- (void) viewDidAppear:(BOOL)animated
{
    if ([iRate sharedInstance].shouldPromptForRating)
        [[iRate sharedInstance] promptForRating];
    if (![[YTOUserDefaults getUserName] isEqualToString:@""] && ![[YTOUserDefaults getPassword] isEqualToString:@""] && [YTOUserDefaults getUserName] != nil && [YTOUserDefaults getPassword] != nil  )
    {
        [tableView reloadData];
    }
    
    int i = [YTOAlerta getPositionToScroll];
    if (i!=0)
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i ]  atScrollPosition:1 animated:YES];
    
    if ([[YTOUserDefaults getLanguage] isEqualToString:@"hu"])
        self.title = @"Riasztások";
    else if ([[YTOUserDefaults getLanguage] isEqualToString:@"en"])
        self.title = @"See alerts";
    else self.title = @"Vezi alerte";
    UILabel *lbl11 = (UILabel * ) [cellHead viewWithTag:11];
    UILabel *lbl22 = (UILabel * ) [cellHead viewWithTag:22];
    
    NSString *string1 = NSLocalizedStringFromTable(@"i706", [YTOUserDefaults getLanguage],@"Alertele");
    NSString *string2 = NSLocalizedStringFromTable(@"i707", [YTOUserDefaults getLanguage],@"tale");
    NSString *string  = [[NSString alloc]initWithFormat:@"%@ %@",string1,string2];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")){
        NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        [attributedString beginEditing];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[YTOUtils colorFromHexString:albastruAlerte] range:NSMakeRange(0, string1.length+1)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[YTOUtils colorFromHexString:ColorTitlu] range:NSMakeRange(string1.length+1, string2.length)];
        [attributedString beginEditing];
        
        [lbl11 setAttributedText:attributedString];
    }else{
        [lbl11 setText:string];
        [lbl11 setTextColor:[YTOUtils colorFromHexString:albastruAlerte]];
    }
    lbl22.text = NSLocalizedStringFromTable(@"i708", [YTOUserDefaults getLanguage],@"i-Asigurare tine minte pentru tine");
}

- (void) viewWillAppear:(BOOL)animated
{
   // YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    listAlerte = [YTOAlerta AlerteActive];
    
    [self verifyViewMode];
    
    counter = 0;
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
        [tableView reloadData];
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
    return listAlerte.count;
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
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
        if (alerta.tipAlerta == 6 || alerta.tipAlerta == 8)
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
        detaliu = NSLocalizedStringFromTable(@"i476", [YTOUserDefaults getLanguage],@"expirare\nasigurare");
        val = masina ? [NSString stringWithFormat:@"%@, %@", masina.marcaAuto, masina.nrInmatriculare] : @"";
        img = [UIImage imageNamed:@"icon-alerta-rca.png"];
    }
    else if (alerta.tipAlerta == 2) // ITP
    {
        detaliu = NSLocalizedStringFromTable(@"i479", [YTOUserDefaults getLanguage],@"expirare\nITP");
        val = masina ? [NSString stringWithFormat:@"%@, %@", masina.marcaAuto, masina.nrInmatriculare] : @"";
        img = [UIImage imageNamed:@"icon-alerta-itp.png"];
    }
    else if (alerta.tipAlerta == 3) // Rovinieta
    {
        detaliu = NSLocalizedStringFromTable(@"i477", [YTOUserDefaults getLanguage],@"expirare\nRovinieta");
        val = masina ? [NSString stringWithFormat:@"%@, %@", masina.marcaAuto, masina.nrInmatriculare] : @"";
        img = [UIImage imageNamed:@"icon-alerta-rovinieta.png"];
    }
    else if (alerta.tipAlerta == 5) // CASCO
    {
        detaliu = NSLocalizedStringFromTable(@"i476", [YTOUserDefaults getLanguage],@"expirare\nasigurare");
        val = masina ? [NSString stringWithFormat:@"%@, %@", masina.marcaAuto, masina.nrInmatriculare] : @"";
        img = [UIImage imageNamed:@"icon-alerta-casco.png"];
    }
    else if (alerta.tipAlerta == 6) // Locuinta
    {
        detaliu = NSLocalizedStringFromTable(@"i476", [YTOUserDefaults getLanguage],@"expirare\nasigurare");
        val = [NSString stringWithFormat:@"%@, %d mp2", locuinta.judet, locuinta.suprafataUtila];
        img = [UIImage imageNamed:@"icon-alerta-locuinta.png"];
    }
    else if (alerta.tipAlerta == 7)
    {
        detaliu = NSLocalizedStringFromTable(@"i478", [YTOUserDefaults getLanguage],@"rata\nscadenta");
        val = masina ? [NSString stringWithFormat:@"%@, %@", masina.marcaAuto, masina.nrInmatriculare] : @"";
        img = [UIImage imageNamed:@"icon-alerta-rata-casco.png"];
    }
    else if (alerta.tipAlerta == 8)
    {
        detaliu = NSLocalizedStringFromTable(@"i478", [YTOUserDefaults getLanguage],@"rata\nscadenta");
        val = [NSString stringWithFormat:@"%@, %d mp2", locuinta.judet, locuinta.suprafataUtila];
        img = [UIImage imageNamed:@"icon-alerta-rata-locuinta.png"];
    }
    
    [cell setDetaliuAlerta:detaliu];
    [cell setNumar:val];
    [cell setAlertaImage:img];
    
    return cell;
}

#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    counter++;
    if (counter == 3) vwPopup.hidden = NO;
    
    /*
    YTOFormAlertaViewController * aView = [[YTOFormAlertaViewController alloc] init];
    aView.controller = self;
    aView.alerta = [listAlerte objectAtIndex:indexPath.section];
    YTOAppDelegate * appDelegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.alerteNavigationController pushViewController:aView animated:YES];
     */
}

- (IBAction) countClick
{
    counter++;
    if (counter == 3) vwPopup.hidden = NO;
}

- (IBAction) hidePopup
{
    vwPopup.hidden = YES;
}

#pragma METHODS

- (void) reloadData
{
    //YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    listAlerte = [YTOAlerta AlerteActive];
    
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
