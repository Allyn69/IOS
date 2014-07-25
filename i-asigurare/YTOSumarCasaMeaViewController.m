//
//  YTOSumarCasaMeaViewController.m
//  i-asigurare
//
//  Created by Stern Edi on 29/04/14.
//
//

#import "YTOSumarCasaMeaViewController.h"
#import "YTOAppDelegate.h"
#import "YTOFinalizareLocuintaViewController.h"
#import "YTOWebViewController.h"
#import "YTOUserDefaults.h"
#import "VerifyNet.h"
#import "YTOTermeniViewController.h"

@interface YTOSumarCasaMeaViewController ()

@end

@implementation YTOSumarCasaMeaViewController
@synthesize oferta, asigurat, locuinta;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedStringFromTable(@"i465", [YTOUserDefaults getLanguage],@"Sumar locuinta");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.trackedViewName = @"YTOSumarLocuintaViewController";
    if (IS_OS_7_OR_LATER){
        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars=NO;
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    [self initCells];
    [YTOUtils rightImageVodafone:self.navigationItem];
    lblHeader.textColor = [YTOUtils colorFromHexString:@"#056f8d"];
    
    
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
            [self showCustomConfirm:NSLocalizedStringFromTable(@"i451", [YTOUserDefaults getLanguage],@"Confirma date") withDescription:@"Am verificat toate datele completate, sunt corect introduse si sunt de acord cu conditiile contractuale si conditiile aplicatiei i-Asigurare. Vreau sa comand polita de LOCUINTA." withButtonIndex:100];
        }else [self showPopupServiciu:@"Te rugam sa te asiguri ca ai o conexiune la internet activa si calculeaza din nou. Iti multumim! "];
    }
}

- (NSString *) XmlRequestInregistrare
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
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
    
    NSString * xml = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                      "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                      "<soap:Body>"
                      "<CallInregistrareComandaCasaMeaSmartphone xmlns=\"http://tempuri.org/\">"
                      "<user>vreaurca</user>"
                      "<password>123</password>"
                      "<udid>%@</udid>"
                      "<id_intern>%@</id_intern>"
                      "<nume_asigurat>%@</nume_asigurat>"
                      "<cod_unic>%@</cod_unic>"
                      "<data_inceput>%@</data_inceput>"
                      "<mod_plata>3</mod_plata>"
                      "<telefon>%@</telefon>"
                      "<email>%@</email>"
                      "<platforma>%@</platforma>"
                      "<cont_user>%@</cont_user>"
                      "<cont_parola>%@</cont_parola>"
                      "</CallInregistrareComandaCasaMeaSmartphone>"
                      "</soap:Body>"
                      "</soap:Envelope>",
                      [[UIDevice currentDevice] xUniqueDeviceIdentifier],
                      locuinta.idIntern,
                      asigurat.nume,
                      asigurat.codUnic,
                      _DataInceput,
                      telefon,
                      emailLivrare,
                      [[UIDevice currentDevice].model stringByReplacingOccurrencesOfString:@" " withString:@"_"],
                      [YTOUserDefaults getUserName],
                      [YTOUserDefaults getPassword]
                      ];
    
    return [xml stringByReplacingOccurrencesOfString:@"'" withString:@""];
}


- (void) callInregistrareComanda {
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@gothaer.asmx", LinkAPI]];
    VerifyNet * vn = [[VerifyNet alloc] init];
    if ([vn hasConnectivity]) {
        [self showLoading];
        
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:30.0];
        
        NSString * parameters = [[NSString alloc] initWithString:[self XmlRequestInregistrare]];
        NSLog(@"Request=%@", parameters);
        NSString * msgLength = [NSString stringWithFormat:@"%d", [parameters length]];
        
        [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request addValue:@"http://tempuri.org/CallInregistrareComandaCasaMeaSmartphone" forHTTPHeaderField:@"SOAPAction"];
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
                          "&moneda=%@",
                          LinkAPI,
                          idOferta,email, asigurat.nume, locuinta.adresa, asigurat.localitate, asigurat.judet, telefon,
                          @"Locuinta", oferta.prima, oferta.companie, [[[UIDevice currentDevice] xUniqueDeviceIdentifier] stringByAppendingString:[NSString stringWithFormat:@"---%@",locuinta.idIntern]],@"eur"];
        
        YTOWebViewController * aView = [[YTOWebViewController alloc] init];
        aView.URL = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate.rcaNavigationController pushViewController:aView animated:YES];
        
        
    }
    else if (btn.tag == 100)
    {
        [self callInregistrareComanda];
    }
}


