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
#import "YTOUserDefaults.h"
#import "CellTarifRCARedus.h"
#import "UILabel+dynamicSizeMe.h"
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
    //self.trackedViewName = @"YTOWebServiceViewController";
    B0Closed = NO;
    [YTOUtils rightImageVodafone:self.navigationItem];
	[self calculRCA];
    lblDetaliiEroare.text = NSLocalizedStringFromTable(@"i580", [YTOUserDefaults getLanguage],@"detalii");
    lblTarifeleNu.text = NSLocalizedStringFromTable(@"i579", [YTOUserDefaults getLanguage],@"nu s-au calculat");
    lbl6Luni.text = NSLocalizedStringFromTable(@"i196", [YTOUserDefaults getLanguage],@"6 luni");
    lbl12Luni.text =NSLocalizedStringFromTable(@"i197", [YTOUserDefaults getLanguage],@"12 luni");
    lblB01.text = NSLocalizedStringFromTable(@"i582", [YTOUserDefaults getLanguage],@"ai obtinut b0");
    lblB02.text =NSLocalizedStringFromTable(@"i583", [YTOUserDefaults getLanguage],@"cauze");
    lblB04.text =NSLocalizedStringFromTable(@"i584", [YTOUserDefaults getLanguage],@"tarife mai mari ");
    lblB03.text = NSLocalizedStringFromTable(@"i221", [YTOUserDefaults getLanguage],@"cauzele");
    
//    lblB01.resizeToFit;
//    lblB02.resizeToFit;
//    lblB03.resizeToFit;
//    lblB04.resizeToFit;
    
    lblCauze1.text = NSLocalizedStringFromTable(@"i585", [YTOUserDefaults getLanguage],@"cauzele");
    lblCauze2.text = NSLocalizedStringFromTable(@"i586", [YTOUserDefaults getLanguage],@"cauzele");
    lblCauze3.text = NSLocalizedStringFromTable(@"i587", [YTOUserDefaults getLanguage],@"cauzele");
    lblCauze4.text = NSLocalizedStringFromTable(@"i588", [YTOUserDefaults getLanguage],@"cauzele");
    
    lblLoad0.text = NSLocalizedStringFromTable(@"i176", [YTOUserDefaults getLanguage],@"Cautam \n cele mai mici tarife \n direct \n de la companiile \n de asigurare");
    lblLoad1.text = NSLocalizedStringFromTable(@"i73", [YTOUserDefaults getLanguage],@"Tarifele sunt obtinute direct de la companiile de asigurare.");
    lblLoad2.text = NSLocalizedStringFromTable(@"i91", [YTOUserDefaults getLanguage],@"Polita de asigurare RCA se livreaza GRATUIT prin curier rapid.");
//    if ([YTOUserDefaults isRedus]){
//        lblLoad2.hidden = YES;
//        imgArrow.hidden = YES;
//    }
    
    lblNointernet.text = NSLocalizedStringFromTable(@"i219", [YTOUserDefaults getLanguage],@"Ne pare rau!\nTarifele nu s-au calculat pentru ca nu esti conectat la internet.\n Te rugam sa te asiguri ca ai o conexiune la internet activa si calculeaza din nou.\nIti multumim!");
    
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
    
    NSString *img = @"header-tarife-rca.png";
    if ([[YTOUserDefaults getLanguage] isEqualToString:@"hu"])
        img = @"header-tarife-rca-hu.png";
    else if ([[YTOUserDefaults getLanguage] isEqualToString:@"en"])
        img = @"header-tarife-rca-en.png";
    else img = @"header-tarife-rca.png";
    
    [image setImage:[UIImage imageNamed:img]];
    
    
    NSString *string1 = NSLocalizedStringFromTable(@"i788", [YTOUserDefaults getLanguage],@"Tarife");
    NSString *string2 = NSLocalizedStringFromTable(@"i789", [YTOUserDefaults getLanguage],@"de asigurare");
    NSString *string  = [[NSString alloc]initWithFormat:@"%@ %@",string1,string2];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")){
        NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        [attributedString beginEditing];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[YTOUtils colorFromHexString:verde] range:NSMakeRange(0, string1.length+1)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[YTOUtils colorFromHexString:ColorTitlu] range:NSMakeRange(string1.length+1, string2.length)];
        [attributedString beginEditing];
        
        [lbl11 setAttributedText:attributedString];
    }else{
        [lbl11 setText:string];
        [lbl11 setTextColor:[YTOUtils colorFromHexString:verde]];
    }
    
    lbl22.text = NSLocalizedStringFromTable(@"i763", [YTOUserDefaults getLanguage],@"cele mai mici tarife pentru masina ta");
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
                      "<CalculRca5JSON xmlns=\"http://tempuri.org/\">"
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
                      "<cont_user>%@</cont_user>"
                      "<cont_parola>%@</cont_parola>"
                      "<limba>%@</limba>"
                      "<versiune>%@</versiune>"
                      "</CalculRca5JSON>"
                      "</soap:Body>"
                      "</soap:Envelope>",
                      asigurat.nume, asigurat.codUnic, 
                      asigurat.telefon, asigurat.email, masina.adresa,
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
                      [[UIDevice currentDevice] xUniqueDeviceIdentifier],
                      masina.idIntern,
                      [[UIDevice currentDevice].model stringByReplacingOccurrencesOfString:@" " withString:@"_"],
                      ([asigurat.tipPersoana isEqualToString:@"juridica"] ? asigurat.codCaen : @"01"),
                      masina.categorieAuto,
                      masina.subcategorieAuto,
                      masina.serieCiv,
                      asigurat.casatorit,
                      asigurat.copiiMinori,
                      asigurat.pensionar,
                      asigurat.nrBugetari,
                      [YTOUserDefaults getUserName],
                      [YTOUserDefaults getPassword],
                      [YTOUserDefaults getLanguage],
                      [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"]
                      ];
    NSLog(@"%@",xml);
    return [xml stringByReplacingOccurrencesOfString:@"'" withString:@""];
}

