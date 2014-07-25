//
//  YTOFinalizareCalatorieViewController.m
//  i-asigurare
//
//  Created by Andi Aparaschivei on 10/12/12.
//
//

#import "YTOFinalizareCalatorieViewController.h"
#import "Database.h"
#import "YTOUserDefaults.h"
#import "YTOAppDelegate.h"

#import "YTOWebViewController.h"
#import "YTOToast.h"



@interface YTOFinalizareCalatorieViewController ()

@end

@implementation YTOFinalizareCalatorieViewController

@synthesize oferta, listAsigurati, cotatie;
@synthesize responseData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedStringFromTable(@"i449", [YTOUserDefaults getLanguage],@"Finalizare comanda");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IS_OS_7_OR_LATER){
        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars=NO;
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    //self.trackedViewName = @"YTOFinalizareCalatorieViewController";
    
    // Do any additional setup after loading the view from its nib.
    [self initCells];

    YTOPersoana * proprietar = [YTOPersoana Proprietar];
    if (!proprietar)
        proprietar = [YTOPersoana ProprietarPJ];
    if (proprietar)
    {
        [self setEmail:proprietar.email];
        [self setTelefon:proprietar.telefon];
    }

//    for (int i=0; i<listAsigurati.count; i++) {
//        YTOPersoana * pers = [listAsigurati objectAtIndex:i];
//        if (pers.serieAct && ![pers.serieAct isEqualToString:@""])
//            [self setSerieAct:pers.serieAct forIndex:i];
//    }
    [self setTipPlata:@"online"];
    [self setTelefon:telefonLivrare];
    [self setEmail:emailLivrare];
    
    lblCustomAlertNO.text = NSLocalizedStringFromTable(@"i344", [YTOUserDefaults getLanguage],@"NU");
    
    lblModPlata.text = NSLocalizedStringFromTable(@"i90", [YTOUserDefaults getLanguage],@"Modalitate de plata");
    lblSeIncarca.text = NSLocalizedStringFromTable(@"i444", [YTOUserDefaults getLanguage],@"se incarca...");
    lblOnlineCuCardul.text =NSLocalizedStringFromTable(@"i179", [YTOUserDefaults getLanguage],@"ONLINE, \n cu cardul");
    
    [YTOUtils rightImageVodafone:self.navigationItem];
    
    UIImageView * img = (UIImageView *)[cellHeader viewWithTag:100];
    img.image = nil;
    if ([[YTOUserDefaults getLanguage] isEqualToString:@"hu"])
        img.image = [UIImage imageNamed:@"asig-calatorie-hu.png"];
    else if ([[YTOUserDefaults getLanguage] isEqualToString:@"en"])
        img.image = [UIImage imageNamed:@"asig-calatorie-en.png"];
    else img.image = [UIImage imageNamed:@"asig-calatorie.png"];
    UILabel * lblView1 = (UILabel *) [cellHeader viewWithTag:11];
    UILabel * lblView2 = (UILabel *) [cellHeader viewWithTag:22];
    lblView1.backgroundColor = [YTOUtils colorFromHexString:portocaliuCalatorie];
    lblView2.backgroundColor = [YTOUtils colorFromHexString:portocaliuCalatorie];
    
    UILabel *lbl1 = (UILabel *) [cellHeader viewWithTag:1];
    UILabel *lbl2 = (UILabel *) [cellHeader viewWithTag:2];
    UILabel *lbl3 = (UILabel *) [cellHeader viewWithTag:3];
    lbl1.textColor = [YTOUtils colorFromHexString:portocaliuCalatorie];
    
    lbl1.text = NSLocalizedStringFromTable(@"i794", [YTOUserDefaults getLanguage],@"Finalizare comanda");
    lbl2.text = NSLocalizedStringFromTable(@"i795", [YTOUserDefaults getLanguage],@"Vei primi polita de asigurare");
    lbl3.text = NSLocalizedStringFromTable(@"i796", [YTOUserDefaults getLanguage],@"pe adresa ta de e-mail");
    cellHeader.userInteractionEnabled = NO;
    
    lblEroare.text = NSLocalizedStringFromTable(@"i799", [YTOUserDefaults getLanguage],@"Eroare !");
    lblEroare.textColor = [YTOUtils colorFromHexString:rosuTermeni];
    if ([[YTOUserDefaults getLanguage] isEqualToString:@"hu"])
        lbl1.adjustsFontSizeToFitWidth = YES;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // returnez numarul de asigurati + telefon + email + buton de finalizare
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2)
        return 100;
    return 62;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;

    if (indexPath.row == 0) cell = cellTelefon;
    else if (indexPath.row == 1) cell = cellEmail;
    else if (indexPath.row == 2) cell = cellPlata;
    else cell = cellCalculeaza;
    
    if (indexPath.row % 2 == 0) {
        CGRect frame = CGRectMake(0, 0, 320, 60);
        UIView *bgColor = [[UIView alloc] initWithFrame:frame];
        [cell addSubview:bgColor];
        [cell sendSubviewToBack:bgColor];
        bgColor.backgroundColor = [YTOUtils colorFromHexString:@"#fafafa"];
    }
    
    UIButton * btnPlata = (UIButton*)[cellPlata viewWithTag:2];
    [btnPlata setSelected:YES];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3)
    {
        [self doneEditing];
        if (telefonLivrare.length == 0)
        {
            [txtTelefonLivrare becomeFirstResponder];
            return;
        }
        if (telefonLivrare.length !=10)
        {
            [[[[iToast makeText:NSLocalizedString(@"Ai introdus gresit numarul de telefon", @"")]
               setGravity:iToastGravityCenter] setDuration:iToastDurationShort] show];
            [txtTelefonLivrare becomeFirstResponder];
            return;
        }
        if (emailLivrare.length == 0)
        {
            [txtEmailLivrare becomeFirstResponder];
            return;
        }
        if (![YTOUtils validateEmail:emailLivrare])
        {
            [[[[iToast makeText:NSLocalizedString(@"Ai introdus gresit adresa de e-mail", @"")]
               setGravity:iToastGravityCenter] setDuration:iToastDurationShort] show];
            [txtEmailLivrare becomeFirstResponder];
            return;
        }

        [self showCustomConfirm:NSLocalizedStringFromTable(@"i451", [YTOUserDefaults getLanguage],@"Confirma date") withDescription:NSLocalizedStringFromTable(@"i452", [YTOUserDefaults getLanguage],@"Apasa DA pentru a confirma ca datele introduse sunt corecte si pentru a plasa comanda. Daca nu doresti sa continui apasa NU")withButtonIndex:100];
    }

}

