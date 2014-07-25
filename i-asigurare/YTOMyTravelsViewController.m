//
//  YTOMyTravelsViewController.m
//  i-asigurare
//
//  Created by Stern Edi on 04/04/14.
//
//

#import "YTOMyTravelsViewController.h"
#import "YTOUtils.h"
#import "YTOAppDelegate.h"
#import "YTOListaAsiguratiViewController.h"
#import "YTOAsiguratViewController.h"
#import "YTOUserDefaults.h"
#import "VerifyNet.h"
#import "YTOWebViewController.h"
#import "YTOSumarMyTravelsViewController.h"

@interface YTOMyTravelsViewController ()

@end

@implementation YTOMyTravelsViewController
@synthesize asigurat;
@synthesize oferta;
@synthesize DataInceput = _DataInceput;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initCells];
    shouldSetAsigurat = NO;
    lblHeader.textColor = [YTOUtils colorFromHexString:portocaliuCalatorie];
    // Do any additional setup after loading the view from its nib.
    isSport = NO;
    isBagaje = NO;
    
    if (IS_OS_7_OR_LATER){
        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars=NO;
        self.automaticallyAdjustsScrollViewInsets=NO;
    }else [tableView setBackgroundView: nil];
    lblHeader.textColor = [YTOUtils colorFromHexString:@"#056f8d"];
    // Do any additional setup after loading the view from its nib.
    _DataInceput = [YTOUtils getDataMinimaInceperePolita];
    [self setDataInceput:_DataInceput];
    [YTOUtils rightImageVodafone:self.navigationItem];
    [self setScopCalatorie:@"turism"];
    [YTOUtils rightImageVodafone:self.navigationItem];
    [tableView setAllowsSelection:YES];
    lblTop.textColor = [YTOUtils colorFromHexString:ColorOrange];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    VerifyNet *vn = [[VerifyNet alloc] init];
    if (asigurat != nil && [vn hasConnectivity] && shouldSetAsigurat)
        [self setAsigurat:asigurat];
    else if (asigurat!=nil && ![vn hasConnectivity]) {
        [self showPopupServiciu:NSLocalizedStringFromTable(@"i219", [YTOUserDefaults getLanguage],@"Atentie !")];
    }
    isCalculating = NO;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == 1)
        return 45;
    else if (indexPath.row == 3)
        return 100;
    else if (indexPath.row == 2)
        return 85;
    else if (indexPath.row == 5){
        if (!oferta || oferta.prima ==0 )
            return 67;
        else return 115;
    }
    return 67;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    
    if (indexPath.row == 0) cell = cellAcoperiri;
    else if (indexPath.row == 1) cell = cellConditii;
    else if (indexPath.row == 2) cell = cellCalator;
    else if (indexPath.row == 3) cell = cellScopCalatorie;
    else if (indexPath.row == 4) cell = cellDataInceput;
    else if (indexPath.row == 5){
        if (!oferta || oferta.prima ==0 )
            cell = cellCalculeaza;
        else cell = cellTarif;
    }
    
    if (indexPath.row == 0) {
        CGRect frame = CGRectMake(0, 0, 320, 45);
        UIView *bgColor = [[UIView alloc] initWithFrame:frame];
        [cell addSubview:bgColor];
        [cell sendSubviewToBack:bgColor];
        bgColor.backgroundColor = [YTOUtils colorFromHexString:@"#fafafa"];
    }
    
    return cell;
}


#pragma buttons

