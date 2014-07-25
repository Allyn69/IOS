//
//  YTOSumarMyTravelsViewController.m
//  i-asigurare
//
//  Created by Stern Edi on 28/04/14.
//
//

#import "YTOSumarMyTravelsViewController.h"
#import "YTOWebViewController.h"
#import "YTOFinalizareCalatorieViewController.h"
#import "YTOAppDelegate.h"
#import "YTOUserDefaults.h"
#import "VerifyNet.h"
#import "YTOTermeniViewController.h"

@interface YTOSumarMyTravelsViewController ()

@end

@implementation YTOSumarMyTravelsViewController

@synthesize oferta, asigurat,scopCalatorie,DataInceput;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title =NSLocalizedStringFromTable(@"i466", [YTOUserDefaults getLanguage],@"Sumar calatorie");
        self.tabBarItem.image = [UIImage imageNamed:@"menu-asigurari.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.trackedViewName = @"YTOSumarCalatorieViewController";
    if (IS_OS_7_OR_LATER){
        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars=NO;
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    lblHeader.textColor = [YTOUtils colorFromHexString:@"#056f8d"];
    // Do any additional setup after loading the view from its nib.
    [self initCells];
    [YTOUtils rightImageVodafone:self.navigationItem];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2 || indexPath.row == 3)
        return 100;
    return 90;
}

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
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell ;
    
    if (indexPath.row == 0) cell = cellSumar1;
    else if (indexPath.row == 1) cell = cellPers1;
    else if (indexPath.row == 2) cell = cellProdus;
    else cell = cellCalculeaza;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3)
    {
        VerifyNet * vn = [[VerifyNet alloc] init];
        if ([vn hasConnectivity])
        {
            [self showCustomConfirm:NSLocalizedStringFromTable(@"i451", [YTOUserDefaults getLanguage],@"Confirma date") withDescription:@"Am verificat toate datele completate, sunt corect introduse si sunt de acord cu conditiile contractuale si conditiile aplicatiei i-Asigurare. Vreau sa comand polita de CALATORIE." withButtonIndex:100];
        }else [self showPopupServiciu:@"Te rugam sa te asiguri ca ai o conexiune la internet activa si calculeaza din nou. Iti multumim! "];
    }
}

-(NSString *) XmlRequestInregistrareComanda
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    YTOPersoana * proprietar = [YTOPersoana Proprietar];
    YTOPersoana * proprietarPJ = [YTOPersoana ProprietarPJ];
    NSString *email;
    if (proprietar.email && proprietar.email.length > 0)
        email = proprietar.email;
    else if (proprietarPJ.email && proprietarPJ.email.length > 0)
        email = proprietarPJ.email;
    NSString * xml = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                      "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                      "<soap:Body>"
                      "<CallInregistrareComandaMyTravels3 xmlns=\"http://tempuri.org/\">"
                      "<user>vreaurca</user>"
                      "<password>123</password>"
                      "<udid>%@</udid>"
                      "<id_intern>%@</id_intern>"
                      "<nume_asigurat>%@</nume_asigurat>"
                      "<cod_unic>%@</cod_unic>"
                      "<data_inceput>%@</data_inceput>"
                      "<mod_plata>%@</mod_plata>"
                      "<telefon>%@</telefon>"
                      "<email>%@</email>"
                      "<cont_user>%@</cont_user>"
                      "<cont_parola>%@</cont_parola>"
                      "</CallInregistrareComandaMyTravels3>"
                      "</soap:Body>"
                      "</soap:Envelope>",
                      [[UIDevice currentDevice] xUniqueDeviceIdentifier],
                      asigurat.idIntern,
                      asigurat.nume,
                      asigurat.codUnic,
                      [formatter stringFromDate:DataInceput],
                      @"3",// numar
                      asigurat.telefon,
                      email,
                      [YTOUserDefaults getUserName],
                      [YTOUserDefaults getPassword]];
    
    return [xml stringByReplacingOccurrencesOfString:@"'" withString:@""];
}

