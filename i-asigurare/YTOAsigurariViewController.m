//
//  YTOAsigurariViewController.m
//  i-asigurare
//
//  Created by Andi Aparaschivei on 7/12/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
//

#import "YTOAsigurariViewController.h"
#import "VerifyNet.h"
#import "YTONotificare.h"
#import "CellNotificareCustom.h"
#import "YTOUserDefaults.h"
#import "YTOUtils.h"
#import "YTOAppDelegate.h"
#import "UILabel+dynamicSizeMe.h"
#import <QuartzCore/QuartzCore.h>
#import "YTOCasaMeaViewController.h"
#import "YTOMyTravelsViewController.h"

@interface YTOAsigurariViewController ()

@end

@implementation YTOAsigurariViewController

@synthesize responseData;
@synthesize notificari;
@synthesize openNotification;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if ([[YTOUserDefaults getLanguage] isEqualToString:@"hu"]){
            self.title = @"Biztositás";
        }
        else if ([[YTOUserDefaults getLanguage] isEqualToString:@"en"]){
            self.title = @"Buy insurance";
        }
        else self.title =@"Asigura-te";
        self.tabBarItem.image = [UIImage imageNamed:@"menu-asigurari.png"];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //tableView.scrollIndicatorInsets = 40;
    lbl1Info.textColor = [YTOUtils colorFromHexString:@"#78a9b9"];
    lbl2Info.textColor = [YTOUtils colorFromHexString:@"#78a9b9"];
    if (IS_OS_7_OR_LATER){
        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars=NO;
        self.automaticallyAdjustsScrollViewInsets=NO;
        tableNotificari = tableNotificari7;
        lblNotificari = lblNotificari7;
        lbl1 = lbl1OS7;
        lbl2 = lbl2OS7;
        lbl3 = lbl3OS7;
        loading = loading7;
        okNotification = okNotification7;
        vwNotification = vwNotification7;
    }else [tableView setBackgroundView: nil];
    
    self->tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setButtonNotificariBackground) name:UIApplicationDidChangeStatusBarFrameNotification object:self];    isNotificationShowing = NO;
    if (openNotification) {
        openNotification = NO;
        [self showNotificari];
    }
    if ([YTOUserDefaults IsFirstTime] || [YTOUserDefaults getOperator] == nil || [[YTOUserDefaults getOperator] isEqualToString:@""])
        [self showPopupOperator];
    if ([[YTOUserDefaults getLanguage] isEqualToString:@"hu"]){
        self.title = @"Biztositás megkötése";
        lblOperator1.text = @"Megtetted az első lépést az\ni-Asigurare tapasztalatában.";
        lblOperator2.text = @"Készülj fel, hogy megtudd milyen az ha minden biztositásod ott található a zsebeidben.";
        lblOperator3.text = @"Mielött elkezdenéd kerünk válaszd ki a mobil szolgáltatod : ";
    }
    else if ([[YTOUserDefaults getLanguage] isEqualToString:@"en"]){
        self.title = @"Buy insurance";
        lblOperator1.text = @"You've completed the first steptowards the\ni-Asigurare experience.";
        lblOperator2.text = @"Be ready to discover\n how it is to have all your insurance policies\nright in your pocket";
        lblOperator3.text = @"Before starting,\nplease select the mobile phone operator:";
    }
    else {
        self.title =@"Incheie asigurare";
        lblOperator1.text = @"Ai facut primul pas spre experienta\ni-Asigurare!";
        lblOperator2.text = @"Fii pregatit sa afli cum este sa\nai toate asigurarile chiar in buzunarul tau!";
        lblOperator3.text = @"Inainte de a incepe,te rugam sa selectezi\noperatorul tau de telefonie mobila:";
    }
    [lblOperator2 resizeToFit];
    
    lblNoInternet.text = NSLocalizedStringFromTable(@"i473", [YTOUserDefaults getLanguage],@"Te rugam sa te asiguri ca ai o conexiune la internet activa si calculeaza din nou. Iti multumim! ");
    
    lblNotificari.text = NSLocalizedStringFromTable(@"i22", [YTOUserDefaults getLanguage],@"Notificari");
    
    lblEroare.text = NSLocalizedStringFromTable(@"i799", [YTOUserDefaults getLanguage],@"Eroare !");
    lblEroare.textColor = [YTOUtils colorFromHexString:rosuTermeni];
    [self initCells];
     [YTOUtils rightImageVodafone:self.navigationItem];
    
    if (![[YTOUserDefaults getUserName] isEqualToString:@""] && ![[YTOUserDefaults getPassword] isEqualToString:@""] && [YTOUserDefaults getUserName] != nil && [YTOUserDefaults getPassword] != nil  )
    {
        [self callLogin];
    }
    [self callGetReducereStatus];

}

