//
//  YTOWebServiceRCAViewController.m
//  i-asigurare
//
//  Created by Andi Aparaschivei on 7/20/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
//

#import "YTOWebServiceRCAViewController.h"
#import "YTOAppDelegate.h"
#import "YTOSumarRCAViewController.h"
#import "YTOUtils.h"
#import "VerifyNet.h"
#import "YTOCalculatorViewController.h"

@interface YTOWebServiceRCAViewController ()

@end

@implementation YTOWebServiceRCAViewController

@synthesize responseData, cotatie, masina, asigurat, oferta;

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
	[self calculRCA];
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
    
    NSString * xml = [NSString stringWithFormat:
                      @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                      "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                      "<soap:Body>"
                      "<CalculRca4 xmlns=\"http://tempuri.org/\">"
                      "<user>vreaurca</user>"
                      "<password>123</password>"
                      "<nume>%@</nume>"
                      "<cnp>%@</cnp>"
                      "<telefon>%@</telefon>"
                      "<email>%@</email>"
                      "<strada>%@</strada>"
                      "<judet>%@</judet>"
                      "<marca>%@</marca>"
                      "<model>%@</model>"
                      "<nr_inmatriculare>%@</nr_inmatriculare>"
                      "<serie_sasiu>%@</serie_sasiu>"
                      "<casco>%@</casco>"
                      "<localitate>%@</localitate>"                      
                      "<data_permis>%@</data_permis>"
                      "<auto_nou>%@</auto_nou>"
                      "<marca_id>%d</marca_id>"
                      "<cm3>%d</cm3>"
                      "<kw>%d</kw>"
                      "<combustibil>%@</combustibil>"
                      "<nr_locuri>%d</nr_locuri>"
                      "<masa_maxima>%d</masa_maxima>"
                      "<an_fabricatie>%d</an_fabricatie>"
                      "<destinatie_auto>%@</destinatie_auto>"
                      "<tip_persoana>%@</tip_persoana>"
                      "<cui>%@</cui>"
                      "<denumire_pj>%@</denumire_pj>"
                      "<nr_daune_ultim_an>%d</nr_daune_ultim_an>"
                      "<ani_fara_daune>%d</ani_fara_daune>"
                      "<durata_asigurare>%d</durata_asigurare>"
                      "<data_inceput_rca>%@</data_inceput_rca>"
                      "<udid>%@</udid>"
                      "<id_intern>%@</id_intern>"
                      "<platforma>%@</platforma>"
                      "<tip_inregistrare>inmatriculat</tip_inregistrare>"
                      "<caen>%@</caen>"
                      "<subtip_activitate>altele</subtip_activitate>"
                      "<index_categorie_auto>%d</index_categorie_auto>"
                      "<subcategorie_auto>%@</subcategorie_auto>"
                      "<in_leasing>nu</in_leasing>"
                      "<serie_civ>%@</serie_civ>"
                      "<casatorit>%@</casatorit>"
                      "<copii_minori>%@</copii_minori>"
                      "<pensionar>%@</pensionar>"
                      "<nr_bugetari>%@</nr_bugetari>"
                      "</CalculRca4>"
                      "</soap:Body>"
                      "</soap:Envelope>",
                      asigurat.nume, asigurat.codUnic, 
                      asigurat.telefon, asigurat.email, asigurat.adresa,
                      masina.judet,                     
                      masina.marcaAuto, 
                      masina.modelAuto, 
                      masina.nrInmatriculare, 
                      masina.serieSasiu,
                      masina.cascoLa,
                      masina.localitate, 
                      asigurat.dataPermis,
                      ([masina.nrInmatriculare isEqualToString:@"-"] ? @"1" : @"0"),
                      0, 
                      masina.cm3, 
                      masina.putere, 
                      masina.combustibil,
                      masina.nrLocuri, 
                      masina.masaMaxima, 
                      masina.anFabricatie, 
                      masina.destinatieAuto,
                      asigurat.tipPersoana, 
                      ([asigurat.tipPersoana isEqualToString:@"juridica"] ? asigurat.codUnic : @""), // cui 
                      ([asigurat.tipPersoana isEqualToString:@"juridica"] ? asigurat.nume : @""), //denumire pj 
                      0 ,  // self.NrDauneUltimAn, 
                      0,  // self.AniFaraDaune, 
                      oferta.durataAsigurare,
                      [formatter stringFromDate:oferta.dataInceput],
                      [[UIDevice currentDevice] uniqueIdentifier],
                      masina.idIntern,
                      [[UIDevice currentDevice].model stringByReplacingOccurrencesOfString:@" " withString:@"_"],
                      ([asigurat.tipPersoana isEqualToString:@"juridica"] ? asigurat.codCaen : @"01"),
                      masina.categorieAuto,
                      masina.subcategorieAuto,
                      masina.serieCiv,
                      asigurat.casatorit,
                      asigurat.copiiMinori,
                      asigurat.pensionar,
                      asigurat.nrBugetari
                      ];
    return xml;
}