- (void) calculInregistrareComanda {
	NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@gothaer.asmx", LinkAPI]];
    
    VerifyNet * vn = [[VerifyNet alloc] init];
    if ([vn hasConnectivity]) {
        
        [vwLoading setHidden:NO];
        [self showLoading];
        
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:30.0];
        
        NSString * parameters = [[NSString alloc] initWithString:[self XmlRequestInregistrareComanda]];
        NSLog(@"Request=%@", parameters);
        NSString * msgLength = [NSString stringWithFormat:@"%d", [parameters length]];
        
        [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request addValue:@"http://tempuri.org/CallInregistrareComandaMyTravels3" forHTTPHeaderField:@"SOAPAction"];
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
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
	NSString * responseString = [[NSString alloc] initWithData:self->responseData encoding:NSUTF8StringEncoding];
	NSLog(@"Response string: %@", responseString);
    self.navigationItem.hidesBackButton = NO;
    [self hideLoading];
    
	NSXMLParser * xmlParser = [[NSXMLParser alloc] initWithData:responseData];
	xmlParser.delegate = self;
	BOOL succes = [xmlParser parse];
	
    
    if (succes) {
        if (idOferta == nil || [idOferta isEqualToString:@""])
            [self showPopupServiciu:responseMessage];
        else {
            oferta.idExtern = [idOferta intValue];
            
            // daca este pentru plata ONLINE
            [self showCustomConfirm:NSLocalizedStringFromTable(@"i449", [YTOUserDefaults getLanguage],@"Finalizare comanda") withDescription:responseMessage withButtonIndex:3];
            
        }
	}
	  else [self showPopupServiciu:@"Comanda nu a fost transmisa"];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"connection:didFailWithError:");
	NSLog(@"%@", [error localizedDescription]);
	
    [self hideLoading];
    [self showPopupServiciu:[error localizedDescription]];
}

- (void) showCustomConfirm:(NSString *) title withDescription:(NSString *) description withButtonIndex:(int) index
{
    self.navigationItem.hidesBackButton = YES;
    
    lblCustomAlertTitle.text = @"Datele sunt corecte?";
    lblCustomAlertTitle.textColor = [YTOUtils colorFromHexString:verde];
    btnCustomAlertOK.tag = index;
    [lblCustomAlertOK setText:NSLocalizedStringFromTable(@"i92", [YTOUserDefaults getLanguage],@"DA")];
    
    if (index != 3){
        [btnCustomAlertNO setHidden:NO];
        [lblCustomAlertNO setHidden:NO];
        lblEroare1.text = title;
    }else{
        lblEroare1.text = @"";
        lblCustomAlertTitle.text = @"Finalizare comanda";
        [lblCustomAlertOK setText:@"OK"];
        [btnCustomAlertNO setHidden:YES];
        [lblCustomAlertNO setHidden:YES];
    }
    
    lblCustomAlertMessage.text = description;
    [vwCustomAlert setHidden:NO];
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
    else if (btn.tag == 100)
    {
        [self calculInregistrareComanda];
    }
}


