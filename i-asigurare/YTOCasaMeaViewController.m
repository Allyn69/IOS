//
//  YTOCasaMeaViewController.m
//  i-asigurare
//
//  Created by Stern Edi on 04/04/14.
//
//

#import "YTOCasaMeaViewController.h"
#import "YTOAppDelegate.h"
#import "YTOCasaViewController.h"
#import "YTOListaLocuinteViewController.h"
#import "YTOListaAsiguratiViewController.h"
#import "YTOAsiguratViewController.h"
#import "YTOUserDefaults.h"
#import "YTOUtils.h"
#import "VerifyNet.h"
#import "YTOOferta.h"
#import "YTOToast.h"
#import "YTOSumarCasaMeaViewController.h"
#import "YTOWebViewController.h"

@interface YTOCasaMeaViewController ()

@end


@implementation YTOCasaMeaViewController
@synthesize locuinta;
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
    // Do any additional setup after loading the view from its nib.
    if (IS_OS_7_OR_LATER){
        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars=NO;
        self.automaticallyAdjustsScrollViewInsets=NO;
    }else [tableView setBackgroundView: nil];
    lblHeader.textColor = [YTOUtils colorFromHexString:@"#056f8d"];
    _DataInceput = [YTOUtils getDataMinimaInceperePolita];
    [self setDataInceput:_DataInceput];
    YTOPersoana * prop = [YTOPersoana Proprietar];
    // Daca nu exista proprietar PF, incerc sa incarc propriertar PJ
    if (!prop)
        prop  = [YTOPersoana ProprietarPJ];
    
    if (prop)
    {
        [self setAsigurat:prop];
    }
    [YTOUtils rightImageVodafone:self.navigationItem];
    
}