- (IBAction)setBagaje:(id)sender
{
    if (isBagaje)
        isBagaje = NO;
    else isBagaje = YES;
    VerifyNet *vn = [[VerifyNet alloc] init];
    if (isBagaje)
    {
        [sender  setImage:[UIImage imageNamed: @"selectat-calatorie.png"] forState:UIControlStateNormal];
    }
    else
    {
        [sender  setImage:[UIImage imageNamed: @"neselectat.png"] forState:UIControlStateNormal];
        
    }
    if (asigurat!=nil && asigurat.isValidForGothaer){
        oferta = nil;
        [tableView reloadData];
    }
}
- (IBAction)setSport:(id)sender
{
    if (isSport)
        isSport = NO;
    else isSport = YES;
    if (isSport)
    {
        [sender  setImage:[UIImage imageNamed: @"selectat-calatorie.png"] forState:UIControlStateNormal];
    }
    else
    {
        [sender  setImage:[UIImage imageNamed: @"neselectat.png"] forState:UIControlStateNormal];
        
    }
    if (asigurat!=nil && asigurat.isValidForGothaer){
        oferta = nil;
        [tableView reloadData];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
    YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (indexPath.row == 0)
        [self showWebViewConditii];
    if (indexPath.row == 2)
    {
        shouldSetAsigurat = YES;
        // Daca exista persoane salvate, afisam lista
        if ([delegate Persoane].count > 0)
        {
            YTOListaAsiguratiViewController * aView;
            if (IS_IPHONE_5)
                aView = [[YTOListaAsiguratiViewController alloc] initWithNibName:@"YTOListaAsiguratiViewController_R4" bundle:nil];
            else aView = [[YTOListaAsiguratiViewController alloc] initWithNibName:@"YTOListaAsiguratiViewController" bundle:nil];
            aView.controller = self;
            aView.produsAsigurare  = MyTravels;
            [delegate.rcaNavigationController pushViewController:aView animated:YES];
        }
        else {
            YTOAsiguratViewController * aView = [[YTOAsiguratViewController alloc] init];
            if (IS_IPHONE_5)
                aView = [[YTOAsiguratViewController alloc] initWithNibName:@"YTOAsiguratViewController-R4" bundle:nil];
            else aView = [[YTOAsiguratViewController alloc] initWithNibName:@"YTOAsiguratViewController" bundle:nil];
            aView.controller = self;
            aView.proprietar = YES;
            [delegate.rcaNavigationController pushViewController:aView animated:YES];
        }
    }else if (indexPath.row == 5 && (oferta == nil || oferta.prima == 0)){
        VerifyNet * vn = [[VerifyNet alloc] init];
        if (![vn hasConnectivity]){
            [self showPopupServiciu:@"Te rugam sa te asiguri ca ai o conexiune la internet activa si calculeaza din nou. Iti multumim! "];
            return;
        }
        if (!asigurat || !asigurat.isValidForGothaer)
        {
            UILabel * lblCell = (UILabel *)[cellCalator viewWithTag:2];
            lblCell.textColor = [UIColor redColor];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
            [tv scrollToRowAtIndexPath:indexPath
                      atScrollPosition:UITableViewScrollPositionTop
                              animated:YES];
            return;
        }
        else {
            UILabel * lblCell = (UILabel *)[cellCalator viewWithTag:2];
            lblCell.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        }
        
        oferta = [[YTOOferta alloc] initWithGuid:[YTOUtils GenerateUUID]];
        oferta.dataInceput = _DataInceput;
        oferta.tipAsigurare = 2;
        oferta.obiecteAsigurate = [[NSMutableArray alloc] init];
        [self calculTarif];
    }
}

- (void)setAsigurat:(YTOPersoana *) a
{
    UILabel * lblCellP = ((UILabel *)[cellCalator viewWithTag:2]);
    lblCellP.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    
    if (a.nume)
        lblCellP.text = a.nume;
    if (a.codUnic && a.judet)
        ((UILabel *)[cellCalator viewWithTag:3]).text = [NSString stringWithFormat:@"%@, %@", a.codUnic, a.judet];
    asigurat = a;
    oferta = nil;
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}


- (void) initCells
{
    
    NSArray *topLevelObjectscalc = [[NSBundle mainBundle] loadNibNamed:@"CellCalculeaza" owner:self options:nil];
    cellCalculeaza = [topLevelObjectscalc objectAtIndex:0];
    UIImageView * img3 = (UIImageView *)[cellCalculeaza viewWithTag:1];
    img3.image = [UIImage imageNamed:@"calculeaza-calatorie.png"];
    UILabel * lblCellC = (UILabel *)[cellCalculeaza viewWithTag:2];
    lblCellC.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblCellC.text = NSLocalizedStringFromTable(@"i128", [YTOUserDefaults getLanguage],@"Calculeaza");
    
    NSArray *topLevelObjects0;
    topLevelObjects0 = [[NSBundle mainBundle] loadNibNamed:@"CellContNou" owner:self options:nil];
    cellAcoperiri = [topLevelObjects0 objectAtIndex:0];
    ((UILabel *)[cellAcoperiri viewWithTag:12]).text = @"Conditii de asigurare";
    [(UIButton *)[cellAcoperiri viewWithTag:11] addTarget:self action:@selector(showWebViewAcoperiri) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *topLevelObjects1;
    topLevelObjects1 = [[NSBundle mainBundle] loadNibNamed:@"CellContNou" owner:self options:nil];
    cellConditii = [topLevelObjects1 objectAtIndex:0];
    ((UILabel *)[cellConditii viewWithTag:12 ]).text = @"Ce riscuri sunt acoperite";
    [(UIButton *)[cellConditii viewWithTag:11] addTarget:self action:@selector(showWebViewConditii) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *topLevelObjectsCalator = [[NSBundle mainBundle] loadNibNamed:@"CellPersoana" owner:self options:nil];
    cellCalator = [topLevelObjectsCalator objectAtIndex:0];
    UILabel * lblCellP = (UILabel *)[cellCalator viewWithTag:2];
    lblCellP.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblCellP.text = @"Alege Calator";
    ((UILabel *)[cellCalator viewWithTag:3]).text =@"";
    UIImageView * imgBg = (UIImageView *)[cellCalator viewWithTag:5];
    imgBg.image = [UIImage imageNamed:@"alege-calator.png"];
    
    NSArray *topLevelObjectsDataInceput = [[NSBundle mainBundle] loadNibNamed:@"CellStepper" owner:self options:nil];
    cellDataInceput = [topLevelObjectsDataInceput objectAtIndex:0];
    ((UILabel *)[cellDataInceput viewWithTag:1]).text = NSLocalizedStringFromTable(@"i127", [YTOUserDefaults getLanguage],@"Data inceput");
    UIStepper * stepper = (UIStepper *)[cellDataInceput viewWithTag:3];
    [stepper addTarget:self action:@selector(dateStepper_Changed:) forControlEvents:UIControlEventValueChanged];
    ((UIImageView *)[cellDataInceput viewWithTag:4]).image = [UIImage imageNamed:@"arrow-calatorie.png"];
    [YTOUtils setCellFormularStyle:cellDataInceput];
}


- (IBAction)goToSumar:(id)sender
{
    shouldSetAsigurat = NO;
    YTOSumarMyTravelsViewController * aView = [[YTOSumarMyTravelsViewController alloc] init];
    aView.oferta = oferta;
    aView.scopCalatorie = scopCalatorie;
    aView.asigurat = asigurat;
    aView.DataInceput = _DataInceput;
    YTOAppDelegate * delegate =  (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate.rcaNavigationController pushViewController:aView animated:YES];
}


- (IBAction)dateStepper_Changed:(id)sender
{
    UIStepper * stepper = (UIStepper *)sender;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    // set tomorrow (0: today, -1: yesterday)
    if (trecutDeOra)
        [comps setDay:stepper.value + 1];
    else
        [comps setDay:stepper.value];
    NSDate *date = [calendar dateByAddingComponents:comps
                                             toDate:currentDate
                                            options:0];
    [self setDataInceput:date];
}

- (void) setDataInceput:(NSDate *)DataInceput
{
    UILabel * lbl = (UILabel *)[cellDataInceput viewWithTag:2];
    lbl.text = [YTOUtils formatDate:DataInceput withFormat:@"dd.MM.yyyy"];
    
    _DataInceput = DataInceput;
    oferta.dataInceput = DataInceput;
}


#pragma Events
- (IBAction) btnScop_Clicked:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    BOOL checkboxSelected = btn.selected;
    checkboxSelected = !checkboxSelected;
    if (!btn.selected)
        [btn setSelected:checkboxSelected];
    if (btn.tag == 1)
    {
        [self setScopCalatorie:@"turism"];
    }
    if (btn.tag == 2)
    {
        [self setScopCalatorie:@"afaceri"];
    }
    for (int i=1; i<=4; i++) {
        UIButton * _btn = (UIButton *)[cellScopCalatorie viewWithTag:i];
        if (btn.tag != i)
            [_btn setSelected:NO];
    }
    oferta = nil;
    [tableView reloadData];
}


- (void) setScopCalatorie:(NSString *)scop
{
    if ([scop isEqualToString:@"turism"])
        ((UIButton *)[cellScopCalatorie viewWithTag:1]).selected = YES;
    else if ([scop isEqualToString:@"afaceri"])
        ((UIButton *)[cellScopCalatorie viewWithTag:2]).selected = YES;
    
    scopCalatorie = scop;
    
    
}

- (void) showCustomAlert:(NSString*) title withDescription:(NSString *)description withError:(BOOL) error withButtonIndex:(int) index
{
    self.navigationItem.hidesBackButton = YES;
    
    if (error){
        lblEroare.text = NSLocalizedStringFromTable(@"i799", [YTOUserDefaults getLanguage],@"Eroare !");
        lblEroare.textColor = [YTOUtils colorFromHexString:rosuTermeni];
    }else{
        lblEroare.text = NSLocalizedStringFromTable(@"i809", [YTOUserDefaults getLanguage],@"Comanda a fost inregistrata");
        lblEroare.textColor = [YTOUtils colorFromHexString:verde];
        [lblEroare setFont:[UIFont fontWithName:@"Chalkboard SE" size:16]];
        
    }
    
    btnCustomAlertOK.tag = index;
    [lblCustomAlertOK setText:@"OK"];
    [btnCustomAlertNO setHidden:YES];
    [lblCustomAlertNO setHidden:YES];
    
    lblCustomAlertTitle.text = title;
    lblCustomAlertMessage.text = description;
    [vwCustomAlert setHidden:NO];
}

- (NSString *) XmlRequestCalcul
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSString * xml = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                      "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                      "<soap:Body>"
                      "<CallCalculMyTravelsSmartphone xmlns=\"http://tempuri.org/\">"
                      "<user>vreaurca</user>"
                      "<password>123</password>"
                      "<udid>%@</udid>"
                      "<id_intern>%@</id_intern>"
                      "<data_inceput>%@</data_inceput>"
                      "<bagaje>%s</bagaje>"
                      "<sporturi>%s</sporturi>"
                      "<nume_asigurat>%@</nume_asigurat>"
                      "<cod_unic>%@</cod_unic>"
                      "<scop_calatorie>%@</scop_calatorie>"
                      "<mod_plata>%@</mod_plata>"
                      "<tip_persoana>%@</tip_persoana>"
                      "<numar_strada>%@</numar_strada>"
                      "<cod_postal>%@</cod_postal>"
                      "<platforma>%@</platforma>"
                      "<cont_user>%@</cont_user>"
                      "<cont_parola>%@</cont_parola>"
                      "</CallCalculMyTravelsSmartphone>"
                      "</soap:Body>"
                      "</soap:Envelope>",
                      [[UIDevice currentDevice] xUniqueDeviceIdentifier],
                      asigurat.idIntern,
                      [formatter stringFromDate:_DataInceput],
                      isBagaje? "da":"nu",
                      isSport? "da":"nu",
                      asigurat.nume,
                      asigurat.codUnic,
                      scopCalatorie,
                      @"3",
                      asigurat.tipPersoana,
                      @"1",
                      asigurat.codPostal,
                      [[UIDevice currentDevice].model stringByReplacingOccurrencesOfString:@" " withString:@"_"],
                      [YTOUserDefaults getUserName],
                      [YTOUserDefaults getPassword]];
    return [xml stringByReplacingOccurrencesOfString:@"'" withString:@""];
}


