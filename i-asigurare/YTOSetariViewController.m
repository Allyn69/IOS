//
//  YTOSetariViewController.m
//  i-asigurare
//
//  Created by Andi Aparaschivei on 7/19/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
//

#import "YTOSetariViewController.h"
#import "YTOComenziFromWebViewController.h"
#import "YTOListaAutoViewController.h"
#import "YTOListaLocuinteViewController.h"
#import "YTOListaAsiguratiViewController.h"
#import "YTOAsiguratViewController.h"
#import "YTOAutovehicul.h"
#import "YTOLocuinta.h"
#import "YTOPersoana.h"
#import "YTOUserDefaults.h"
#import "VerifyNet.h"
#import "YTOLoginViewController.h"
#import "YTORegisterViewController.h"
#import "YTOUtils.h"
//#import <CoreTelephony/CTCarrier.h>
//#import<CoreTelephony/CTCallCenter.h>
//#import<CoreTelephony/CTCall.h>
//#import<CoreTelephony/CTCarrier.h>
//#import<CoreTelephony/CTTelephonyNetworkInfo.h>

@interface YTOSetariViewController ()

@end

@implementation YTOSetariViewController

@synthesize responseData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if ([[YTOUserDefaults getLanguage] isEqualToString:@"hu"]){
            self.title = @"Adataim";
        }
        else if ([[YTOUserDefaults getLanguage] isEqualToString:@"en"]){
            self.title = @"My data";
        }
        else self.title =@"Datele tale";
        //self.title = NSLocalizedStringFromTable(@"i228", [YTOUserDefaults getLanguage], @"Datele mele");
        self.tabBarItem.image = [UIImage imageNamed:@"menu-datele-mele.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.trackedViewName = @"YTOSetariViewController";
    
    [self initCells];
    canUpdate = YES;
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(callSyncItems) forControlEvents:UIControlEventValueChanged];
    [tableView addSubview:refreshControl];
    
    NSString *title = @"";
    NSString *subTitle = @"Se actualizeaza datele";
    
    NSMutableAttributedString *titleAttString =  [[NSMutableAttributedString alloc] initWithString:title];
    NSMutableAttributedString *subTitleAttString =  [[NSMutableAttributedString alloc] initWithString:subTitle];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")){
        
        [titleAttString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:20.0f] range:NSMakeRange(0, [title length])];
        [subTitleAttString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:14.0f] range:NSMakeRange(0,[subTitle length])];
        
        [titleAttString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [title length])];
        [subTitleAttString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, [subTitle length])];
        
        [titleAttString appendAttributedString:subTitleAttString];
        
        refreshControl.attributedTitle = titleAttString;
    }
    // [refreshControl addSubview:lbl];
    //    if ([YTOUserDefaults IsSyncronized] == NO)
    //    {
    //        //btnEdit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(confirmSync)];
    //        //btnEdit = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sincronizare.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(confirmSync)];
    //
    //        UIButton *a1 = [UIButton buttonWithType:UIButtonTypeCustom];
    //        [a1 setFrame:CGRectMake(0.0f, 0.0f, 41.0f, 25.0f)];
    //        [a1 addTarget:self action:@selector(confirmSync) forControlEvents:UIControlEventTouchUpInside];
    //        [a1 setImage:[UIImage imageNamed:@"sincronizare.png"] forState:UIControlStateNormal];
    //        UIBarButtonItem *btnEdit = [[UIBarButtonItem alloc] initWithCustomView:a1];
    //        self.navigationItem.leftBarButtonItem = btnEdit;
    //        lblLoad.text = NSLocalizedStringFromTable(@"i444", [YTOUserDefaults getLanguage],@"loading");
    //    }
    if (IS_OS_7_OR_LATER){
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }else [tableView setBackgroundView: nil];
    //vodafone
    //    UIImageView * item3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"powered-by-vdf.png"]];
    //    UIView * vw3 = [[UIView alloc] initWithFrame:CGRectMake(270, 0, 50,40)];
    
    [YTOUtils rightImageVodafone:self.navigationItem];
    // Daca nu s-a facut  sincronizarea,
    // se apeleaza metoda din serviciu
    //if ([YTOUserDefaults IsSyncronized] == NO)
    //    [self callSyncItems];
    
    // Do any additional setup after loading the view from its nib.
    //    [self startLoadingAnimantion];
    //    [self performSelector:@selector(stopLoadingAnimantion) withObject:nil afterDelay:3.2];
    
    
}

- (IBAction)showDeCeInfo:(id)sender
{
    vwDeCeInfo.hidden = NO;
    NSString* htmlContentString = [NSString stringWithFormat:
                                   @"<html xmlns='http://www.w3.org/1999/xhtml'>"
                                   "<head>"
                                   "<p><center><strong style='color:#cf3030'>De ce iti cerem atatea informatii?</strong><br /></center></p>"
                                   "</head>"
                                   "<body style='font-family:Arial; font-size:.8em; color:#464646;'>"
                                   "<span style='font:.9em'></span>"
                                   "Tarifele RCA variaza in functie de anumite date. De exemplu, daca introduci o alta serie de sasiu sau un alt judet, vei obtine alte preturi decat cel al asigurarii tale:<br /><br />"
                                   "<strong> CNP : </strong> pe baza lui se stabileste categoria de bonus/malus, in functie de istoricul daunelor si varsta;<br />"
                                   "<br />"
                                   "<strong> Seria de sasiu : </strong> se verifica daca exista daune inregistrate in baza de date CEDAM (evidenta  centralizata a politelor RCA din Romania,implementata si mentinuta de Comisia de Supraveghere a Asigurarilor) <br /><br />"
                                   "<strong> Judet & localitate : </strong> societatile de asigurare au tarife diferentiate pe zone - de ex. preturile pot fi mai mari pentru anumite orase unde , conform statisticilor, riscul de accidente este mai mare<br /><br />"
                                   "<strong> Casatorit / Copii minori / Bugetar : </strong> anumite societati de asigurare acorda reduceri pentru persoanele incadrate in aceste categorii;<br /><br />"
                                   "<strong> Putere (kW), capacitate cilindrica, numar de locuri, masa maxima : </strong> acestea sunt criterii folosite de compania de asigurare pentru stabilirea primei.<br />"
                                   "<p style='color:#808080'>Datele tale sunt in siguranta! Suntem inregistrati la ANSPDCP ca operatori de date cu caracter personal, avand nr. 21266.</p>"
                                   "</body>"
                                   "</html>"];
    
    [webView loadHTMLString:htmlContentString baseURL:nil];
}

- (IBAction)hideDeCeInfo:(id)sender
{
    vwDeCeInfo.hidden = YES;
    //[YTOUserDefaults setIsFirstCalc:YES];
    //[tableView reloadData];
    //vwBtnDeCeInfo.hidden = YES;
}

