//
//  YTOWebServiceCalatorieViewController.m
//  i-asigurare
//
//  Created by Andi Aparaschivei on 7/31/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
//

#import "YTOWebServiceCalatorieViewController.h"
#import "YTOUtils.h"
#import "YTOSumarCalatorieViewController.h"
#import "VerifyNet.h"
#import "YTOUserDefaults.h"


@interface YTOWebServiceCalatorieViewController ()

@end

@implementation YTOWebServiceCalatorieViewController

@synthesize responseData, oferta, cotatie, listTarife, listAsigurati;

YTOSumarCalatorieViewController * viewIfPlatinum;// trimit view pentru cazul in care e ok platinum in weekend

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedStringFromTable(@"i446", [YTOUserDefaults getLanguage],@"Calculator");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    if (IS_OS_7_OR_LATER){
        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars=NO;
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    //self.trackedViewName = @"YTOWebServiceCalatorieViewController";
	
    listTarife = [[NSMutableArray alloc] init];

	[self calculCalatorie];
    [YTOUtils rightImageVodafone:self.navigationItem];
    
    lblCauze1.text = NSLocalizedStringFromTable(@"i585", [YTOUserDefaults getLanguage],@"cauzele");
    lblCauze2.text = NSLocalizedStringFromTable(@"i586", [YTOUserDefaults getLanguage],@"cauzele");
    lblCauze3.text = NSLocalizedStringFromTable(@"i587", [YTOUserDefaults getLanguage],@"cauzele");
    lblCauze4.text = NSLocalizedStringFromTable(@"i588", [YTOUserDefaults getLanguage],@"cauzele");
    
    lblLoad0.text = NSLocalizedStringFromTable(@"i176", [YTOUserDefaults getLanguage],@"Cautam \n cele mai mici tarife \n direct \n de la companiile \n de asigurare");
    lblLoad1.text = NSLocalizedStringFromTable(@"i73", [YTOUserDefaults getLanguage],@"Tarifele sunt obtinute direct de la companiile de asigurare.");
    lblLoad2.text = NSLocalizedStringFromTable(@"i74", [YTOUserDefaults getLanguage],@"Plata asigurarii de calatorie se efectueaza online cu cardul.");;
    lblLoad3.text = NSLocalizedStringFromTable(@"i75", [YTOUserDefaults getLanguage],@"Vei primi polita prin email,in cateva minute dupa efectuarea platii.");
    
    lblNointernet2.text = lblNointernet1.text = NSLocalizedStringFromTable(@"i219", [YTOUserDefaults getLanguage],@"Ne pare rau!\nTarifele nu s-au calculat pentru ca nu esti conectat la internet.\n Te rugam sa te asiguri ca ai o conexiune la internet activa si calculeaza din nou.\nIti multumim!");
    
    lblAtentiePlatinum.text = NSLocalizedStringFromTable(@"i123", [YTOUserDefaults getLanguage],@"atentie");
    lblPlatinum.text = NSLocalizedStringFromTable(@"i649", [YTOUserDefaults getLanguage],@"ai ales gothaer");
    lblBtnNoPlatinum.text = NSLocalizedStringFromTable(@"i650", [YTOUserDefaults getLanguage],@"alta companie");
    lblBtnOkPlatinum.text = NSLocalizedStringFromTable(@"i651", [YTOUserDefaults getLanguage],@"sunt de acord");
    
    lblMultumim1.text = NSLocalizedStringFromTable(@"i798", [YTOUserDefaults getLanguage],@"Iti multumim pentru intelegere");
    lblMultumim2.text = NSLocalizedStringFromTable(@"i798", [YTOUserDefaults getLanguage],@"Iti multumim pentru intelegere");
    lblSorry1.text = NSLocalizedStringFromTable(@"i806", [YTOUserDefaults getLanguage],@":( ne pare rau");
    lblSorry2.text = NSLocalizedStringFromTable(@"i806", [YTOUserDefaults getLanguage],@":( ne pare rau");
    lblDetaliiErr1.text = NSLocalizedStringFromTable(@"i819", [YTOUserDefaults getLanguage],@"detalii eroare");
    lblEroare.text = NSLocalizedStringFromTable(@"i799", [YTOUserDefaults getLanguage],@"Eroare !");
    lblEroare2.text = NSLocalizedStringFromTable(@"i799", [YTOUserDefaults getLanguage],@"Eroare !");
    
    lblMultumim1.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblMultumim2.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblSorry1.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblSorry2.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblDetaliiErr1.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblEroare.textColor = [YTOUtils colorFromHexString:rosuTermeni];
    lblEroare2.textColor = [YTOUtils colorFromHexString:rosuTermeni];
    
    UILabel *lbl11 = (UILabel * ) [cellHead viewWithTag:11];
    UILabel *lbl22 = (UILabel * ) [cellHead viewWithTag:22];
    UIImageView *image = (UIImageView *) [cellHead viewWithTag:100];
    
    NSString *img = @"header-tarife-calatorie.png";
    if ([[YTOUserDefaults getLanguage] isEqualToString:@"hu"])
        img = @"header-tarife-calatorie-hu.png";
    else if ([[YTOUserDefaults getLanguage] isEqualToString:@"en"])
        img = @"header-tarife-calatorie-en.png";
    else img = @"header-tarife-calatorie";
    
    [image setImage:[UIImage imageNamed:img]];
    
    
    NSString *string1 = NSLocalizedStringFromTable(@"i788", [YTOUserDefaults getLanguage],@"Tarife");
    NSString *string2 = NSLocalizedStringFromTable(@"i789", [YTOUserDefaults getLanguage],@"de asigurare");
    NSString *string  = [[NSString alloc]initWithFormat:@"%@ %@",string1,string2];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")){
        NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        [attributedString beginEditing];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[YTOUtils colorFromHexString:portocaliuCalatorie] range:NSMakeRange(0, string1.length+1)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[YTOUtils colorFromHexString:ColorTitlu] range:NSMakeRange(string1.length+1, string2.length)];
        [attributedString beginEditing];
        
        [lbl11 setAttributedText:attributedString];
    }else{
        [lbl11 setText:string];
        [lbl11 setTextColor:[YTOUtils colorFromHexString:portocaliuCalatorie]];
    }
    
    lbl22.text = NSLocalizedStringFromTable(@"i778", [YTOUserDefaults getLanguage],@"cele mai mici tarife pentru calatoria ta");


}




