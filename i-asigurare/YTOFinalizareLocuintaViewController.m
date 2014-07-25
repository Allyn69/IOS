//
//  YTOFinalizareLocuintaViewController.m
//  i-asigurare
//
//  Created by Andi Aparaschivei on 11/8/12.
//
//

#import "YTOFinalizareLocuintaViewController.h"
#import "Database.h"
#import "YTOAppDelegate.h"
#import "YTOUserDefaults.h"
#import "YTOToast.h"
#import "YTOWebViewController.h"

@interface YTOFinalizareLocuintaViewController ()

@end

@implementation YTOFinalizareLocuintaViewController

@synthesize oferta, locuinta, asigurat, responseData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title =NSLocalizedStringFromTable(@"i449", [YTOUserDefaults getLanguage],@"Finalizare comanda");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.trackedViewName = @"YTOFinalizareLocuintaViewController";
    if (IS_OS_7_OR_LATER){
        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars=NO;
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    proprietar = [YTOPersoana Proprietar];
    
    goingBack = YES;
    [self initCells];
    [self setTipPlata:@"op"];
    [self setLocalitate:asigurat.localitate];
    [self setJudet:asigurat.judet];
    [self setAdresa:asigurat.adresa];
    [self setTelefon:asigurat.telefon];
    [self setEmail:asigurat.email];
    if (locuinta.cesiune){
        [self setCesiune:locuinta.mentiuneCesiune];
        [self setCuiBanca:locuinta.cuiBanca];
    }
     [YTOUtils rightImageVodafone:self.navigationItem];
    
    lblModPlata.text = NSLocalizedStringFromTable(@"i90", [YTOUserDefaults getLanguage],@"Modalitate de plata");
    lblCard.text = NSLocalizedStringFromTable(@"i179", [YTOUserDefaults getLanguage],@"ONLINE, \n cu cardul");
    lblPlataOP.text = NSLocalizedStringFromTable(@"i178", [YTOUserDefaults getLanguage],@"Prin OP / \n transfer");
    lblCustomAlertNO.text = NSLocalizedStringFromTable(@"i344", [YTOUserDefaults getLanguage],@"NU");
    lblCustomAlertOK.text = NSLocalizedStringFromTable(@"i343", [YTOUserDefaults getLanguage],@"DA");
    lblCustomFacebook.text = NSLocalizedStringFromTable(@"i592", [YTOUserDefaults getLanguage],@"fb");
    lblCustomTwitter.text = NSLocalizedStringFromTable(@"i593", [YTOUserDefaults getLanguage],@"tweet");
    lblLoading.text = NSLocalizedStringFromTable(@"i444", [YTOUserDefaults getLanguage],@"loading");
    lblEroare.text = NSLocalizedStringFromTable(@"i799", [YTOUserDefaults getLanguage],@"Eroare !");
    lblEroare.textColor = [YTOUtils colorFromHexString:rosuTermeni];
    
    UIImageView * img = (UIImageView *)[cellHeader viewWithTag:0];
    img.image = nil;
    if ([[YTOUserDefaults getLanguage] isEqualToString:@"hu"])
        img.image = [UIImage imageNamed:@"asig-locuinte-hu.png"];
    else if ([[YTOUserDefaults getLanguage] isEqualToString:@"en"])
        img.image = [UIImage imageNamed:@"asig-locuinte-en.png"];
    else img.image = [UIImage imageNamed:@"asig-locuinte.png"];
    UILabel * lblView1 = (UILabel *) [cellHeader viewWithTag:11];
    UILabel * lblView2 = (UILabel *) [cellHeader viewWithTag:22];
    lblView1.backgroundColor = [YTOUtils colorFromHexString:albastruLocuinta];
    lblView2.backgroundColor = [YTOUtils colorFromHexString:albastruLocuinta];
    
    UILabel *lbl1 = (UILabel *) [cellHeader viewWithTag:1];
    UILabel *lbl2 = (UILabel *) [cellHeader viewWithTag:2];
    UILabel *lbl3 = (UILabel *) [cellHeader viewWithTag:3];
    lbl1.textColor = [YTOUtils colorFromHexString:albastruLocuinta];
    
    lbl1.text = NSLocalizedStringFromTable(@"i794", [YTOUserDefaults getLanguage],@"Finalizare comanda");
    lbl2.text = NSLocalizedStringFromTable(@"i795", [YTOUserDefaults getLanguage],@"Vei primi polita de asigurare");
    lbl3.text = NSLocalizedStringFromTable(@"i796", [YTOUserDefaults getLanguage],@"pe adresa ta de e-mail");
    cellHeader.userInteractionEnabled = NO;
    lbl1.adjustsFontSizeToFitWidth = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (locuinta.cesiune)
        return 8;
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (locuinta.cesiune && indexPath.row == 6)
        return 100;
    else if (!locuinta.cesiune && indexPath.row == 4)
        return 100;
    return 62;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    if (locuinta.cesiune){
        if (indexPath.row == 0) cell = cellJudetLocalitate;
        else if (indexPath.row == 1) cell = cellAdresa;
        else if (indexPath.row == 2) cell = cellTelefon;
        else if (indexPath.row == 3) cell = cellEmail;
        else if (indexPath.row == 4) cell = cellCesiune;
        else if (indexPath.row == 5) cell = cellCuiBanca;
        else if (indexPath.row == 6) cell = cellPlata;
        else cell = cellCalculeaza;
    }else {
        if (indexPath.row == 0) cell = cellJudetLocalitate;
        else if (indexPath.row == 1) cell = cellAdresa;
        else if (indexPath.row == 2) cell = cellTelefon;
        else if (indexPath.row == 3) cell = cellEmail;
        else if (indexPath.row == 4) cell = cellPlata;
        else cell = cellCalculeaza;
    }
    
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
    else if ((indexPath.row == 7 && locuinta.cesiune) || (indexPath.row == 5 && !locuinta.cesiune))
    {
        [self doneEditing];
        [self doneEditing];
        
        if (txtTelefonLivrare.text.length == 0)
        {
            [txtTelefonLivrare becomeFirstResponder];
            return;
        }
        if (txtTelefonLivrare.text.length !=10)
        {
            [[[[iToast makeText:NSLocalizedString(@"Ai introdus gresit numarul de telefon", @"")]
               setGravity:iToastGravityCenter] setDuration:iToastDurationShort] show];
            [txtTelefonLivrare becomeFirstResponder];
            return;
        }
        if (txtEmailLivrare.text.length == 0)
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
        
        [self showCustomConfirm:NSLocalizedStringFromTable(@"i451", [YTOUserDefaults getLanguage],@"Confirma date") withDescription:NSLocalizedStringFromTable(@"i452", [YTOUserDefaults getLanguage],@"Apasa DA pentru a confirma ca datele introduse sunt corecte si pentru a plasa comanda. Daca nu doresti sa continui apasa NU") withButtonIndex:100];
    }
}

