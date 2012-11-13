//
//  YTOWebServiceLocuintaViewController.m
//  i-asigurare
//
//  Created by Administrator on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YTOWebServiceLocuintaViewController.h"
#import "YTOSumarLocuintaViewController.h"

@interface YTOWebServiceLocuintaViewController ()

@end

@implementation YTOWebServiceLocuintaViewController

@synthesize responseData, listTarife, oferta;
@synthesize locuinta, asigurat;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Produse asigurare", @"Produse asigurare");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    listTarife = [[NSMutableArray alloc] init];
	[self calculLocuinta];
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

#pragma mark Consume WebService

- (NSString *) XmlRequest
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSString * xml = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                      "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                      "<soap:Body>"
                      "<CallCalculLocuinta xmlns=\"http://tempuri.org/\">"
                      "<user>vreaurca</user>"
                      "<password>123</password>"
                      "<id_intern>%@</id_intern>"
                      "<nume_asigurat>%@</nume_asigurat>"
                      "<cod_unic>%@</cod_unic>"
                      "<telefon>%@</telefon>"
                      "<email>%@</email>"
                      "<data_inceput>%@</data_inceput>"
                      "<durata_asigurare>12</durata_asigurare>"
                      "<moneda>%@</moneda>"
                      "<numar_rate>1</numar_rate>"
                      "<asigurat_paid>neasigurat</asigurat_paid>"
                      "<nr_polita_paid></nr_polita_paid>"
                      "<limita_paid></limita_paid>"
                      "<asigurat_locuinta>neasigurat</asigurat_locuinta>"
                      "<nr_polita_incendiu></nr_polita_incendiu>"
                      "<tip_persoana>%@</tip_persoana>"
                      "<calitate_asigurat>proprietar</calitate_asigurat>"
                      "<pensionar>nu</pensionar>"
                      "<grad_handicap>nu</grad_handicap>"
                      "<judet>%@</judet>"
                      "<localitate>%@</localitate>"
                      "<tip_strada>Strada</tip_strada>"
                      "<strada>%@</strada>"
                      "<nr_strada>2</nr_strada>"
                      "<cod_strada>021177</cod_strada>"
                      "<etaj>2</etaj>"
                      "<bloc>A</bloc>"
                      "<scara>A</scara>"
                      "<apartament>12</apartament>"
                      "<mod_evaluare>%@</mod_evaluare>"
                      "<sa_locuinta>%d</sa_locuinta>"
                      "<sa_bunuri_generale>0</sa_bunuri_generale>"
                      "<sa_bunuri_de_valoare>0</sa_bunuri_de_valoare>"
                      "<sa_raspundere_civila>%d</sa_raspundere_civila>"
                      "<sa_spargere_geamuri>0</sa_spargere_geamuri>"
                      "<sa_centrala_termica>0</sa_centrala_termica>"
                      "<tip_geam>termopan</tip_geam>"
                      "<vechime_centrala>0</vechime_centrala>"
                      "<clauza_furt_bunuri>nu</clauza_furt_bunuri>"
                      "<clauza_apa_conducta>nu</clauza_apa_conducta>"
                      "<tip_cladire>%@</tip_cladire>"
                      "<structura_rezistenta>%@</structura_rezistenta>"
                      "<regim_inaltime>%d</regim_inaltime>"
                      "<nr_camere>%d</nr_camere>"
                      "<an_constructie>%d</an_constructie>"
                      "<suprafata_utila>%d</suprafata_utila>"
                      "<nr_locatari>%d</nr_locatari>"
                      "<are_teren>nu</are_teren>"
                      "<alarma>nu</alarma>"
                      "<detectie_incendiu>da</detectie_incendiu>"
                      "<grilaje_geam>nu</grilaje_geam>"
                      "<paza>da</paza>"
                      "<locuit_permanent>da</locuit_permanent>"
                      "<zona_izolata>nu</zona_izolata>"
                      "<udid>%@</udid>"
                      "<platforma>%@</platforma>"
                      "</CallCalculLocuinta>"
                      "</soap:Body>"
                      "</soap:Envelope>",
                      locuinta.idIntern, asigurat.nume, asigurat.codUnic, asigurat.telefon, asigurat.email,
                      [formatter stringFromDate:oferta.dataInceput],oferta.moneda,
                      asigurat.tipPersoana,
                      locuinta.judet, locuinta.localitate, asigurat.adresa, locuinta.modEvaluare,
                      locuinta.sumaAsigurata, locuinta.sumaAsigurataRC, locuinta.tipLocuinta, locuinta.structuraLocuinta,
                      locuinta.regimInaltime, locuinta.nrCamere, locuinta.anConstructie, locuinta.suprafataUtila,
                      locuinta.nrLocatari,
                      [[UIDevice currentDevice] uniqueIdentifier],
                      [[UIDevice currentDevice].model stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
    return xml;
}

