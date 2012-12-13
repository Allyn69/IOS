//
//  YTOFinalizareRCAViewController.m
//  i-asigurare
//
//  Created by Andi Aparaschivei on 7/30/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
//

#import "YTOFinalizareRCAViewController.h"
#import "YTOUtils.h"
#import "Database.h"
#import "YTOWebViewController.h"
#import "YTOAppDelegate.h"
#import "YTOUserDefaults.h"

@interface YTOFinalizareRCAViewController ()

@end

@implementation YTOFinalizareRCAViewController

@synthesize oferta, asigurat, masina;
@synthesize responseData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Finalizare comanda", @"Finalizare comanda");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    goingBack = YES;
    
    proprietar = [YTOPersoana Proprietar];
    
    [self initCells];
    [self setTipPlata:@"cash"];
    [self setJudet:asigurat.judet];
    [self setLocalitate:asigurat.localitate];
    [self setAdresa:asigurat.adresa];
    [self setTelefon:asigurat.telefon];
    [self setEmail:asigurat.email];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 4)
        return 100;
    return 62;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    if (indexPath.row == 0) cell = cellJudetLocalitate;
    else if (indexPath.row == 1) cell = cellAdresa;
    else if (indexPath.row == 2) cell = cellTelefon;
    else if (indexPath.row == 3) cell = cellEmail;
    else if (indexPath.row == 4) cell = cellPlata;
    else cell = cellCalculeaza;
    
    if (indexPath.row % 2 == 0) {
        CGRect frame = CGRectMake(0, 0, 320, 60);  
        UIView *bgColor = [[UIView alloc] initWithFrame:frame];  
        [cell addSubview:bgColor];  
        [cell sendSubviewToBack:bgColor];
        bgColor.backgroundColor = [YTOUtils colorFromHexString:@"#fafafa"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self showListaJudete:indexPath];
    }
    else if (indexPath.row == 5)
    {
        [self doneEditing];
        
        if (telefonLivrare.length == 0)
        {
            [txtTelefonLivrare becomeFirstResponder];
            return;
        }
        if (emailLivrare.length == 0)
        {
            [txtEmailLivare becomeFirstResponder];
            return;
        }
        
        [self showCustomConfirm:@"Confirmare date" withDescription:@"Apasa DA pentru a confirma ca datele introduse sunt corecte si pentru a plasa comanda. Daca nu doresti sa continui, apasa NU." withButtonIndex:100];
    }
}