- (void) initCells
{
    
    NSArray *topLevelObjects1;
    topLevelObjects1 = [[NSBundle mainBundle] loadNibNamed:@"CellView_RCA" owner:self options:nil];
    cellRow1 = [topLevelObjects1 objectAtIndex:0];
    ((UIImageView *)[cellRow1 viewWithTag:11]).layer.shadowColor = [YTOUtils colorFromHexString:@"#040404"].CGColor;
    ((UIImageView *)[cellRow1 viewWithTag:11]).layer.shadowOffset = CGSizeMake(0, 1);
    ((UIImageView *)[cellRow1 viewWithTag:11]).layer.shadowOpacity = 0.75;
    ((UIImageView *)[cellRow1 viewWithTag:11]).clipsToBounds = NO;
    btnRca = ((UIImageView *) [cellRow1 viewWithTag:22]);
    [(UIView *) [cellRow1 viewWithTag:55] setBackgroundColor:[YTOUtils colorFromHexString:@"#e1e1e1"]];
    [(UILabel *) [cellRow1 viewWithTag:66] setTextColor:[YTOUtils colorFromHexString:@"#78a9b9"]];
    
    NSArray *topLevelObjects2;
    topLevelObjects2 = [[NSBundle mainBundle] loadNibNamed:@"CellView_TrLoc" owner:self options:nil];
   //  ((UIImageView *)[cellRow2 viewWithTag:11]).frame = CGRectMake(15, 5, 70, 70);
    cellRow2 = [topLevelObjects2 objectAtIndex:0];
    
    NSArray *topLevelObjects3;
    topLevelObjects3 = [[NSBundle mainBundle] loadNibNamed:@"CellView_TrLoc" owner:self options:nil];
    cellRow3 = [topLevelObjects3 objectAtIndex:0];
   // ((UIImageView *)[cellRow3 viewWithTag:11]).frame = CGRectMake(15, 5, 70, 70);
    ((UIImageView *)[cellRow3 viewWithTag:11]).image = [UIImage imageNamed:@"asig-locuinte.png"];
    ((UILabel *)[cellRow3 viewWithTag:22]).text = @"Asigurare locuinta";
    ((UILabel *)[cellRow3 viewWithTag:33]).text = @"Oferte de asigurare pentru casa - pentru un somn linistit";
    ((UILabel *)[cellRow3 viewWithTag:100]).hidden = YES;
    
    NSArray *topLevelObjects4;
    topLevelObjects4 = [[NSBundle mainBundle] loadNibNamed:@"CellView_Gothaer" owner:self options:nil];
    cellRow4 = [topLevelObjects4 objectAtIndex:0];
    [(UIView *) [cellRow4 viewWithTag:55] setBackgroundColor:[YTOUtils colorFromHexString:@"#e1e1e1"]];
    [(UILabel *) [cellRow4 viewWithTag:66] setTextColor:[YTOUtils colorFromHexString:@"#78a9b9"]];
    [(UILabel *) [cellRow4 viewWithTag:155] setTextColor:[YTOUtils colorFromHexString:@"#056f8d"]];
    
    
    NSArray *topLevelObjects5;
    topLevelObjects5 = [[NSBundle mainBundle] loadNibNamed:@"CellView_MyTravels" owner:self options:nil];
    cellRow5 = [topLevelObjects5 objectAtIndex:0];
    [(UILabel *) [cellRow5 viewWithTag:155] setTextColor:[YTOUtils colorFromHexString:@"#056f8d"]];
    //((UILabel *)[cellRow5 viewWithTag:55]).hidden = YES;

}