- (IBAction)calculeazaRCADupaAltaDurata
{
//    if (oferta.durataAsigurare == 6)
//    {
//        oferta.durataAsigurare = 12;
//    }
//    else
//    {
//        oferta.durataAsigurare = 6;
//    }
    
    oferta.durataAsigurare = (oferta.durataAsigurare == 6 ? 12 : 6);

    if (oferta.durataAsigurare == 6 && responseCalcul6Luni != nil)
    {
        [self parseRcaResponse:responseCalcul6Luni];
        
        imgDurata.image = [UIImage imageNamed:@"selectat-stanga-masina.png"];
        lbl12Luni.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lbl6Luni.textColor = [UIColor whiteColor];
    }
    else if (oferta.durataAsigurare == 12 && responseCalcul12Luni != nil)
    {
        [self parseRcaResponse:responseCalcul12Luni];
        
        imgDurata.image = [UIImage imageNamed:@"selectat-dreapta-masina.png"];
        lbl6Luni.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lbl12Luni.textColor = [UIColor whiteColor];
    }
    else
        [self calculRCA];
}

- (void) calculRCA {
    self.navigationItem.hidesBackButton = YES;
    
    if (oferta.durataAsigurare == 6)
    {
        imgDurata.image = [UIImage imageNamed:@"selectat-stanga-masina.png"];
        lbl12Luni.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lbl6Luni.textColor = [UIColor whiteColor];
    }
    else
    {
        imgDurata.image = [UIImage imageNamed:@"selectat-dreapta-masina.png"];
        lbl6Luni.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lbl12Luni.textColor = [UIColor whiteColor];
    }
    
    VerifyNet * vn = [[VerifyNet alloc] init];
    if ([vn hasConnectivity]) {
        
        [vwLoading setHidden:NO];
        [self startLoadingAnimantion];
        
	NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@rca.asmx", LinkAPI]];
    
	NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
															cachePolicy:NSURLRequestUseProtocolCachePolicy
														timeoutInterval:30.0];
    
	NSString * parameters = [[NSString alloc] initWithString:[self XmlRequest]];
	NSLog(@"Request=%@", parameters);
	NSString * msgLength = [NSString stringWithFormat:@"%d", [parameters length]];
	
	[request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[request addValue:@"http://tempuri.org/CalculRca4" forHTTPHeaderField:@"SOAPAction"];
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
    
    if (oferta.durataAsigurare == 6)
        responseCalcul6Luni = responseData;
    else
        responseCalcul12Luni = responseData;
    
	NSLog(@"Response string: %@", responseString);
	
	[self parseRcaResponse:responseData];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"connection:didFailWithError:");
	NSLog(@"%@", [error localizedDescription]);
	
//	UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Atentie!" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//	[alertView show];

    //[self showPopupWithTitle:@"Atentie" andDescription:[error localizedDescription]];
    
    vwErrorAlert.hidden = NO;
    
//    YTOCustomPopup * alert = [[YTOCustomPopup alloc] initWithNibName:@"YTOCustomPopupView" bundle:nil];
//    alert.delegate = self;
//    [alert showAlert:@"Atentie" withMessage:[error localizedDescription] andImage:[UIImage imageNamed:@"comanda-eroare.png"] delegate:self];
}

