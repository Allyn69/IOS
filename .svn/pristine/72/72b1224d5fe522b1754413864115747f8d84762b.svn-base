//
//  YTOFinalizareLocuintaViewController.m
//  i-asigurare
//
//  Created by Andi Aparaschivei on 11/8/12.
//
//

#import "YTOFinalizareLocuintaViewController.h"
#import "Database.h"

@interface YTOFinalizareLocuintaViewController ()

@end

@implementation YTOFinalizareLocuintaViewController

@synthesize oferta, locuinta, asigurat, responseData;

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
    
    goingBack = YES;
    [self initCells];
    [self setTipPlata:@"op"];
    [self setJudet:asigurat.judet];
    [self setLocalitate:asigurat.localitate];
    [self setAdresa:asigurat.adresa];
    [self setTelefon:asigurat.telefon];
    [self setEmail:asigurat.email];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        [self doneEditing];
        
        if (telefonLivrare.length == 0)
        {
            [txtTelefonLivrare becomeFirstResponder];
            return;
        }
        if (emailLivrare.length == 0)
        {
            [txtEmailLivrare becomeFirstResponder];
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
    {
        [self setAdresa:textField.text];
    }
    else if (index == 2) // telefon
    {
        [self setTelefon:textField.text];
    }
    else if (index == 3) // email
    {
        [self setEmail:textField.text];
    }
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
    [(UILabel *)[cellJudetLocalitate viewWithTag:1] setText:@"JUDET, LOCALITATE LIVRARE"];
    [YTOUtils setCellFormularStyle:cellJudetLocalitate];
    
    NSArray *topLevelObjectsAdresa = [[NSBundle mainBundle] loadNibNamed:@"CellView_String" owner:self options:nil];
    cellAdresa = [topLevelObjectsAdresa objectAtIndex:0];
    [(UILabel *)[cellAdresa viewWithTag:1] setText:@"STRADA, NUMAR, BLOC"];
    [(UITextField *)[cellAdresa viewWithTag:2] setAutocapitalizationType:UITextAutocapitalizationTypeAllCharacters];
    [YTOUtils setCellFormularStyle:cellAdresa];
    
    NSArray *topLevelObjectsEmail = [[NSBundle mainBundle] loadNibNamed:@"CellView_String" owner:self options:nil];
    cellEmail = [topLevelObjectsEmail objectAtIndex:0];
    txtEmailLivrare = (UITextField *)[cellEmail viewWithTag:2];
    [(UILabel *)[cellEmail viewWithTag:1] setText:@"EMAIL"];
    [(UITextField *)[cellEmail viewWithTag:2] setPlaceholder:@""];
    [(UITextField *)[cellEmail viewWithTag:2] setKeyboardType:UIKeyboardTypeEmailAddress];
    [YTOUtils setCellFormularStyle:cellEmail];
    
    NSArray *topLevelObjectsTelefon = [[NSBundle mainBundle] loadNibNamed:@"CellView_Numeric" owner:self options:nil];
    cellTelefon = [topLevelObjectsTelefon objectAtIndex:0];
    txtTelefonLivrare = (UITextField *)[cellTelefon viewWithTag:2];
    [(UILabel *)[cellTelefon viewWithTag:1] setText:@"TELEFON"];
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
    emailLivrare = email;
    txtEmailLivrare.text = email;
    
    if ([YTOUtils validateEmail:asigurat.email] == NO && [YTOUtils validateEmail:email])
        asigurat.email = email;
}

- (void) setTelefon:(NSString *)telefon
{
    telefonLivrare = telefon;
    txtTelefonLivrare.text = telefon;

    if (asigurat.telefon.length < 10 && asigurat.telefon.length > 14 &&
        telefon.length > 9 && telefon.length < 15)
        asigurat.telefon = telefon;
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
    
    if (btn.tag == 2)
        [self setTipPlata:@"op"];
    else if (btn.tag ==3)
        [self setTipPlata:@"online"];
    
    [self doneEditing];
}