- (UIImage *)generatePhotoFrameWithImage:(UIImage *)image {
    CGSize newSize = CGSizeMake(image.size.width + 50, image.size.height + 60);
    CGRect rect = CGRectMake(25, 35, image.size.width, image.size.height);
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, image.scale); {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextBeginTransparencyLayer(context, NULL); {
            [image drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
            
            CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
            CGContextSetShadowWithColor(context, CGSizeMake(0, 5), 5, [UIColor blackColor].CGColor);
            CGContextStrokeRectWithWidth(context, CGRectMake(25, 35, image.size.width, image.size.height), 50);
        } CGContextEndTransparencyLayer(context);
    }
    UIImage *result =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

- (IBAction)showDeCeInfo:(id)sender
{
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
        vwDeCeInfo.hidden = NO;
}

- (IBAction)showDeCeCont:(id)sender
{
    NSString* htmlContentString = [NSString stringWithFormat:
                                   @"<html xmlns='http://www.w3.org/1999/xhtml'>"
                                   "<head>"
                                   "<p><center><strong style='color:#cf3030'>Cu ce te ajuta contul i-Asigurare?</strong><br /></center></p>"
                                   "</head>"
                                   "<body style='font-family:Arial; font-size:.8em; color:#464646;'>"
                                   "<span style='font:.9em'></span>"
                                   "<li>iti accesezi informatiile, comenzile si politele de asigurare de pe orice dispozitiv: smartphone-tableta-PC-laptop</li><br />"
                                   "<li>nu pierzi niciodata polita de asigurare: ai mereu o copie a politelor de asigurare comandate, in format PDF. Le poti descarca oricand ai nevoie, de cate ori doresti</li><br />"
                                   "<li>poti vedea oricand istoricul comenzilor efectuate, precum si pretul platit pentru o polita anterioara</li>"
                                   "</body>"
                                   "</html>"];
    
    [webView loadHTMLString:htmlContentString baseURL:nil];
    vwDeCeInfo.hidden = NO;
}

- (IBAction)hideDeCeInfo:(id)sender
{
    vwDeCeInfo.hidden = YES;
    [webView loadHTMLString:@"" baseURL:nil];
}
- (void) showNotificari
{
    if (!isNotificationShowing){
        [self callGetNotificari];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
         [a1 setImage:[UIImage imageNamed:@"notificari-icon.png"] forState:UIControlStateNormal];
        isNotificationShowing = YES;
    }
    else [self hideNotificari];
}

- (void)setButtonNotificariBackground
{
    a1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [a1 setFrame:CGRectMake(0.0f, 0.0f, 34.0f, 34.0f)];
    [a1 addTarget:self action:@selector(showNotificari) forControlEvents:UIControlEventTouchUpInside];
    [a1 setImage:[UIImage imageNamed:@"notificari-icon.png"] forState:UIControlStateNormal];
    numberOfNewNotifications = [UIApplication sharedApplication].applicationIconBadgeNumber;
    if (numberOfNewNotifications > 0){
        [a1 setImage:[UIImage imageNamed:@"notificari-noi-icon.png"] forState:UIControlStateNormal];
    }else{
        [a1 setImage:[UIImage imageNamed:@"notificari-icon.png"] forState:UIControlStateNormal];
    }
    vw = [[UIView alloc] initWithFrame:CGRectMake(0,0, 34, 34)];
    [vw addSubview:a1];
    
    UIBarButtonItem *btnEdit = [[UIBarButtonItem alloc] initWithCustomView:vw];
    self.navigationItem.leftBarButtonItem = btnEdit;
    //self.navigationItem.leftBarButtonItems = [btnEdit , lblBadge];
    [self.tabBarController setDelegate:self];

}

- (void) viewDidAppear:(BOOL)animated
{
    [self setButtonNotificariBackground];
    if ([iRate sharedInstance].shouldPromptForRating)
        [iRate sharedInstance].promptForRating;
    
        vwBtnDeCeInfo.hidden = YES;
    if ([[YTOUserDefaults getLanguage] isEqualToString:@"hu"]){
        self.title = @"Biztositás megkötése";
    }
    else if ([[YTOUserDefaults getLanguage] isEqualToString:@"en"]){
        self.title = @"Buy insurance";
    }
    else self.title =@"Asigura-te";
    UILabel *lbl11 = (UILabel * ) [cellHead viewWithTag:11];
    UILabel *lbl22 = (UILabel * ) [cellHead viewWithTag:22];

    NSString *string1 = NSLocalizedStringFromTable(@"i700", [YTOUserDefaults getLanguage],@"Polite de");
    NSString *string2 = NSLocalizedStringFromTable(@"i701", [YTOUserDefaults getLanguage],@"asigurare");
    NSString *string  = [[NSString alloc]initWithFormat:@"%@ %@",string1,string2];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")){
        NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        [attributedString beginEditing];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[YTOUtils colorFromHexString:ColorTitlu] range:NSMakeRange(0, string1.length+1)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[YTOUtils colorFromHexString:verde] range:NSMakeRange(string1.length+1, string2.length)];
        [attributedString beginEditing];
        
        [lbl11 setAttributedText:attributedString];
    }else{
        [lbl11 setText:string];
        [lbl11 setTextColor:[YTOUtils colorFromHexString:verde]];
    }
    
    lbl22.text = NSLocalizedStringFromTable(@"i702", [YTOUserDefaults getLanguage],@"Calculeaza tarife si comanda asigurari");
    lbl22.adjustsFontSizeToFitWidth = YES;

    NSString *img = @"asig-rca.png";
    if ([[YTOUserDefaults getLanguage] isEqualToString:@"hu"])
        img = @"asig-rca-hu.png";
    else if ([[YTOUserDefaults getLanguage] isEqualToString:@"en"])
        img = @"asig-rca-en.png";
    else img = @"asig-rca.png";
    
    
    
}