- (void) viewDidAppear:(BOOL)animated
{
    // [YTOUserDefaults setSyncronized:YES];
    if ([iRate sharedInstance].shouldPromptForRating)
        [iRate sharedInstance].promptForRating;
    if ([[YTOUserDefaults getLanguage] isEqualToString:@"hu"]){
        self.title = @"Adataim";
    }
    canUpdate = YES;
    
    
    NSString *str = [NSString stringWithFormat:@"%@" , [YTOUserDefaults getUserName]];
    if ([YTOUserDefaults getUserName] != nil && ![[YTOUserDefaults getUserName] isEqualToString:@""]){
        //        if (str.length >10){
        //            NSRange range = [str rangeOfString:@"@" options:NSBackwardsSearch range:NSMakeRange(0, 11)];
        //            str = [str substringToIndex:range.location];
        //        }
        [logInButton setTitle:str forState:UIControlStateNormal];
        [registerButton setTitle:@"Iesire cont" forState:UIControlStateNormal];
    }
    
    vwBtnDeCeInfo.hidden = YES;
    if ([[YTOUserDefaults getLanguage] isEqualToString:@"en"]){
        self.title = @"My data";
    }
    else self.title =@"Datele tale";
    UILabel *lbl11 = (UILabel * ) [cellHead viewWithTag:11];
    UILabel *lbl22 = (UILabel * ) [cellHead viewWithTag:22];
    
    NSString *string1 = @"i-Asigurare";
    NSString *string2 = @"app";
    NSString *string  = [[NSString alloc]initWithFormat:@"%@ %@",string1,string2];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")){
        NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        [attributedString beginEditing];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[YTOUtils colorFromHexString:verde] range:NSMakeRange(0, string1.length+1)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[YTOUtils colorFromHexString:ColorTitlu] range:NSMakeRange(string1.length+1, string2.length)];
        [attributedString beginEditing];
        
        [lbl11 setAttributedText:attributedString];
    }else{
        [lbl11 setText:string];
        [lbl11 setTextColor:[YTOUtils colorFromHexString:verde]];
    }
    
    lbl22.text = NSLocalizedStringFromTable(@"i705", [YTOUserDefaults getLanguage],@"asigura-te inteligent de pe telefonul tau");
    
    //    if (![[YTOUserDefaults getUserName] isEqualToString:@""] && ![[YTOUserDefaults getPassword] isEqualToString:@""] && [YTOUserDefaults getUserName] != nil && [YTOUserDefaults getPassword] != nil  )
    //    {
    //        UIButton *a1 = [UIButton buttonWithType:UIButtonTypeCustom];
    //        [a1 setFrame:CGRectMake(0.0f, 0.0f, 41.0f, 25.0f)];
    //        [a1 addTarget:self action:@selector(confirmSync) forControlEvents:UIControlEventTouchUpInside];
    //        [a1 setImage:[UIImage imageNamed:@"sincronizare.png"] forState:UIControlStateNormal];
    //        UIBarButtonItem *btnEdit = [[UIBarButtonItem alloc] initWithCustomView:a1];
    //        self.navigationItem.leftBarButtonItem = btnEdit;
    //        lblLoad.text = NSLocalizedStringFromTable(@"i444", [YTOUserDefaults getLanguage],@"loading");
    //    }else self.navigationItem.leftBarButtonItem = nil;
}