- (void) viewWillDisappear:(BOOL)animated {
    [self doneEditing];
    
    [locuinta updateLocuinta:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (shouldSet){
        if (locuinta != nil)
            [self setLocuinta:locuinta];
        if (asigurat != nil)
            [self setAsigurat:asigurat];
    }
    shouldSet = YES;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (IBAction)goToSumar:(id)sender
{
    shouldSet = NO;
    YTOSumarCasaMeaViewController * aView = [[YTOSumarCasaMeaViewController alloc] init];
    oferta.moneda = @"EUR";
    oferta.companie = @"Platinum";
    aView.oferta = oferta;
    aView.locuinta = locuinta;
    aView.asigurat = asigurat;
    aView.DataInceput = _DataInceput;
    YTOAppDelegate * delegate =  (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate.rcaNavigationController pushViewController:aView animated:YES];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == 1)
        return 45;
    else if (indexPath.row == 2 || indexPath.row == 3)
        return 75;
    else if (indexPath.row == 6){
         if (!oferta || oferta.prima == 0)
             return 67;
         else return 110;
    }
    return 67;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    
    if (indexPath.row == 0) cell = cellAcoperiri;
    else if (indexPath.row == 1) cell = cellConditii;
    else if (indexPath.row == 2) cell = cellLocuinta;
    else if (indexPath.row == 3) cell = cellProprietar;
    else if (indexPath.row == 4) cell = cellSumaAsigurata;
    else if (indexPath.row == 5) cell = cellDataInceput;
    else if (indexPath.row == 6)
    {
        if (!oferta || oferta.prima == 0)
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (indexPath.row == 2)
    {
        if ([delegate Locuinte].count > 0)
        {
            YTOListaLocuinteViewController * aView = [[YTOListaLocuinteViewController alloc] init];
            aView.controller = self;
            [delegate.rcaNavigationController pushViewController:aView animated:YES];
        }
        else {
            YTOCasaViewController * aView;
            if (IS_IPHONE_5)
                aView = [[YTOCasaViewController alloc] initWithNibName:@"YTOCasaViewController_R4" bundle:nil];
            else aView = [[YTOCasaViewController alloc] initWithNibName:@"YTOCasaViewController" bundle:nil];
            aView.controller = self;
            [delegate.rcaNavigationController pushViewController:aView animated:YES];
        }
    }
    else if (indexPath.row == 3)
    {
        // Daca exista persoane salvate, afisam lista
        if ([delegate Persoane].count > 0)
        {
            YTOListaAsiguratiViewController * aView;
            if (IS_IPHONE_5)
                aView = [[YTOListaAsiguratiViewController alloc] initWithNibName:@"YTOListaAsiguratiViewController_R4" bundle:nil];
            else aView = [[YTOListaAsiguratiViewController alloc] initWithNibName:@"YTOListaAsiguratiViewController" bundle:nil];
            aView.controller = self;
            aView.produsAsigurare  = Locuinta;
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
    }else if (indexPath.row == 6 && (!oferta || oferta.prima == 0))
    {
        if (![locuinta isValidForGothaer])
        {
            UILabel * lblCell = (UILabel *)[cellLocuinta viewWithTag:2];
            lblCell.textColor = [UIColor redColor];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [tv scrollToRowAtIndexPath:indexPath
                      atScrollPosition:UITableViewScrollPositionTop
                              animated:YES];
            return;
        }
        
        if (![locuinta.locuitPermanent isEqualToString:@"da"])
        {
            UILabel * lblCell = (UILabel *)[cellLocuinta viewWithTag:2];
            lblCell.textColor = [UIColor redColor];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [tv scrollToRowAtIndexPath:indexPath
                      atScrollPosition:UITableViewScrollPositionTop
                              animated:YES];
            [self showPopupServiciu:@" Se preiau in asigurare doar imobilele locuinte permanent. Pentru a bifa aceasta optiune, intra in formularul de locuinta la sectiunea Alte Informatii."];
            return;
        }
        
        if (![locuinta.structuraLocuinta isEqualToString:@"beton-armat"] && ![locuinta.structuraLocuinta isEqualToString:@"beton"] && ![locuinta.structuraLocuinta isEqualToString:@"bca"] && ![locuinta.structuraLocuinta isEqualToString:@"caramida"])
        {
            UILabel * lblCell = (UILabel *)[cellLocuinta viewWithTag:2];
            lblCell.textColor = [UIColor redColor];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [tv scrollToRowAtIndexPath:indexPath
                      atScrollPosition:UITableViewScrollPositionTop
                              animated:YES];
            [self showPopupServiciu:@"Se preiau in asigurare doar imobile care au structura de rezistenta din : beton-armat,beton,bca sau caramida."];
            return;
        }
        
        if (![asigurat isValidForCompute])
        {
            UILabel * lblCell = (UILabel *)[cellProprietar viewWithTag:2];
            lblCell.textColor = [UIColor redColor];
            //isOK = NO;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [tv scrollToRowAtIndexPath:indexPath
                      atScrollPosition:UITableViewScrollPositionTop
                              animated:YES];
            return;
        }
        else {
            UILabel * lblCell = (UILabel *)[cellProprietar viewWithTag:2];
            lblCell.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        }
        if (locuinta.sumaAsigurata < 20000 || locuinta.sumaAsigurata > 200000) {
            [[[[iToast makeText:@"Suma asigurata cuprinsa intre 20.000 Eur. si 200.000"]
               setGravity:iToastGravityCenter] setDuration:iToastDurationShort] show];
            [(UITextField *)[cellSumaAsigurata viewWithTag:2] becomeFirstResponder];
            return;
        }
        //if (!isOK)
        //return;
        
        oferta.tipAsigurare = 3;
        oferta.idAsigurat = asigurat.idIntern;
        oferta.obiecteAsigurate = [[NSMutableArray alloc] initWithObjects:locuinta.idIntern, nil];
        oferta.numeAsigurare = [NSString stringWithFormat:@"Locuinta, %d mp", locuinta.suprafataUtila];
        
        locuinta.idProprietar = asigurat.idIntern;
        if (locuinta.CompletedPercent < 1)
            [locuinta updateLocuinta:YES];
        
        [self calculTarif];
    }

}

- (void)setAsigurat:(YTOPersoana *) a
{
    UILabel * lblCellP = ((UILabel *)[cellProprietar viewWithTag:2]);
    lblCellP.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    
    if (a.nume)
        lblCellP.text = a.nume;
    if (a.codUnic && a.judet)
        ((UILabel *)[cellProprietar viewWithTag:3]).text = [NSString stringWithFormat:@"%@, %@", a.codUnic, a.judet];
    asigurat = a;
    oferta = nil;
    [tableView reloadData];
     [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void) setLocuinta:(YTOLocuinta *) a
{
    UILabel * lblCellP = ((UILabel *)[cellLocuinta viewWithTag:2]);
    lblCellP.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    if ([a.tipLocuinta isEqualToString:@"apartament-in-bloc"])
        lblCellP.text = NSLocalizedStringFromTable(@"i377", [YTOUserDefaults getLanguage],@"Apartament in bloc");
    else if ([a.tipLocuinta isEqualToString:@"casa-vila-comuna"])
        lblCellP.text = NSLocalizedStringFromTable(@"i378", [YTOUserDefaults getLanguage],@"Casa - vila comuna");
    else if ([a.tipLocuinta isEqualToString:@"casa-vila-individuala"])
        lblCellP.text = NSLocalizedStringFromTable(@"i379", [YTOUserDefaults getLanguage],@"Casa - vila individuala");
    //lblCellP.text = a.tipLocuinta;
    ((UILabel *)[cellLocuinta viewWithTag:3]).text = [NSString stringWithFormat:@"%@, %@, %d mp", a.codPostal, a.structuraLocuinta, a.suprafataUtila];
    locuinta = a;
    if (locuinta.sumaAsigurata >= 20000 && locuinta.sumaAsigurata <= 200000)
        [self setSumaAsigurata:[NSString stringWithFormat:@"%d",locuinta.sumaAsigurata]];
    else
        [self setSumaAsigurata:0];
    oferta = nil;
    [tableView reloadData];
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void) setSumaAsigurata:(NSString *)p
{
    if (p > 0) {
        locuinta.sumaAsigurata = [p intValue];
        [(UITextField *)[cellSumaAsigurata viewWithTag:2] setText:[NSString stringWithFormat:@"%.2f %@", [p floatValue], [@"EUR" uppercaseString]]];
    }
    else
        [(UITextField *)[cellSumaAsigurata viewWithTag:2] setText:@""];
    oferta = nil;
    [tableView reloadData];
}

- (void) initCells
{
    NSArray *topLevelObjectsLocuinta = [[NSBundle mainBundle] loadNibNamed:@"CellAutovehicul" owner:self options:nil];
    cellLocuinta = [topLevelObjectsLocuinta objectAtIndex:0];
    UILabel * lblCell = (UILabel *)[cellLocuinta viewWithTag:2];
    lblCell.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblCell.text = NSLocalizedStringFromTable(@"i70", [YTOUserDefaults getLanguage],@"Alege locuinta");
    UIImageView * img2 = (UIImageView *)[cellLocuinta viewWithTag:4];
    img2.image = [UIImage imageNamed:@"icon-foto-casa.png"];
    UIImageView * bg = (UIImageView *)[cellLocuinta viewWithTag:5];
    bg.image = [UIImage imageNamed:@"alege-persoana-locuinta.png"];
    
    UILabel * lblCell1 = (UILabel *)[cellLocuinta viewWithTag:6];
    lblCell1.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblCell1.text = NSLocalizedStringFromTable(@"i77", [YTOUserDefaults getLanguage],@"LOCUINTA ASIGURATA");
    
    NSArray *topLevelObjectsProprietar = [[NSBundle mainBundle] loadNibNamed:@"CellPersoana" owner:self options:nil];
    cellProprietar = [topLevelObjectsProprietar objectAtIndex:0];
    UILabel * lblCellP = (UILabel *)[cellProprietar viewWithTag:2];
    lblCellP.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblCellP.text = NSLocalizedStringFromTable(@"i148", [YTOUserDefaults getLanguage],@"Alege Persoana");
    UIImageView * bg2 = (UIImageView *)[cellProprietar viewWithTag:5];
    bg2.image = [UIImage imageNamed:@"alege-persoana-locuinta.png"];
    
    UILabel * lblCell2 = (UILabel *)[cellProprietar viewWithTag:6];
    lblCell2.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblCell2.text = NSLocalizedStringFromTable(@"i86", [YTOUserDefaults getLanguage],@"PROPRIETAR LOCUINTA");
    
    NSArray *topLevelObjectscalc = [[NSBundle mainBundle] loadNibNamed:@"CellCalculeaza" owner:self options:nil];
    cellCalculeaza = [topLevelObjectscalc objectAtIndex:0];
    UIImageView * img3 = (UIImageView *)[cellCalculeaza viewWithTag:1];
    img3.image = [UIImage imageNamed:@"calculeaza-locuinta.png"];
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
    ((UILabel *)[cellConditii viewWithTag:12]).text = @"Ce riscuri sunt acoperite?";
    [(UIButton *)[cellConditii viewWithTag:11] addTarget:self action:@selector(showWebViewConditii) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSArray *topLevelObjectsSA = [[NSBundle mainBundle] loadNibNamed:@"CellView_Numeric" owner:self options:nil];
    cellSumaAsigurata = [topLevelObjectsSA objectAtIndex:0];
    [(UILabel *)[cellSumaAsigurata viewWithTag:1] setText:@"Valoare de piata (minim 20.000 EUR)"];
    //    [(UITextField *)[cellSumaAsigurata viewWithTag:2] setPlaceholder:@""];
    [(UITextField *)[cellSumaAsigurata viewWithTag:2] setKeyboardType:UIKeyboardTypeNumberPad];
    [YTOUtils setCellFormularStyle:cellSumaAsigurata];
    
    
    
    
    NSArray *topLevelObjectsDataInceput = [[NSBundle mainBundle] loadNibNamed:@"CellStepper" owner:self options:nil];
    cellDataInceput = [topLevelObjectsDataInceput objectAtIndex:0];
    ((UILabel *)[cellDataInceput viewWithTag:1]).text = NSLocalizedStringFromTable(@"i127", [YTOUserDefaults getLanguage],@"Data inceput");
    UIStepper * stepper = (UIStepper *)[cellDataInceput viewWithTag:3];
    [stepper addTarget:self action:@selector(dateStepper_Changed:) forControlEvents:UIControlEventValueChanged];
    ((UIImageView *)[cellDataInceput viewWithTag:4]).image = [UIImage imageNamed:@"arrow-locuinta.png"];
    [YTOUtils setCellFormularStyle:cellDataInceput];
    
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

int paramForReq1 = 0; // 1 pentru calcul, 2 pentru comanda

- (NSString *) XmlRequestCalcul
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    paramForReq1 = 1;
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSString * xml = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                      "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                      "<soap:Body>"
                      "<CallCalculCasaMeaSmarphone xmlns=\"http://tempuri.org/\">"
                      "<user>vreaurca</user>"
                      "<password>123</password>"
                      "<udid>%@</udid>"
                      "<id_intern>%@</id_intern>"
                      "<data_inceput>%@</data_inceput>"
                      "<tip_persoana>%@</tip_persoana>"
                      "<cod_postal>%@</cod_postal>"
                      "<adresa>%@</adresa>"
                      "<etaj>%d</etaj>"
                      "<an_constructie>%d</an_constructie>"
                      "<suprafata>%d</suprafata>"
                      "<tip_cladire>%@</tip_cladire>"
                      "<structura_rezistenta>%@</structura_rezistenta>"
                      "<nr_anexe>%@</nr_anexe>"
                      "<valoare_imobil>%d</valoare_imobil>"
                      "<cod_unic>%@</cod_unic>"
                      "<nume_asigurat>%@</nume_asigurat>"
                      "<valoare_bunuri>%@</valoare_bunuri>"
                      "<platforma>%@</platforma>"
                      "<cont_user>%@</cont_user>"
                      "<cont_parola>%@</cont_parola>"
                      "</CallCalculCasaMeaSmarphone>"
                      "</soap:Body>"
                      "</soap:Envelope>",
                      [[UIDevice currentDevice] xUniqueDeviceIdentifier],
                      locuinta.idIntern,
                      [formatter stringFromDate:_DataInceput],
                      asigurat.tipPersoana,
                      locuinta.codPostal,//cod postal
                      locuinta.adresa,
                      locuinta.etaj,
                      locuinta.anConstructie,
                      locuinta.suprafataUtila,
                      locuinta.tipLocuinta,
                      locuinta.structuraLocuinta,
                      @"fara-anexe",//numar anexe
                      locuinta.sumaAsigurata,//valoare imobil
                      asigurat.codUnic,
                      asigurat.nume,
                      @"5000",//valoare bunuri
                      [[UIDevice currentDevice].model stringByReplacingOccurrencesOfString:@" " withString:@"_"],
                      [YTOUserDefaults getUserName],
                      [YTOUserDefaults getPassword]
                      
                      ];
    
    return [xml stringByReplacingOccurrencesOfString:@"'" withString:@""];
}

- (void) calculTarif {
    
	NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@gothaer.asmx", LinkAPI]];
    paramForReq1 = 1;
    VerifyNet * vn = [[VerifyNet alloc] init];
    if ([vn hasConnectivity]) {
        
        [vwLoading setHidden:NO];
        [self showLoading];
        
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:30.0];
        
        NSString * parameters = [[NSString alloc] initWithString:[self XmlRequestCalcul]];
        NSLog(@"Request=%@", parameters);
        NSString * msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[parameters length]];
        
        [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request addValue:@"http://tempuri.org/CallCalculCasaMeaSmarphone" forHTTPHeaderField:@"SOAPAction"];
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

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"Response: %@", [response textEncodingName]);
	[self->responseData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSLog(@"connection:DidReceiveData");
	[self->responseData appendData:data];
    if (paramForReq1 == 1)
        oferta = [[YTOOferta alloc] init];
}
- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
	
	NSXMLParser * xmlParser = [[NSXMLParser alloc] initWithData:responseData];
	xmlParser.delegate = self;
	BOOL succes = [xmlParser parse];
    if (paramForReq1 == 1){
        if (succes)
        {
            NSError * err = nil;
            NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            
            if (data) {
                NSDictionary * item = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
                NSString * eroare_ws = [item objectForKey:@"Eroare_ws"];
                float  prima;
                @try {
                    prima = [[item objectForKey:@"PrimaEUR"] floatValue];
                }
                @catch (NSException *exception) {
                    prima = 0;
                }
                
                if (eroare_ws && ![eroare_ws isEqualToString:@""] && (!prima || prima == 0 ))
                {
                    [vwLoading setHidden:YES];
                    [self showPopupServiciu:eroare_ws];
                    UILabel * lblCell = (UILabel *)[cellLocuinta viewWithTag:2];
                    lblCell.textColor = [UIColor redColor];
                    UILabel * lblCell1 = (UILabel *)[cellProprietar viewWithTag:2];
                    lblCell1.textColor = [UIColor redColor];
                    
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                    [tableView scrollToRowAtIndexPath:indexPath
                                     atScrollPosition:UITableViewScrollPositionTop
                                             animated:YES];
                    return;
                }
                if ([eroare_ws isEqualToString:@""] && prima == 0)
                {
                    [vwLoading setHidden:YES];
                    [self showPopupServiciu:@"Serviciul care calculeaza tarife nu functioneaza momentan. Te rugam sa revii putin mai tarziu. Intre timp incercam sa remediem aceasta problema."];
                    return;
                }
                oferta.prima = prima;
                oferta.idExtern = [[item objectForKey:@"Cod"] intValue];
                NSString *string1 = @"";
                NSString *string2 = [NSString stringWithFormat:@"%.02f EUR",oferta.prima];
                NSString *string  = [[NSString alloc]initWithFormat:@"%@ %@",string1,string2];
                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")){
                    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:string];
                    [attributedString beginEditing];
                    [attributedString addAttribute:NSForegroundColorAttributeName value:[YTOUtils colorFromHexString:ColorTitlu] range:NSMakeRange(0, string1.length+1)];
                    [attributedString addAttribute:NSForegroundColorAttributeName value:[YTOUtils colorFromHexString:rosuTermeni] range:NSMakeRange(string1.length+1, string2.length)];
                    [attributedString beginEditing];
                    
                    [lblTarif setAttributedText:attributedString];
                }else{
                    [lblTarif  setText:string];
                    [lblTarif  setTextColor:[YTOUtils colorFromHexString:rosuProfil]];
                }
                lblSumaAsig.backgroundColor = [YTOUtils colorFromHexString:albastruLocuinta];
                lblNumeProdus.backgroundColor = [YTOUtils colorFromHexString:albastruLocuinta];
                lblSumaAsig.text = [NSString stringWithFormat:@"S.A. %d.00 %@", locuinta.sumaAsigurata, [@"EUR" uppercaseString]];
                [tableView reloadData];
                [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }else
            {
                [self showPopupServiciu:@"Serviciul care calculeaza tarife nu functioneaza momentan. Te rugam sa revii putin mai tarziu. Intre timp incercam sa remediem aceasta problema."];
            }
        }
        else
        {
            [self showPopupServiciu:@"Serviciul care calculeaza tarife nu functioneaza momentan. Te rugam sa revii putin mai tarziu. Intre timp incercam sa remediem aceasta problema."];
        }
    }else if (paramForReq1 == 2){
        if (succes) {
            if (idOferta == nil || [idOferta isEqualToString:@""])
                [self showCustomAlert:@"Finalizare comanda" withDescription:responseMessage withError:YES withButtonIndex:2];
            else {
                if (succes)
                    [self showCustomAlert:NSLocalizedStringFromTable(@"i449", [YTOUserDefaults getLanguage],@"Finalizare comanda") withDescription:responseMessage withError:NO withButtonIndex:3];
            }
        }
        else {
            [self showCustomAlert:NSLocalizedStringFromTable(@"i449", [YTOUserDefaults getLanguage],@"Finalizare comanda") withDescription:@"Comanda NU a fost transmisa." withError:YES withButtonIndex:4];
        }
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

#pragma mark NSXMLParser Methods

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"CallCalculCasaMeaSmarphoneResult"])
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