- (IBAction) hideNotificari
{
    [vwNotification removeFromSuperview];
    isNotificationShowing = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)_tableView
{
    if (_tableView == tableNotificari){
        if (notificari.count>0)
            return 1;
        else return 0;
    }
    if (isGothaer && [isGothaer isEqualToString:@"da"])
        return 3;
    else return 2;
}

- (CGFloat) tableView:(UITableView *)tableView1 heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView1 viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}


- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tableView == tableNotificari){
        YTONotificare *notificare = [notificari objectAtIndex:indexPath.row];
        NSString *str = notificare.subiect;
        CGSize size = [str sizeWithFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:14] constrainedToSize:CGSizeMake(200, 310) lineBreakMode:UILineBreakModeWordWrap];
        NSLog(@"%f",size.height);
        return size.height + 10;
    }else{
        if (indexPath.section == 0 && indexPath.row == 0)
            return 58;
        if (indexPath.section == 1 && indexPath.row == 0)
            return 122;
        if (indexPath.section == 1 && (indexPath.row == 1 || indexPath.row == 2))
            return 80;
        if (indexPath.section == 2 && indexPath.row == 0)
            return 92;
        if (indexPath.section == 2 && indexPath.row == 1)
            return 62;
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tableNotificari)
        return notificari.count;
    if (section == 0)
        return 1;
    if (section == 1)
        return 3;
    if (section == 2)
        return 2;
}


- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tableView == tableNotificari)
    {
        static NSString *CellIdentifier = @"CellView_Notificare";
    
        CellNotificareCustom *cell = (CellNotificareCustom *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = (CellNotificareCustom *)[nib objectAtIndex:0];
        }
        
        //NSLog(@"index path %d", indexPath.row);
        
        YTONotificare * notificare = [notificari objectAtIndex:indexPath.row];
        
        NSString * data = @"";
        NSString * detaliu = @"";
        
        detaliu = notificare.subiect;
        data = notificare.dataAlerta;
        
        [cell setDataNotificare:data];
        [cell setDetaliiNotificare:detaliu];
    
     
        if (numberOfNewNotifications>0){
        [cell contentView].backgroundColor = [YTOUtils colorFromHexString:GalbenNotification];
        numberOfNewNotifications--;
        }
        
        return cell;

    }else{
    UITableViewCell * cell;
    if (indexPath.section == 0)
        cell = cellButoane;
    if (indexPath.section == 1 && indexPath.row == 0)
        cell = cellRow1;
    else if  (indexPath.section == 1 && indexPath.row == 1)
        cell = cellRow2;
    else if (indexPath.section == 1 && indexPath.row == 2)
        cell = cellRow3;
    else if (indexPath.section == 2 && indexPath.row == 0)
        cell = cellRow4;
    else if (indexPath.section == 2 && indexPath.row == 1)
        cell = cellRow5;
        
    cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tableView == tableView)
    {
        if (indexPath.row == 0 && indexPath.section == 1)
        {
            [self showRCAView];
        }
        if (indexPath.row == 1 && indexPath.section == 1)
        {
            [self showCalatorieView];
        }
        if (indexPath.row == 2 && indexPath.section == 1)
        {
            [self showLocuintaView];
        }
        if (indexPath.row == 0 && indexPath.section == 2)
        {
            [self showCasaMeaView];
        }
        if (indexPath.row == 1 && indexPath.section == 2)
        {
            [self showMyTravelsView];
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)showRCAView
{
    YTOCalculatorViewController * aView;
    
    if (IS_IPHONE_5)
        aView = [[YTOCalculatorViewController alloc] initWithNibName:@"YTOCalculatorViewController_R4" bundle:nil];
    else
        aView = [[YTOCalculatorViewController alloc] initWithNibName:@"YTOCalculatorViewController" bundle:nil];
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
    [self eroareCasco];
}

- (void)showCasaMeaView
{
    YTOCasaMeaViewController * aView = [[YTOCasaMeaViewController alloc] init];
    YTOAppDelegate * appDelegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
}

- (void)showMyTravelsView
{
    YTOMyTravelsViewController * aView = [[YTOMyTravelsViewController alloc] init];
    YTOAppDelegate * appDelegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
}

//notificari

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *) XmlRequest
{
    NSString * xml = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                      "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                      "<soap:Body>"
                      "<GetNotificari xmlns=\"http://tempuri.org/\">"
                      "<username>vreaurca</username>"
                      "<password>123</password>"
                      "<udid>%@</udid>"
                      "</GetNotificari>"
                      "</soap:Body>"
                      "</soap:Envelope>",[[UIDevice currentDevice] xUniqueDeviceIdentifier] ];
    NSLog(@"xml=%@", xml);
    return xml;
}