- (void) viewWillAppear:(BOOL)animated
{
    [tableView reloadData];
    
    //get career
    //    CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
    //    CTCarrier *car = [netinfo subscriberCellularProvider];
    //    NSLog(@"Carrier Name: %@", car.carrierName);
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
    return 5;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //    if (![YTOUserDefaults isFirstCalc] && section == 0)
    //        return 40;
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (indexPath.section == 1){
    //        if (IS_OS_7_OR_LATER)
    //            return 50;
    //        else return 50;
    //    }
    //    if (IS_OS_7_OR_LATER)
    //        return 80;
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    //    if (indexPath.section == 1){
    //        cell = cellCont;
    //        logInButton = (UIButton *)[cell viewWithTag:1];
    //        registerButton = (UIButton *) [cell viewWithTag:2];
    //        [logInButton addTarget:self action:@selector(loginMethod) forControlEvents:UIControlEventTouchUpInside];
    //        [registerButton addTarget:self action:@selector(registerMethod) forControlEvents:UIControlEventTouchUpInside];
    //    }
    if (indexPath.section == 0)
    {
        cell = cellProfilulMeu;
        ((UIImageView *)[cell viewWithTag:1]).image = [UIImage imageNamed:@"setari-profilul-meu.png"];
        ((UILabel *)[cell viewWithTag:2]).text = NSLocalizedStringFromTable(@"i231", [YTOUserDefaults getLanguage],@"PROFILUL MEU");;
        
        // Incarc proprietar PF, daca nu exista incarcam proprietar PJ
        YTOPersoana * proprietar = [YTOPersoana Proprietar];
        YTOPersoana * proprietarPJ = [YTOPersoana ProprietarPJ];
        if (!proprietar)
        {
            proprietar = proprietarPJ;
        }
        
        if (proprietar && proprietar.nume.length > 0)
        {
            ((UILabel *)[cell viewWithTag:3]).text = proprietar.nume;
            ((UILabel *)[cell viewWithTag:3]).textColor = [YTOUtils colorFromHexString:@"#cb2929"];
        }
        else if (proprietarPJ && proprietarPJ.nume.length > 0)
        {
            ((UILabel *)[cell viewWithTag:3]).text = proprietarPJ.nume;
            ((UILabel *)[cell viewWithTag:3]).textColor = [YTOUtils colorFromHexString:@"#cb2929"];
        }
        else {
            ((UILabel *)[cell viewWithTag:3]).text = NSLocalizedStringFromTable(@"i232", [YTOUserDefaults getLanguage],@"Configureaza profilul tau");;
            ((UILabel *)[cell viewWithTag:3]).textColor = [YTOUtils colorFromHexString:@"#b3b3b3"];
        }
    }
    else if (indexPath.section == 1)
    {
        cell = cellMasinileMele;
        ((UIImageView *)[cell viewWithTag:1]).image = [UIImage imageNamed:@"setari-masinile-mele.png"];
        ((UILabel *)[cell viewWithTag:2]).text = NSLocalizedStringFromTable(@"i261", [YTOUserDefaults getLanguage],@"MASINILE MELE");;
        //        UIScrollView * scrollView = (UIScrollView *)[cell viewWithTag:4];
        YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSMutableArray * masini = [delegate Masini];
        //        for (int i=0; i<masini.count; i++) {
        //            UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(i*60, 5, 30, 30)];
        //            img.image = [UIImage imageNamed:@"marca-auto.png"]; //[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", ((YTOAutovehicul *)[masini objectAtIndex:i]).marcaAuto]];
        //            UILabel * lbl = [[UILabel alloc] initWithFrame:CGRectMake(i*60, 35, 60, 20)];
        //            lbl.text = [((YTOAutovehicul *)[masini objectAtIndex:i]).nrInmatriculare uppercaseString];
        //            lbl.font = [UIFont fontWithName:@"Arial" size:10];
        //            [scrollView addSubview:img];
        //            [scrollView addSubview:lbl];
        //        }
        if (masini.count > 0)
        {
            ((UILabel *)[cell viewWithTag:3]).text = [NSString stringWithFormat:@"%d %@", masini.count, (masini.count == 1 ? NSLocalizedStringFromTable(@"i263", [YTOUserDefaults getLanguage],@"masina") : NSLocalizedStringFromTable(@"i262", [YTOUserDefaults getLanguage],@"masini") )];
            ((UILabel *)[cell viewWithTag:3]).textColor = [YTOUtils colorFromHexString:@"#4b4b4b"];
        }
        else
        {
            ((UILabel *)[cell viewWithTag:3]).text = [NSString stringWithFormat:@"%@%@",@"0 ",NSLocalizedStringFromTable(@"i262", [YTOUserDefaults getLanguage],@"masini")];
            ((UILabel *)[cell viewWithTag:3]).textColor = [YTOUtils colorFromHexString:@"#b3b3b3"];
        }
    }
    else if (indexPath.section == 2)
    {
        cell = cellLocuinteleMele;
        ((UIImageView *)[cell viewWithTag:1]).image = [UIImage imageNamed:@"setari-locuintele-mele.png"];
        ((UILabel *)[cell viewWithTag:2]).text = NSLocalizedStringFromTable(@"i358", [YTOUserDefaults getLanguage],@"LOCUINTELE MELE");
        YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSMutableArray * locuinte = [delegate Locuinte];
        if (locuinte.count > 0)
        {
            ((UILabel *)[cell viewWithTag:3]).text = [NSString stringWithFormat:@"%d %@", locuinte.count, (locuinte.count == 1 ? NSLocalizedStringFromTable(@"i360", [YTOUserDefaults getLanguage],@"locuinta") : NSLocalizedStringFromTable(@"i359", [YTOUserDefaults getLanguage],@"locuinte") )];
            ((UILabel *)[cell viewWithTag:3]).textColor = [YTOUtils colorFromHexString:@"#4b4b4b"];
        }
        else
        {
            ((UILabel *)[cell viewWithTag:3]).text = [NSString stringWithFormat:@"%@%@",@"0 ",NSLocalizedStringFromTable(@"i359", [YTOUserDefaults getLanguage],@"locuinte")];
            ((UILabel *)[cell viewWithTag:3]).textColor = [YTOUtils colorFromHexString:@"#b3b3b3"];
        }
    }
    else if (indexPath.section == 3)
    {
        cell = cellAltePersoane;
        ((UIImageView *)[cell viewWithTag:1]).image = [UIImage imageNamed:@"setari-alte-persoane.png"];
        ((UILabel *)[cell viewWithTag:2]).text = NSLocalizedStringFromTable(@"i414", [YTOUserDefaults getLanguage],@"ALTE PERSOANE ASIGURATE");;
        NSMutableArray * persoane = [YTOPersoana AltePersoane];
        if (persoane.count > 0)
        {
            ((UILabel *)[cell viewWithTag:3]).text = [NSString stringWithFormat:@"%d %@", persoane.count, (persoane.count == 1 ? NSLocalizedStringFromTable(@"i416", [YTOUserDefaults getLanguage],@"persoana") : NSLocalizedStringFromTable(@"i415", [YTOUserDefaults getLanguage],@"persoane"))];
            ((UILabel *)[cell viewWithTag:3]).textColor = [YTOUtils colorFromHexString:@"#4b4b4b"];
        }
        else
        {
            ((UILabel *)[cell viewWithTag:3]).text = [NSString stringWithFormat:@"%@%@",@"0 ",NSLocalizedStringFromTable(@"i415", [YTOUserDefaults getLanguage],@"persoane")];
            ((UILabel *)[cell viewWithTag:3]).textColor = [YTOUtils colorFromHexString:@"#b3b3b3"];
        }
    }
    else if (indexPath.section == 4)
    {
        cell = cellComenzileMele;
        ((UIImageView *)[cell viewWithTag:1]).image = [UIImage imageNamed:@"setari-asigurarile-mele.png"];
        ((UILabel *)[cell viewWithTag:2]).text = NSLocalizedStringFromTable(@"i427", [YTOUserDefaults getLanguage],@"COMENZILE MELE");
        
        //  NSMutableArray * asigurari = [YTOOferta Oferte];
        //        if (asigurari.count > 0)
        //        {
        ((UILabel *)[cell viewWithTag:3]).text =  @"Comenzi efectuate";
        ((UILabel *)[cell viewWithTag:3]).textColor = [YTOUtils colorFromHexString:@"#4b4b4b"];
        //        }
        
    }else cell = cellBlank;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    return cell;
}

- (void) loginMethod
{
    if ([[YTOUserDefaults getUserName] isEqualToString:@""] || [YTOUserDefaults getUserName] == nil){
        YTOAppDelegate * appDelegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
        YTOLoginViewController *aView = [[YTOLoginViewController alloc] init];
        if (IS_IPHONE_5)
            aView = [[YTOLoginViewController alloc] initWithNibName:@"YTOLoginViewController_R4" bundle:nil];
        else aView = [[YTOLoginViewController alloc] initWithNibName:@"YTOLoginViewController" bundle:nil];
        aView.navigationItem.title = NSLocalizedStringFromTable(@"i233", [YTOUserDefaults getLanguage],@"Intra in cont");
        [appDelegate.setariNavigationController pushViewController:aView animated:YES];
    }else {
        //do nothing
    }
}

- (void) registerMethod
{
    if ([[YTOUserDefaults getUserName] isEqualToString:@""] || [YTOUserDefaults getUserName] == nil){
        YTOAppDelegate * appDelegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
        YTORegisterViewController *aView = [[YTORegisterViewController alloc] init];
        if (IS_IPHONE_5)
            aView = [[YTORegisterViewController alloc] initWithNibName:@"YTORegisterViewController_R4" bundle:nil];
        else aView = [[YTORegisterViewController alloc] initWithNibName:@"YTORegisterViewController" bundle:nil];
        aView.navigationItem.title = NSLocalizedStringFromTable(@"i233", [YTOUserDefaults getLanguage],@"Inregistrare");
        [appDelegate.setariNavigationController pushViewController:aView animated:YES];
    }else {
        [self showCustomConfirm:@"" withDescription:@"Vrei sa iesi din contul tau?" withButtonIndex:200];
    }
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YTOAppDelegate * appDelegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (indexPath.section == 0)
    {
        YTOAsiguratViewController *aView = [[YTOAsiguratViewController alloc] init];
        if (IS_IPHONE_5)
            aView = [[YTOAsiguratViewController alloc] initWithNibName:@"YTOAsiguratViewController-R4" bundle:nil];
        else aView = [[YTOAsiguratViewController alloc] initWithNibName:@"YTOAsiguratViewController" bundle:nil];
        aView.proprietar = YES;
        aView.controller = self;
        aView.navigationItem.title = NSLocalizedStringFromTable(@"i233", [YTOUserDefaults getLanguage],@"Contul meu");
        [appDelegate.setariNavigationController pushViewController:aView animated:YES];
    }
    else if (indexPath.section == 1)
    {
        YTOListaAutoViewController * aView = [[YTOListaAutoViewController alloc] init];
        aView.controller = self;
        [appDelegate.setariNavigationController pushViewController:aView animated:YES];
    }
    else if (indexPath.section == 2)
    {
        YTOListaLocuinteViewController * aView = [[YTOListaLocuinteViewController alloc] init];
        aView.controller = self;
        [appDelegate.setariNavigationController pushViewController:aView animated:YES];
    }
    else if (indexPath.section == 3)
    {
        YTOListaAsiguratiViewController * aView;
        if (IS_IPHONE_5)
            aView = [[YTOListaAsiguratiViewController alloc] initWithNibName:@"YTOListaAsiguratiViewController_R4" bundle:nil];
        else aView = [[YTOListaAsiguratiViewController alloc] initWithNibName:@"YTOListaAsiguratiViewController" bundle:nil];
        aView.controller = self;
        [appDelegate.setariNavigationController pushViewController:aView animated:YES];
        
    }
    else if (indexPath.section == 4)
    {
        //        if ([[YTOUserDefaults getUserName] isEqualToString:@""] || [[YTOUserDefaults getPassword] isEqualToString:@""] || [YTOUserDefaults getUserName] == nil || [YTOUserDefaults getPassword] == nil  ){
        //            [self showCustomConfirm:@"" withDescription:@"Nu esti logat in contul i-Asigurare" withButtonIndex:300];
        //            return;
        //        }
        YTOComenziFromWebViewController * aView = [[YTOComenziFromWebViewController alloc] init];
        if (IS_IPHONE_5)
            aView = [[YTOComenziFromWebViewController alloc] initWithNibName:@"YTOComenziFromWebViewController_R4" bundle:nil];
        else aView = [[YTOComenziFromWebViewController alloc] initWithNibName:@"YTOComenziFromWebViewController" bundle:nil];
        aView.controller = self;
        [appDelegate.setariNavigationController pushViewController:aView animated:YES];
    }
}

- (void) initCells
{
    //    cellHeader = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
    //    UIImageView * imgHeader = [[UIImageView alloc] initWithFrame:CGRectMake(0, -10, 320, 68)];
    //    imgHeader.image = [UIImage imageNamed:@"header-first-screen.png"];
    //    [cellHeader addSubview:imgHeader];
    //    UILabel * lblLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 58, 320, 1)];
    //    [lblLine setBackgroundColor:[YTOUtils colorFromHexString:@"#b3b3b3"]];
    //    [cellHeader addSubview:imgHeader];
    //    [cellHeader addSubview:lblLine];
    
    NSArray *topLevelObjects1;
    //if (IS_OS_7_OR_LATER)
    topLevelObjects1 = [[NSBundle mainBundle] loadNibNamed:@"CellView_SetariIOS7" owner:self options:nil];
    //else topLevelObjects1 = [[NSBundle mainBundle] loadNibNamed:@"CellView_Setari" owner:self options:nil];
    cellProfilulMeu = [topLevelObjects1 objectAtIndex:0];
    
    NSArray *topLevelObjects2;
    //if (IS_OS_7_OR_LATER)
    topLevelObjects2 = [[NSBundle mainBundle] loadNibNamed:@"CellView_SetariIOS7" owner:self options:nil];
    //else topLevelObjects2 = [[NSBundle mainBundle] loadNibNamed:@"CellView_Setari" owner:self options:nil];
    cellMasinileMele = [topLevelObjects2 objectAtIndex:0];
    
    NSArray *topLevelObjects3;
    // if (IS_OS_7_OR_LATER)
    topLevelObjects3 = [[NSBundle mainBundle] loadNibNamed:@"CellView_SetariIOS7" owner:self options:nil];
    //else topLevelObjects3 = [[NSBundle mainBundle] loadNibNamed:@"CellView_Setari" owner:self options:nil];
    cellLocuinteleMele = [topLevelObjects3 objectAtIndex:0];
    
    NSArray *topLevelObjects4;
    //if (IS_OS_7_OR_LATER)
    topLevelObjects4 = [[NSBundle mainBundle] loadNibNamed:@"CellView_SetariIOS7" owner:self options:nil];
    //else topLevelObjects4 = [[NSBundle mainBundle] loadNibNamed:@"CellView_Setari" owner:self options:nil];
    cellAltePersoane = [topLevelObjects4 objectAtIndex:0];
    
    NSArray *topLevelObjects5;
    //if (IS_OS_7_OR_LATER)
    topLevelObjects5 = [[NSBundle mainBundle] loadNibNamed:@"CellView_SetariIOS7" owner:self options:nil];
    //else topLevelObjects5 = [[NSBundle mainBundle] loadNibNamed:@"CellView_Setari" owner:self options:nil];
    cellComenzileMele = [topLevelObjects5 objectAtIndex:0];
    
    NSArray *topLevelObjects6;
    // if (IS_OS_7_OR_LATER)
    topLevelObjects6 = [[NSBundle mainBundle] loadNibNamed:@"CellView_ContIOS7" owner:self options:nil];
    //else topLevelObjects6 = [[NSBundle mainBundle] loadNibNamed:@"CellView_Cont" owner:self options:nil];
    cellCont = [topLevelObjects6 objectAtIndex:0];
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //    if (section == 0){
    //        return vwBtnDeCeInfo;
    //    }
    return nil;
}

- (void)reloadData
{
    [tableView reloadData];
}

- (void) startLoadingAnimantion
{
    NSArray * imgs = [NSArray arrayWithObjects: [UIImage imageNamed:@"1.png"],
                      [UIImage imageNamed:@"2.png"],
                      [UIImage imageNamed:@"3.png"],
                      [UIImage imageNamed:@"4.png"],
                      [UIImage imageNamed:@"5.png"],
                      [UIImage imageNamed:@"6.png"],
                      [UIImage imageNamed:@"7.png"],
                      [UIImage imageNamed:@"8.png"],
                      [UIImage imageNamed:@"9.png"],
                      [UIImage imageNamed:@"10.png"],
                      [UIImage imageNamed:@"11.png"],
                      [UIImage imageNamed:@"12.png"],
                      [UIImage imageNamed:@"13.png"],
                      [UIImage imageNamed:@"14.png"],
                      [UIImage imageNamed:@"15.png"],
                      [UIImage imageNamed:@"16.png"],
                      [UIImage imageNamed:@"17.png"],
                      [UIImage imageNamed:@"18.png"],
                      [UIImage imageNamed:@"19.png"],
                      [UIImage imageNamed:@"20.png"],
                      [UIImage imageNamed:@"21.png"],
                      [UIImage imageNamed:@"22.png"],
                      [UIImage imageNamed:@"23.png"],
                      [UIImage imageNamed:@"24.png"],
                      [UIImage imageNamed:@"25.png"],
                      [UIImage imageNamed:@"26.png"],
                      [UIImage imageNamed:@"26.png"],
                      [UIImage imageNamed:@"26.png"],
                      [UIImage imageNamed:@"26.png"],
                      [UIImage imageNamed:@"26.png"],
                      [UIImage imageNamed:@"26.png"],
                      [UIImage imageNamed:@"26.png"],
                      [UIImage imageNamed:@"26.png"],
                      [UIImage imageNamed:@"26.png"],
                      [UIImage imageNamed:@"26.png"],
                      [UIImage imageNamed:@"26.png"],
                      [UIImage imageNamed:@""], nil];
    
    imgAnimation.animationDuration = 2.5;
    imgAnimation.animationRepeatCount = 1;
    imgAnimation.animationImages = imgs;
    [imgAnimation startAnimating];
}

- (void) stopLoadingAnimantion
{
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.view setNeedsLayout];
    self.hidesBottomBarWhenPushed = NO;
}