- (void) calculTarif {
    
	NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@gothaer.asmx", LinkAPI]];
    VerifyNet * vn = [[VerifyNet alloc] init];
    if ([vn hasConnectivity]) {
        
        [vwLoading setHidden:NO];
        [self showLoading];
        
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:30.0];
        
        NSString * parameters = [[NSString alloc] initWithString:[self XmlRequestCalcul]];
        NSLog(@"Request=%@", parameters);
        NSString * msgLength = [NSString stringWithFormat:@"%d",[parameters length]];
        
        [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request addValue:@"http://tempuri.org/CallCalculMyTravelsSmartphone" forHTTPHeaderField:@"SOAPAction"];
        [request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if (connection) {
            self->responseData = [NSMutableData data];
            NSLog(@"%@",responseData);
        }
    }
    else {
        [self showPopupServiciu:NSLocalizedStringFromTable(@"i123", [YTOUserDefaults getLanguage],@"Atentie !") ];// andDescription:eroare_ws];
        
        
    }
    
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
	
	NSString * responseString = [[NSString alloc] initWithData:self->responseData encoding:NSUTF8StringEncoding];
	NSLog(@"Response string: %@", responseString);
    
	NSXMLParser * xmlParser = [[NSXMLParser alloc] initWithData:responseData];
    xmlParser.delegate = self;
	BOOL succes = [xmlParser parse];
    if (succes)
    {
        NSError * err = nil;
        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        
        if (data) {
            NSDictionary * item = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
            NSString * eroare_ws = [item objectForKey:@"Eroare_ws"];
            float  prima;
            @try {
                prima = [[item objectForKey:@"Prima"] floatValue];
            }
            @catch (NSException *exception) {
                prima = 0;
            }
            
            if (eroare_ws && ![eroare_ws isEqualToString:@""] && (!prima || prima == 0 ))
            {
                [vwLoading setHidden:YES];
                [self showPopupServiciu:eroare_ws];
                UILabel * lblCell = (UILabel *)[cellCalator viewWithTag:2];
                lblCell.textColor = [UIColor redColor];
                return;
            }
            oferta.prima = prima;
            oferta.idExtern = [[item objectForKey:@"Cod"] intValue];
            oferta.CalatorieScop = scopCalatorie;
            [lblTarif  setText:[NSString stringWithFormat:@"%.2f RON",oferta.prima]];
            [lblTarif  setTextColor:[YTOUtils colorFromHexString:rosuProfil]];
            [(UILabel *) cellTarif viewWithTag:2].backgroundColor = [YTOUtils colorFromHexString:portocaliuCalatorie];
            [(UILabel *) cellTarif viewWithTag:3].backgroundColor = [YTOUtils colorFromHexString:portocaliuCalatorie];
            UIImage *imgDa = [UIImage imageNamed:@"icon-check.png"];
            UIImage *imgNu = [UIImage imageNamed:@"icon-x.png"];
            if (isBagaje)
                acopBagaje.image = imgDa;
            else acopBagaje.image = imgNu;
            
            if (isSport)
                acopSport.image = imgDa;
            else acopSport.image = imgNu;
            [tableView reloadData];
            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }else
        {
            [self showPopupServiciu:@"Serviciul care calculeaza tarife nu functioneaza momentan. Te rugam sa revii putin mai tarziu. Intre timp incercam sa remediem aceasta problema."];
        }
    }
    else
    {
        [self showPopupServiciu:@"Serviciul care calculeaza tarife nu functioneaza momentan. Te rugam sa revii putin mai tarziu. Intre timp incercam sa remediem aceasta problema."];
    }
    [vwLoading setHidden:YES];
    [self hideLoading];
}


- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"connection:didFailWithError:");
	NSLog(@"%@", [error localizedDescription]);
    [self hideLoading];
    [self showPopupServiciu:@"Serviciul care calculeaza tarife nu functioneaza momentan. Te rugam sa revii putin mai tarziu. Intre timp incercam sa remediem aceasta problema."];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"Response: %@", [response textEncodingName]);
	[self->responseData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSLog(@"connection:DidReceiveData");
	[self->responseData appendData:data];
    oferta = [[YTOOferta alloc] init];
}

- (void) showPopupServiciu: (NSString *) description
{
    [vwServiciu setHidden:NO];
    lblServiciuDescription.text = description;
}

- (IBAction)hidePopUpServiciu:(id)sender
{
    [vwServiciu setHidden:YES];
}

- (void) showCustomConfirm:(NSString *) title withDescription:(NSString *) description withButtonIndex:(int) index
{
    self.navigationItem.hidesBackButton = YES;
    
    lblEroare.text =NSLocalizedStringFromTable(@"i808", [YTOUserDefaults getLanguage],@"Datele sunt corecte ?");
    lblEroare.textColor = [YTOUtils colorFromHexString:verde];
    btnCustomAlertOK.tag = index;
    [lblCustomAlertOK setText:NSLocalizedStringFromTable(@"i92", [YTOUserDefaults getLanguage],@"DA")];
    
    [btnCustomAlertNO setHidden:NO];
    [lblCustomAlertNO setHidden:NO];
    
    lblCustomAlertTitle.text = title;
    lblCustomAlertMessage.text = description;
    [vwCustomAlert setHidden:NO];
}