- (IBAction) callGetNotificari{
    paramForRequest = 1;
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@sync.asmx", LinkAPI]];
    
    VerifyNet * vn = [[VerifyNet alloc] init];
    if ([vn hasConnectivity]) {
        [self showLoading];
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:30.0];
        
        NSString * parameters = [[NSString alloc] initWithString:[self XmlRequest]];
        NSLog(@"Request=%@", parameters);
        NSString * msgLength = [NSString stringWithFormat:@"%d", [parameters length]];
        
        [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request addValue:@"http://tempuri.org/GetNotificari" forHTTPHeaderField:@"SOAPAction"];
        [request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if (connection) {
            self.responseData = [NSMutableData data];
        }
    }
    else {
        [self arataPopup:NSLocalizedStringFromTable(@"i123", [YTOUserDefaults getLanguage],@"Atentie !") ];
        self.navigationItem.hidesBackButton = NO;
        
    }
}

- (void) callLogin {
    paramForRequest = 2;
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@sync.asmx", LinkAPI]];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                        timeoutInterval:20.0];
    
    NSString * parameters = [[NSString alloc] initWithString:[self XmlRequestLogin]];
    NSLog(@"Request=%@", parameters);
    NSString * msgLength = [NSString stringWithFormat:@"%d", [parameters length]];
    
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"http://tempuri.org/AccountLogin" forHTTPHeaderField:@"SOAPAction"];
    [request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (connection) {
        self.responseData = [NSMutableData data];
    }
}

