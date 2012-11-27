//
//  YTOFinalizareCalatorieViewController.m
//  i-asigurare
//
//  Created by Administrator on 10/12/12.
//
//

#import "YTOFinalizareCalatorieViewController.h"
#import "Database.h"

@interface YTOFinalizareCalatorieViewController ()

@end

@implementation YTOFinalizareCalatorieViewController

@synthesize oferta, listAsigurati;
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
    [self initCells];


    for (int i=0; i<listAsigurati.count; i++) {
        YTOPersoana * pers = [listAsigurati objectAtIndex:i];
        if (pers.serieAct && ![pers.serieAct isEqualToString:@""])
            [self setSerieAct:pers.serieAct forIndex:i];
    }
    [self setTipPlata:@"online"];
    [self setTelefon:telefonLivrare];
    [self setEmail:emailLivrare];
    
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
    return listAsigurati.count + 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    
    int indexAfter = listAsigurati.count-1;
    
    if (indexPath.row < listAsigurati.count)
    {
        cell = (UITableViewCell *)[listCells objectAtIndex:indexPath.row];
    }
    else if (indexPath.row == (indexAfter+1)) cell = cellTelefon;
    else if (indexPath.row == (indexAfter+2)) cell = cellEmail;
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
    if (indexPath.row == listAsigurati.count + 2)
    {
        [self showCustomConfirm:@"Confirmare date" withDescription:@"Apasa DA pentru a confirma ca datele introduse sunt corecte si pentru a plasa comanda. Daca nu doresti sa continui, apasa NU." withButtonIndex:100];
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
	
	UITableViewCell *currentCell = (UITableViewCell *) [[textField superview] superview];
    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
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
    UITableViewCell *currentCell = (UITableViewCell *) [[textField superview] superview];
    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];

    int indexAfter = listAsigurati.count-1;
    
    if (indexPath.row < listAsigurati.count)
    {
        [self setSerieAct:textField.text forIndex:indexPath.row];
    }
    else if(indexPath.row == (indexAfter+1))
    {
        [self setTelefon:textField.text];
    }
    else if (indexPath.row == (indexAfter + 2))
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
    listCells = [[NSMutableArray alloc] init];
    for (int i=0; i<listAsigurati.count; i++) {
        YTOPersoana * asigurat = [listAsigurati objectAtIndex:i];
        NSArray *topLevelObjectAsigurat = [[NSBundle mainBundle] loadNibNamed:@"CellView_String" owner:self options:nil];
        UITableViewCell * cell = [topLevelObjectAsigurat objectAtIndex:0];
        [(UILabel *)[cell viewWithTag:1] setText:[NSString stringWithFormat:@"%@", [asigurat.nume uppercaseString]]];
        //[(UITextField *)[cell viewWithTag:2] setPlaceholder:@"Serie/Numar act"];
        [(UITextField *)[cell viewWithTag:2] setAutocapitalizationType:UITextAutocapitalizationTypeAllCharacters];
        [YTOUtils setCellFormularStyle:cell];
        [listCells addObject:cell];
    }
    
    NSArray *topLevelObjectsEmail = [[NSBundle mainBundle] loadNibNamed:@"CellView_String" owner:self options:nil];
    cellEmail = [topLevelObjectsEmail objectAtIndex:0];
    [(UILabel *)[cellEmail viewWithTag:1] setText:@"EMAIL"];
    [(UITextField *)[cellEmail viewWithTag:2] setPlaceholder:@""];
    [(UITextField *)[cellEmail viewWithTag:2] setKeyboardType:UIKeyboardTypeEmailAddress];
    [YTOUtils setCellFormularStyle:cellEmail];
    
    NSArray *topLevelObjectsTelefon = [[NSBundle mainBundle] loadNibNamed:@"CellView_Numeric" owner:self options:nil];
    cellTelefon = [topLevelObjectsTelefon objectAtIndex:0];
    [(UILabel *)[cellTelefon viewWithTag:1] setText:@"TELEFON"];
    [(UITextField *)[cellTelefon viewWithTag:2] setPlaceholder:@""];
    [(UITextField *)[cellTelefon viewWithTag:2] setKeyboardType:UIKeyboardTypeNumberPad];
    [YTOUtils setCellFormularStyle:cellTelefon];
    
    NSArray *topLevelObjectscalc = [[NSBundle mainBundle] loadNibNamed:@"CellCalculeaza" owner:self options:nil];
    cellCalculeaza = [topLevelObjectscalc objectAtIndex:0];
    UIImageView * imgComanda = (UIImageView *)[cellCalculeaza viewWithTag:1];
    imgComanda.image = [UIImage imageNamed:@"comanda-calatorie.png"];
    UILabel * lblCellC = (UILabel *)[cellCalculeaza viewWithTag:2];
    lblCellC.textColor = [UIColor whiteColor];
    lblCellC.text = @"COMANDA";
}