#pragma mark TEXTFIELD
- (void) textFieldDidBeginEditing:(UITextField *)textField 
{
    UITableViewCell *currentCell = (UITableViewCell *) [[textField superview] superview];
    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
    
    if (indexPath.row != 0)
    {
        [self addBarButton];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField 
{
	if(activeTextField != nil)
	{
		//[self saveTextField];
	}
    
	activeTextField = textField;
	
	UITableViewCell *currentCell = (UITableViewCell *) [[textField superview] superview];
    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
    
    activeTextField.tag = indexPath.row;
    
	tableView.contentInset = UIEdgeInsetsMake(64, 0, 210, 0);
	[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
	return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField 
{
	if(activeTextField == textField)
	{
        [self textFieldDidEndEditing:activeTextField];
		activeTextField = nil;
	}
    
	[textField resignFirstResponder];
	[self deleteBarButton];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
	return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    UITableViewCell *currentCell = (UITableViewCell *) [[textField superview] superview];
    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
    
    // In cazul in care tastatura este activa si se da back
    int index = 0;
    if (indexPath != nil)
        index = indexPath.row;
    else
        index = textField.tag;
    
    if (index == 1)
        [self setAdresa:textField.text];
    if (index == 2)
        [self setTelefon:textField.text];
    else if (index == 3)
        [self setEmail:textField.text];
}

-(IBAction) doneEditing
{
    [activeTextField resignFirstResponder];
	activeTextField = nil;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
	[self deleteBarButton];
}

- (void) addBarButton {
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"checked.png"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(doneEditing)];
    self.navigationItem.rightBarButtonItem = backButton;
}

- (void) deleteBarButton {
	self.navigationItem.rightBarButtonItem = nil;
}

#pragma Others
- (void) initCells
{
    NSArray *topLevelObjectsJudet = [[NSBundle mainBundle] loadNibNamed:@"CellView_Nomenclator" owner:self options:nil];
    cellJudetLocalitate = [topLevelObjectsJudet objectAtIndex:0];
    [(UILabel *)[cellJudetLocalitate viewWithTag:1] setText:@"LIVRARE (JUDET, LOCALITATE)"];
    [YTOUtils setCellFormularStyle:cellJudetLocalitate];
    
    NSArray *topLevelObjectsAdresa = [[NSBundle mainBundle] loadNibNamed:@"CellView_String" owner:self options:nil];
    cellAdresa = [topLevelObjectsAdresa objectAtIndex:0];
    [(UILabel *)[cellAdresa viewWithTag:1] setText:@"LIVRARE (STRADA, NUMAR, BLOC)"];
    [(UITextField *)[cellAdresa viewWithTag:2] setAutocapitalizationType:UITextAutocapitalizationTypeAllCharacters];
    [YTOUtils setCellFormularStyle:cellAdresa]; 
    
    NSArray *topLevelObjectsEmail = [[NSBundle mainBundle] loadNibNamed:@"CellView_String" owner:self options:nil];
    cellEmail = [topLevelObjectsEmail objectAtIndex:0];
    txtEmailLivare = (UITextField *)[cellEmail viewWithTag:2];
    [(UILabel *)[cellEmail viewWithTag:1] setText:@"EMAIL CONTACT"];
    [(UITextField *)[cellEmail viewWithTag:2] setPlaceholder:@""];
    [(UITextField *)[cellEmail viewWithTag:2] setKeyboardType:UIKeyboardTypeEmailAddress];        
    [YTOUtils setCellFormularStyle:cellEmail];
    
    NSArray *topLevelObjectsTelefon = [[NSBundle mainBundle] loadNibNamed:@"CellView_Numeric" owner:self options:nil];
    cellTelefon = [topLevelObjectsTelefon objectAtIndex:0];
    txtTelefonLivrare = (UITextField *)[cellTelefon viewWithTag:2];
    [(UILabel *)[cellTelefon viewWithTag:1] setText:@"TELEFON CONTACT"];
    [(UITextField *)[cellTelefon viewWithTag:2] setPlaceholder:@""];
    [(UITextField *)[cellTelefon viewWithTag:2] setKeyboardType:UIKeyboardTypeNumberPad];
    [YTOUtils setCellFormularStyle:cellTelefon];
    
    NSArray *topLevelObjectscalc = [[NSBundle mainBundle] loadNibNamed:@"CellCalculeaza" owner:self options:nil];
    cellCalculeaza = [topLevelObjectscalc objectAtIndex:0];
    UIImageView * imgComanda = (UIImageView *)[cellCalculeaza viewWithTag:1];
    imgComanda.image = [UIImage imageNamed:@"comanda-rca.png"];
    UILabel * lblCellC = (UILabel *)[cellCalculeaza viewWithTag:2];
    lblCellC.textColor = [UIColor whiteColor];
    lblCellC.text = @"COMANDA";
}

- (void) showListaJudete:(NSIndexPath *)index
{
    goingBack = NO;
    PickerVCSearch * actionPicker = [[PickerVCSearch alloc]initWithNibName:@"PickerVCSearch" bundle:nil];
    actionPicker.listOfItems = [[NSMutableArray alloc] initWithArray:[Database Judete]];
    actionPicker._indexPath = index;
    actionPicker.nomenclator = kJudete;
    actionPicker.delegate = self;
    actionPicker.titlu = @"Judete";
    [self presentModalViewController:actionPicker animated:YES];
}

#pragma Picker View Nomenclator
-(void)chosenIndexAfterSearch:(NSString*)selected rowIndex:(NSIndexPath *)indexPath  forView:(PickerVCSearch *)vwSearch {
    if (indexPath.row == 0) // JUDET + LOCALITATE
    {
        if (vwSearch.nomenclator == kJudete) {
            [self setJudet:selected];
        }
        else { 
            [self setLocalitate:selected];
        }
    }
    goingBack = YES;
}

- (void) setJudet:(NSString *)judet
{
    judetLivrare = judet;
}

- (void) setLocalitate:(NSString *)localitate
{
    localitateLivrare = localitate;
    UILabel * lbl = (UILabel *)[cellJudetLocalitate viewWithTag:2];
    lbl.text = [[judetLivrare stringByAppendingString:@","] stringByAppendingString:localitateLivrare];
}

- (void) setAdresa:(NSString *)adresa
{
    adresaLivrare = adresa;
    UITextField * txt = (UITextField *)[cellAdresa viewWithTag:2];
    txt.text = adresa;
}

- (void) setEmail:(NSString *)email
{
    if ([email isEqualToString:@""] && proprietar.email.length >0 )
    {
        email = proprietar.email;
    }
    else if (asigurat.email == nil || [asigurat.email isEqualToString:@"null"])
    {
        asigurat.email = email;
        saveAsigurat = YES;
    }
    
    emailLivrare = email;
    txtEmailLivare.text = email;
}

- (void) setTelefon:(NSString *)telefon
{
    if ([telefon isEqualToString:@""] && proprietar.telefon.length >0 )
    {
        telefon = proprietar.telefon;
    }
    else if (asigurat.telefon == nil || [asigurat.telefon isEqualToString:@"null"] || [asigurat.telefon isEqualToString:@"(null)"])
    {
        asigurat.telefon = telefon;
        saveAsigurat = YES;
    }
    
    telefonLivrare = telefon;
    txtTelefonLivrare.text = telefon;
}

- (IBAction)btnTipPlata_Clicked:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    //BOOL checkboxSelected = btn.selected;
    //checkboxSelected = !checkboxSelected;
    
    for (int i=1; i<=3; i++) {
        UIButton * _btn = (UIButton *)[cellPlata viewWithTag:i];
        if (btn.tag != i)
            [_btn setSelected:NO];
    }
    
    if (btn.tag == 1)
        [self setTipPlata:@"cash"];
    else if (btn.tag == 2)
        [self setTipPlata:@"op"];
    else if (btn.tag ==3)
        [self setTipPlata:@"online"];
    
    [self doneEditing];
}

- (void) setTipPlata:(NSString *)p
{
    if ([p isEqualToString:@"cash"]) {
        ((UIButton *)[cellPlata viewWithTag:1]).selected = YES;
        modPlata = 1;
    }
    else if ([p isEqualToString:@"op"])
    {
        ((UIButton *)[cellPlata viewWithTag:2]).selected = YES;
        modPlata = 2;
    }
    else if ([p isEqualToString:@"online"])
    {
        ((UIButton *)[cellPlata viewWithTag:3]).selected = YES;
        modPlata = 3;
    }
}

#pragma mark Consume WebService

- (NSString *) XmlRequest
{
    NSString * bonusMalus = [NSString stringWithFormat:@"Bonus/Malus: %@", [oferta RCABonusMalus]];

    NSString * xml = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
							 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
							 "<soap:Body>"
							 "<InregistrareComandaSmartphone xmlns=\"http://tempuri.org/\">"
							 "<user>vreaurca</user>"
							 "<password>123</password>"
							 "<oferta_prima>%.2f</oferta_prima>"
							 "<oferta_companie>%@</oferta_companie>"
							 "<oferta_cod>%@</oferta_cod>"
							 "<oferta_clasa_bm>%@</oferta_clasa_bm>"
							 "<livrare_adresa>%@</livrare_adresa>"
							 "<livrare_localitate>%@</livrare_localitate>"
							 "<livrare_judet>%@</livrare_judet>"
							 "<telefon>%@</telefon>"
                             "<email>%@</email>"
							 "<mod_plata>%d</mod_plata>"
							 "<udid>%@</udid>"
                             "<id_masina>%@</id_masina>"
							 "<platforma>%@</platforma>"
							 "</InregistrareComandaSmartphone>"
							 "</soap:Body>"
							 "</soap:Envelope>",
							 oferta.prima, oferta.companie, oferta.codOferta, bonusMalus, adresaLivrare, localitateLivrare, judetLivrare, telefonLivrare, emailLivrare, modPlata,
							 [[UIDevice currentDevice] uniqueIdentifier],
                             masina.idIntern,
                             [[UIDevice currentDevice].model stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
    return xml;
}

- (IBAction) callInregistrareComanda {
    [self showCustomLoading];
    self.navigationItem.hidesBackButton = YES;

	NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@rca.asmx", LinkAPI]];
    
	NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
															cachePolicy:NSURLRequestUseProtocolCachePolicy
														timeoutInterval:15.0];
    
	NSString * parameters = [[NSString alloc] initWithString:[self XmlRequest]];
	NSLog(@"Request=%@", parameters);
	NSString * msgLength = [NSString stringWithFormat:@"%d", [parameters length]];
	
	[request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[request addValue:@"http://tempuri.org/InregistrareComandaSmartphone" forHTTPHeaderField:@"SOAPAction"];
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
    self.navigationItem.hidesBackButton = NO;
    [self hideCustomLoading];

	NSXMLParser * xmlParser = [[NSXMLParser alloc] initWithData:responseData];
	xmlParser.delegate = self;
	BOOL succes = [xmlParser parse];
	
    if (succes) {
        if (idOferta == nil || [idOferta isEqualToString:@""])
            [self showCustomAlert:@"Finalizare comanda RCA" withDescription:responseMessage withError:YES withButtonIndex:2];
        else {
            oferta.idExtern = [idOferta intValue];
            
            if (!oferta._isDirty)
                [oferta addOferta];
            else
                [oferta updateOferta];
            
            // in cazul in care nu avea telefon sau email introdus,
            // salvam aceste valori
            if (saveAsigurat)
                [asigurat updatePersoana];
            
            // daca este pentru plata ONLINE
            if (modPlata == 3) {
                [self showCustomAlert:@"Finalizare comanda RCA" withDescription:responseMessage withError:NO withButtonIndex:3];
            }
            else [self showCustomAlert:@"Finalizare comanda RCA" withDescription:responseMessage withError:NO withButtonIndex:1];
        }
	}
	else
    {
        [self showCustomAlert:@"Finalizare comanda RCA" withDescription:@"Comanda NU a fost transmisa." withError:YES withButtonIndex:4];
	}
   
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"connection:didFailWithError:");
	NSLog(@"%@", [error localizedDescription]);
	
//	UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Atentie!" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//	[alertView show];
    [self hideCustomLoading];
    [self showCustomAlert:@"Atentie" withDescription:[error localizedDescription] withError:YES withButtonIndex:4];
}

#pragma mark NSXMLParser Methods
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if ([elementName isEqualToString:@"NumarComanda"]) {
		idOferta = currentElementValue;
		if (idOferta.length > 0)
		{
			//setari.idOferta = idOferta;
			//[appDelegate salveazaSetari];
		}
	}
	else if ([elementName isEqualToString:@"MesajComanda"]) {
		responseMessage = [NSString stringWithString:currentElementValue];
	}

	currentElementValue = nil;
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if(!currentElementValue)
		currentElementValue = [[NSMutableString alloc] initWithString:string];
	else
		[currentElementValue appendString:string];
}

- (void) showCustomLoading
{
    self.navigationItem.hidesBackButton = YES;
    [self hideCustomLoading];
    [btnClosePopup setHidden:YES];
    [loading setHidden:NO];
    [lblLoading setHidden:NO];
    [imgLoading setImage:[UIImage imageNamed:@"popup-generic.png"]];
    [vwLoading setHidden:NO];
}

- (IBAction) hideCustomLoading
{
    self.navigationItem.hidesBackButton = NO;
    [vwLoading setHidden:YES];
    if (idOferta && ![idOferta isEqualToString:@""] && [YTOUserDefaults IsFirstInsuranceRequest])
    {
        [YTOUserDefaults setFirstInsuranceRequest:YES];
        [self showPopupDupaComanda];   
    }
}

- (void) showCustomAlert:(NSString*) title withDescription:(NSString *)description withError:(BOOL) error withButtonIndex:(int) index
{
    self.navigationItem.hidesBackButton = YES;
    if (error)
        imgError.image = [UIImage imageNamed:@"comanda-eroare.png"];
    else
        imgError.image = [UIImage imageNamed:@"comanda-ok.png"];
    
    btnCustomAlertOK.tag = index;
    btnCustomAlertOK.frame = CGRectMake(124, 239, 73, 42);
    lblCustomAlertOK.frame = CGRectMake(150, 249, 42, 21);
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
    
    NSLog(@"tag=%d", btn.tag);
    
    if (btn.tag == 1)
    {
        if ([YTOUserDefaults IsFirstInsuranceRequest])
            [self showPopupDupaComanda];
        else
            [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if (btn.tag == 11 || btn.tag == 5)
        [self.navigationController popToRootViewControllerAnimated:YES];
    else if (btn.tag == 3)
    {
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
                     "&udid=%@",
                     LinkAPI,
                     idOferta, emailLivrare, asigurat.nume, asigurat.adresa, asigurat.localitate, asigurat.judet, telefonLivrare,
                     @"RCA", oferta.prima, oferta.companie, [[UIDevice currentDevice] uniqueIdentifier]];
        
        NSURL * nsURL = [[NSURL alloc] initWithString:[url stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
        [[UIApplication sharedApplication] openURL:nsURL];
        
        //YTOWebViewController * aView = [[YTOWebViewController alloc] init];
        //aView.URL = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        //YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
        //[delegate.rcaNavigationController pushViewController:aView animated:YES];
    }
    else if (btn.tag == 100)
    {
        [self doneEditing];
        
        [self callInregistrareComanda];
    }
//    else
//        [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) showCustomConfirm:(NSString *) title withDescription:(NSString *) description withButtonIndex:(int) index
{
    self.navigationItem.hidesBackButton = YES;
    imgError.image = [UIImage imageNamed:@"comanda-confirmare-date.png"];
    btnCustomAlertOK.tag = index;
    btnCustomAlertOK.frame = CGRectMake(189, 239, 73, 42);
    lblCustomAlertOK.frame = CGRectMake(215, 249, 42, 21);
    [lblCustomAlertOK setText:@"DA"];
    
    [btnCustomAlertNO setHidden:NO];
    [lblCustomAlertNO setHidden:NO];
    
    lblCustomAlertTitle.text = title;
    lblCustomAlertMessage.text = description;
    [vwCustomAlert setHidden:NO];
}

- (void) showPopupDupaComanda
{
    self.navigationItem.hidesBackButton = YES;
    
    viewTooltip = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    img.tag = 1;
    [img setImage:[UIImage imageNamed:@"popup-dupa-comanda.png"]];
    [viewTooltip addSubview:img];
    
    UIButton * btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    btnClose.tag = 2;
    btnClose.frame = CGRectMake(126, 400, 70, 31);
    [btnClose addTarget:self action:@selector(closeTooltip) forControlEvents:UIControlEventTouchUpInside];
    [viewTooltip addSubview:btnClose];
    
    YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.window addSubview:viewTooltip];
}

- (void) closeTooltip
{
    self.navigationItem.hidesBackButton = NO;
    [viewTooltip removeFromSuperview];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