- (IBAction)calculeazaRCADupaAltaDurata
{
//    if (oferta.durataAsigurare == 6)
//        oferta.durataAsigurare = 12;
//    else
//        oferta.durataAsigurare = 6;
    
    [self calculLocuinta];
}

- (void) calculLocuinta {
    [vwLoading setHidden:NO];
    [self startLoadingAnimantion];
    
//    NSString * btnText;
//    if (oferta.durataAsigurare == 6)
//        btnText = @"Vezi si tarifele pe 12 luni";
//    else
//        btnText = @"Vezi si tarifele pe 6 luni";        
    
    //[btnTarif setTitle:btnText forState:UIControlStateNormal];
    
    
	//NSURL * url = [NSURL URLWithString:@"http://192.168.1.176:8082/locuinta.asmx"];
	NSURL * url = [NSURL URLWithString:@"https://api.i-business.ro/MaAsigurApiTest/locuinta.asmx"];
    
	NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
															cachePolicy:NSURLRequestUseProtocolCachePolicy
														timeoutInterval:10.0];
    //	
    //	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //	formatter.dateFormat = @"yyyy-MM-dd";
    //	NSDate * dataRca = [formatter dateFromString:setari.DataInceputRCA];
    //	
    //	NSString * data_inceput;
    //	if ([dataRca compare:[[NSDate date] dateByAddingTimeInterval:86400]] == NSOrderedDescending)
    //		data_inceput = setari.DataInceputRCA;
    //	else {
    //		data_inceput = [formatter stringFromDate:[[NSDate date] dateByAddingTimeInterval:86400]];
    //		setari.DataInceputRCA = data_inceput;
    //	}
    //	[appDelegate salveazaSetari];
	
	NSString * parameters = [[NSString alloc] initWithString:[self XmlRequest]];
	NSLog(@"Request=%@", parameters);
	NSString * msgLength = [NSString stringWithFormat:@"%d", [parameters length]];
	
	[request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[request addValue:@"http://tempuri.org/CallCalculLocuinta" forHTTPHeaderField:@"SOAPAction"];
	[request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
	
	//[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	
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
	
    //NSString * responseString = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
	//NSLog(@"Response string: %@", responseString);
    
	//to do parseXML
	NSXMLParser * xmlParser = [[NSXMLParser alloc] initWithData:responseData];
	xmlParser.delegate = self;
	BOOL succes = [xmlParser parse];

	if (succes)
    {
        NSError * err = nil;
        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        
        for(NSDictionary *item in jsonArray) {
            cotatie = [[CotatieLocuinta alloc] init];
            NSString * eroare_ws = [item objectForKey:@"Eroare_ws"];
            if (eroare_ws && ![eroare_ws isEqualToString:@"success"])
            {
                NSLog(@"%@",eroare_ws);
                // to do popup generic
                [vwLoading setHidden:YES];
                [self stopLoadingAnimantion];
                return;
            }
            cotatie.cod = [item objectForKey:@"Cod"];
            cotatie.prima = [item objectForKey:@"Prima"];
            cotatie.companie = [item objectForKey:@"Companie"];
            cotatie.sumaAsigurata = [item objectForKey:@"SumaAsigurata"];
            cotatie.moneda = [item objectForKey:@"Moneda"];
            cotatie.fransiza = [item objectForKey:@"Fransiza"];
            cotatie.tipProdus = [item objectForKey:@"TipProdus"];
            cotatie.saBunuriValoare = [item objectForKey:@"SABunuriValoare"];
            cotatie.saBunuriGenerale = [item objectForKey:@"SABunuriGenerale"];
            cotatie.saRaspundere = [item objectForKey:@"SARaspundere"];
            cotatie.riscFurt = [item objectForKey:@"RiscFurt"];
            cotatie.riscApaConducta = [item objectForKey:@"RiscApaConducta"];
            cotatie.linkConditii = [item objectForKey:@"LinkConditii"];
            
            [listTarife addObject:cotatie];
        }
    }
    //if (succes) {
        [vwLoading setHidden:YES];
        [self stopLoadingAnimantion];
        [tableView reloadData];
    //}
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"connection:didFailWithError:");
	NSLog(@"%@", [error localizedDescription]);
	
	UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Atentie!" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
}