- (void) setSerieAct:(NSString *)serie forIndex:(int)index
{
    YTOPersoana * asigurat = [listAsigurati objectAtIndex:index];
    asigurat.serieAct = serie;
    UITextField * txt = (UITextField *)[(UITableViewCell*)[listCells objectAtIndex:index] viewWithTag:2];
    txt.text = serie;
}
- (void) setEmail:(NSString *)email
{
    emailLivrare = email;
    UITextField * txt = (UITextField *)[cellEmail viewWithTag:2];
    txt.text = email;
}

- (void) setTelefon:(NSString *)telefon
{
    telefonLivrare = telefon;
    UITextField * txt = (UITextField *)[cellTelefon viewWithTag:2];
    txt.text = telefon;
}

- (void) setTipPlata:(NSString *)p
{
    if ([p isEqualToString:@"online"])
        modPlata = 3;
}

#pragma mark Consume WebService

- (NSString *) XmlRequest
{
    NSString * xml = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                      "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                      "<soap:Body>"
                      "<CallInregistrareComanda xmlns=\"http://tempuri.org/\">"
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
                      "</CallInregistrareComanda>"
                      "</soap:Body>"
                      "</soap:Envelope>",
                      oferta.prima, oferta.companie, oferta.numeAsigurare, oferta.codOferta, [YTOUtils formatDate:oferta.dataInceput withFormat:@"yyyy-MM-dd"],
                      [YTOPersoana getJsonPersoane:listAsigurati],
                      emailLivrare, telefonLivrare, modPlata,
                      [[UIDevice currentDevice] uniqueIdentifier], [[UIDevice currentDevice].model stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
    return xml;
}

- (IBAction) callInregistrareComanda {
    [self showCustomLoading];
    self.navigationItem.hidesBackButton = YES;

	NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@travel.asmx", LinkAPI]];
    
	NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
															cachePolicy:NSURLRequestUseProtocolCachePolicy
														timeoutInterval:15.0];
    
	NSString * parameters = [[NSString alloc] initWithString:[self XmlRequest]];
	NSLog(@"Request=%@", parameters);
	NSString * msgLength = [NSString stringWithFormat:@"%d", [parameters length]];
	
	[request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[request addValue:@"http://tempuri.org/CallInregistrareComanda" forHTTPHeaderField:@"SOAPAction"];
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
	//to do parseXML
	NSXMLParser * xmlParser = [[NSXMLParser alloc] initWithData:responseData];
	xmlParser.delegate = self;
	BOOL succes = [xmlParser parse];
	
    // daca este pentru plata ONLINE
	if (succes && modPlata == 3) {
        [self showCustomAlert:@"Finalizare comanda" withDescription:responseMessage withError:NO withButtonIndex:3];
    }
    else if (succes) {
        if (idOferta == nil || [idOferta isEqualToString:@""])
            [self showCustomAlert:@"Finalizare comanda" withDescription:responseMessage withError:YES withButtonIndex:2];
        else {
            oferta.idExtern = [idOferta intValue];
            
            if (!oferta._isDirty)
                [oferta addOferta];
            else
                [oferta updateOferta];
            
            [self showCustomAlert:@"Finalizare comanda" withDescription:responseMessage withError:NO withButtonIndex:1];
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
    [self hideCustomLoading];
    [vwLoading setHidden:NO];
}
- (IBAction) hideCustomLoading
{
    [vwLoading setHidden:YES];
}

- (void) showCustomAlert:(NSString*) title withDescription:(NSString *)description withError:(BOOL) error withButtonIndex:(int) index
{
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
    UIButton * btn = (UIButton *)sender;
    [vwCustomAlert setHidden:YES];
    if (btn.tag == 1)
        [self.navigationController popToRootViewControllerAnimated:YES];
    else if (btn.tag == 3)
    {
        // to do plata ONLINE
    }
    else if (btn.tag == 100)
        [self callInregistrareComanda];
}

- (void) showCustomConfirm:(NSString *) title withDescription:(NSString *) description withButtonIndex:(int) index
{
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

@end