- (void) setTipPlata:(NSString *)p
{
    if ([p isEqualToString:@"op"])
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
    NSString * xml = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                      "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                      "<soap:Body>"
                      "<CallInregistrareComandaSmartphone xmlns=\"http://tempuri.org/\">"
                      "<user>vreaurca</user>"
                      "<password>123</password>"
                      "<oferta_prima>%.2f</oferta_prima>"
                      "<oferta_companie>%@</oferta_companie>"
                      "<oferta_produs>%@</oferta_produs>"
                      "<oferta_cod>%@</oferta_cod>"
                      "<datainceput>%@</datainceput>"
                      "<nume_asigurat>%@</nume_asigurat>"
                      "<cod_unic>%@</cod_unic>"
                      "<email>%@</email>"
                      "<telefon>%@</telefon>"
                      "<mod_plata>%d</mod_plata>"
                      "<udid>%@</udid>"
                      "<platforma>%@</platforma>"
                      "<id_locuinta>%@</id_locuinta>"
                      "<sendEmail>1</sendEmail>"
                      "</CallInregistrareComandaSmartphone>"
                      "</soap:Body>"
                      "</soap:Envelope>",
                      oferta.prima, oferta.companie, [oferta LocuintaTipProdus], oferta.codOferta, [YTOUtils formatDate:oferta.dataInceput withFormat:@"yyyy-MM-dd"],
                      asigurat.nume, asigurat.codUnic, emailLivrare, telefonLivrare, modPlata,
                      [[UIDevice currentDevice] uniqueIdentifier], [[UIDevice currentDevice].model stringByReplacingOccurrencesOfString:@" " withString:@"_"],
                      locuinta.idIntern];
    return xml;
}

- (IBAction) callInregistrareComanda {
    [self showCustomLoading];
    self.navigationItem.hidesBackButton = YES;

	NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@locuinta.asmx", LinkAPI]];
    
	NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
															cachePolicy:NSURLRequestUseProtocolCachePolicy
														timeoutInterval:15.0];
    
	NSString * parameters = [[NSString alloc] initWithString:[self XmlRequest]];
	NSLog(@"Request=%@", parameters);
	NSString * msgLength = [NSString stringWithFormat:@"%d", [parameters length]];
	
	[request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[request addValue:@"http://tempuri.org/CallInregistrareComandaSmartphone" forHTTPHeaderField:@"SOAPAction"];
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
            [self showCustomAlert:@"Finalizare comanda" withDescription:responseMessage withError:YES withButtonIndex:2];
        else {
            oferta.idExtern = [idOferta intValue];
            
            if (!oferta._isDirty)
                [oferta addOferta];
            else
                [oferta updateOferta];
            
            // daca este pentru plata ONLINE
            if (succes && modPlata == 3) {
                [self showCustomAlert:@"Finalizare comanda" withDescription:responseMessage withError:NO withButtonIndex:3];
            }
            else [self showCustomAlert:@"Finalizare comanda" withDescription:responseMessage withError:NO withButtonIndex:1];
        }
	}
	else {
        [self showCustomAlert:@"Finalizare comanda" withDescription:@"Comanda NU a fost transmisa." withError:YES withButtonIndex:4];
	}
    
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"connection:didFailWithError:");
	NSLog(@"%@", [error localizedDescription]);
	
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
    self.navigationItem.hidesBackButton = NO;
    
    [self hideCustomLoading];
    [vwLoading setHidden:NO];
}

- (IBAction) hideCustomLoading
{
    self.navigationItem.hidesBackButton = NO;
    
    [vwLoading setHidden:YES];
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
    
  //  NSLog(@"btn tag=%d", btn.tag);
    
    if (btn.tag == 1)
    {
        //if (true)
        //    [self showPopupDupaComanda];
        // else
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if (btn.tag == 11)
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
                          "&udid=%@"
                          "&moneda=eur",
                          LinkAPI,
                          idOferta, emailLivrare, asigurat.nume, asigurat.adresa, asigurat.localitate, asigurat.judet, telefonLivrare,
                          @"Locuinta", oferta.prima, oferta.companie, [[UIDevice currentDevice] uniqueIdentifier]];
        
        NSURL * nsURL = [[NSURL alloc] initWithString:[url stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
        [[UIApplication sharedApplication] openURL:nsURL];

    }
    else if (btn.tag == 100)
    {
        [self doneEditing];
        
        if (telefonLivrare.length == 0 || emailLivrare.length == 0)
        {
            return;
        }
        
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
//    [vwLoading setHidden:NO];
//    [loading setHidden:YES];
//    [lblLoading setHidden:YES];
//    [btnClosePopup setHidden:NO];
//    btnClosePopup.tag = 11;
//    [imgLoading setImage:[UIImage imageNamed:@"popup-dupa-comanda.png"]];
}
@end