- (IBAction) hideCustomAlert:(id)sender;
{
    self.navigationItem.hidesBackButton = NO;
    
    UIButton * btn = (UIButton *)sender;
    [vwCustomAlert setHidden:YES];
    if (btn.tag == 3){
        YTOPersoana * proprietar = [YTOPersoana Proprietar];
        YTOPersoana * proprietarPJ = [YTOPersoana ProprietarPJ];
        NSString *telefon , *email;
        if (proprietar.telefon && proprietar.telefon.length > 0)
            telefon = proprietar.telefon;
        else if (proprietarPJ.telefon && proprietarPJ.telefon.length > 0)
            telefon = proprietar.telefon;
        if (proprietar.email && proprietar.email.length > 0)
            email = proprietar.email;
        else if (proprietarPJ.email && proprietarPJ.email.length > 0)
            email = proprietarPJ.email;
        NSString * url = [NSString stringWithFormat:@"%@pre-pay.aspx?numar_oferta=%@"
                          "&email=%@"
                          "&nume=%@"
                          "&adresa=%@"
                          "&localitate=%@"
                          "&judet=%@"
                          "&telefon=%@"
                          "&codProdus=%@"
                          "&valoare=%.2f"
                          "&companie=%@"
                          "&udid=%@"
                          "&moneda=RON",
                          LinkAPI,
                          idOferta,email, asigurat.nume, asigurat.adresa, asigurat.localitate, asigurat.judet, telefon,
                          @"Calatorie", oferta.prima, oferta.companie, [[[UIDevice currentDevice] xUniqueDeviceIdentifier] stringByAppendingString:[NSString stringWithFormat:@"---%@",asigurat.idIntern]]];
        
        YTOWebViewController * aView = [[YTOWebViewController alloc] init];
        aView.URL = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate.rcaNavigationController pushViewController:aView animated:YES];
        
        
        //        NSURL * nsURL = [[NSURL alloc] initWithString:[url stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
        //        [[UIApplication sharedApplication] openURL:nsURL];
    }
}