#pragma mark TEXTFIELD
- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    UITableViewCell *currentCell;
    if (IS_OS_7_OR_LATER) currentCell = (UITableViewCell *) textField.superview.superview.superview;
    else currentCell =  (UITableViewCell *) [[textField superview] superview];
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

    UITableViewCell *currentCell;
    if (IS_OS_7_OR_LATER) currentCell = (UITableViewCell *) textField.superview.superview.superview;
    else currentCell =  (UITableViewCell *) [[textField superview] superview];
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
    else if (index == 4 && locuinta.cesiune)
    {
        [self setCesiune:textField.text];
    }
    else if (index == 5 && locuinta.cesiune)
    {
        [self setCuiBanca:textField.text];
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
    NSArray *topLevelObjectsJudet = [[NSBundle mainBundle] loadNibNamed:@"CellView_Nomenclator" owner:self options:nil];
    cellJudetLocalitate = [topLevelObjectsJudet objectAtIndex:0];
    [(UILabel *)[cellJudetLocalitate viewWithTag:1] setText:NSLocalizedStringFromTable(@"i120", [YTOUserDefaults getLanguage],@"LIVRARE(JUDET,LOCALITATE)")];
    [YTOUtils setCellFormularStyle:cellJudetLocalitate];
    
    NSArray *topLevelObjectsAdresa = [[NSBundle mainBundle] loadNibNamed:@"CellView_String" owner:self options:nil];
    cellAdresa = [topLevelObjectsAdresa objectAtIndex:0];
    [(UILabel *)[cellAdresa viewWithTag:1] setText:NSLocalizedStringFromTable(@"i121", [YTOUserDefaults getLanguage],@"LIVRARE (STRADA,NUMAR,BLOC)")];
    [(UITextField *)[cellAdresa viewWithTag:2] setAutocapitalizationType:UITextAutocapitalizationTypeAllCharacters];
    [YTOUtils setCellFormularStyle:cellAdresa];
    
    NSArray *topLevelObjectsEmail = [[NSBundle mainBundle] loadNibNamed:@"CellView_String" owner:self options:nil];
    cellEmail = [topLevelObjectsEmail objectAtIndex:0];
    txtEmailLivrare = (UITextField *)[cellEmail viewWithTag:2];
    [(UILabel *)[cellEmail viewWithTag:1] setText:@"EMAIL"];
    [(UITextField *)[cellEmail viewWithTag:2] setPlaceholder:@""];
    [(UITextField *)[cellEmail viewWithTag:2] setKeyboardType:UIKeyboardTypeEmailAddress];
    [YTOUtils setCellFormularStyle:cellEmail];
    
    NSArray *topLevelObjectsCesiune = [[NSBundle mainBundle] loadNibNamed:@"CellView_String" owner:self options:nil];
    cellCesiune = [topLevelObjectsCesiune objectAtIndex:0];
    txtCesiune = (UITextField *)[cellCesiune viewWithTag:2];
    [txtCesiune setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
    [(UILabel *)[cellCesiune viewWithTag:1] setText:@"MENTIUNE DE CESIUNE"];
    [(UITextField *)[cellCesiune viewWithTag:2] setPlaceholder:@"introdu aici textul pentru cesiune"];
    [(UITextField *)[cellCesiune viewWithTag:2] setKeyboardType:UIKeyboardTypeDefault];
    [YTOUtils setCellFormularStyle:cellCesiune];
    
    NSArray *topLevelObjectsCuiBanca = [[NSBundle mainBundle] loadNibNamed:@"CellView_Numeric" owner:self options:nil];
    cellCuiBanca = [topLevelObjectsCuiBanca objectAtIndex:0];
    txtCuiBanca = (UITextField *)[cellCuiBanca viewWithTag:2];
    [(UILabel *)[cellCuiBanca viewWithTag:1] setText:@"CUI BANCA (CESIUNE)"];
    [(UITextField *)[cellCuiBanca viewWithTag:2] setPlaceholder:@""];
    [(UITextField *)[cellCuiBanca viewWithTag:2] setKeyboardType:UIKeyboardTypeNumberPad];
    [YTOUtils setCellFormularStyle:cellCuiBanca];
    
    NSArray *topLevelObjectsTelefon = [[NSBundle mainBundle] loadNibNamed:@"CellView_Numeric" owner:self options:nil];
    cellTelefon = [topLevelObjectsTelefon objectAtIndex:0];
    txtTelefonLivrare = (UITextField *)[cellTelefon viewWithTag:2];
    [(UILabel *)[cellTelefon viewWithTag:1] setText:NSLocalizedStringFromTable(@"i244", [YTOUserDefaults getLanguage],@"TELEFON")];
    [(UITextField *)[cellTelefon viewWithTag:2] setPlaceholder:@""];
    [(UITextField *)[cellTelefon viewWithTag:2] setKeyboardType:UIKeyboardTypeNumberPad];
    [YTOUtils setCellFormularStyle:cellTelefon];
    
    
    
    NSArray *topLevelObjectscalc = [[NSBundle mainBundle] loadNibNamed:@"CellCalculeaza" owner:self options:nil];
    cellCalculeaza = [topLevelObjectscalc objectAtIndex:0];
    UIImageView * imgComanda = (UIImageView *)[cellCalculeaza viewWithTag:1];
    imgComanda.image = [UIImage imageNamed:@"comanda-locuinta.png"];
    UILabel * lblCellC = (UILabel *)[cellCalculeaza viewWithTag:2];
    lblCellC.textColor = [UIColor whiteColor];
    lblCellC.text = NSLocalizedStringFromTable(@"i96", [YTOUserDefaults getLanguage],@"COMANDA");
}

- (void) showListaJudete:(NSIndexPath *)index
{
    goingBack = NO;
    PickerVCSearch * actionPicker = [[PickerVCSearch alloc]initWithNibName:@"PickerVCSearch" bundle:nil];
    actionPicker.listOfItems = [[NSMutableArray alloc] initWithArray:[Database Judete]];
    actionPicker._indexPath = index;
    actionPicker.nomenclator = kJudete;
    actionPicker.delegate = self;
    actionPicker.titlu = NSLocalizedStringFromTable(@"i304", [YTOUserDefaults getLanguage],@"Judete");
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
    UILabel * lbl = (UILabel *)[cellJudetLocalitate viewWithTag:2];
    lbl.text = [[judetLivrare stringByAppendingString:@","] stringByAppendingString:localitateLivrare];
}

- (void) setLocalitate:(NSString *)localitate
{
    localitateLivrare = localitate;
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
    }
    
    emailLivrare = email;
    txtEmailLivrare.text = email;
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
    }
    
    telefonLivrare = telefon;
    txtTelefonLivrare.text = telefon;

}