- (void) verifyViewMode
{
    if (notificari.count == 0)
    {
        [tableNotificari setHidden:YES];
        lbl1.hidden = NO;
        //lbl1.text = @"Pana acum nu ai primit notificari.\nAsigura-te ca functia Push Notifications\npentru aplicatia i-Asigurare este activa.";
        lbl2.hidden = NO;
        lbl3.hidden = NO;
        lbl1.text = NSLocalizedStringFromTable(@"i220", [YTOUserDefaults getLanguage],@"Pentru ce se folosesc push");
        lbl2.text = NSLocalizedStringFromTable(@"i573", [YTOUserDefaults getLanguage],@"De ce sa activezi push");
        lbl3.text = NSLocalizedStringFromTable(@"i40", [YTOUserDefaults getLanguage],@"vei fi notificat pt alertele setate de tine\nvei sti cand exista oferte si promotii\n vei putea primi reduceri");
    }
    else
    {
        [tableNotificari setHidden:NO];
        lbl1.hidden = YES;
        lbl2.hidden = YES;
        lbl3.hidden = YES;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"Response: %@", [response textEncodingName]);
	[self.responseData setLength:0];
    self.navigationItem.hidesBackButton = NO;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSLog(@"connection:DidReceiveData");
	[self.responseData appendData:data];
    self.navigationItem.hidesBackButton = NO;
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
	NSString * responseString = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
	NSLog(@"Response string: %@", responseString);
    self.navigationItem.hidesBackButton = NO;
    [self hideLoading];
	
	NSXMLParser * xmlParser = [[NSXMLParser alloc] initWithData:responseData];
	xmlParser.delegate = self;
	BOOL succes = [xmlParser parse];
    if (succes && paramForRequest == 3){
        @try {
            if ([isRedus isEqualToString:@"da"]){
                NSString *img = @"asig-rca-reducere.png";
                btnRca.image = [UIImage imageNamed:img];
            }else {
                NSString *img = @"asig-rca.png";
                if ([[YTOUserDefaults getLanguage] isEqualToString:@"hu"])
                    img = @"asig-rca-hu.png";
                else if ([[YTOUserDefaults getLanguage] isEqualToString:@"en"])
                    img = @"asig-rca-en.png";
                else img = @"asig-rca.png";
                
                btnRca.image = [UIImage imageNamed:img];
            }
        }@catch (NSException *e) {
            NSString *img = @"asig-rca.png";
            if ([[YTOUserDefaults getLanguage] isEqualToString:@"hu"])
                img = @"asig-rca-hu.png";
            else if ([[YTOUserDefaults getLanguage] isEqualToString:@"en"])
                img = @"asig-rca-en.png";
            else img = @"asig-rca.png";
            
            btnRca.image = [UIImage imageNamed:img];
        }
    }
	if (succes && paramForRequest == 1) {
        NSError * err = nil;
        NSData *data = [jsonResponse dataUsingEncoding:NSUTF8StringEncoding];
        if (data!=nil){
            NSDictionary * jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
            notificari = [[NSMutableArray alloc] init];
        
            for(NSDictionary *json in jsonArray) {
                YTONotificare *notificare = [[YTONotificare alloc] init];
                notificare._id = [[json objectForKey:@"Id"] intValue];
                notificare.dataAlerta = [json objectForKey:@"DataCreareAsString"];
                notificare.subiect = [json objectForKey:@"Subiect"];
                notificare.tipAlerta = [[json objectForKey:@"Sursa"] intValue];
                [notificari addObject:notificare];
            }
        }
        [tableNotificari reloadData];
        [self verifyViewMode];
    }
    if (succes && paramForRequest == 2){
        if (raspuns ==nil || [raspuns isEqualToString:@""])
        {
            [YTOUserDefaults setPassword:@""];
            [YTOUserDefaults setUserName:@""];
            [YTOUtils deleteWhenLogOff];
        }
    }
    

}

- (NSString *) XmlRequestLogin
{
    NSString * xml =  [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                       "<soap:Body>"
                       "<AccountLogin xmlns=\"http://tempuri.org/\">"
                       "<username>%@</username>"
                       "<password>%@</password>"
                       "</AccountLogin>"
                       "</soap:Body>"
                       "</soap:Envelope>",[YTOUserDefaults getUserName],[YTOUserDefaults getPassword]];
    return xml;
}

- (NSString *) XmlRequest2
{
    NSString * xml = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                      "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
                      "<soap12:Body>"
                      "<GetReducereStatus xmlns=\"http://tempuri.org/\">"
                      "<username>vreaurca</username>"
                      "<password>123</password>"
                      "<platforma>iPhone</platforma>"
                      "</GetReducereStatus>"
                      "</soap12:Body>"
                      "</soap12:Envelope>"];
    return xml;
}


- (IBAction) callGetReducereStatus {
    paramForRequest = 3;
	NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@utils.asmx", LinkAPI]];
    
	NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
															cachePolicy:NSURLRequestUseProtocolCachePolicy
														timeoutInterval:30.0];
    
	NSString * parameters = [[NSString alloc] initWithString:[self XmlRequest2]];
	NSLog(@"Request=%@", parameters);
	NSString * msgLength = [NSString stringWithFormat:@"%d", [parameters length]];
	
	[request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[request addValue:@"http://tempuri.org/GetReducereStatus" forHTTPHeaderField:@"SOAPAction"];
	[request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	if (connection) {
		self.responseData = [NSMutableData data];
	}
 //    [tableView reloadData];
}





- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"connection:didFailWithError:");
	NSLog(@"%@", [error localizedDescription]);
    [self hideLoading];
}