- (IBAction)calculeazaRCADupaAltaDurata
{
    
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
        [request addValue:@"http://tempuri.org/CalculRca5JSON" forHTTPHeaderField:@"SOAPAction"];
        [request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if (connection) {
            self.responseData = [NSMutableData data];
        }
    }
    else {
        [self showPopupWithTitle:@"Atentie!"];// andDescription:@""];
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
    
    NSLog(@"%@",responseString);
    NSLog(@"RESPONSE DATA : %@",responseData);
    
    if (oferta.durataAsigurare == 6)
        responseCalcul6Luni = responseData;
    else
        responseCalcul12Luni = responseData;
    
    [self parseRcaResponse:responseData];
    
	NSLog(@"Response string: %@", responseString);
	
	
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"connection:didFailWithError:");
	NSLog(@"%@", [error localizedDescription]);
	
//	UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Atentie!" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//	[alertView show];

    [self showPopupServiciu:@"Serviciul care calculeaza tarife nu functioneaza momentan. Te rugam sa revii putin mai tarziu. Intre timp incercam sa remediem aceasta problema."];    
    //vwErrorAlert.hidden = NO;
    
//    YTOCustomPopup * alert = [[YTOCustomPopup alloc] initWithNibName:@"YTOCustomPopupView" bundle:nil];
//    alert.delegate = self;
//    [alert showAlert:@"Atentie" withMessage:[error localizedDescription] andImage:[UIImage imageNamed:@"comanda-eroare.png"] delegate:self];
}