- (void) callSyncItems
{
    // [self showCustomLoading];
    tableView.userInteractionEnabled = NO;
    if (![[YTOUserDefaults getUserName] isEqualToString:@""] && ![[YTOUserDefaults getPassword] isEqualToString:@""] && [YTOUserDefaults getUserName] != nil && [YTOUserDefaults getPassword] != nil  )
    {
        [refreshControl beginRefreshing];
        [YTOUtils deleteWhenLogOff];
        
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@sync.asmx", LinkAPI]];
        
        
        VerifyNet * vn = [[VerifyNet alloc] init];
        if ([vn hasConnectivity]) {
            
            
            NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
                                                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                timeoutInterval:30.0];
            
            NSString * parameters = [[NSString alloc] initWithString:[self XmlRequestForAuto]];
            NSLog(@"Request=%@", parameters);
            NSString * msgLength = [NSString stringWithFormat:@"%d", [parameters length]];
            
            [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            [request addValue:@"http://tempuri.org/ExistingClientByCont" forHTTPHeaderField:@"SOAPAction"];
            [request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            
            if (connection) {
                self.responseData = [NSMutableData data];
            }
        }
        else {
            vwPopup.hidden = NO;
            [self hideCustomLoading];
        }
    }else{
        [refreshControl endRefreshing];
        tableView.userInteractionEnabled = YES;
    }
}

- (NSString *) XmlRequestForAuto
{
    return [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
            "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
            "<soap:Body>"
            "<ExistingClientByCont xmlns=\"http://tempuri.org/\">"
            "<udid>%@</udid>"
            "<cont_user>%@</cont_user>"
            "<cont_parola>%@</cont_parola>"
            "</ExistingClientByCont>"
            "</soap:Body>"
            "</soap:Envelope>",[[UIDevice currentDevice] xUniqueDeviceIdentifier],
            [YTOUserDefaults getUserName],
            [YTOUserDefaults getPassword]];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"Response: %@", [response textEncodingName]);
	[self.responseData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSLog(@"connection:DidReceiveData");
	[self.responseData appendData:data];
}

- (void) getAlerte:(NSDictionary*) item
{
    NSDictionary * alerte;
    alerte = [item objectForKey:@"Alerte"];
    
    for(NSDictionary *item in alerte) {
        NSString * idObiect = [item objectForKey:@"IdIntern"];
        
        // Daca exista idIntern, cautam in baza de date
        // Altfel, generam un guid
        
        int tipAlerta = [[item objectForKey:@"TipAlerta"] intValue];
        
        if (idObiect && idObiect.length > 0)
            alerta = [YTOAlerta getAlerta:idObiect forType:tipAlerta];
        
        // Daca alerta nu exista in baza de date,
        // se creeaza un obiect cu idIntern
        if (!alerta)
        {
            alerta = [[YTOAlerta alloc] initWithGuid:[YTOUtils GenerateUUID]];
            alerta.idObiect = [item objectForKey:@"IdIntern"];
            NSLog(@"%@", alerta.idObiect);
        }
        
        alerta.tipAlerta = [[item objectForKey:@"TipAlerta"] intValue];
        NSString * dataString = [item objectForKey:@"DataAlerta"];
        if (dataString && dataString.length > 0)
        {
            alerta.dataAlerta = [YTOUtils getDateFromString:dataString withFormat:@"dd.MM.yyyy"];
            
            if (!alerta._isDirty)
                [alerta addAlerta:YES];
            else
                [alerta updateAlerta:YES];
        }
        alerta = nil;
        
        YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate refreshAlerte];
    }
}