#pragma mark NSXMLParser Methods
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"CallCalculMyTravelsSmartphoneResult"])
    {
        jsonString = currentElementValue;
        NSLog(@"%@=%@\n", elementName, currentElementValue);
    }
    if ([elementName isEqualToString:@"MesajComanda"]) {
		responseMessage = [NSString stringWithString:currentElementValue];
        mesajComanda = responseMessage;
	}
    if ([elementName isEqualToString:@"NumarComanda"]) {
		responseMessage = [NSString stringWithString:currentElementValue];
        idOferta = responseMessage;
	}
	currentElementValue = nil;
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if(!currentElementValue)
		currentElementValue = [[NSMutableString alloc] initWithString:string];
	else
		[currentElementValue appendString:string];
}

- (void) showLoading
{
    vwLoading.hidden = NO;
    isCalculating = YES;
}

- (void) hideLoading
{
    vwLoading.hidden = YES;
    isCalculating = NO;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)hideWebView:(id)sender
{
    wvWebView.hidden = YES;
    self.navigationItem.hidesBackButton = NO;
    [webView loadHTMLString:@"" baseURL:nil];
}

- (void)showWebViewAcoperiri
{
    NSString *pathImg1 = [[NSBundle mainBundle] pathForResource:@"mytravels" ofType:@"jpg"];
    NSString *pathImg2 = [[NSBundle mainBundle] pathForResource:@"mytravels23" ofType:@"jpg"];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"bootstrap.min.css" ofType:nil];
    NSString* htmlContentString = [NSString stringWithFormat:
                                   @"<!DOCTYPE html>"
                                   "<html xmlns=\"http://www.w3.org/1999/xhtml\">"
                                   "<head>"
                                   "<title>My travels</title>"
                                   "<meta charset=\"utf-8\" />"
                                   "<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\" />"
                                   "<meta name=\"viewport\" content=\"initial-scale=1, maximum-scale=1, user-scalable=no\">"
                                   "<link href=\"file://%@\" rel=\"stylesheet\" />"
                                   "</head>"
                                   "<body>"
                                   "<div class='container col-sm-6' style=\"padding-left: 5px; padding-right: 5px;\">"
                                   "<table class=\"table text-center\">"
                                   "<tr>"
                                   "<img src=\"file://%@\" alt=\"my travels\" class=\"pull-left img-responsive\" /></td>"
                                   "<center>"
                                   "<span style=\"color: #60ad00\">- sumar conditii asigurare -</span>"
                                   "</center>"
                                   "</tr>"
                                   "<tr>"
                                   "<td style=\"width: 10px;\"></td>"
                                   "<td style=\"width: 40px;\">"
                                   "<img src=\"file://%@\" alt=\"My travels gothaer\" class=\"pull-right  img-responsive\" /></td>"
                                   "<td style=\"width: 10px;\"></td>"
                                   "</tr>"
                                   "</table>"
                                   "<p><strong style=\"color: #056f8d\">Asigurarea My Travels de la Gothaer</strong> iti ofera:</p>"
                                   "<ul>"
                                   "<li>Acoperire timp de 1 an de zile si numar nelimitat de calatorii, fara avizare inainte de plecarea in calatorie;</li>"
                                   "<li>Durata maxima a unei calatorii 45 de zile;</li>"
                                   "<li>Suma asigurata 30.000 euro;</li>"
                                   "<li>Scopul calatoriei: turistic si/sau afaceri;</li>"
                                   "<li>Acoperire teritoriala: intreaga lume.</li>"
                                   "</ul>"
                                   "Suplimentar poti opta pentru <strong>asigurarea bagajelor</strong> in limita a 500 euro, precum si pentru acoperirea evenimentelor ce pot aparea in timpul practicarii sporturilor de agrement."
                                   "</div>"
                                   "</body>"
                                   "</html>",filePath,pathImg2,pathImg1];
    
    [webView loadHTMLString:htmlContentString baseURL:nil];
    [webView scalesPageToFit];
    self.navigationItem.hidesBackButton = YES;
    wvWebView.hidden = NO;
}