#pragma mark TEXTFIELD
- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    UITableViewCell *currentCell;
    if (IS_OS_7_OR_LATER) currentCell = (UITableViewCell *) textField.superview.superview.superview;
    else currentCell =  (UITableViewCell *) [[textField superview] superview];
    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditing)];
    
    NSArray *itemsArray = [NSArray arrayWithObjects:doneButton, nil];
    
    [toolbar setItems:itemsArray];
    
    [activeTextField setInputAccessoryView:toolbar];
    
    if (indexPath.row == 4)
    {
        [self addBarButton];
        textField.text = [textField.text stringByReplacingOccurrencesOfString:@".00 EUR" withString:@""];
        textField.text = [textField.text stringByReplacingOccurrencesOfString:@" LEI" withString:@""];
    }
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
    //    btnCustomAlertOK.frame = CGRectMake(124, 239, 73, 42);
    //    lblCustomAlertOK.frame = CGRectMake(150, 249, 42, 21);
    [lblCustomAlertOK setText:@"OK"];
    [btnCustomAlertNO setHidden:YES];
    [lblCustomAlertNO setHidden:YES];
    
    lblCustomAlertTitle.text = title;
    lblCustomAlertMessage.text = description;
    [vwCustomAlert setHidden:NO];
}

- (IBAction) hideCustomAlert:(id)sender;
{
    self.navigationItem.hidesBackButton = NO;
    UIButton * btn = (UIButton *)sender;
    [vwCustomAlert setHidden:YES];
    if (btn.tag == 3)
    {
        YTOPersoana * proprietar = [YTOPersoana Proprietar];
        YTOPersoana * proprietarPJ = [YTOPersoana ProprietarPJ];
        NSString *telefon , *emailLivrare;
        if (proprietar.telefon && proprietar.telefon.length > 0)
            telefon = proprietar.telefon;
        else if (proprietarPJ.telefon && proprietarPJ.telefon.length > 0)
            telefon = proprietar.telefon;
        if (proprietar.email && proprietar.email.length > 0)
            emailLivrare = proprietar.email;
        else if (proprietarPJ.email && proprietarPJ.email.length > 0)
            emailLivrare = proprietarPJ.email;
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
                          "&moneda=ron",
                          LinkAPI,
                          idOferta, emailLivrare, asigurat.nume, locuinta.adresa, asigurat.localitate, asigurat.judet, telefon,
                          @"Locuinta", oferta.prima, @"Gothaer", [[[UIDevice currentDevice] xUniqueDeviceIdentifier] stringByAppendingString:[NSString stringWithFormat:@"---%@",locuinta.idIntern]]];
        
        
        YTOWebViewController * aView = [[YTOWebViewController alloc] init];
        aView.URL = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate.rcaNavigationController pushViewController:aView animated:YES];
    }
    
}