- (void) parseRcaResponse:(NSMutableData *) response
{
	NSXMLParser * xmlParser = [[NSXMLParser alloc] initWithData:response];
	xmlParser.delegate = self;
	BOOL succes = [xmlParser parse];
	//cotatie.eroare_ws = @"xx";
    if (succes && cotatie != nil && cotatie.eroare_ws != nil && cotatie.eroare_ws.length > 0) {
        NSLog(@"Error = %@", cotatie.eroare_ws);
        //    		UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Atentie!" message:[NSString stringWithFormat:@"%@", cotatie.eroare_ws] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //    		[alertView show];
        
        //[self showPopupWithTitle:@"Atentie!" andDescription:[NSString stringWithFormat:@"%@", cotatie.eroare_ws]];
        
        //            YTOCustomPopup * alert = [[YTOCustomPopup alloc] init];
        //            [alert showAlert:@"Atentie" withMessage:[NSString stringWithFormat:@"%@", cotatie.eroare_ws] andImage:[UIImage imageNamed:@"comanda-eroare.png"] delegate:self];
        vwErrorAlert.hidden = NO;
    }
    else if (succes && cotatie != nil) {
        
        listTarife = [[NSMutableArray alloc] init];
        
        NSString * errorMsgs;
        
        
        if ([cotatie.Astra_status_response isEqualToString:@"true"]) {
            TarifRCA * tarif0 = [[TarifRCA alloc] init];
            tarif0.idCompanie = 4;
            tarif0.nume = @"Astra";
            tarif0.codOferta = cotatie.Astra_cod_oferta;
            tarif0.prima = (cotatie.Astra_prima != nil ? cotatie.Astra_prima : @"0");
            tarif0.clasa_bm = cotatie.Astra_clasa_bm;
            
            if ([tarif0.prima intValue] > 0)
                [listTarife addObject:tarif0];
        }
        else [errorMsgs stringByAppendingString:[NSString stringWithFormat:@"- %@\n", cotatie.Astra_mesaj_eroare]];
        //else errorMsgs = [NSString stringWithFormat:@"- %@\n", cotatie.Astra_mesaj_eroare];
        
        
        if ([cotatie.Allianz_status_response isEqualToString:@"true"]) {
            TarifRCA * tarif1 = [[TarifRCA alloc] init];
            tarif1.idCompanie = 5;
            tarif1.nume = @"Allianz";
            tarif1.codOferta = cotatie.Allianz_cod_oferta;
            tarif1.prima = (cotatie.Allianz_prima != nil ? cotatie.Allianz_prima : @"0");
            tarif1.clasa_bm = cotatie.Allianz_clasa_bm;
            
            if ([tarif1.prima intValue] > 0)
                [listTarife addObject:tarif1];
        }
        else [errorMsgs stringByAppendingString:[NSString stringWithFormat:@"- %@\n", cotatie.Allianz_mesaj_eroare]];
        
        if ([cotatie.Omniasig_status_response isEqualToString:@"true"]) {
            TarifRCA * tarif2 = [[TarifRCA alloc] init];
            tarif2.idCompanie = 6;
            tarif2.nume = @"Omniasig";
            tarif2.codOferta = cotatie.Omniasig_cod_oferta;
            tarif2.prima = (cotatie.Omniasig_prima != nil ? cotatie.Omniasig_prima : @"0");
            tarif2.clasa_bm = cotatie.Omniasig_clasa_bm;
            
            if ([tarif2.prima intValue] > 0)
                [listTarife addObject:tarif2];
        }
        else [errorMsgs stringByAppendingString:[NSString stringWithFormat:@"- %@\n", cotatie.Omniasig_mesaj_eroare]];
        
        if ([cotatie.Groupama_status_response isEqualToString:@"true"]) {
            TarifRCA * tarif3 = [[TarifRCA alloc] init];
            tarif3.idCompanie = 7;
            tarif3.nume = @"Groupama";
            tarif3.codOferta = cotatie.Groupama_cod_oferta;
            tarif3.prima = (cotatie.Groupama_prima != nil ? cotatie.Groupama_prima : @"0");
            tarif3.clasa_bm = cotatie.Groupama_clasa_bm;
            
            if ([tarif3.prima intValue] > 0)
                [listTarife addObject:tarif3];
        }
        else [errorMsgs stringByAppendingString:[NSString stringWithFormat:@"- %@\n", cotatie.Groupama_mesaj_eroare]];
        
        if ([cotatie.BCR_status_response isEqualToString:@"true"]) {
            TarifRCA * tarif4 = [[TarifRCA alloc] init];
            tarif4.idCompanie = 8;
            tarif4.nume = @"BCR";
            tarif4.codOferta = cotatie.BCR_cod_oferta;
            tarif4.prima = (cotatie.BCR_prima != nil ? cotatie.BCR_prima : @"0");
            tarif4.clasa_bm = cotatie.BCR_clasa_bm;
           
            if ([tarif4.prima intValue] > 0)
                [listTarife addObject:tarif4];
        }
        else [errorMsgs stringByAppendingString:[NSString stringWithFormat:@"- %@\n", cotatie.BCR_mesaj_eroare]];
        
        if ([cotatie.Asirom_status_response isEqualToString:@"true"]) {
            TarifRCA * tarif5 = [[TarifRCA alloc] init];
            tarif5.idCompanie = 9;
            tarif5.nume = @"Asirom";
            tarif5.codOferta = cotatie.Asirom_cod_oferta;
            tarif5.prima = (cotatie.Asirom_prima != nil ? cotatie.Asirom_prima : @"0");
            tarif5.clasa_bm = cotatie.Asirom_clasa_bm;

            if ([tarif5.prima intValue] > 0)
                [listTarife addObject:tarif5];
        }
        else [errorMsgs stringByAppendingString:[NSString stringWithFormat:@"- %@\n", cotatie.Asirom_mesaj_eroare]];
        
        if ([cotatie.Uniqa_status_response isEqualToString:@"true"]) {
            TarifRCA * tarif6 = [[TarifRCA alloc] init];
            tarif6.idCompanie = 10;
            tarif6.nume = @"Uniqa";
            tarif6.codOferta = cotatie.Uniqa_cod_oferta;
            tarif6.prima = (cotatie.Uniqa_prima != nil ? cotatie.Uniqa_prima : @"0");
            tarif6.clasa_bm = cotatie.Uniqa_clasa_bm;
            
            if ([tarif6.prima intValue] > 0)
                [listTarife addObject:tarif6];
        }
        else [errorMsgs stringByAppendingString:[NSString stringWithFormat:@"- %@\n", cotatie.Uniqa_mesaj_eroare]];
        
        if ([cotatie.Generali_status_response isEqualToString:@"true"]) {
            TarifRCA * tarif7 = [[TarifRCA alloc] init];
            tarif7.idCompanie = 11;
            tarif7.nume = @"Generali";
            tarif7.codOferta = cotatie.Generali_cod_oferta;
            tarif7.prima = (cotatie.Generali_prima != nil ? cotatie.Generali_prima : @"0");
            tarif7.clasa_bm = cotatie.Generali_clasa_bm;

            if ([tarif7.prima intValue] > 0)
                [listTarife addObject:tarif7];
        }
        else [errorMsgs stringByAppendingString:[NSString stringWithFormat:@"- %@\n", cotatie.Generali_mesaj_eroare]];
        
        if ([cotatie.Euroins_status_response isEqualToString:@"true"]) {
            TarifRCA * tarif8 = [[TarifRCA alloc] init];
            tarif8.idCompanie = 12;
            tarif8.nume = @"Euroins";
            tarif8.codOferta = cotatie.Euroins_cod_oferta;
            tarif8.prima = (cotatie.Euroins_prima != nil ? cotatie.Euroins_prima : @"0");
            tarif8.clasa_bm = cotatie.Euroins_clasa_bm;
            
            if ([tarif8.prima intValue] > 0)
                [listTarife addObject:tarif8];
        }
        else [errorMsgs stringByAppendingString:[NSString stringWithFormat:@"- %@\n", cotatie.Euroins_mesaj_eroare]];
        
        if ([cotatie.Carpatica_status_response isEqualToString:@"true"]) {
            TarifRCA * tarif9 = [[TarifRCA alloc] init];
            tarif9.idCompanie = 13;
            tarif9.nume = @"Carpatica";
            tarif9.codOferta = cotatie.Carpatica_cod_oferta;
            tarif9.prima = (cotatie.Carpatica_prima != nil ? cotatie.Carpatica_prima : @"0");
            tarif9.clasa_bm = cotatie.Carpatica_clasa_bm;
            
            if ([tarif9.prima intValue] > 0)
                [listTarife addObject:tarif9];
        }
        else [errorMsgs stringByAppendingString:[NSString stringWithFormat:@"- %@\n", cotatie.Carpatica_mesaj_eroare]];
        
        if ([cotatie.Ardaf_status_response isEqualToString:@"true"]) {
            TarifRCA * tarif11 = [[TarifRCA alloc] init];
            tarif11.idCompanie = 14;
            tarif11.nume = @"Ardaf";
            tarif11.codOferta = cotatie.Ardaf_cod_oferta;
            tarif11.prima = (cotatie.Ardaf_prima != nil ? cotatie.Ardaf_prima : @"0");
            tarif11.clasa_bm = cotatie.Ardaf_clasa_bm;
            
            if ([tarif11.prima intValue] > 0)
                [listTarife addObject:tarif11];
        }
        else [errorMsgs stringByAppendingString:[NSString stringWithFormat:@"- %@\n", cotatie.Ardaf_mesaj_eroare]];
        
        if ([cotatie.City_status_response isEqualToString:@"true"]) {
            TarifRCA * tarif12 = [[TarifRCA alloc] init];
            tarif12.idCompanie = 15;
            tarif12.nume = @"City";
            tarif12.codOferta = cotatie.City_cod_oferta;
            tarif12.prima = (cotatie.City_prima != nil ? cotatie.City_prima : @"0");
            tarif12.clasa_bm = cotatie.City_clasa_bm;
            
            if ([tarif12.prima intValue] > 0)
                [listTarife addObject:tarif12];
        }
        else [errorMsgs stringByAppendingString:[NSString stringWithFormat:@"- %@\n", cotatie.Ardaf_mesaj_eroare]];
        
        NSSortDescriptor * sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"primaInt" ascending:YES];
        
        NSMutableArray * sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        [listTarife sortUsingDescriptors:sortDescriptors];
        
        [vwLoading setHidden:YES];
        [self stopLoadingAnimantion];
        self.navigationItem.hidesBackButton = NO;
        
        if (listTarife.count == 0)
        {
            //[self showPopupWithTitle:@"Atentie" andDescription:@"Serverul companiilor de asigurare nu afiseaza tarifele. Te rugam sa verifici ca datele introduse sunt complete si corecte si apoi sa refaci calculatia."];
            vwErrorAlert.hidden = NO;
        }
        else
            [tableView reloadData];
        
    }
}

