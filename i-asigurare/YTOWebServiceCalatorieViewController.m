//
//  YTOWebServiceCalatorieViewController.m
//  i-asigurare
//
//  Created by Administrator on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YTOWebServiceCalatorieViewController.h"
#import "YTOUtils.h"
#import "YTOSumarCalatorieViewController.h"

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
    NSDate * dataInceput = [YTOUtils getDataSfarsitPolita:[NSDate date] andDurataInZile:1];
    
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
                      [formatter stringFromDate:dataInceput],
                      [oferta CalatorieTranzit],
                      oferta.durataAsigurare, taraDestinatie, sumaAsigurata, scopCalatorie, (listAsigurati.count == 1 ? @"individual" : @"grup"), [YTOPersoana getJsonPersoane:listAsigurati], pers1.judet, pers1.localitate,
                      [[UIDevice currentDevice].model stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
    return xml;
}

- (IBAction)calculeazaRCADupaAltaDurata
{
    [self calculCalatorie];
}

- (void) calculCalatorie {
    [vwLoading setHidden:NO];
    [self startLoadingAnimantion];
    
	NSURL * url = [NSURL URLWithString:@"http://192.168.1.176:8082/travel.asmx"];
	//NSURL * url = [NSURL URLWithString:@"https://api.i-business.ro/MaAsigurApiTest/travel.asmx"];
    
	NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
															cachePolicy:NSURLRequestUseProtocolCachePolicy
														timeoutInterval:10.0];
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
	
	//to do parseXML
	NSXMLParser * xmlParser = [[NSXMLParser alloc] initWithData:responseData];
	xmlParser.delegate = self;
	BOOL succes = [xmlParser parse];
	
    if (succes) {
        [vwLoading setHidden:YES];
        [self stopLoadingAnimantion];
        [tableView reloadData];
    }
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"connection:didFailWithError:");
	NSLog(@"%@", [error localizedDescription]);

    [self showPopupWithTitle:@"Atentie!" andDescription:[NSString stringWithFormat:@"%@", [error localizedDescription]]];
    
//	UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Atentie!" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//	[alertView show];
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
    return 94;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"%d %@, %d zile in %@", listAsigurati.count, (listAsigurati.count == 1 ? @"asigurare" : @"asigurari"), oferta.durataAsigurare, taraDestinatie];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
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

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

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

@end