- (void) setCesiune : (NSString*) cesiune
{
    if (locuinta.cesiune && ![cesiune isEqualToString:@"" ])
        locuinta.mentiuneCesiune = cesiune;
    txtCesiune.text = cesiune;
}

- (void) setCuiBanca : (NSString*) cuiBanca
{
    if (locuinta.cesiune && ![cuiBanca isEqualToString:@""])
        locuinta.cuiBanca = cuiBanca;
    txtCuiBanca.text = cuiBanca;
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
                      "<CallInregistrareComandaSmartphone2 xmlns=\"http://tempuri.org/\">"
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
                      "<cesionar>%@</cesionar>"
                      "<cui_cesionar>%@</cui_cesionar>"
                      "<sendEmail>1</sendEmail>"
                      "<cont_user>%@</cont_user>"
                      "<cont_parola>%@</cont_parola>"
                      "</CallInregistrareComandaSmartphone2>"
                      "</soap:Body>"
                      "</soap:Envelope>",
                      oferta.prima, oferta.companie, [oferta LocuintaTipProdus], oferta.codOferta, [YTOUtils formatDate:oferta.dataInceput withFormat:@"yyyy-MM-dd"],
                      asigurat.nume, asigurat.codUnic, emailLivrare, telefonLivrare, modPlata,
                      [[UIDevice currentDevice] xUniqueDeviceIdentifier], [[UIDevice currentDevice].model stringByReplacingOccurrencesOfString:@" " withString:@"_"],
                      locuinta.idIntern,txtCesiune.text,txtCuiBanca.text, [YTOUserDefaults getUserName], [YTOUserDefaults getPassword]];
    return xml;
}