- (void)scrollViewDidEndDecelerating:(UITableView*) tableView
{
    if (canUpdate){
        NSString *title = @"";
        NSString *subTitle = @"Se actualizeaza datele";
        
        NSMutableAttributedString *titleAttString =  [[NSMutableAttributedString alloc] initWithString:title];
        NSMutableAttributedString *subTitleAttString =  [[NSMutableAttributedString alloc] initWithString:subTitle];
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")){
            
            [titleAttString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:20.0f] range:NSMakeRange(0, [title length])];
            [subTitleAttString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:14.0f] range:NSMakeRange(0,[subTitle length])];
            
            [titleAttString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [title length])];
            [subTitleAttString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, [subTitle length])];
            
            [titleAttString appendAttributedString:subTitleAttString];
            
            refreshControl.attributedTitle = titleAttString;
        }
        [self callSyncItems];
        canUpdate = NO;
    }
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
	
    //NSString * responseString = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
	//NSLog(@"Response string: %@", responseString);
    
	NSXMLParser * xmlParser = [[NSXMLParser alloc] initWithData:responseData];
	xmlParser.delegate = self;
	BOOL succes = [xmlParser parse];
    
	if (succes)
    {
        //[YTOUserDefaults setSyncronized:YES];
        
        NSError * err = nil;
        NSData *dataMasini = [jsonMasini dataUsingEncoding:NSUTF8StringEncoding];
        if (dataMasini)
        {
            NSDictionary * jsonArray = [NSJSONSerialization JSONObjectWithData:dataMasini options:kNilOptions error:&err];
            
            for(NSDictionary *item in jsonArray) {
                NSString * idIntern = [item objectForKey:@"IdIntern"];
                
                // Daca exista idIntern, cautam in baza de date
                // Altfel, generam un guid
                if (idIntern && idIntern.length >0)
                    masina = [YTOAutovehicul getAutovehicul:idIntern];
                else
                    idIntern = [YTOUtils GenerateUUID];
                
                // Daca masina nu exista in baza de date,
                // se creeaza un obiect cu idIntern
                if (!masina)
                {
                    masina = [[YTOAutovehicul alloc] init];
                    masina.idIntern = [item objectForKey:@"IdIntern"];
                    NSLog(@"%@", masina.idIntern);
                }
                
                // Mapare valori
                masina.marcaAuto = [item objectForKey:@"Marca"];
                masina.modelAuto = [item objectForKey:@"Model"];
                masina.categorieAuto = [[item objectForKey:@"Categorie"] intValue];
                masina.subcategorieAuto = [item objectForKey:@"Subcategorie"];
                masina.judet = [item objectForKey:@"Judet"];
                masina.localitate = [item objectForKey:@"Localitate"];
                masina.nrInmatriculare = [item objectForKey:@"NrInmatriculare"];
                masina.serieSasiu = [item objectForKey:@"SerieSasiu"];
                masina.cm3 = [[item objectForKey:@"CC"] intValue];
                masina.putere = [[item objectForKey:@"Putere"] intValue];
                masina.nrLocuri = [[item objectForKey:@"NrLocuri"] intValue];
                masina.masaMaxima = [[item objectForKey:@"MasaMax"] intValue];
                masina.anFabricatie = [[item objectForKey:@"AnFabricatie"] intValue];
                masina.serieCiv = [item objectForKey:@"CI"];
                masina.destinatieAuto = [item objectForKey:@"DestinatieAuto"];
                masina.combustibil = [item objectForKey:@"Combustibil"];
                masina.inLeasing = [[item objectForKey:@"Leasing"] boolValue] ? @"da" : @"nu";
                masina.firmaLeasing = [item objectForKey:@"FirmaLeasing"];
                masina.adresa = [item objectForKey:@"Adresa"];
                masina.savedInCont = @"da";
                
                [self getAlerte:item];
                
                // Daca masina exista in baza de date, se face update
                // Altfel se face insert
                if (!masina._isDirty)
                    [masina addAutovehicul:YES];
                else
                    [masina updateAutovehicul:YES];
                
                masina = nil;
                
                YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
                [delegate refreshMasini];
            }
            
        }
        
        
        NSData *dataLocuinte = [jsonLocuinte dataUsingEncoding:NSUTF8StringEncoding];
        if (dataLocuinte)
        {
            NSDictionary * jsonArray = [NSJSONSerialization JSONObjectWithData:dataLocuinte options:kNilOptions error:&err];
            
            for(NSDictionary *item in jsonArray) {
                NSString * idIntern = [item objectForKey:@"IdIntern"];
                
                // Daca exista idIntern, cautam in baza de date
                // Altfel, generam un guid
                if (idIntern && idIntern.length >0)
                    locuinta = [YTOLocuinta getLocuinta:idIntern];
                else
                    idIntern = [YTOUtils GenerateUUID];
                
                // Daca masina nu exista in baza de date,
                // se creeaza un obiect cu idIntern
                if (!locuinta)
                {
                    locuinta = [[YTOLocuinta alloc] init];
                    locuinta.idIntern = [item objectForKey:@"IdIntern"];
                    NSLog(@"%@", locuinta.idIntern);
                }
                
                // Mapare valori
                locuinta.tipLocuinta = [item objectForKey:@"TipLocuinta"];
                locuinta.structuraLocuinta = [item objectForKey:@"StructuraLocuinta"];
                locuinta.regimInaltime = [[item objectForKey:@"RegimInaltime"] intValue];
                locuinta.etaj = [[item objectForKey:@"Etaj"] intValue];
                locuinta.anConstructie = [[item objectForKey:@"AnConstructie"] intValue];
                if ([[item objectForKey:@"NrCamere"] isEqualToString:@""])
                    locuinta.nrCamere = [[item objectForKey:@"NrCamere"] intValue];
                else locuinta.nrCamere = 2;
                locuinta.suprafataUtila = [[item objectForKey:@"SuprafataUtila"] intValue];
                if ([[item objectForKey:@"NrCamere"] isEqualToString:@""])
                    locuinta.nrLocatari = [[item objectForKey:@"NrLocatari"] intValue];
                else locuinta.nrLocatari = 2;
                locuinta.tipGeam = [[item objectForKey:@"TipGeam"] boolValue] ? @"da" : @"nu";
                locuinta.areAlarma = [[item objectForKey:@"AreAlarma"] boolValue] ? @"da" : @"nu";
                locuinta.areGrilajeGeam = [[item objectForKey:@"AreGrilajeGeam"] boolValue] ? @"da" : @"nu";
                locuinta.zonaIzolata = [[item objectForKey:@"ZonaIzolata"]  boolValue] ? @"da" : @"nu";
                locuinta.clauzaFurtBunuri = [[item objectForKey:@"ClauzaFurtBunuri"] boolValue] ? @"da" : @"nu";
                locuinta.clauzaApaConducta = [[item objectForKey:@"ClauzaApaConducta"] boolValue] ? @"da" : @"nu";
                locuinta.detectieIncendiu = [[item objectForKey:@"DetectieIncendiu"] boolValue] ? @"da" : @"nu";
                locuinta.arePaza = [[item objectForKey:@"ArePaza"] boolValue] ? @"da" : @"nu";
                locuinta.areTeren= [[item objectForKey:@"AreTeren"] boolValue] ? @"da" : @"nu";
                locuinta.locuitPermanent = [[item objectForKey:@"LocuitPermanent"] boolValue] ? @"da" : @"nu";
                locuinta.judet = [item objectForKey:@"Judet"];
                locuinta.localitate = [item objectForKey:@"Localitate"];
                locuinta.adresa = [item objectForKey:@"Adresa"];
                locuinta.modEvaluare = [[item objectForKey:@"ModEvaluare"] boolValue] ? @"da" : @"nu";
                locuinta.nrRate = [[item objectForKey:@"NrRate"] intValue];
                locuinta.sumaAsigurata = [[item objectForKey:@"SumaAsigurata"] intValue];
                locuinta.sumaAsigurataRC = [[item objectForKey:@"SumaAsigurataRC"] intValue];
                
                [self getAlerte:item];
                
                // Daca masina exista in baza de date, se face update
                // Altfel se face insert
                if (!locuinta._isDirty)
                    [locuinta addLocuinta:YES];
                else
                    [locuinta updateLocuinta:YES];
                
                locuinta = nil;
                
                YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
                [delegate refreshLocuinte];
            }
            
        }
        NSData * dataPersoane;
        dataPersoane= [jsonPersoane dataUsingEncoding:NSUTF8StringEncoding];
        if (dataPersoane)
        {
            NSDictionary * jsonArray = [NSJSONSerialization JSONObjectWithData:dataPersoane options:kNilOptions error:&err];
            
            for(NSDictionary *item in jsonArray) {
                NSString * idIntern = [item objectForKey:@"IdIntern"];
                if (![[item objectForKey:@"TipPersoana"] isKindOfClass:[NSNull class]] && [item objectForKey:@"TipPersoana"]){
                    if ([[item objectForKey:@"TipPersoana"] isEqualToString:@"juridica"] && [[item objectForKey:@"Proprietar"] isEqualToString:@"da"])
                    {
                        persoana = [YTOPersoana ProprietarPJ];
                    }
                    // Daca exista idIntern, cautam in baza de date
                    // Altfel, generam un guid
                    else if (idIntern && idIntern.length > 0)
                        persoana = [YTOPersoana getPersoana:idIntern];
                    else
                        idIntern = [YTOUtils GenerateUUID];
                    
                    // Daca persoana nu exista in baza de date,
                    // se creeaza un obiect cu idIntern
                    if (!persoana)
                    {
                        persoana = [[YTOPersoana alloc] init];
                        if (![[item objectForKey:@"IdIntern"] isKindOfClass:[NSNull class]] && [item objectForKey:@"IdIntern"])
                            persoana.idIntern = [item objectForKey:@"IdIntern"];
                        NSLog(@"%@", persoana.idIntern);
                    }
                    
                    if (![[item objectForKey:@"Nume"] isKindOfClass:[NSNull class]] && [item objectForKey:@"Nume"])
                        persoana.nume = [item objectForKey:@"Nume"];
                    if (![[item objectForKey:@"CodUnic"] isKindOfClass:[NSNull class]] && [item objectForKey:@"CodUnic"])
                        persoana.codUnic = [item objectForKey:@"CodUnic"];
                    NSString * tel = nil;
                    if (![[item objectForKey:@"Telefon"] isKindOfClass:[NSNull class]] && [item objectForKey:@"Telefon"])
                        tel= [item objectForKey:@"Telefon"];
                    persoana.telefon = tel ? tel : @"";
                    
                    
                    persoana.email = [YTOUserDefaults getUserName];
                    if (![[item objectForKey:@"Judet"] isKindOfClass:[NSNull class]] && [item objectForKey:@"Judet"]){
                        persoana.judet = [item objectForKey:@"Judet"];
                        persoana.localitate = [item objectForKey:@"Localitate"];
                    }
                    if (![[item objectForKey:@"Adresa"] isKindOfClass:[NSNull class]] && [item objectForKey:@"Adresa"])
                        persoana.adresa = [item objectForKey:@"Adresa"];
                    if (![[item objectForKey:@"AnPermis"] isKindOfClass:[NSNull class]] && [item objectForKey:@"AnPermis"])
                        persoana.dataPermis = [item objectForKey:@"AnPermis"];
                    if (![[item objectForKey:@"CodCaen"] isKindOfClass:[NSNull class]] && [item objectForKey:@"CodCaen"])
                        persoana.codCaen = [item objectForKey:@"CodCaen"];
                    if (![[item objectForKey:@"TipPersoana"] isKindOfClass:[NSNull class]] && [item objectForKey:@"TipPersoana"])
                        persoana.tipPersoana = [item objectForKey:@"TipPersoana"];
                    if (![[item objectForKey:@"Proprietar"] isKindOfClass:[NSNull class]] && [item objectForKey:@"Proprietar"])
                        persoana.proprietar = [item objectForKey:@"Proprietar"];
                    else persoana.proprietar = @"nu";
                    
                    if (!persoana._isDirty)
                        [persoana addPersoana:YES];
                    else
                        [persoana updatePersoana:YES];
                }
            }
        }
        NSData * dataProprietar = [jsonProprietar dataUsingEncoding:NSUTF8StringEncoding];
        
        if (dataProprietar)
        {
            NSDictionary * jsonItem = [NSJSONSerialization JSONObjectWithData:dataProprietar options:kNilOptions error:&err];
            YTOPersoana * proprietar = [YTOPersoana Proprietar];
            if (!proprietar)
            {
                proprietar = [[YTOPersoana alloc] initWithGuid:[YTOUtils GenerateUUID]];
                proprietar.proprietar = @"da";
            }
            if (![[jsonItem objectForKey:@"Nume"] isKindOfClass:[NSNull class]] && [jsonItem objectForKey:@"Nume"])
                proprietar.nume = [jsonItem objectForKey:@"Nume"];
            if (![[jsonItem objectForKey:@"CodUnic"] isKindOfClass:[NSNull class]] && [jsonItem objectForKey:@"CodUnic"])
                proprietar.codUnic = [jsonItem objectForKey:@"CodUnic"];
            else proprietar.codUnic = @"";
            if (proprietar.codUnic && proprietar.codUnic.length == 13)
                proprietar.tipPersoana = @"fizica";
            else if (proprietar.codUnic && proprietar.codUnic.length > 0)
                proprietar.tipPersoana = @"juridica";
            if (![[jsonItem objectForKey:@"TipPersoana"] isKindOfClass:[NSNull class]] && [jsonItem objectForKey:@"TipPersoana"]){
                if ([[jsonItem objectForKey:@"TipPersoana"] isEqualToString:@"fizica"] || [[jsonItem objectForKey:@"TipPersoana"] isEqualToString:@"juridica"])
                {
                    persoana.tipPersoana = [jsonItem objectForKey:@"TipPersoana"];
                }
                else
                {
                    if (proprietar.codUnic && proprietar.codUnic.length == 13)
                        proprietar.tipPersoana = @"fizica";
                    else if (proprietar.codUnic && proprietar.codUnic.length > 0)
                        proprietar.tipPersoana = @"juridica";
                }
            }
            NSString * tel = nil;
            if (![[jsonItem objectForKey:@"Telefon"] isKindOfClass:[NSNull class]] && [jsonItem objectForKey:@"Telefon"])
                tel = [jsonItem objectForKey:@"Telefon"];
            proprietar.telefon = tel ? tel : @"";
            
            
            proprietar.email = [YTOUserDefaults getUserName];
            if (![[jsonItem objectForKey:@"Judet"] isKindOfClass:[NSNull class]] && [jsonItem objectForKey:@"Judet"]){
                proprietar.judet = [jsonItem objectForKey:@"Judet"];
                proprietar.localitate = [jsonItem objectForKey:@"Localitate"];
            }
            if (![[jsonItem objectForKey:@"Adresa"] isKindOfClass:[NSNull class]] && [jsonItem objectForKey:@"Adresa"])
                proprietar.adresa = [jsonItem objectForKey:@"Adresa"];
            if (![[jsonItem objectForKey:@"AnPermis"] isKindOfClass:[NSNull class]] && [jsonItem objectForKey:@"AnPermis"])
                proprietar.dataPermis = [jsonItem objectForKey:@"AnPermis"];
            if (![[jsonItem objectForKey:@"CodCaen"] isKindOfClass:[NSNull class]] && [jsonItem objectForKey:@"CodCaen"])
                proprietar.codCaen = [jsonItem objectForKey:@"CodCaen"];
            
            //NSLog(@"%@", [jsonItem objectForKey:@"DataPermisDR"]);
            
            if (!proprietar._isDirty)
                [proprietar addPersoana:YES];
            else
                [proprietar updatePersoana:YES];
        }
    }
    else {
        [self showPopupServiciu:@"Serviciul nu functioneaza momentan. Te rugam sa revii putin mai tarziu. Intre timp incercam sa remediem aceasta problema."];
    }
    
    //[self hideCustomLoading];
    [refreshControl endRefreshing];
    [self reloadData];
    tableView.userInteractionEnabled = YES;
    //self.navigationItem.leftBarButtonItem = nil;
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"connection:didFailWithError:");
	NSLog(@"%@", [error localizedDescription]);
    
    [refreshControl endRefreshing];
    tableView.userInteractionEnabled = YES;
    
}