#pragma METHODS
- (void) initCells
{
    NSArray *topLevelObjectsSumar1 = [[NSBundle mainBundle] loadNibNamed:@"CellView_Sumar" owner:self options:nil];
    cellSumar1 = [topLevelObjectsSumar1 objectAtIndex:0];
    ((UILabel *)[cellSumar1 viewWithTag:1]).text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"i18", [YTOUserDefaults getLanguage],@"Asigurare locuinta")];
    ((UIImageView *)[cellSumar1 viewWithTag:2]).image = [UIImage imageNamed:@"icon-foto-casa.png"];
    ((UILabel *)[cellSumar1 viewWithTag:3]).text = [NSString stringWithFormat:@"%@: %d %@",NSLocalizedStringFromTable(@"i126", [YTOUserDefaults getLanguage],@"Suma asigurata"), locuinta.sumaAsigurata, @"EUR"];
    NSString *str = @"";
    NSString *p = locuinta.structuraLocuinta;
    if ([p isEqualToString:@"beton-armat"])
        str =  NSLocalizedStringFromTable(@"i382", [YTOUserDefaults getLanguage],@"beton-armat");
    else if ([p isEqualToString:@"beton"])
        str = NSLocalizedStringFromTable(@"i383", [YTOUserDefaults getLanguage],@"beton");
    else if ([p isEqualToString:@"bca"])
        str =NSLocalizedStringFromTable(@"i384", [YTOUserDefaults getLanguage],@"bca");
    else if ([p isEqualToString:@"caramida"])
        str =NSLocalizedStringFromTable(@"i385", [YTOUserDefaults getLanguage],@"caramida");
    else if ([p isEqualToString:@"caramida-nearsa"])
        str =NSLocalizedStringFromTable(@"i386", [YTOUserDefaults getLanguage],@"caramida-nearsa");
    else if ([p isEqualToString:@"chirpici-paiata"])
        str =NSLocalizedStringFromTable(@"i387", [YTOUserDefaults getLanguage],@"chirpici-paiata");
    else if ([p isEqualToString:@"lemn"])
        str =NSLocalizedStringFromTable(@"i388", [YTOUserDefaults getLanguage],@"lemn");
    else if ([p isEqualToString:@"zidarie-lemn"])
        str =NSLocalizedStringFromTable(@"i389", [YTOUserDefaults getLanguage],@"zidarie-lemn");
    ((UILabel *)[cellSumar1 viewWithTag:4]).text = [NSString stringWithFormat:@"%d mp2, %@", locuinta.suprafataUtila, str];
    ((UIImageView *)[cellSumar1 viewWithTag:5]).image = ((UIImageView *)[cellSumar1 viewWithTag:6]).image = [UIImage imageNamed:@"arrow-locuinta.png"];
    
    
    NSArray *topLevelObjectsPers1 = [[NSBundle mainBundle] loadNibNamed:@"CellView_Sumar" owner:self options:nil];
    cellPers1 = [topLevelObjectsPers1 objectAtIndex:0];
    ((UILabel *)[cellPers1 viewWithTag:1]).text = asigurat.nume;
    ((UIImageView *)[cellPers1 viewWithTag:2]).image = [UIImage imageNamed:@"icon-foto-person-xs.png"];
    ((UILabel *)[cellPers1 viewWithTag:3]).text = asigurat.codUnic;
    ((UILabel *)[cellPers1 viewWithTag:4]).text = [NSString stringWithFormat:@"%@, %@", asigurat.judet, asigurat.localitate];
    ((UIImageView *)[cellPers1 viewWithTag:5]).image = ((UIImageView *)[cellPers1 viewWithTag:6]).image = [UIImage imageNamed:@"arrow-locuinta.png"];
    
    NSArray *topLevelObjectsProdus = [[NSBundle mainBundle] loadNibNamed:@"CellView_Sumar" owner:self options:nil];
    cellProdus = [topLevelObjectsProdus objectAtIndex:0];
    ((UILabel *)[cellProdus viewWithTag:1]).text = [NSString stringWithFormat:@"%.2f %@", oferta.prima, [oferta.moneda uppercaseString]];
    ((UIImageView *)[cellProdus viewWithTag:2]).image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", [oferta.companie lowercaseString]]];
    
    
    ((UILabel *)[cellProdus viewWithTag:3]).text = @"";
    ((UILabel *)[cellProdus viewWithTag:4]).text = @"";
    ((UIImageView *)[cellProdus viewWithTag:5]).image = ((UIImageView *)[cellProdus viewWithTag:6]).image = nil ;//[UIImage imageNamed:@"arrow-calatorie.png"];
    UIButton * btnConditii = ((UIButton *)[cellProdus viewWithTag:7]);
    UIButton * btnSumar = ((UIButton *)[cellProdus viewWithTag:9]);
    ((UILabel *) [cellProdus viewWithTag:8]).text = @"Conditii\ncontractuale";
    ((UILabel *) [cellProdus viewWithTag:10]).text = @"Termeni\nsi conditii";
    btnConditii.hidden = ((UILabel *)[cellProdus viewWithTag:8]).hidden =
    btnSumar.hidden = ((UILabel *)[cellProdus viewWithTag:10]).hidden = NO;
    [btnConditii setImage:[UIImage imageNamed:@"conditii-asigurare-sumar.png"] forState:UIControlStateNormal];
    [btnSumar setImage:[UIImage imageNamed:@"conditii-asigurare-pdf.png"] forState:UIControlStateNormal];
    
    [btnConditii addTarget:self action:@selector(showConditiiContractuale) forControlEvents:UIControlEventTouchUpInside];
    [btnSumar addTarget:self action:@selector(showTermeniSiConditii) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *topLevelObjectscalc = [[NSBundle mainBundle] loadNibNamed:@"CellCalculeaza" owner:self options:nil];
    cellCalculeaza = [topLevelObjectscalc objectAtIndex:0];
    UIImageView * imgComanda = (UIImageView *)[cellCalculeaza viewWithTag:1];
    imgComanda.image = [UIImage imageNamed:@"comanda-locuinta.png"];
    UILabel * lblCellC = (UILabel *)[cellCalculeaza viewWithTag:2];
    lblCellC.textColor = [YTOUtils colorFromHexString:@"ffffff"];
    lblCellC.text = @"Comanda";
}



#pragma mark NSXMLParser Methods
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"CallInregistrareComandaCasaMeaSmartphoneResult"])
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
}

- (void) hideLoading
{
    vwLoading.hidden = YES;
}


- (IBAction)hideWebView:(id)sender
{
    wvWebView.hidden = YES;
    [webView loadHTMLString:@"" baseURL:nil];
}

- (void)showConditiiContractuale
{
    NSString * url = @"http://sources.i-crm.ro/i-asigurare/conditii/Gothaer-Conditii-Casa-Mea.pdf";
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