/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void) viewDidAppear:(BOOL)animated
{
    if (listTarife!=nil && listTarife.count>0){
        [tableView reloadData];
        resume = YES;
    }
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	//listTarife = nil;
}

#pragma mark Consume WebService

- (NSString *) XmlRequest
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSString * scopCalatorie = [oferta CalatorieScop];
    taraDestinatie = [oferta CalatorieDestinatie];

    NSString * sumaAsigurata = [oferta CalatorieProgram];
    
    YTOPersoana * pers1 = (YTOPersoana *)[listAsigurati objectAtIndex:0]; 
    
    NSString * xml = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                      "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                      "<soap:Body>"
                      "<CallCalculTravel xmlns=\"http://tempuri.org/\">"
                      "<user>vreaurca</user>"
                      "<password>123</password>"
                      "<tip_persoana>fizica</tip_persoana>"
                      "<udid>%@</udid>"
                      "<data_inceput>%@</data_inceput>"
                      "<tranzit>%@</tranzit>"
                      "<numar_zile>%d</numar_zile>"
                      "<tara_destinatie>%@</tara_destinatie>"
                      "<nationalitate>Romania</nationalitate>"
                      "<program_asigurare>%@</program_asigurare>"
                      "<scop_calatorie>%@</scop_calatorie>"
                      "<tip_calatorie>%@</tip_calatorie>"
                      "<jsonPersoane>%@</jsonPersoane>"
                      "<judet>%@</judet>"
                      "<localitate>%@</localitate>"
                      "<platforma>%@</platforma>"
                      "</CallCalculTravel>"
                      "</soap:Body>"
                      "</soap:Envelope>",[[UIDevice currentDevice] xUniqueDeviceIdentifier],
                      [formatter stringFromDate:oferta.dataInceput],
                      [oferta CalatorieTranzit],
                      oferta.durataAsigurare, taraDestinatie, sumaAsigurata, scopCalatorie, (listAsigurati.count == 1 ? @"individual" : @"grup"), [YTOPersoana getJsonPersoane:listAsigurati], pers1.judet, pers1.localitate,
                      [[UIDevice currentDevice].model stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
    
    return [xml stringByReplacingOccurrencesOfString:@"'" withString:@""];
    
}