#pragma mark TEXTFIELD
- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    [self addBarButton];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	activeTextField = textField;
	
	UITableViewCell *currentCell;
    if (IS_OS_7_OR_LATER) currentCell = (UITableViewCell *) textField.superview.superview.superview;
    else currentCell =  (UITableViewCell *) [[textField superview] superview];
    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
    
    activeTextField.tag = indexPath.row;
    
	tableView.contentInset = UIEdgeInsetsMake(0, 0, 210, 0);
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
    UITableViewCell *currentCell;
    if (IS_OS_7_OR_LATER) currentCell = (UITableViewCell *) textField.superview.superview.superview;
    else currentCell =  (UITableViewCell *) [[textField superview] superview];
    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];

    //int indexAfter = listAsigurati.count-1;
    
    // In cazul in care tastatura este activa si se da back
    int index = 0;
    if (indexPath != nil)
        index = indexPath.row;
    else
        index = textField.tag;
    
    if(index == 0)
    {
        [self setTelefon:textField.text];
    }
    else if (index == 1)
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
	//self.navigationItem.rightBarButtonItem = nil;
 [YTOUtils rightImageVodafone:self.navigationItem];
}

#pragma Others
- (void) initCells
{
//    listCells = [[NSMutableArray alloc] init];
//    for (int i=0; i<listAsigurati.count; i++) {
//        YTOPersoana * asigurat = [listAsigurati objectAtIndex:i];
//        NSArray *topLevelObjectAsigurat = [[NSBundle mainBundle] loadNibNamed:@"CellView_String" owner:self options:nil];
//        cellSerie = [topLevelObjectAsigurat objectAtIndex:0];
//        [(UILabel *)[cellSerie viewWithTag:1] setText:[NSString stringWithFormat:@"SERIE DOCUMENT %@", [asigurat.nume uppercaseString]]];
//        txtSerie = (UITextField *)[cellSerie viewWithTag:2];
//        [(UITextField *)[cellSerie viewWithTag:2] setPlaceholder:@"seria CI/Pasaport"];
//        [(UITextField *)[cellSerie viewWithTag:2] setAutocapitalizationType:UITextAutocapitalizationTypeAllCharacters];
//        [YTOUtils setCellFormularStyle:cellSerie];
//        [listCells addObject:cellSerie];
//    }
    
    NSArray *topLevelObjectsEmail = [[NSBundle mainBundle] loadNibNamed:@"CellView_String" owner:self options:nil];
    cellEmail = [topLevelObjectsEmail objectAtIndex:0];
    [(UILabel *)[cellEmail viewWithTag:1] setText:NSLocalizedStringFromTable(@"i57", [YTOUserDefaults getLanguage],@"EMAIL")];
    txtEmailLivrare = (UITextField *)[cellEmail viewWithTag:2];
    [(UITextField *)[cellEmail viewWithTag:2] setPlaceholder:@""];
    [(UITextField *)[cellEmail viewWithTag:2] setKeyboardType:UIKeyboardTypeEmailAddress];
    [YTOUtils setCellFormularStyle:cellEmail];
    
    NSArray *topLevelObjectsTelefon = [[NSBundle mainBundle] loadNibNamed:@"CellView_Numeric" owner:self options:nil];
    cellTelefon = [topLevelObjectsTelefon objectAtIndex:0];
    txtTelefonLivrare = (UITextField *)[cellTelefon viewWithTag:2];
    [(UILabel *)[cellTelefon viewWithTag:1] setText:NSLocalizedStringFromTable(@"i63", [YTOUserDefaults getLanguage],@"TELEFON")];
    [(UITextField *)[cellTelefon viewWithTag:2] setPlaceholder:@""];
    [(UITextField *)[cellTelefon viewWithTag:2] setKeyboardType:UIKeyboardTypeNumberPad];
    [YTOUtils setCellFormularStyle:cellTelefon];
    
    NSArray *topLevelObjectscalc = [[NSBundle mainBundle] loadNibNamed:@"CellCalculeaza" owner:self options:nil];
    cellCalculeaza = [topLevelObjectscalc objectAtIndex:0];
    UIImageView * imgComanda = (UIImageView *)[cellCalculeaza viewWithTag:1];
    imgComanda.image = [UIImage imageNamed:@"comanda-calatorie.png"];
    UILabel * lblCellC = (UILabel *)[cellCalculeaza viewWithTag:2];
    lblCellC.textColor = [UIColor whiteColor];
    lblCellC.text = NSLocalizedStringFromTable(@"i96", [YTOUserDefaults getLanguage],@"COMANDA");
}