#pragma mark NSXMLParser Methods
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
	attributes:(NSDictionary *)attributeDict {
	
	if ([elementName isEqualToString:@"ExistingClientResponse"]) {
        //	masina = [[YTOAutovehicul alloc] init];
        //    [listTarife addObject:cotatie];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if (![elementName isEqualToString:@"ExistingClientResponse"]
        && ![elementName isEqualToString:@"soap:Envelope"]
        && ![elementName isEqualToString:@"soap:Body"]) {
		
        if ([elementName isEqualToString:@"masini"])
            jsonMasini = currentElementValue;
        else if ([elementName isEqualToString:@"proprietar"])
            jsonProprietar = currentElementValue;
        else if ([elementName isEqualToString:@"locuinte"])
            jsonLocuinte = currentElementValue;
        else if ([elementName isEqualToString:@"persoane"])
            jsonPersoane = currentElementValue;
        
		NSLog(@"%@=%@\n", elementName, currentElementValue);
	}
    
	currentElementValue = nil;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if(!currentElementValue)
		currentElementValue = [[NSMutableString alloc] initWithString:string];
	else
		[currentElementValue appendString:string];
}

- (void) confirmSync
{
    [self showCustomConfirm:NSLocalizedStringFromTable(@"i225", [YTOUserDefaults getLanguage],@"Sincronizare date") withDescription:NSLocalizedStringFromTable(@"i227", [YTOUserDefaults getLanguage],@"Daca ai mai folosit aplicatia...")  withButtonIndex:100];
}