- (IBAction)calculeazaDupaAltaSA:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    
    // Daca SA=5.000 eur
    if (btn.tag == 1)
        [oferta setCalatorieProgram:@"5.000-eur"];
    else if (btn.tag == 2)
        [oferta setCalatorieProgram:@"10.000-eur"];
    else if (btn.tag == 3)
        [oferta setCalatorieProgram:@"30.000-eur"];
    else if (btn.tag == 4)
        [oferta setCalatorieProgram:@"50.000-eur"];
    [listTarife removeAllObjects];
    [self calculCalatorie];
}

- (void) calculCalatorie {
    
    VerifyNet * vn = [[VerifyNet alloc] init];
    if ([vn hasConnectivity]) {
    
        [vwLoading setHidden:NO];
        [self startLoadingAnimantion];
        
        if ([[oferta CalatorieProgram] isEqualToString:@"5.000-eur"])
        {
            imgSA.image = [UIImage imageNamed:@"tarife-calatorie-5000.png"];
            lbl10k.textColor = lbl30k.textColor = lbl50k.textColor = [YTOUtils colorFromHexString:ColorTitlu];
            lbl5k.textColor = [UIColor whiteColor];
        }
        else if ([[oferta CalatorieProgram] isEqualToString:@"10.000-eur"])
        {
            imgSA.image = [UIImage imageNamed:@"tarife-calatorie-10000.png"];
            lbl5k.textColor = lbl30k.textColor = lbl50k.textColor = [YTOUtils colorFromHexString:ColorTitlu];
            lbl10k.textColor = [UIColor whiteColor];
        }
        else if ([[oferta CalatorieProgram] isEqualToString:@"30.000-eur"])
        {
            imgSA.image = [UIImage imageNamed:@"tarife-calatorie-30000.png"];
            lbl5k.textColor = lbl10k.textColor = lbl50k.textColor = [YTOUtils colorFromHexString:ColorTitlu];
            lbl30k.textColor = [UIColor whiteColor];
        }
        else if ([[oferta CalatorieProgram] isEqualToString:@"50.000-eur"])
        {
            imgSA.image = [UIImage imageNamed:@"tarife-calatorie-50000.png"];
            lbl5k.textColor = lbl10k.textColor = lbl30k.textColor = [YTOUtils colorFromHexString:ColorTitlu];
            lbl50k.textColor = [UIColor whiteColor];
        }

        
	NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@travel.asmx", LinkAPI]];
    
	NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
															cachePolicy:NSURLRequestUseProtocolCachePolicy
														timeoutInterval:30.0];
	NSString * parameters = [[NSString alloc] initWithString:[self XmlRequest]];
	NSLog(@"Request=%@", parameters);
	NSString * msgLength = [NSString stringWithFormat:@"%d", [parameters length]];
	
	[request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[request addValue:@"http://tempuri.org/CallCalculTravel" forHTTPHeaderField:@"SOAPAction"];
	[request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	if (connection) {
		self.responseData = [NSMutableData data];
	}
    }
    else {
        
        [self showPopupWithTitle:NSLocalizedStringFromTable(@"i123", [YTOUserDefaults getLanguage],@"Atentie !")];
        //vwErrorAlert.hidden = NO;
        
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"Response: %@", [response textEncodingName]);
	[self.responseData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSLog(@"connection:DidReceiveData");
	[self.responseData appendData:data];
}
- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
	NSString * responseString = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
	NSLog(@"Response string: %@", responseString);
	
	
	NSXMLParser * xmlParser = [[NSXMLParser alloc] initWithData:responseData];
	xmlParser.delegate = self;
	BOOL succes = [xmlParser parse];
	
    if (succes) {
        [vwLoading setHidden:YES];
        [self stopLoadingAnimantion];
        
        if ([YTOPersoana getJsonPersoane:listAsigurati] == nil)
            [self showPopupErrorWithTitle:NSLocalizedStringFromTable(@"i123", [YTOUserDefaults getLanguage],@"Atentie !") andDescription:@"Identitatea fiscala a unei persoane fizice trebuie sa fie un numar cu 13 digiti"];
        else
        if (listTarife.count > 0)
        {
            // verific daca nu a intors eroare
            CotatieCalatorie * _cotatie = [listTarife objectAtIndex:0];
        
            if (listTarife.count == 1 && ![_cotatie.Eroare_ws isEqualToString:@"success"])
                [self showPopupErrorWithTitle:NSLocalizedStringFromTable(@"i123", [YTOUserDefaults getLanguage],@"Atentie !") andDescription:_cotatie.Eroare_ws];
                //vwErrorAlert.hidden = NO;
            else{
                [tableView reloadData];
                [iRate sharedInstance].eventCount++;
            }
        }
        else
            //[self showPopupWithTitle:@"Atentie" andDescription:@"Serverul companiilor de asigurare nu afiseaza tarifele. Te rugam sa verifici ca datele introduse sunt complete si corecte si apoi sa refaci calculatia."];
            //vwErrorAlert.hidden = NO;
            [self showPopupServiciu:@"Serviciul care calculeaza tarife nu functioneaza momentan. Te rugam sa revii putin mai tarziu. Intre timp incercam sa remediem aceasta problema."];
    }
    else {
         [self showPopupServiciu:@"Serviciul care calculeaza tarife nu functioneaza momentan. Te rugam sa revii putin mai tarziu. Intre timp incercam sa remediem aceasta problema."];
    }
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"connection:didFailWithError:");
	NSLog(@"%@", [error localizedDescription]);

    //[self showPopupErrorWithTitle:@"Atentie!" andDescription:[NSString stringWithFormat:@"%@", [error localizedDescription]]];
    [self showPopupServiciu:@"Serviciul care calculeaza tarife nu functioneaza momentan. Te rugam sa revii putin mai tarziu. Intre timp incercam sa remediem aceasta problema."];

    //vwErrorAlert.hidden = NO;

}