#pragma mark NSXMLParser Methods
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if ([elementName isEqualToString:@"GetNotificariResult"]) {
        jsonResponse = currentElementValue;
	}
    if ([elementName isEqualToString:@"GetReducereStatusResult"]){
        NSData *jsonData = [currentElementValue dataUsingEncoding:NSUTF8StringEncoding];
        NSError *e;
        NSDictionary *item = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&e];
        @try {
            isRedus = [item objectForKey:@"RCA"];
            isGothaer = [item objectForKey:@"Gothaer"];
            isGothaer = NO;
            [YTOUserDefaults setIsRedus:([isRedus isEqualToString:@"da"] ? YES:NO)];
            [tableView reloadData];
        }
        @catch (NSException *exception) {
            isRedus = @"nu";
            isGothaer = @"nu";
        }
        @finally {
            
        }
        
    }
    if ([elementName isEqualToString:@"AccountLoginResult"]){
        raspuns = currentElementValue;
    }
    
	currentElementValue = nil;
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if(!currentElementValue)
		currentElementValue = [[NSMutableString alloc] initWithString:string];
	else
		[currentElementValue appendString:string];
}

#pragma POPUP
- (void) showLoading
{
    YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.window addSubview:vwNotification];//ceva pe ios 7
    lblLoading.hidden = NO;
    tableNotificari.hidden = YES;
    lbl1.hidden = YES;
    lbl2.hidden = NO;
    lbl1.text = NSLocalizedStringFromTable(@"i220", [YTOUserDefaults getLanguage],@"Pentru ce se folosesc push");
    lbl2.text = NSLocalizedStringFromTable(@"i573", [YTOUserDefaults getLanguage],@"De ce sa activezi push");
    lbl3.text = NSLocalizedStringFromTable(@"i40", [YTOUserDefaults getLanguage],@"vei fi notificat pt alertele setate de tine\nvei sti cand exista oferte si promotii\n vei putea primi reduceri");
    lbl3.hidden = NO;
    lblLoading.text = @"";
    loading.hidden = NO;
    [lbl1 resizeToFit];
    [lbl2 resizeToFit];
    [lbl3 resizeToFit];
}
- (IBAction) hideLoading
{
    lblLoading.hidden = YES;
    loading.hidden = YES;
}

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController1 {
    if (!isNotificationShowing && !isPopUpOperatorShowing) {
        return YES;
    }
    return NO;
}

- (void) eroareCasco
{
    wvPopup.hidden = NO;
    lblEroare.text = @"Important";
    lblNoInternet.text = @"Lucram la implementarea calculatorului CASCO.\nDatorita numarului mare de cereri CASCO, va putem ajuta DOAR in cazul in care va expira polita anterioara si doriti reinnoire. Pentru detalii, scrie-ne pe office@i-asigurare.ro.";
}


- (void) arataPopup:(NSString *)title
{
    //isNotificationShowing = NO;
    wvPopup.hidden = NO;
}

- (IBAction)hidePopup
{
    isNotificationShowing = NO;
    wvPopup.hidden = YES;
}

- (void) showPopupOperator
{
    vwOperator.hidden = NO;
    isPopUpOperatorShowing = YES;
    UIButton * _btn = (UIButton *)[vwOperator viewWithTag:1];
     [YTOUserDefaults setOperatorMobil:@"Vodafone"];
     [_btn setSelected:YES];
}

- (IBAction)choseOperator:(id)sender
{
   // NSLog(@"Operator %@", [YTOUserDefaults getOperator]);
    NSString *operator;
    UIButton *btn = (UIButton *) sender;
    for (int i=1; i<=3; i++) {
        UIButton * _btn = (UIButton *)[vwOperator viewWithTag:i];
            [_btn setSelected:NO];
    }

    if (btn.tag == 1){
        operator = @"Vodafone";
        btn.selected = YES;
    }
    else if (btn.tag == 2){
        operator = @"Orange";
        btn.selected = YES;
    }
    else if (btn.tag == 3){
        operator = @"Cosmote";
        btn.selected = YES;
    }
    [YTOUserDefaults setOperatorMobil:operator];
}

- (IBAction)hidePopupOperator:(id)sender
{
    vwOperator.hidden = YES;
    isPopUpOperatorShowing = NO;
}


@end