#pragma mark UIAlertView
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	//MainViewController * mainController = [[MainViewController alloc] init];
	//[self presentModalViewController:mainController animated:YES];
    //[self dismissModalViewControllerAnimated:YES];
    YTOAppDelegate * delegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate.rcaNavigationController popViewControllerAnimated:YES];
}

- (void) showCustomLoading
{
    [vwLoading setHidden:NO];
}
- (IBAction) hideCustomLoading
{
    [vwLoading setHidden:YES];
}

#pragma Custom Alert
- (IBAction) hideCustomAlert:(id)sender;
{
    UIButton * btn = (UIButton *)sender;
    [vwCustomAlert setHidden:YES];
    
    if (btn.tag == 100)
    {
        [self callSyncItems];
    }if (btn.tag == 200)
    {
        [YTOUtils deleteWhenLogOff];
        [tableView reloadData];
        //        [YTOUserDefaults setUserName:@""];
        //        [YTOUserDefaults setPassword:@""];
        [logInButton setTitle:@"Intra in cont" forState:UIControlStateNormal];
        [registerButton setTitle:@"Inregistrare" forState:UIControlStateNormal];
    }
}

- (void) showPopupServiciu:description
{
    [vwServiciu setHidden:NO];
    lblServiciuDescription.text = description;
}