- (IBAction) callInregistrareComanda {
    [self showCustomLoading];
    self.navigationItem.hidesBackButton = YES;

	NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@locuinta.asmx", LinkAPI]];
    
	NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
															cachePolicy:NSURLRequestUseProtocolCachePolicy
														timeoutInterval:30.0];
    
	NSString * parameters = [[NSString alloc] initWithString:[self XmlRequest]];
	NSLog(@"Request=%@", parameters);
	NSString * msgLength = [NSString stringWithFormat:@"%d", [parameters length]];
	
	[request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[request addValue:@"http://tempuri.org/CallInregistrareComandaSmartphone2" forHTTPHeaderField:@"SOAPAction"];
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
                [self showCustomAlert:NSLocalizedStringFromTable(@"i449", [YTOUserDefaults getLanguage],@"Finalizare comanda") withDescription:responseMessage withError:NO withButtonIndex:3];
            }
            else [self showCustomAlert:NSLocalizedStringFromTable(@"i449", [YTOUserDefaults getLanguage],@"Finalizare comanda") withDescription:responseMessage withError:NO withButtonIndex:1];
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
    [self showCustomAlert:NSLocalizedStringFromTable(@"i123", [YTOUserDefaults getLanguage],@"Atentie !") withDescription:[error localizedDescription] withError:YES withButtonIndex:4];
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
    [YTOUserDefaults setFirstInsuranceRequest:YES];
    
    if (idOferta && ![idOferta isEqualToString:@""] && [YTOUserDefaults IsFirstInsuranceRequest])
    {
       
     //   [self showPopupDupaComanda:@""];
    }
    
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
    [lblCustomAlertOK setText:@"OK"];
    [btnCustomAlertNO setHidden:YES];
    [lblCustomAlertNO setHidden:YES];
    
    if (modPlata != 3 && !SYSTEM_VERSION_LESS_THAN(@"6.0") && !error){
        [btnCustomFacebook setHidden:NO];
        [lblCustomFacebook setHidden:NO];
        [btnCustomTwitter setHidden:NO];
        [lblCustomTwitter setHidden:NO];
    }
    
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
//        if (true)
//            [self showPopupDupaComanda:@""];
//        else
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
                          @"Locuinta", oferta.prima, oferta.companie, [[[UIDevice currentDevice] xUniqueDeviceIdentifier] stringByAppendingString:[NSString stringWithFormat:@"---%@",locuinta.idIntern]]];
        
        NSURL * nsURL = [[NSURL alloc] initWithString:[url stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
        
        YTOWebViewController * aView = [[YTOWebViewController alloc] init];
        aView.URL = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate.rcaNavigationController pushViewController:aView animated:YES];
  //      [self.navigationController popToRootViewControllerAnimated:YES];

    }
    else if (btn.tag == 100)
    {
        [self doneEditing];
        
        if (telefonLivrare.length == 0 || emailLivrare.length == 0)
        {
            return;
        }
        if (locuinta.cesiune)
            [locuinta updateLocuinta:YES];
        locuinta.cesiune = NO;
        [self callInregistrareComanda];
    }