- (void) setSerieAct:(NSString *)serie forIndex:(int)index
{
    YTOPersoana * asigurat = [listAsigurati objectAtIndex:index];
    asigurat.serieAct = serie;
    
    //am adaugat ca nu salva serieAct
    [asigurat updatePersoana:NO];
    
    UITextField * txt = (UITextField *)[(UITableViewCell*)[listCells objectAtIndex:index] viewWithTag:2];
    txt.text = serie;
    seriePasaport = serie;
}

- (void) setEmail:(NSString *)email
{
    emailLivrare = email;
    txtEmailLivrare.text = email;
}

- (void) setTelefon:(NSString *)telefon
{
    telefonLivrare = telefon;
    txtTelefonLivrare.text = telefon;
}

- (void) setTipPlata:(NSString *)p
{
    if ([p isEqualToString:@"online"])
        modPlata = 3;
}

#pragma mark Consume WebService

- (NSString *) XmlRequest
{
    NSString * appVersion = [NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    
    NSString * xml = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                      "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                      "<soap:Body>"
                      "<CallInregistrareComanda5 xmlns=\"http://tempuri.org/\">"
                      "<user>vreaurca</user>"
                      "<password>123</password>"
                      "<oferta_prima>%.2f</oferta_prima>"
                      "<oferta_companie>%@</oferta_companie>"
                      "<oferta_produs>%@</oferta_produs>"
                      "<oferta_cod>%@</oferta_cod>"
                      "<datainceput>%@</datainceput>"
                      "<jsonPersoane>%@</jsonPersoane>"
                      "<email>%@</email>"
                      "<telefon>%@</telefon>"
                      "<mod_plata>%d</mod_plata>"
                      "<udid>%@</udid>"
                      "<platforma>%@</platforma>"
                      "<sendEmail>1</sendEmail>"
                      "<tip_emitere>2</tip_emitere>" // Emitere Automata = 2
                      "<idReducere>%@</idReducere>"
                      "<versiune>%@</versiune>"
                      "<cont_user>%@</cont_user>"
                      "<cont_parola>%@</cont_parola>"
                      "</CallInregistrareComanda5>"
                      "</soap:Body>"
                      "</soap:Envelope>",
                      oferta.prima, oferta.companie, cotatie.TipProdus, oferta.codOferta, [YTOUtils formatDate:oferta.dataInceput withFormat:@"yyyy-MM-dd"],
                      [YTOPersoana getJsonPersoane:listAsigurati],
                      emailLivrare, telefonLivrare, modPlata,
                      [[UIDevice currentDevice] xUniqueDeviceIdentifier], [[UIDevice currentDevice].model stringByReplacingOccurrencesOfString:@" " withString:@"_"],
                      cotatie.IdReducere,
                      appVersion,[YTOUserDefaults getUserName],[YTOUserDefaults getPassword]];
    return xml;
}