#pragma mark NSXMLParser Methods
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
	attributes:(NSDictionary *)attributeDict {
	
	if ([elementName isEqualToString:@"return"]) {
		cotatie = [[CotatieRCA alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if (![elementName isEqualToString:@"return"] && ![elementName isEqualToString:@"ns1:calcul_prima_rcaResponse"]
		&& ![elementName isEqualToString:@"SOAP-ENV:Body"]
		&& ![elementName isEqualToString:@"SOAP-ENV:Envelope"]) {
		
		//TarifRCA * tarif = [[TarifRCA alloc] init];
		if (cotatie == nil)
			cotatie = [[CotatieRCA alloc] init];
		
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
    return 55;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listTarife.count;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    TarifRCA * tarif = (TarifRCA *)[listTarife objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", [tarif.nume lowercaseString]]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ lei", tarif.prima];
    cell.textLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:16];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Clasa B/M: %@", tarif.clasa_bm];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Arial" size:14];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"adauga-in-cos.png"]];
    cell.accessoryView = imageView;
    UILabel * lbl = [[UILabel alloc] initWithFrame:CGRectMake(32, 0, 80, 40)];
    lbl.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:12];
    [lbl setText:@"Adauga in cos"];
    [lbl setNumberOfLines:2];
    [lbl setTextAlignment:UITextAlignmentCenter];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setTextColor:[UIColor whiteColor]];
    [cell.accessoryView addSubview:lbl];
    
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
    TarifRCA * tarif = [listTarife objectAtIndex:indexPath.row];
    oferta.prima = tarif.primaInt;
    oferta.companie = tarif.nume;
    oferta.dataSfarsit = [YTOUtils getDataSfarsitPolita:oferta.dataInceput andDurataInLuni:oferta.durataAsigurare];
    oferta.numeAsigurare = [NSString stringWithFormat:@"RCA, %@", masina.nrInmatriculare];
    oferta.moneda = @"RON";
    oferta.codOferta = tarif.codOferta;
    [oferta setRCABonusMalus:tarif.clasa_bm];
    
    YTOSumarRCAViewController * aView = [[YTOSumarRCAViewController alloc] init];
    aView.masina = masina;
    aView.asigurat = asigurat;
    aView.oferta = oferta;
    
    YTOAppDelegate * delegate =  (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate.rcaNavigationController pushViewController:aView animated:YES];
}

- (void) startLoadingAnimantion
{
    NSArray * imgs = [NSArray arrayWithObjects: [UIImage imageNamed:@"loading-rca1.png"], [UIImage imageNamed:@"loading-rca2.png"],[UIImage imageNamed:@"loading-rca3.png"],[UIImage imageNamed:@"loading-rca4.png"],[UIImage imageNamed:@""], nil];
    
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

//- (void) showPopupWithTitle:(NSString *)title andDescription:(NSString *)description
//{
//    [self stopLoadingAnimantion];
//    //[vwPopup setHidden:NO];
//    [vwErrorAlert setHidden:NO];
//    //lblPopupDescription.text = description;
//    //lblPopupTitle.text = title;
//}

//- (IBAction)hidePopup:(id)sender
//{
//    [vwPopup setHidden:YES];
//    YTOAppDelegate * delegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
//    [delegate.rcaNavigationController popViewControllerAnimated:YES];
//}

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