//    else
//        [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) showCustomConfirm:(NSString *) title withDescription:(NSString *) description withButtonIndex:(int) index
{
    self.navigationItem.hidesBackButton = YES;
    
    lblEroare.text = NSLocalizedStringFromTable(@"i808", [YTOUserDefaults getLanguage],@"Datele sunt corecte ?");
    lblEroare.textColor = [YTOUtils colorFromHexString:verde];
    btnCustomAlertOK.tag = index;
//    btnCustomAlertOK.frame = CGRectMake(189, 239, 73, 42);
//    lblCustomAlertOK.frame = CGRectMake(215, 249, 42, 21);
    [lblCustomAlertOK setText:NSLocalizedStringFromTable(@"i343", [YTOUserDefaults getLanguage],@"DA")];
    
    [btnCustomAlertNO setHidden:NO];
    [lblCustomAlertNO setHidden:NO];
    
    lblCustomAlertTitle.text = title;
    lblCustomAlertMessage.text = description;
    [vwCustomAlert setHidden:NO];
}

- (void) showPopupDupaComanda:(NSString*) share
{
    self.navigationItem.hidesBackButton = YES;
    
    if (IS_IPHONE_5) {
        viewTooltip = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
        UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
        img.tag = 1;
        [img setImage:[UIImage imageNamed:@"popup-dupa-comanda-r4.png"]];
        
        [viewTooltip addSubview:img];
        
        if ([share isEqualToString:@"Fb"]) {
            UIImageView * imgFb = [[UIImageView alloc] initWithFrame:CGRectMake(45, 150, 238, 50)];
            [imgFb setImage:[UIImage imageNamed:@"popup-facebook.png"]];
            [img addSubview:imgFb];
        }
        else if ([share isEqualToString:@"Tweet"]) {
            UIImageView * imgTw = [[UIImageView alloc] initWithFrame:CGRectMake(45, 150, 238, 50)];
            [imgTw setImage:[UIImage imageNamed:@"popup-twitter.png"]];
            [img addSubview:imgTw];
        }
        
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
        
        if ([share isEqualToString:@"Fb"]) {
            UIImageView * imgFb = [[UIImageView alloc] initWithFrame:CGRectMake(45, 110, 238, 50)];
            [imgFb setImage:[UIImage imageNamed:@"popup-facebook.png"]];
            [img addSubview:imgFb];
        }
        else if ([share isEqualToString:@"Tweet"]) {
            UIImageView * imgTw = [[UIImageView alloc] initWithFrame:CGRectMake(45, 110, 238, 50)];
            [imgTw setImage:[UIImage imageNamed:@"popup-twitter.png"]];
            [img addSubview:imgTw];
        }
        
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
        YTOFinalizareLocuintaViewController *self_ = self;
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) //check if Facebook Account is linked
        {
            mySLComposerSheet = [[SLComposeViewController alloc] init]; //initiate the Social Controller
            mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook]; //Tell him with what social plattform to use it, e.g. facebook or twitter
            NSString *byPlatforma = [[NSString alloc] initWithFormat:@"Smart choice: am cumparat asigurarea de locuinta direct de pe %@! :) http://bit.ly/WKhiSD",[[UIDevice currentDevice].model stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
            [mySLComposerSheet setInitialText:byPlatforma]; //the message you want to post
            UIImage * img;
            UIImage *sharedImg;
            NSString *text;
            img= [UIImage imageNamed:@"socialmedia-ios-locuinta.png"];
            text = [[NSString alloc] initWithFormat:@""];
            NSString *text2 = [[NSString alloc] initWithFormat:@"  %.0f EUR \n  %@",oferta.prima,oferta.companie ];
            sharedImg = [YTOUtils  drawText:text
                                    inImage:img
                                    atPoint:CGPointMake(20, 185)
                                  drawText2:text2
                                   atPoint2:CGPointMake(55, 400)];
            
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
            
//            if ([YTOUserDefaults IsFirstInsuranceRequest] && [YTOUserDefaults getUserName] != nil &&  ![[YTOUserDefaults getUserName] isEqualToString:@""]){
//                if (output)
//                    [self showPopupDupaComanda:@"Fb"];
//                else
//                    [self showPopupDupaComanda:@""];
//            }
//            else
                [self_.navigationController popToRootViewControllerAnimated:YES];
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
            NSString *byPlatforma = [[NSString alloc] initWithFormat:@"Smart choice: am cumparat asigurarea de locuinta direct de pe %@! :) http://bit.ly/WKhiSD",[[UIDevice currentDevice].model stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
            [mySLComposerSheet setInitialText:byPlatforma]; //the message you want to post
            UIImage * img;
            UIImage *sharedImg;
            NSString *text;
            img= [UIImage imageNamed:@"socialmedia-ios-locuinta.png"];
            text = [[NSString alloc] initWithFormat:@""];
            NSString *text2 = [[NSString alloc] initWithFormat:@"  %.0f EUR \n  %@",oferta.prima,oferta.companie ];
            sharedImg = [YTOUtils  drawText:text
                                    inImage:img
                                    atPoint:CGPointMake(20, 185)
                                  drawText2:text2
                                   atPoint2:CGPointMake(40, 400)];
            
            [mySLComposerSheet addImage:sharedImg]; //an image you could post
            
            
            [self presentViewController:mySLComposerSheet animated:YES completion:nil];
        }
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
             [mySLComposerSheet dismissViewControllerAnimated:YES completion:nil];
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
            
//            if ([YTOUserDefaults IsFirstInsuranceRequest] && [YTOUserDefaults getUserName] != nil &&  ![[YTOUserDefaults getUserName] isEqualToString:@""]) {
//                if (output)
//                    [self showPopupDupaComanda:@"Tweet"];
//                else
//                    [self showPopupDupaComanda:@""];
//            }
//            else
                [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        
    }
}


@end