- (void)chosenIndexAfterSearch:(NSString *)selected rowIndex:(NSIndexPath *)index forView:(id)view
{
    
}

- (IBAction) callInregistrareComanda {
    [self showCustomLoading];
    self.navigationItem.hidesBackButton = YES;

	NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@travel.asmx", LinkAPI]];
    
	NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
															cachePolicy:NSURLRequestUseProtocolCachePolicy
														timeoutInterval:30.0];
    
	NSString * parameters = [[NSString alloc] initWithString:[self XmlRequest]];
	NSLog(@"Request=%@", parameters);
	NSString * msgLength = [NSString stringWithFormat:@"%d", [parameters length]];
	
	[request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[request addValue:@"http://tempuri.org/CallInregistrareComanda5" forHTTPHeaderField:@"SOAPAction"];
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
	
    // daca este pentru plata ONLINE
	if (succes && modPlata == 3) {
        if (idOferta != nil)
        {
            oferta.idExtern = [idOferta intValue];
            
            if (!oferta._isDirty)
                [oferta addOferta];
            else
                [oferta updateOferta];
            
            [self showCustomAlert:NSLocalizedStringFromTable(@"i449", [YTOUserDefaults getLanguage],@"Finalizare comanda") withDescription:responseMessage withError:NO withButtonIndex:3];
        }
        else
            [self showCustomAlert:NSLocalizedStringFromTable(@"i449", [YTOUserDefaults getLanguage],@"Finalizare comanda") withDescription:responseMessage withError:YES withButtonIndex:4];
        
    }
    else if (succes) {
        if (idOferta == nil || [idOferta isEqualToString:@""])
            [self showCustomAlert:NSLocalizedStringFromTable(@"i449", [YTOUserDefaults getLanguage],@"Finalizare comanda") withDescription:responseMessage withError:YES withButtonIndex:2];
        else {
            oferta.idExtern = [idOferta intValue];
            
            if (!oferta._isDirty)
                [oferta addOferta];
            else
                [oferta updateOferta];
            
            [self showCustomAlert:NSLocalizedStringFromTable(@"i449", [YTOUserDefaults getLanguage],@"Finalizare comanda") withDescription:responseMessage withError:NO withButtonIndex:1];
        }
	}
	else {
        [self showCustomAlert:NSLocalizedStringFromTable(@"i449", [YTOUserDefaults getLanguage],@"Finalizare comanda") withDescription:@"Comanda NU a fost transmisa." withError:YES withButtonIndex:4];
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
    self.navigationItem.hidesBackButton = YES;
    [self hideCustomLoading];
    [vwLoading setHidden:NO];
}
- (IBAction) hideCustomLoading
{
    self.navigationItem.hidesBackButton = NO;
    [vwLoading setHidden:YES];
    [YTOUserDefaults setFirstInsuranceRequest:YES];
    if (idOferta && ![idOferta isEqualToString:@""] && [YTOUserDefaults IsFirstInsuranceRequest])
    {
        
        [self showPopupDupaComanda];
    }
}

- (void) showPopupDupaComanda
{
    self.navigationItem.hidesBackButton = YES;
    
    if (IS_IPHONE_5) {
        viewTooltip = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
        UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
        img.tag = 1;
        [img setImage:[UIImage imageNamed:@"popup-dupa-comanda-r4.png"]];
        [viewTooltip addSubview:img];
        
        UIButton * btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
        btnClose.tag = 2;
        btnClose.frame = CGRectMake(126, 480, 70, 31);
        [btnClose addTarget:self action:@selector(closeTooltip) forControlEvents:UIControlEventTouchUpInside];
        [viewTooltip addSubview:btnClose];
    }
    else {
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
    }
    
    YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.window addSubview:viewTooltip];
    [iRate sharedInstance].usesCount +=2;
    [iRate sharedInstance].eventCount+=2;
}