- (IBAction) hidePopupServiciu
{
    vwServiciu.hidden = YES;
}

- (void) showCustomConfirm:(NSString *) title withDescription:(NSString *) description withButtonIndex:(int) index
{
    self.navigationItem.hidesBackButton = YES;
    if (index == 100)
        lblEroare.text  = NSLocalizedStringFromTable(@"i807", [YTOUserDefaults getLanguage],@"Sincronizezi datele ?");
    else if (index == 200){
        lblEroare.text = @"Iesi din cont?";
        lblEroare.textColor = [YTOUtils colorFromHexString:verde];
    }else if (index == 300){
        lblEroare.text = @"Eroare";
        lblEroare.textColor = [YTOUtils colorFromHexString:rosuProfil];
    }
    btnCustomAlertOK.tag = index;
    //    btnCustomAlertOK.frame = CGRectMake(189, 239, 73, 42);
    //    lblCustomAlertOK.frame = CGRectMake(215, 249, 42, 21);
    [lblCustomAlertOK setText:NSLocalizedStringFromTable(@"i343", [YTOUserDefaults getLanguage],@"DA")];
    [lblCustomAlertNO setText:NSLocalizedStringFromTable(@"i344", [YTOUserDefaults getLanguage],@"NU")];
    
    [btnCustomAlertNO setHidden:NO];
    [lblCustomAlertNO setHidden:NO];
    
    lblCustomAlertTitle.text = title;
    lblCustomAlertMessage.text = description;
    if (index == 300){
        [btnCustomAlertNO setHidden:YES];
        [lblCustomAlertNO setHidden:YES];
        lblCustomAlertOK.text = @"OK";
    }
    [vwCustomAlert setHidden:NO];
    
}

- (IBAction) hidePopup
{
    vwPopup.hidden = YES;
}

@end
