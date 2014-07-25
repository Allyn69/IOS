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

@interface YTOWebServiceCalatorieViewController ()

@end

@implementation YTOWebServiceCalatorieViewController

@synthesize responseData, oferta, cotatie, listTarife, listAsigurati;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Calculator", @"Calculator");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
    listTarife = [[NSMutableArray alloc] init];

	[self calculCalatorie];
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

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
                      "</soap:Envelope>",[[UIDevice currentDevice] uniqueIdentifier],
                      [formatter stringFromDate:oferta.dataInceput],
                      [oferta CalatorieTranzit],
                      oferta.durataAsigurare, taraDestinatie, sumaAsigurata, scopCalatorie, (listAsigurati.count == 1 ? @"individual" : @"grup"), [YTOPersoana getJsonPersoane:listAsigurati], pers1.judet, pers1.localitate,
                      [[UIDevice currentDevice].model stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
    return xml;
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
        
        vwErrorAlert.hidden = NO;
        
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
        if (listTarife.count > 0)
        {
            // verific daca nu a intors eroare
            CotatieCalatorie * _cotatie = [listTarife objectAtIndex:0];
            if (listTarife.count == 1 && ![_cotatie.Eroare_ws isEqualToString:@"success"])
                [self showPopupWithTitle:@"Atentie" andDescription:_cotatie.Eroare_ws];
                //vwErrorAlert.hidden = NO;
            else
                [tableView reloadData];
        }
        else
            [self showPopupWithTitle:@"Atentie" andDescription:@"Serverul companiilor de asigurare nu afiseaza tarifele. Te rugam sa verifici ca datele introduse sunt complete si corecte si apoi sa refaci calculatia."];
            //vwErrorAlert.hidden = NO;
    }
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"connection:didFailWithError:");
	NSLog(@"%@", [error localizedDescription]);

    [self showPopupWithTitle:@"Atentie!" andDescription:[NSString stringWithFormat:@"%@", [error localizedDescription]]];
    
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
    return 110;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"%d %@, %d zile in %@", listAsigurati.count, (listAsigurati.count == 1 ? @"persoana" : @"persoane"), oferta.durataAsigurare, taraDestinatie];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listTarife.count;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CellTarifCustom *cell = (CellTarifCustom *)[tv dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[CellTarifCustom alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier forCalatorie:YES];
    }
    
    CotatieCalatorie * tarif = (CotatieCalatorie *)[listTarife objectAtIndex:indexPath.row];
    
    [cell setNumeProdus:tarif.TipProdus];
    [cell setLogo:[NSString stringWithFormat:@"%@.jpg", [tarif.Companie lowercaseString]]];
    [cell setPrima:[NSString stringWithFormat:@"%.2f  lei", [tarif.Prima floatValue]]];
    [cell setCol1:tarif.Fransiza andLabel:@"Fransiza"];
    [cell setCol2:tarif.SABagaje andLabel:@"SA Bagaje"];
    [cell setCol3:tarif.SAEei andLabel:@"SA Electronice"];
    [cell setCol4:tarif.AcoperireSportAgrement andLabel:@"Acoperire Sport"];
    cell.btnComanda.tag = indexPath.row;
    
    [cell.btnComanda addTarget:self action:@selector(btnComandaAsigurare_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
    oferta.prima = [_cotatie.Prima floatValue];
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
    
    YTOAppDelegate * delegate =  (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate.rcaNavigationController pushViewController:aView animated:YES];
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

- (void) showPopupWithTitle:(NSString *)title andDescription:(NSString *)description
{
    [self stopLoadingAnimantion];
    [vwPopup setHidden:NO];
    lblPopupDescription.text = description;
    lblPopupTitle.text = title;
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

@end