#pragma mark NSXMLParser Methods
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName 
	attributes:(NSDictionary *)attributeDict {
	
	if ([elementName isEqualToString:@"ResponsePrima"]) {
		cotatie = [[CotatieCalatorie alloc] init];
        [listTarife addObject:cotatie];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if (![elementName isEqualToString:@"CallCalculTravelResponse"] 
        && ![elementName isEqualToString:@"CallCalculTravelResult"]
        && ![elementName isEqualToString:@"ResponsePrima"]
        && ![elementName isEqualToString:@"soap:Envelope"]
        && ![elementName isEqualToString:@"soap:Body"]) {
		
		//TarifRCA * tarif = [[TarifRCA alloc] init];
		if (cotatie == nil) {
			cotatie = [[CotatieCalatorie alloc] init];
        }
		
		NSLog(@"%@=%@\n", elementName, currentElementValue);
		if ([cotatie respondsToSelector:NSSelectorFromString(elementName)])
			[cotatie setValue:currentElementValue forKey:elementName];
	}
    
	currentElementValue = nil;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if(!currentElementValue)
		currentElementValue = [[NSMutableString alloc] initWithString:string];
	else
		[currentElementValue appendString:string];
}

#pragma mark UIAlertView
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	//MainViewController * mainController = [[MainViewController alloc] init];
	//[self presentModalViewController:mainController animated:YES];
    //[self dismissModalViewControllerAnimated:YES];
    YTOAppDelegate * delegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate.rcaNavigationController popViewControllerAnimated:YES];
}