- (void) showCustomConfirm:(NSString *) title withDescription:(NSString *) description withButtonIndex:(int) index
{
    self.navigationItem.hidesBackButton = YES;
    
    lblEroare.text = NSLocalizedStringFromTable(@"i808", [YTOUserDefaults getLanguage],@"Datele sunt corecte ?");
    lblEroare.textColor = [YTOUtils colorFromHexString:verde];
    btnCustomAlertOK.tag = index;
    //    btnCustomAlertOK.frame = CGRectMake(189, 239, 73, 42);
    //    lblCustomAlertOK.frame = CGRectMake(215, 249, 42, 21);
    [lblCustomAlertOK setText:NSLocalizedStringFromTable(@"i343", [YTOUserDefaults getLanguage],@"DA")];
    
    [btnCustomAlertNO setHidden:NO];
    [lblCustomAlertNO setHidden:NO];
    
    lblCustomAlertTitle.text = title;
    lblCustomAlertMessage.text = description;
    [vwCustomAlert setHidden:NO];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //	btnDone.enabled = YES;
	activeTextField = textField;
	
	UITableViewCell *currentCell;
    if (IS_OS_7_OR_LATER) currentCell = (UITableViewCell *) textField.superview.superview.superview;
    else currentCell =  (UITableViewCell *) [[textField superview] superview];
    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
	tableView.contentInset = UIEdgeInsetsMake(65, 0, 210, 0);
	[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
	return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    
	if(activeTextField == textField)
	{
		activeTextField = nil;
	}
    
	[textField resignFirstResponder];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
	return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    UITableViewCell *currentCell;
    if (IS_OS_7_OR_LATER) currentCell = (UITableViewCell *) textField.superview.superview.superview;
    else currentCell =  (UITableViewCell *) [[textField superview] superview];
    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
    
    if (indexPath.row == 4)
        [self setSumaAsigurata:textField.text];
}

- (void) addBarButton {
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"checked.png"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(doneEditing)];
    self.navigationItem.rightBarButtonItem = backButton;
}