- (void) closeTooltip
{
    self.navigationItem.hidesBackButton = NO;
    [viewTooltip removeFromSuperview];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) showCustomAlert:(NSString*) title withDescription:(NSString *)description withError:(BOOL) error withButtonIndex:(int) index
{
    self.navigationItem.hidesBackButton = YES;
    
    if (error){
        lblEroare.text = NSLocalizedStringFromTable(@"i799", [YTOUserDefaults getLanguage],@"Eroare !");
        lblEroare.textColor = [YTOUtils colorFromHexString:rosuTermeni];
    }else{
        lblEroare.text = NSLocalizedStringFromTable(@"i809", [YTOUserDefaults getLanguage],@"Comanda a fost inregistrata");
        lblEroare.textColor = [YTOUtils colorFromHexString:verde];
        [lblEroare setFont:[UIFont fontWithName:@"Chalkboard SE" size:16]];
        
    }
    
    btnCustomAlertOK.tag = index;
//    btnCustomAlertOK.frame = CGRectMake(124, 239, 73, 42);
//    lblCustomAlertOK.frame = CGRectMake(150, 249, 42, 21);
    
//    if (!error)
//    {
//        [btnCustomFacebook setHidden:NO];
//        [lblCustomFacebook setHidden:NO];
//        [btnCustomTwitter setHidden:NO];
//        [lblCustomTwitter setHidden:NO];
//    }
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
    if (btn.tag == 1)
    {
        if ([YTOUserDefaults IsFirstInsuranceRequest] && [YTOUserDefaults getUserName] != nil &&  ![[YTOUserDefaults getUserName] isEqualToString:@""])
            [self showPopupDupaComanda];
        else
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if (btn.tag == 3)
    {
        YTOPersoana * asig1 = [listAsigurati objectAtIndex:0];
        
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
                          idOferta, emailLivrare, asig1.nume, asig1.adresa, asig1.localitate, asig1.judet, telefonLivrare,
                          @"Calatorie", oferta.prima, oferta.companie, [[UIDevice currentDevice] xUniqueDeviceIdentifier]];
        
        NSURL * nsURL = [[NSURL alloc] initWithString:[url stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
       
        YTOWebViewController * aView = [[YTOWebViewController alloc] init];
        aView.URL = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate.rcaNavigationController pushViewController:aView animated:YES];
        //[self.navigationController popToRootViewControllerAnimated:YES];
        
     //   [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if (btn.tag == 100)
    {
        [self callInregistrareComanda];
    }
}

- (void) showCustomConfirm:(NSString *) title withDescription:(NSString *) description withButtonIndex:(int) index
{
    self.navigationItem.hidesBackButton = YES;
    
    lblEroare.text =NSLocalizedStringFromTable(@"i808", [YTOUserDefaults getLanguage],@"Datele sunt corecte ?");
    lblEroare.textColor = [YTOUtils colorFromHexString:verde];
    btnCustomAlertOK.tag = index;
//    btnCustomAlertOK.frame = CGRectMake(189, 239, 73, 42);
//    lblCustomAlertOK.frame = CGRectMake(215, 249, 42, 21);
    [lblCustomAlertOK setText:NSLocalizedStringFromTable(@"i92", [YTOUserDefaults getLanguage],@"DA")];
    
    [btnCustomAlertNO setHidden:NO];
    [lblCustomAlertNO setHidden:NO];
    
    lblCustomAlertTitle.text = title;
    lblCustomAlertMessage.text = description;
    [vwCustomAlert setHidden:NO];
}

//edi for social media
- (IBAction) hideButtonSocialMedia:(id)sender
{
    [btnCustomFacebook setHidden:YES];
    [lblCustomFacebook setHidden:YES];
    [btnCustomTwitter setHidden:YES];
    [lblCustomTwitter setHidden:YES];
    
    self.navigationItem.hidesBackButton = NO;
    UIButton * btn = (UIButton *)sender;
    [vwCustomAlert setHidden:YES];
    
    if (btn.tag == 2) {
        // share pe Facebook
        
        // ca sa vedem pe analytics cate share-uri s-au dat
        
//        id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-8624521-11"];
//        [tracker sendSocial:@"Facebook"
//                 withAction:@"Share"
//                 withTarget:@"https://developers.google.com/analytics"];
        
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) //check if Facebook Account is linked
        {
            mySLComposerSheet = [[SLComposeViewController alloc] init]; //initiate the Social Controller
            mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook]; //Tell him with what social plattform to use it, e.g. facebook or twitter
            [mySLComposerSheet setInitialText:@"Smart choice: am cumparat asigurarea de calatorie direct de pe iPhone! :) http://bit.ly/WKhiSD"]; //the message you want to post
            UIImage * img;
            UIImage *sharedImg;
            NSString *text;
            img= [UIImage imageNamed:@"socialmedia-ios-calatorie.png"];
            text = [[NSString alloc] initWithFormat:@""];
            NSString *text2 = [[NSString alloc] initWithFormat:@"  %.2f lei \n  %@",oferta.prima,oferta.companie ];
            sharedImg = [YTOUtils  drawText:text
                                    inImage:img
                                    atPoint:CGPointMake(20, 185)
                                  drawText2:text2
                                   atPoint2:CGPointMake(40, 400)];
            
            [mySLComposerSheet addImage:sharedImg]; //an image you could post
            
            
            [self presentViewController:mySLComposerSheet animated:YES completion:nil];
        }
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            int output;
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    output = 0;
                    break;
                case SLComposeViewControllerResultDone:
                    output = 1;
                    break;
                default:
                    break;
            } //check if everythink worked properly. Give out a message on the state.
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            //            [alert show];
            
            if ([YTOUserDefaults IsFirstInsuranceRequest] && [YTOUserDefaults getUserName] != nil &&  ![[YTOUserDefaults getUserName] isEqualToString:@""]) {
                if (output)
                    [self showPopupDupaComanda];
                else
                    [self showPopupDupaComanda];
            }
        }];
        
        
    }
    else {
        
        // analytics - cate tweet-uri s-au dat
        
//        id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-8624521-11"];
//        [tracker sendSocial:@"Twitter"
//                 withAction:@"Tweet"
//                 withTarget:@"https://developers.google.com/analytics"];
        
        
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) //check if Facebook Account is linked
        {
            mySLComposerSheet = [[SLComposeViewController alloc] init]; //initiate the Social Controller
            mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter]; //Tell him with what social plattform to use it, e.g. facebook or twitter
            [mySLComposerSheet setInitialText:@"Smart choice: am cumparat asigurarea de calatorie direct de pe iPhone! :) http://bit.ly/WKhiSD"]; //the message you want to post
            UIImage * img;
            UIImage *sharedImg;
            NSString *text;
            img= [UIImage imageNamed:@"socialmedia-ios-calatorie.png"];
            text = [[NSString alloc] initWithFormat:@""];
            NSString *text2 = [[NSString alloc] initWithFormat:@"  %.2f lei \n  %@",oferta.prima,oferta.companie ];
            sharedImg = [YTOUtils  drawText:text
                                    inImage:img
                                    atPoint:CGPointMake(20, 185)
                                  drawText2:text2
                                   atPoint2:CGPointMake(40, 400)];
            
            [mySLComposerSheet addImage:sharedImg]; //an image you could post
            
            
            [self presentViewController:mySLComposerSheet animated:YES completion:nil];
        }
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            int output;
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    output = 0;
                    break;
                case SLComposeViewControllerResultDone:
                    output = 1;
                    break;
                default:
                    break;
            } //check if everythink worked properly. Give out a message on the state.
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter" message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            //            [alert show];
            
           if ([YTOUserDefaults IsFirstInsuranceRequest] && [YTOUserDefaults getUserName] != nil &&  ![[YTOUserDefaults getUserName] isEqualToString:@""]) {
                if (output)
                    [self showPopupDupaComanda];
                else
                    [self showPopupDupaComanda];
            }
        }];
        
    }
}

@end