#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CotatieCalatorie * tarif;
    if (listTarife && listTarife.count>0){
        tarif = (CotatieCalatorie *)[listTarife objectAtIndex:0];
    }
    BOOL isTarifRedus = ([tarif.Reducere isEqualToString:@"true"]? YES:NO);
    BOOL isRedusByBodafone = ([tarif.PromoVodafone isEqualToString:@"true"]? YES:NO);
    if (tarif && isTarifRedus && isRedusByBodafone)
        return 170;
    else return 110;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"%d %@, %d %@ in %@", listAsigurati.count, (listAsigurati.count == 1 ? NSLocalizedStringFromTable(@"i416", [YTOUserDefaults getLanguage],@"persoana") : NSLocalizedStringFromTable(@"i415", [YTOUserDefaults getLanguage],@"persoane")), oferta.durataAsigurare, NSLocalizedStringFromTable(@"i468", [YTOUserDefaults getLanguage],@"zile") ,taraDestinatie];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listTarife.count;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellTarifCalatories";

    BOOL isVodafone = [[YTOUserDefaults getOperator] isEqualToString:@"Vodafone"]? YES:NO;
    CotatieCalatorie * tarif = (CotatieCalatorie *)[listTarife objectAtIndex:indexPath.row];
    CellTarifCalatorie *cell1;
    CellTarifCustom *cell2;
    BOOL isTarifRedus = ([tarif.Reducere isEqualToString:@"true"]? YES:NO);
    BOOL isRedusByBodafone = ([tarif.PromoVodafone isEqualToString:@"true"]? YES:NO);
    if (cell1 == nil || resume) {
        if (isTarifRedus && isRedusByBodafone){
            cell1 = (CellTarifCalatorie *)[tv dequeueReusableCellWithIdentifier:CellIdentifier];
            cell1 = [[CellTarifCalatorie alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier forAbonatVodafone:isVodafone];
        }
        else if (cell2 == nil) {
            cell2 = (CellTarifCustom *)[tv dequeueReusableCellWithIdentifier:CellIdentifier];
            cell2 = [[CellTarifCustom alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier forCalatorie:YES withReducere:isTarifRedus];
        }
    }
    
    //CotatieCalatorie * tarif = (CotatieCalatorie *)[listTarife objectAtIndex:indexPath.row];
    if (isTarifRedus && isRedusByBodafone){
    [cell1 setNumeProdus:tarif.TipProdus];
    NSString *textSumaAsigurata = [NSString stringWithFormat:@"SA : %@",tarif.SumaAsigurata];
    [cell1 setSumaAsigurata:textSumaAsigurata ];
    [cell1 setLogo:[NSString stringWithFormat:@"%@.jpg", [tarif.Companie lowercaseString]]];
    [cell1 setPrima:[NSString stringWithFormat:@"%.2f  lei", [tarif.Prima floatValue]]];
    [cell1 setCol1:tarif.Fransiza andLabel:NSLocalizedStringFromTable(@"i140", [YTOUserDefaults getLanguage],@"Fransiza")];
    if ([tarif.Reducere isEqualToString:@"true"])[cell1 setPrimaReducere:[NSString stringWithFormat:@"%.2f lei",[tarif.PrimaReducere floatValue]]];
    else [cell1 setPrimaReducere:[NSString stringWithFormat:@"%.2f  lei", [tarif.Prima floatValue]]];
    [cell1 setCol2:tarif.SABagaje andLabel:NSLocalizedStringFromTable(@"i144", [YTOUserDefaults getLanguage],@"SA Bagaje")];
    [cell1 setCol3:tarif.SAEei andLabel:NSLocalizedStringFromTable(@"i143", [YTOUserDefaults getLanguage],@"SA Electronice")];
    [cell1 setCol4:tarif.AcoperireSportAgrement andLabel:NSLocalizedStringFromTable(@"i142", [YTOUserDefaults getLanguage],@"Acoperire Sport")andVineDin:@"Calatorie"];
    cell1.btnComanda.tag = indexPath.row;
    }else {
        [cell2 setNumeProdus:tarif.TipProdus];
        NSString *textSumaAsigurata = [NSString stringWithFormat:@"SA : %@",tarif.SumaAsigurata];
        [cell2 setSumaAsigurata:textSumaAsigurata ];
        [cell2 setLogo:[NSString stringWithFormat:@"%@.jpg", [tarif.Companie lowercaseString]]];
        [cell2 setPrima:[NSString stringWithFormat:@"%.2f  lei", [tarif.Prima floatValue]]];
        if (isTarifRedus){
            [cell2 setPrimaTaiat:[NSString stringWithFormat:@"%.2f  lei", [tarif.Prima floatValue]]];
            [cell2 setPrima:[NSString stringWithFormat:@"%.2f  lei", [tarif.PrimaReducere floatValue]]];
        }
        [cell2 setCol1:tarif.Fransiza andLabel:NSLocalizedStringFromTable(@"i140", [YTOUserDefaults getLanguage],@"Fransiza")];
        [cell2 setCol2:tarif.SABagaje andLabel:NSLocalizedStringFromTable(@"i144", [YTOUserDefaults getLanguage],@"SA Bagaje")];
        [cell2 setCol3:tarif.SAEei andLabel:NSLocalizedStringFromTable(@"i143", [YTOUserDefaults getLanguage],@"SA Electronice")];
        [cell2 setCol4:tarif.AcoperireSportAgrement andLabel:NSLocalizedStringFromTable(@"i142", [YTOUserDefaults getLanguage],@"Acoperire Sport") andVineDin:@"Calatorie"];
        cell2.btnComanda.tag = indexPath.row;
    }
    
    [cell1.btnComanda addTarget:self action:@selector(btnComandaAsigurare_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell2.btnComanda addTarget:self action:@selector(btnComandaAsigurare_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    cell2.selectionStyle = UITableViewCellSelectionStyleNone;
    if (isTarifRedus && isRedusByBodafone)
        return cell1;
    else return cell2;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void) btnComandaAsigurare_Clicked:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    
    CotatieCalatorie * _cotatie = [listTarife objectAtIndex:btn.tag];
    
    oferta.companie = _cotatie.Companie;
    BOOL isVodafone = [[YTOUserDefaults getOperator] isEqualToString:@"Vodafone"]? YES:NO;
    if (isVodafone && [_cotatie.Reducere isEqualToString:@"true"] && [_cotatie.PromoVodafone isEqualToString:@"true"])
    {
        oferta.prima = [_cotatie.PrimaReducere floatValue];
    }
    else if ([_cotatie.Reducere isEqualToString:@"true"] && ![_cotatie.PromoVodafone isEqualToString:@"true"])
    {
        oferta.prima = [_cotatie.PrimaReducere floatValue];
    }
    else oferta.prima = [_cotatie.Prima floatValue];
    oferta.codOferta = _cotatie.Cod;
    oferta.moneda = @"RON";
    
    //    if (!oferta._isDirty)
    //        [oferta addOferta];
    //    else
    //        [oferta updateOferta];
    
    YTOSumarCalatorieViewController * aView = [[YTOSumarCalatorieViewController alloc] init];
    aView.oferta = oferta;
    aView.cotatie = _cotatie;
    aView.listAsigurati = listAsigurati;
    if ([oferta.companie isEqualToString:@"Platinum"] && [YTOUtils isWeekend])
    {
        viewIfPlatinum = [[YTOSumarCalatorieViewController alloc] init];
        viewIfPlatinum = aView;
        vwPlatinum.hidden = NO;
    }else{
    YTOAppDelegate * delegate =  (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate.rcaNavigationController pushViewController:aView animated:YES];
    }
}

- (void) startLoadingAnimantion
{
    NSArray * imgs = [NSArray arrayWithObjects: [UIImage imageNamed:@"loading-calatorie1.png"], [UIImage imageNamed:@"loading-calatorie2.png"],[UIImage imageNamed:@"loading-calatorie3.png"],[UIImage imageNamed:@"loading-calatorie4.png"],[UIImage imageNamed:@""], nil];
    
    imgLoading.animationDuration = 1.5;
    imgLoading.animationRepeatCount = 0;
    imgLoading.animationImages = imgs;
    [imgLoading startAnimating];
}

- (void) stopLoadingAnimantion
{
    [imgLoading stopAnimating];    
}

#pragma YTOCustomPopup
- (void)chosenButton:(UIButton *)button
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void) showPopupWithTitle:(NSString *)title
{
    [self stopLoadingAnimantion];
    [vwPopup setHidden:NO];
    lblPopupTitle.text = title;
}

- (void) showPopupErrorWithTitle:(NSString *)title andDescription:(NSString *)description
{
    [self stopLoadingAnimantion];
    [vwPopupError setHidden:NO];
    lblPopupErrorTitle.text = title;
    lblPopupErrorDescription.text = description;
}

- (void) showPopupServiciu:description
{
    [vwServiciu setHidden:NO];
    lblServiciuDescription.text = description;
}

- (IBAction) hidePopupServiciu
{
    vwServiciu.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) hidePopupError
{
    vwPopupError.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)hidePopup:(id)sender
{
    [vwPopup setHidden:YES];
    YTOAppDelegate * delegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate.rcaNavigationController popViewControllerAnimated:YES];
}

- (IBAction) hideErrorAlert:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    [vwErrorAlert setHidden:YES];
    
    if (btn == btnErrorAlertOK)
        [vwDetailErrorAlert setHidden:NO];
    else
        [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) hideDetailErrorAlert
{
    [vwDetailErrorAlert setHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)noPlatinum:(id)sender
{
    vwPlatinum.hidden = YES;
}

- (IBAction)okPlatinum:(id)sender
{
    YTOAppDelegate * delegate =  (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate.rcaNavigationController pushViewController:viewIfPlatinum animated:YES];
    vwPlatinum.hidden = YES;
}

@end