-(IBAction) doneEditing
{
    [activeTextField resignFirstResponder];
	activeTextField = nil;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
	[self deleteBarButton];
}

- (void) deleteBarButton {
	self.navigationItem.rightBarButtonItem = nil;
    [YTOUtils rightImageVodafone:self.navigationItem];
}

#pragma mark NSXMLParser Methods


- (void) showLoading
{
    vwLoading.hidden = NO;
}

- (void) hideLoading
{
    vwLoading.hidden = YES;
}

- (IBAction)hideWebView:(id)sender
{
    wvWebView.hidden = YES;
    self.navigationItem.hidesBackButton = NO;
    [webView loadHTMLString:@"" baseURL:nil];
}

- (void)showWebViewAcoperiri
{
    NSString *pathImg1 = [[NSBundle mainBundle] pathForResource:@"casamea" ofType:@"jpg"];
    NSString *pathImg2 = [[NSBundle mainBundle] pathForResource:@"casamea2" ofType:@"jpg"];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"bootstrap.min.css" ofType:nil];
    NSString* htmlContentString = [NSString stringWithFormat:
                                   @"<!DOCTYPE html>"
                                   "<html xmlns=\"http://www.w3.org/1999/xhtml\">"
                                   "<head>"
                                   "<title>Casa mea</title>"
                                   "<meta charset=\"utf-8\" />"
                                   "<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\" />"
                                   "<meta name=\"viewport\" content=\"initial-scale=1, maximum-scale=1, user-scalable=no\">"
                                   "<link href=\"file://%@\" rel=\"stylesheet\" />"
                                   "</head>"
                                   "<body>"
                                   "<div class='container col-sm-6' style=\"padding-left: 5px; padding-right: 5px;\">"
                                   "<table class=\"table text-center\">"
                                   "<tr>"
                                   "<img src=\"file://%@\" alt=\"casa mea gothaer\" class=\"pull-left img-responsive\" /></td>"
                                   "<center>"
                                   "<span style=\"color: #60ad00\"> - riscuri acoperite -</span>"
                                   "</center>"
                                   "</td>"
                                   "</tr>"
                                   "<tr>"
                                   "<td style=\"width:10px;\"></td>"
                                   "<td style=\"width:40px;\">"
                                   "<img src=\"file://%@\" alt=\"casa mea gothaer\" class=\"pull-right  img-responsive\" /></td>"
                                   "<td style=\"width:10px;\"></td>"
                                   "</tr>"
                                   "</table>"
                                   "<div>"
                                   "<h5 style=\"color: #60ad00\">RISCURI acoperite de Asigurarea facultativa a locuintei „CASA MEA”</h5>"
                                   "<strong>Pentru locuinta si bunurile din locuinta: </strong>"
                                   "<ul>"
                                   "<li><strong>Flexa</strong>: incendiu, traznet, explozie, cadere de corpuri;</li>"
                                   "<li><strong>Calamitati naturale</strong>: cutremur, inundatii, alunecari de teren peste limita prevazuta de lege;</li>"
                                   "<li><strong>Fenomene atmosferice</strong>: vijelie, furtuna, uragan, tornada, grindina, ploaie torentiala, greutatea stratului de zapada/gheata, avalansa de zapada;</li>"
                                   "<li>Riscul “<strong>Apa de conducta</strong>” este acoperit in sub-limita de 1.000 euro pe eveniment si in total pe perioada asigurata. Se acorda despagubiri numai pentru daunele materiale directe produse locuintei si/sau bunurilor asigurate (nu se despagubesc pagubele la instalatiile, conductele, rezervoarele ori vasele etc. care au cauzat scurgerea accidentala de apa);</li>"
                                   "<li><strong>Riscuri politice</strong>: vandalism, greve, revolte si tulburari civile;</li>"
                                   "<li><strong>Alte riscuri acoperite</strong>: lovirea locuintei de catre vehicule, unda de soc provocata de aeronave (boom sonic), distrugeri provocate de animalele salbatice;</li>"
                                   "<li><strong>Pentru Bunurile din Locuinta este acoperit si Riscul de Furt prin efractie sau prin acte de talharie</strong> al bunurilor aflate la adresa asigurata, furtul bunurilor prin intrebuintarea cheilor originale daca acestea au fost obtinute prin acte de talharie asupra ta sau asupra membrilor familiei tale, pagubele produse locuintei in care se gasesc bunurile asigurate, cu prilejul furtului prin efractie sau a tentativei de furt prin efractie.</li>"
                                   "<li>Esti <strong>acoperit gratuit</strong>, in sublimita a 10%% din suma asigurata totala (locuinta si bunuri) si pentru pagubele produse de autoritati (de exemplu pompieri) locuintei si/sau bunurilor asigurate ca urmare a masurilor de salvare, precum si pentru anumite costuri/cheltuieli, respectiv pentru limitarea daunelor, cu interventia pompierilor pentru stingerea incendiului, pentru curatarea locului unde s-a produs evenimentul asigurat si pentru efectuarea expertizei daunei. </li>"
                                   "</ul>"
                                   
                                   "<strong>Pentru raspunderea civila a familiei: </strong>"
                                   "<ul>"
                                   "<li>Asigurarea acopera raspunderea civila a ta si a membrilor familiei tale (sotul/sotia, copiii, bunicii, rudele sau alte persoane care locuiesc in mod statornic impreuna cu tine la locatia asigurata), pentru prejudiciile (vatamari corporale si/sau pagube la bunuri) produse din culpa unor terte persoane;</li>"
                                   "<li>Prejudicii produse nu numai ca urmare a unor evenimente aparute in interiorul locuintei, cat si pentru cele produse oriunde pe teritoriul Romaniei;</li>"
                                   "<li>Protectie si pentru cheltuielile de judecata in procesul civil, stabilit de lege ori de catre instantele de judecata, daca ai fost obligat la desdaunare, decurgand din evenimente asigurate produse in perioada de asigurare.</li>"
                                   "</ul>"
                                   "<strong><span style=\"color: #60ad00\">Gothaer</span> iti ofera <span style=\"color: #60ad00\">GRATUIT</span> acoperire pentru: </strong>"
                                   "<ul>"
                                   "<li><strong>Bunurile din locuinta</strong> in limita a 5.000 euro, valoare globala, la prim risc; </li>"
                                   "<li><strong>Raspunderea civila a familiei</strong> in limita a 3.000 euro pe eveniment si in total pe perioada asigurata.</li>"
                                   "</ul>"
                                   "</div>"
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
    NSString *pathImg1 = [[NSBundle mainBundle] pathForResource:@"casamea" ofType:@"jpg"];
    NSString *pathImg2 = [[NSBundle mainBundle] pathForResource:@"casamea2" ofType:@"jpg"];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"bootstrap.min.css" ofType:nil];
    NSString* htmlContentString = [NSString stringWithFormat:
                                   @"<!DOCTYPE html>"
                                   "<html xmlns=\"http://www.w3.org/1999/xhtml\">"
                                   "<head>"
                                   "<title>Casa mea</title>"
                                   "<meta charset=\"utf-8\" />"
                                   "<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\" />"
                                   "<meta name=\"viewport\" content=\"initial-scale=1, maximum-scale=1, user-scalable=no\">"
                                   "<link href=\"file://%@\" rel=\"stylesheet\" />"
                                   "</head>"
                                   "<body>"
                                   "<div class='container col-sm-6' style=\"padding-left: 5px; padding-right: 5px;\">"
                                   "<table class=\"table text-center\">"
                                   "<tr>"
                                   "<img src=\"file://%@\" alt=\"casa mea gothaer\" class=\"pull-left img-responsive\" /></td>"
                                   "<center>"
                                   "<span style=\"color: #60ad00\">- sumar conditii asigurare -</span>"
                                   "</center>"
                                   "</tr>"
                                   "<tr>"
                                   "<td style=\"width:10px;\"></td>"
                                   "<td style=\"width:40px;\">"
                                   "<img src=\"file://%@\" alt=\"casa mea gothaer\" class=\"pull-right  img-responsive\" /></td>"
                                   "<td style=\"width:10px;\"></td>"
                                   "</tr>"
                                   "</table>"
                                   "<div style=\"clear: both;\">"
                                   "<p>Pentru ca riscurile de incendiu, explozie, furtuna, cutremur sau inundatie sunt cat se poate de reale, producerea acestora poate afecta confortul caminului tau.</p>"
                                   "<p><strong style=\"color: #056f8d\">Asigurarea facultativa a locuintei CASA MEA de la Gothaer</strong> este o asigurare complexa si cuprinzatoare prin care se asigura:</p>"
                                   "<ul>"
                                   "<li>Locuinta in integritatea ei constructiva, inclusiv instalatiile fixe ce asigura functionalitatea acesteia, precum si anexele care sunt legate structural de locuinta asigurata;</li>"
                                   "<li>Bunurile din gospodarie: mobilier, aparatura electrocasnica si electronica, articole de imbracaminte / incaltaminte etc.;</li>"
                                   "<li>Raspunderea civila legala a intregii familii, pe tot teritoriul Romaniei.</li>"
                                   "</ul>"
                                   "<strong><span style=\"color: #60ad00\">Gothaer</span> iti ofera <span style=\"color: #60ad00\">GRATUIT</span> acoperire pentru: </strong>"
                                   "<ul>"
                                   "<li><strong>Bunurile din locuinta</strong> in limita a 5.000 euro, valoare globala, la prim risc; </li>"
                                   "<li><strong>Raspunderea civila a familiei</strong> in limita a 3.000 euro pe eveniment si in total pe perioada asigurata.</li>"
                                   "</ul>"
                                   
                                   "Asigurarea locuintei “CASA MEA” de la Gothaer reprezinta o asigurare facultativă a locuinţelor si nu constituie şi nici nu înlocuieşte Poliţa de asigurare obligatorie a locuinţelor împotriva cutremurelor, alunecărilor de teren sau inudaţiilor (PAD), reglementată în baza Legii nr. 260/2008, cu modificarile si completarile ulterioare. PAD reprezintă o poliţă separată faţă de poliţa facultativă, iar obligativitatea incheierii acesteia revine in exclusivitate Asiguratului."
                                   
                                   "<h5 style=\"color: #60ad00\">RISCURI acoperite de Asigurarea facultativa a locuintei „CASA MEA”</h5>"
                                   "<strong>Pentru locuinta si bunurile din locuinta: </strong>"
                                   "<ul>"
                                   "<li><strong>Flexa</strong>: incendiu, traznet, explozie, cadere de corpuri;</li>"
                                   "<li><strong>Calamitati naturale</strong>: cutremur, inundatii, alunecari de teren peste limita prevazuta de lege;</li>"
                                   "<li><strong>Fenomene atmosferice</strong>: vijelie, furtuna, uragan, tornada, grindina, ploaie torentiala, greutatea stratului de zapada/gheata, avalansa de zapada;</li>"
                                   "<li>Riscul “<strong>Apa de conducta</strong>” este acoperit in sub-limita de 1.000 euro pe eveniment si in total pe perioada asigurata. Se acorda despagubiri numai pentru daunele materiale directe produse locuintei si/sau bunurilor asigurate (nu se despagubesc pagubele la instalatiile, conductele, rezervoarele ori vasele etc. care au cauzat scurgerea accidentala de apa);</li>"
                                   "<li><strong>Riscuri politice</strong>: vandalism, greve, revolte si tulburari civile;</li>"
                                   "<li><strong>Alte riscuri acoperite</strong>: lovirea locuintei de catre vehicule, unda de soc provocata de aeronave (boom sonic), distrugeri provocate de animalele salbatice;</li>"
                                   "<li><strong>Pentru Bunurile din Locuinta este acoperit si Riscul de Furt prin efractie sau prin acte de talharie</strong> al bunurilor aflate la adresa asigurata, furtul bunurilor prin intrebuintarea cheilor originale daca acestea au fost obtinute prin acte de talharie asupra ta sau asupra membrilor familiei tale, pagubele produse locuintei in care se gasesc bunurile asigurate, cu prilejul furtului prin efractie sau a tentativei de furt prin efractie.</li>"
                                   "<li>Esti <strong>acoperit gratuit</strong>, in sublimita a 10%% din suma asigurata totala (locuinta si bunuri) si pentru pagubele produse de autoritati (de exemplu pompieri) locuintei si/sau bunurilor asigurate ca urmare a masurilor de salvare, precum si pentru anumite costuri/cheltuieli, respectiv pentru limitarea daunelor, cu interventia pompierilor pentru stingerea incendiului, pentru curatarea locului unde s-a produs evenimentul asigurat si pentru efectuarea expertizei daunei. </li>"
                                   "</ul>"
                                   "</div>"
                                   "</div>"
                                   "</body>"
                                   "</html>",filePath,pathImg2,pathImg1];
    
    [webView loadHTMLString:htmlContentString baseURL:nil];
    [webView scalesPageToFit];
    self.navigationItem.hidesBackButton = YES;
    wvWebView.hidden = NO;
}




@end