#pragma METHODS
- (void) initCells
{
    NSArray *topLevelObjectsSumar1 = [[NSBundle mainBundle] loadNibNamed:@"CellView_SumarCalatorie" owner:self options:nil];
    cellSumar1 = [topLevelObjectsSumar1 objectAtIndex:0];
    ((UILabel *)[cellSumar1 viewWithTag:1]).text = [NSString stringWithFormat:@"SA : 30000.00 EUR"];
    ((UIImageView *)[cellSumar1 viewWithTag:2]).image = [UIImage imageNamed:@"icon-foto-person-xs.png"];
    NSString * scop;
    if ([scopCalatorie isEqualToString:@"turism"])
        scop = NSLocalizedStringFromTable(@"i65", [YTOUserDefaults getLanguage],@"Turism");
    else if ([scopCalatorie isEqualToString:@"afaceri"])
        scop = NSLocalizedStringFromTable(@"i71", [YTOUserDefaults getLanguage],@"Afaceri");
    else  if ([scopCalatorie isEqualToString:@"sofer-profesionist"])
        scop = NSLocalizedStringFromTable(@"i81", [YTOUserDefaults getLanguage],@"Sofer profesionist");
    else if ([scopCalatorie isEqualToString:@"studii"])
        scop = NSLocalizedStringFromTable(@"i82", [YTOUserDefaults getLanguage],@"Studii");
    ((UILabel *)[cellSumar1 viewWithTag:3]).text = [NSString stringWithFormat:@"%@ %@",NSLocalizedStringFromTable(@"i461", [YTOUserDefaults getLanguage],@"scopul calatoriei : "), scop];
    ((UILabel *)[cellSumar1 viewWithTag:4]).text = [NSString stringWithFormat:@"%@ %d %@",NSLocalizedStringFromTable(@"i462", [YTOUserDefaults getLanguage],@"durata asigurare : "), 365 ,NSLocalizedStringFromTable(@"i468", [YTOUserDefaults getLanguage],@"zile")];
    ((UIImageView *)[cellSumar1 viewWithTag:5]).image = ((UIImageView *)[cellSumar1 viewWithTag:6]).image = [UIImage imageNamed:@"arrow-calatorie.png"];
    ((UIImageView *)[cellSumar1 viewWithTag:11]).image  = ((UIImageView *)[cellSumar1 viewWithTag:11]).image = [UIImage imageNamed:@"arrow-calatorie.png"];
    ((UILabel *)[cellSumar1 viewWithTag:12]).text = @"My travels";
    
    YTOPersoana * persoana1 = asigurat;
    
    NSArray *topLevelObjectsPers1 = [[NSBundle mainBundle] loadNibNamed:@"CellView_SumarCalatorie" owner:self options:nil];
    cellPers1 = [topLevelObjectsPers1 objectAtIndex:0];
    ((UILabel *)[cellPers1 viewWithTag:1]).text = persoana1.nume;
    ((UIImageView *)[cellPers1 viewWithTag:2]).image = [UIImage imageNamed:@"icon-foto-person-xs.png"];
    ((UILabel *)[cellPers1 viewWithTag:3]).text = persoana1.codUnic;
    ((UILabel *)[cellPers1 viewWithTag:4]).text = [NSString stringWithFormat:@"Cod Postal : %@", persoana1.codPostal];
    ((UIImageView *)[cellPers1 viewWithTag:5]).image = ((UIImageView *)[cellPers1 viewWithTag:6]).image = [UIImage imageNamed:@"arrow-calatorie.png"];
    ((UIImageView *)[cellPers1 viewWithTag:11]).image  = ((UIImageView *)[cellPers1 viewWithTag:11]).image = nil;
    ((UILabel *)[cellPers1 viewWithTag:12]).text = @"";
    
    NSArray *topLevelObjectsProdus = [[NSBundle mainBundle] loadNibNamed:@"CellView_Sumar" owner:self options:nil];
    cellProdus = [topLevelObjectsProdus objectAtIndex:0];
    ((UILabel *)[cellProdus viewWithTag:1]).text = [NSString stringWithFormat:@"%.2f RON", oferta.prima];
    ((UIImageView *)[cellProdus viewWithTag:2]).image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", [@"platinum" lowercaseString]]];
    
    ((UILabel *)[cellProdus viewWithTag:3]).text = @"";
    ((UILabel *)[cellProdus viewWithTag:4]).text = @"";
    ((UIImageView *)[cellProdus viewWithTag:5]).image = ((UIImageView *)[cellProdus viewWithTag:6]).image = nil ;//[UIImage imageNamed:@"arrow-calatorie.png"];
    UIButton * btnConditii = ((UIButton *)[cellProdus viewWithTag:7]);
    UIButton * btnSumar = ((UIButton *)[cellProdus viewWithTag:9]);
    btnConditii.hidden = ((UILabel *)[cellProdus viewWithTag:8]).hidden = NO;
    btnSumar.hidden = ((UILabel *)[cellProdus viewWithTag:10]).hidden = NO;
    ((UILabel *) [cellProdus viewWithTag:8]).text = @"Conditii\ncontractuale";
    ((UILabel *) [cellProdus viewWithTag:10]).text = @"Termeni\nsi conditii";
    [btnConditii setImage:[UIImage imageNamed:@"conditii-asigurare-sumar.png"] forState:UIControlStateNormal];
    [btnSumar setImage:[UIImage imageNamed:@"conditii-asigurare-pdf.png"] forState:UIControlStateNormal];
    
    [btnConditii addTarget:self action:@selector(showConditiiContractuale) forControlEvents:UIControlEventTouchUpInside];
    [btnSumar addTarget:self action:@selector(showTermeniSiConditii) forControlEvents:UIControlEventTouchUpInside];

    NSArray *topLevelObjectscalc = [[NSBundle mainBundle] loadNibNamed:@"CellCalculeaza" owner:self options:nil];
    cellCalculeaza = [topLevelObjectscalc objectAtIndex:0];
    UIImageView * imgComanda = (UIImageView *)[cellCalculeaza viewWithTag:1];
    imgComanda.image = [UIImage imageNamed:@"comanda-calatorie.png"];
    UILabel * lblCellC = (UILabel *)[cellCalculeaza viewWithTag:2];
    lblCellC.textColor = [YTOUtils colorFromHexString:@"ffffff"];
    lblCellC.text = @"Comanda";
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


- (IBAction)hideWebView:(id)sender
{
    wvWebView.hidden = YES;
    [webView loadHTMLString:@"" baseURL:nil];
}

- (void)showConditiiContractuale
{
    NSString * url = @"http://sources.i-crm.ro/i-asigurare/conditii/Gothaer-Conditii-Travel.pdf";
    YTOWebViewController * aView = [[YTOWebViewController alloc] init];
    aView.URL = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.rcaNavigationController pushViewController:aView animated:YES];
}

- (void) showTermeniSiConditii
{
    YTOTermeniViewController * aView;
    YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (IS_IPHONE_5)
        aView = [[YTOTermeniViewController alloc] initWithNibName:@"YTOTermeniViewController_R4" bundle:nil];
    else aView = [[YTOTermeniViewController alloc] initWithNibName:@"YTOTermeniViewController" bundle:nil];
    [delegate.rcaNavigationController pushViewController:aView animated:YES];
}



@end