- (void) showWebViewConditii
{
    NSString *pathImg1 = [[NSBundle mainBundle] pathForResource:@"mytravels" ofType:@"jpg"];
    NSString *pathImg2 = [[NSBundle mainBundle] pathForResource:@"mytravels23" ofType:@"jpg"];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"bootstrap.min.css" ofType:nil];
    NSString* htmlContentString = [NSString stringWithFormat:
                                   @"<!DOCTYPE html>"
                                   "<html xmlns=\"http://www.w3.org/1999/xhtml\">"
                                   "<head>"
                                   "<title>My travels</title>"
                                   "<meta charset=\"utf-8\" />"
                                   "<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\" />"
                                   "<meta name=\"viewport\" content=\"initial-scale=1, maximum-scale=1, user-scalable=no\">"
                                   "<link href=\"file://%@\" rel=\"stylesheet\" />"
                                   "</head>"
                                   "<body>"
                                   "<div style=\"padding-left: 5px; padding-right: 5px;\">"
                                   "<table class=\"table text-center\">"
                                   "<tr>"
                                   "<img src=\"file://%@\" alt=\"my travels\" class=\"pull-left img-responsive\" /></td>"
                                   "<center>"
                                   "<span style=\"color: #60ad00\">- riscuri acoperite -</span>"
                                   "</center>"
                                   "</td>"
                                   "</tr>"
                                   "<tr>"
                                   "<td style=\"width: 10px;\"></td>"
                                   "<td style=\"width: 40px;\">"
                                   "<img src=\"file://%@\" alt=\"My travels gothaer\" class=\"pull-right  img-responsive\" /></td>"
                                   "<td style=\"width: 10px;\"></td>"
                                   "</tr>"
                                   "</table>"
                                   "<p><strong>RISCURI</strong> acoperite, in limita sumei asigurate, ca urmare a producerii unui accident sau a unei imbolnaviri imprevizibile in timpul calatoriei, precum si costurile si cheltuielile impuse de acordarea in regim de urgenta a urmatoarelor servicii medicale:</p>"
                                   "<ul>"
                                   "<li><strong>Asistenta medicala de urgenta</strong>: consultatie si diagnosticare, tratament si medicatie, spitalizare, interventie chirurgicala (inclusiv anestezie si utilizarea salii de operatie); tratament dentar (in sublimita a 300 euro) acordat urmare a unui accident sau a unei crize acute, pentru calmarea durerii;</li>"
                                   "<li><strong>Transport medical de urgenta, in sublimita a 5.000 euro</strong>: cheltuielile cu transportul medical de urgenta, necesar si recomandat de medic, in tara straina, de la locul urgentei medicale aparute pana la cea mai apropiata unitate medicala abilitata sa acorde ingrijirea medicala adecvata urgentei;</li>"
                                   "<li><strong>Repatriere in sublimita a 10.000 euro:</strong>"
                                   "<ul>"
                                   "<li>Repatriere medicala – repatrierea in Romania, daca te afli in imposibilitatea de a te deplasa ca urmare a producerii unui risc asigurat, organizata de serviciul de asistenta pus la dispozitie de catre Gothaer;</li>"
                                   "<li>Repatriere in caz de deces.</li>"
                                   "</ul>"
                                   "</li>"
                                   "</ul>"
                                   "Suplimentar poti opta pentru <strong>asigurarea bagajelor</strong> in limita a 500 euro, precum si pentru acoperirea evenimentelor ce pot aparea in timpul practicarii sporturilor de agrement."
                                   "</div>"
                                   "</body>"
                                   "</html>",filePath,pathImg2,pathImg1];
    
    [webView loadHTMLString:htmlContentString baseURL:nil];
    self.navigationItem.hidesBackButton = YES;
    wvWebView.hidden = NO;
}

@end