- (void) parseRcaResponse:(NSMutableData *) response
{
    
    NSXMLParser * xmlParser = [[NSXMLParser alloc] initWithData:response];
	xmlParser.delegate = self;
	BOOL succes = [xmlParser parse];
    listTarife = [[NSMutableArray alloc] init];
    
	if (succes)
    {
        NSError * err = nil;
        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        
        if (data) {
            NSDictionary * jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
            
            for(NSDictionary *item in jsonArray) {
                cotatie = [[CotatieRCA2 alloc] init];
                NSString * eroare_ws = [item objectForKey:@"Eroare_ws"];
                if (eroare_ws && ![eroare_ws isEqualToString:@"success"])
                {
                    [vwLoading setHidden:YES];
                    //trebe decomentat
                    [self showPopupErrorWithTitle:NSLocalizedStringFromTable(@"i123", [YTOUserDefaults getLanguage],@"Atentie !")  andDescription:eroare_ws];
                    //vwErrorAlert.hidden = NO;
                    [self stopLoadingAnimantion];
                    return;
                }
                cotatie.prima = [NSString stringWithFormat:@"%.02f",[[item valueForKey:@"Prima"] doubleValue] ];
                cotatie.primaReducere = [NSString stringWithFormat:@"%.02f",[[item valueForKey:@"PrimaReducere"] doubleValue] ];
                cotatie.Reducere = [[item objectForKey:@"Reducere"] boolValue]? @"true": @"false" ;

                cotatie.idReducere = [item objectForKey:@"IdReducere"];
                cotatie.numeCompanie = [item objectForKey:@"Companie"];
                cotatie.codOferta = [item objectForKey:@"Cod"];
                cotatie.clasaBM = [item objectForKey:@"Clasa_bm"];
                if ([cotatie.clasaBM isEqualToString:@"B0"])
                    cellB0.hidden = NO;;
                [listTarife addObject:cotatie];
            }
           
        }
        else {
            [self showPopupServiciu:@"Serviciul care calculeaza tarife nu functioneaza momentan. Te rugam sa revii putin mai tarziu. Intre timp incercam sa remediem aceasta problema."];
        }
    }
    else
    {
        [self showPopupServiciu:@"Serviciul care calculeaza tarife nu functioneaza momentan. Te rugam sa revii putin mai tarziu. Intre timp incercam sa remediem aceasta problema."];
    }
    
    [vwLoading setHidden:YES];
    [self stopLoadingAnimantion];
    
    // Daca serviciul raspunde, dar nu intoarce nicio prima, dau mesaj
    if (listTarife.count == 0)
    {
        [self showPopupServiciu:@"Serverul companiilor de asigurare nu afiseaza tarifele. Te rugam sa verifici ca datele introduse sunt complete si corecte si apoi sa refaci calculatia."];
        //vwErrorAlert.hidden = NO;
    }
    else
    {
        [iRate sharedInstance].eventCount++;
        [tableView reloadData];
    }
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
	if (![elementName isEqualToString:@"CalculRca5JSONResponse"]
        && ![elementName isEqualToString:@"soap:Envelope"]
        && ![elementName isEqualToString:@"soap:Body"]
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
    TarifRCA * tarif = (TarifRCA *)[listTarife objectAtIndex:indexPath.row];
    if ([tarif.Reducere isEqualToString:@"true"])
        return 72;
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
    TarifRCA * tarif = (TarifRCA *)[listTarife objectAtIndex:indexPath.row];
 
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    CellTarifRCARedus *cellRedus;
    
    if (cell == nil && ![tarif.Reducere isEqualToString:@"true"])
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];

    if (cellRedus == nil && [tarif.Reducere isEqualToString:@"true"]){
        cellRedus = (CellTarifRCARedus *)[tv dequeueReusableCellWithIdentifier:CellIdentifier];
        cellRedus = [[CellTarifRCARedus alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withReducere:YES];
    }
   
    if ([tarif.Reducere isEqualToString:@"true"]){
        [cellRedus setPrima: [NSString stringWithFormat:@"%@ lei",tarif.prima]];
        [cellRedus setPrimaReducere: [NSString stringWithFormat:@"%@ lei",tarif.primaReducere]];
        [cellRedus setClasaBM:tarif.clasaBM];
        [cellRedus setLogo:[tarif.numeCompanie lowercaseString]];
        
        cellRedus.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else {
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", [tarif.numeCompanie lowercaseString]]];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ lei", tarif.prima];
        cell.textLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:14];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Clasa B/M: %@", tarif.clasaBM];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Arial" size:12];
    
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"adauga-in-cos.png"]];
        cell.accessoryView = imageView;
        UILabel * lbl = [[UILabel alloc] initWithFrame:CGRectMake(32, 0, 80, 40)];
        lbl.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:12];
        [lbl setText:NSLocalizedStringFromTable(@"i581", [YTOUserDefaults getLanguage],@"in cos")];
        [lbl setNumberOfLines:2];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [lbl setBackgroundColor:[UIColor clearColor]];
        [lbl setTextColor:[UIColor whiteColor]];
        [cell.accessoryView addSubview:lbl];
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    self.navigationItem.hidesBackButton = NO;
    if ([tarif.Reducere isEqualToString:@"true"])
        return cellRedus;
    else return cell;
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
    if ([tarif.Reducere isEqualToString:@"true"]){
        oferta.prima = tarif.primaInt;
        NSLog(@"%@",tarif.idReducere);
        oferta.primaReducere = tarif.primaReducereInt;
        oferta.idReducere = [NSString stringWithFormat:@"%@",tarif.idReducere];
    }
    else{
        oferta.prima = tarif.primaInt;
        oferta.primaReducere = 0.0;
        oferta.idReducere = @"";
    }
    oferta.companie = tarif.numeCompanie;
    oferta.dataSfarsit = [YTOUtils getDataSfarsitPolita:oferta.dataInceput andDurataInLuni:oferta.durataAsigurare];
    oferta.numeAsigurare = [NSString stringWithFormat:@"RCA, %@", masina.nrInmatriculare];
    oferta.moneda = @"RON";
    oferta.codOferta = tarif.codOferta;
    [oferta setRCABonusMalus:tarif.clasaBM];
    
    
    YTOSumarRCAViewController * aView = [[YTOSumarRCAViewController alloc] init];
    aView.masina = masina;
    aView.asigurat = asigurat;
    aView.oferta = oferta;
    if ([tarif.Reducere isEqualToString:@"true"])
        aView.pretRedus = YES;
    else aView.pretRedus = NO;
    
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

- (void) showPopupWithTitle:(NSString *)title// andDescription:(NSString *)description
{
    [self stopLoadingAnimantion];
    [vwPopup setHidden:NO];
    //[vwErrorAlert setHidden:NO];
    //lblPopupDescription.text = description;
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

- (IBAction)hideB0:(id)sender
{
    cellB0.hidden = YES;
}

@end