#pragma mark NSXMLParser Methods
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName 
	attributes:(NSDictionary *)attributeDict {
	
	if ([elementName isEqualToString:@"ResponsePrima"]) {
	//	cotatie = [[CotatieCalatorie alloc] init];
    //    [listTarife addObject:cotatie];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if (![elementName isEqualToString:@"CallCalculLocuintaResponse"] 
        && ![elementName isEqualToString:@"soap:Envelope"]
        && ![elementName isEqualToString:@"soap:Body"]
        && ![elementName isEqualToString:@"ns1:calcul_prima_incendiuResponse"]
        && ![elementName isEqualToString:@"return"]) {
		
		//TarifRCA * tarif = [[TarifRCA alloc] init];
	//	if (cotatie == nil) {
	//		cotatie = [[CotatieCalatorie alloc] init];
    //   }
		jsonString = currentElementValue;
		NSLog(@"%@=%@\n", elementName, currentElementValue);
	//	if ([cotatie respondsToSelector:NSSelectorFromString(elementName)])
	//		[cotatie setValue:currentElementValue forKey:elementName];
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
    return @"Produse asigurare locuinta";
//    return [NSString stringWithFormat:@"%d %@, %d zile in %@", listAsigurati.count, (listAsigurati.count == 1 ? @"asigurare" : @"asigurari"), 5, @"Turcia"];
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
        cell = [[CellTarifCustom alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier forLocuinta:YES];
    }
    
    CotatieLocuinta * c = (CotatieLocuinta *)[listTarife objectAtIndex:indexPath.row];

    [cell setLogo:[NSString stringWithFormat:@"%@.jpg", [c.companie lowercaseString]]];
    [cell setPrima:[NSString stringWithFormat:@"%.2f  %@", [c.prima floatValue], [oferta.moneda uppercaseString]]];
    [cell setCol1:c.fransiza andLabel:@"Fransiza"];
    [cell setCol2:c.riscApaConducta andLabel:@"Acop. apa conducta"];
    [cell setCol3:c.riscFurt andLabel:@"Acop. furt"];
    [cell setCol4:c.saRaspundere andLabel:@"Rasp. civila"];
    
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
    
    CotatieLocuinta * _cotatie = [listTarife objectAtIndex:btn.tag];
    
    oferta.companie = _cotatie.companie;
    oferta.prima = [_cotatie.prima floatValue];
    oferta.codOferta = _cotatie.cod;
    oferta.durataAsigurare = 12;

    [oferta setLocuintaSA:_cotatie.sumaAsigurata];
    [oferta setLocuintaFransiza:_cotatie.fransiza];
    [oferta setLocuintaTipProdus:_cotatie.tipProdus];
    [oferta setLocuintaSABunuriValoare:_cotatie.saBunuriValoare];
    [oferta setLocuintaSABunuriGenerale:_cotatie.saBunuriGenerale];
    [oferta setLocuintaSARaspundere:_cotatie.saRaspundere];
    [oferta setLocuintaRiscFurt:_cotatie.riscFurt];
    [oferta setLocuintaRiscApa:_cotatie.riscApaConducta];
    [oferta setLocuintaConditii:_cotatie.linkConditii];
    
    YTOSumarLocuintaViewController * aView = [[YTOSumarLocuintaViewController alloc] init];
    aView.oferta = oferta;
    aView.cotatie = _cotatie;
    aView.asigurat = asigurat;
    aView.locuinta = locuinta;
    
    YTOAppDelegate * delegate =  (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate.rcaNavigationController pushViewController:aView animated:YES];
}


- (void) startLoadingAnimantion
{
    NSArray * imgs = [NSArray arrayWithObjects: [UIImage imageNamed:@"loading-locuinta1.png"], [UIImage imageNamed:@"loading-locuinta2.png"],[UIImage imageNamed:@"loading-locuinta3.png"],[UIImage imageNamed:@"loading-locuinta4.png"],[UIImage imageNamed:@""], nil];
    
    imgLoading.animationDuration = 1.5;
    imgLoading.animationRepeatCount = 0;
    imgLoading.animationImages = imgs;
    [imgLoading startAnimating];
}

- (void) stopLoadingAnimantion
{
    [imgLoading stopAnimating];    
}
@end
