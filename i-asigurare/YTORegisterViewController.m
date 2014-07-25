//
//  YTOLoginViewController.m
//  i-asigurare
//
//  Created by Stern Edi on 14/01/14.
//
//

#import "YTORegisterViewController.h"
#import "YTOUserDefaults.h"
#import "VerifyNet.h"

@interface YTORegisterViewController ()

@end

@implementation YTORegisterViewController

@synthesize controller,fieldArray;
//@synthesize indexAsigurat;
@synthesize responseData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        self.title = @"Intra in cont";
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
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
    }else [tableView setBackgroundView: nil];
    isOkToRegister = YES;
    //self.trackedViewName = @"YTOLoginViewController";
    [tableView setAllowsSelection:YES];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardDidShowNotification object:nil];
    
    [self initCells];
    [YTOUtils rightImageVodafone:self.navigationItem];
    UILabel *lbl11 = (UILabel * ) [cellHead viewWithTag:11];
    //UILabel *lbl22 = (UILabel * ) [cellHead viewWithTag:22];
    keyboardFirstTimeActive = YES;
    NSString *string1 = @"Cont nou";
    NSString *string2 = @"i-Asigurare";
    NSString *string  = [[NSString alloc]initWithFormat:@"%@ %@",string1,string2];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")){
        NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        [attributedString beginEditing];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[YTOUtils colorFromHexString:rosuProfil] range:NSMakeRange(0, string1.length+1)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[YTOUtils colorFromHexString:ColorTitlu] range:NSMakeRange(string1.length+1, string2.length)];
        [attributedString beginEditing];
        
        [lbl11 setAttributedText:attributedString];
    }else{
        [lbl11 setText:string];
        [lbl11 setTextColor:[YTOUtils colorFromHexString:rosuProfil]];
    }
    
    YTOPersoana * proprietar = [YTOPersoana Proprietar];
    YTOPersoana * proprietarPJ = [YTOPersoana ProprietarPJ];
    NSString * email;
    if (proprietar.email && proprietar.email.length > 0)
        email = proprietar.email;
    else if (proprietarPJ.email && proprietarPJ.email.length > 0)
        email = proprietarPJ.email;
    txtUser.text = email;
    txtUserConfirm.text = email;
}

- (void) viewDidAppear:(BOOL)animated
{
    wasEmailChecked = NO;
    YTOPersoana * proprietar = [YTOPersoana Proprietar];
    YTOPersoana * proprietarPJ = [YTOPersoana ProprietarPJ];
    NSString * email;
    if (proprietar.email && proprietar.email.length > 0)
        email = proprietar.email;
    else if (proprietarPJ.email && proprietarPJ.email.length > 0)
        email = proprietarPJ.email;
    txtUser.text = email;
    txtUserConfirm.text = email;
}


- (void)keyboardWillShow {
    
    keyboardFirstTimeActive = YES;
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
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell;
    
    if (indexPath.row == 0) cell = cellUser;
    else if (indexPath.row == 1) cell = cellUserConfirm;
    else if (indexPath.row == 2) cell = cellPassword;
    else if (indexPath.row == 3) cell = cellPasswordConfirm;
    else if (indexPath.row == 4) cell = cellRegister;
    
    if (indexPath.row % 2 == 0) {
        CGRect frame = CGRectMake(0, 0, 320, 60);
        UIView *bgColor = [[UIView alloc] initWithFrame:frame];
        [cell addSubview:bgColor];
        [cell sendSubviewToBack:bgColor];
        bgColor.backgroundColor = [YTOUtils colorFromHexString:@"#fafafa"];
    }
    
    return cell;
}


#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self doneEditing];
    if (indexPath.row == 4)
    {
        isOkToRegister = YES;
        if (![txtPassword.text isEqualToString:txtPasswordConfirm.text] || ![YTOUtils validateEmail:txtUser.text])
        {
            [cellPassword viewWithTag:10].hidden = NO;
            [cellPasswordConfirm viewWithTag:10].hidden = NO;
            isOkToRegister = NO;
            return;
        }else {
            [cellPassword viewWithTag:10].hidden = YES;
            [cellPasswordConfirm viewWithTag:10].hidden = YES;
        }
        if (![txtPassword.text isEqualToString:txtPasswordConfirm.text])
        {
            [cellPassword viewWithTag:10].hidden = NO;
            [cellPasswordConfirm viewWithTag:10].hidden = NO;
            isOkToRegister = NO;
            return;
        }else {
            [cellPassword viewWithTag:10].hidden = YES;
            [cellPasswordConfirm viewWithTag:10].hidden = YES;
        }
        VerifyNet * vn = [[VerifyNet alloc] init];
        if (![vn hasConnectivity]){
            [self showPopup:@"Eroare" withDescription:@"Ne pare rau! \nCererea nu a fost trimisa pentru ca nu esti conectat la internet. \nTe rugam sa te asiguri ca ai o conexiune la internet activa si sa incerci din nou.\n Iti multumim!" withCollor:[YTOUtils colorFromHexString:rosuTermeni]];
            return;
        }
        if (!emailIsOK)
        {
            [cellUser viewWithTag:10].hidden = NO;
            [cellUserConfirm viewWithTag:10].hidden = NO;
            isOkToRegister = NO;
            [self showPopup:@"Adresa de e-mail indisponibila" withDescription:@"Exista deja un cont creat pentru aceasta adresa de e-mail" withCollor:[YTOUtils colorFromHexString:rosuTermeni]];
            return;
        }
        if (isOkToRegister){
            if ([vn hasConnectivity])
                [self callRegister];
            else  [self showPopup:@"Eroare" withDescription:@"Ne pare rau! \nCererea nu a fost trimisa pentru ca nu esti conectat la internet. \nTe rugam sa te asiguri ca ai o conexiune la internet activa si sa incerci din nou.\n Iti multumim!" withCollor:[YTOUtils colorFromHexString:rosuTermeni]];
        }
    }
}

#pragma mark TEXTFIELD


- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    UITableViewCell *currentCell;
    currentCell =  (UITableViewCell *) [[textField superview] superview];
    NSIndexPath *indexPath;
    if (IS_OS_7_OR_LATER){
        UIView* contentView =[textField superview];
        CGPoint center = [self->tableView convertPoint:textField.center fromView:contentView];
        indexPath =[tableView indexPathForRowAtPoint:center];
    }
    else indexPath = [tableView indexPathForCell:currentCell];
    
    
    
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditing)];
    
    UIBarButtonItem *flexButton1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *prevButton =[[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"prev", [YTOUserDefaults getLanguage],@"Inapoi")style:UIBarButtonItemStyleBordered target:self action:@selector(prevEditing)];
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"next", [YTOUserDefaults getLanguage],@"Inainte") style:UIBarButtonItemStyleBordered  target:self action:@selector(nextEditing)];
    
    
    NSArray *itemsArray = [NSArray arrayWithObjects: prevButton, nextButton, flexButton1, doneButton, nil];
    
    
    [toolbar setItems:itemsArray];
    [activeTextField setInputAccessoryView:toolbar];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UIView *keyboardView = [[UIView alloc] initWithFrame:CGRectMake(0, 265, 320, 215)];
    tableView.tableFooterView = keyboardView;
    
    UITableViewCell *currentCell;
    currentCell =  (UITableViewCell *) [[textField superview] superview];
    NSIndexPath *indexPath;
    if (IS_OS_7_OR_LATER){
        UIView* contentView =[textField superview];
        CGPoint center = [self->tableView convertPoint:textField.center fromView:contentView];
        indexPath =[tableView indexPathForRowAtPoint:center];
    }
    else indexPath = [tableView indexPathForCell:currentCell];
    
    
    
    int index = 0;
    
    if (indexPath != nil)
        index = indexPath.row;
    else
        index = textField.tag;
    
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:indexPath.section]
                     atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
	activeTextField = textField;
	//tableView.contentInset = UIEdgeInsetsMake(65, 0, 210, 0);
    
    activeTextField.tag = indexPath.row;
    
	return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    
	if(activeTextField == textField)
	{
		activeTextField = nil;
	}
    
	[textField resignFirstResponder];
	//btnDone.enabled = NO;
    [self doneEditing];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
	return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    UITableViewCell *currentCell ;
    if (IS_OS_7_OR_LATER) currentCell = (UITableViewCell *) activeTextField.superview.superview.superview;
    else currentCell =  (UITableViewCell *) [[activeTextField superview] superview];
    
    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
    
    // In cazul in care tastatura este activa si se da back
    int index = 0;
    if (indexPath != nil)
        index = indexPath.row;
    else
        index = textField.tag;
    
    // Verifica adresa de email
    if (index == 1)
        [self callCheckEmail];
}

-(IBAction) doneEditing
{
    tableView.tableFooterView = nil;
    [activeTextField resignFirstResponder];
	activeTextField = nil;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
	[self deleteBarButton];
}


-(void) nextEditing
{
    UITableViewCell *currentCell;
    if (IS_OS_7_OR_LATER) currentCell = (UITableViewCell *) activeTextField.superview.superview.superview;
    else currentCell =  (UITableViewCell *) [[activeTextField superview] superview];
    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
	[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    BOOL didResign = [activeTextField resignFirstResponder];
    if (!didResign) return;
    
    NSUInteger index = [self.fieldArray indexOfObject:activeTextField];
    if (index == NSNotFound || index + 1 == fieldArray.count) {
        [self deleteBarButton];
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        tableView.tableFooterView = nil;
        return;
    }
    id nextField = [fieldArray objectAtIndex:index + 1];
    activeTextField = nextField;
    [nextField becomeFirstResponder];
}

- (void) prevEditing
{
    UITableViewCell *currentCell;
    if (IS_OS_7_OR_LATER) currentCell = (UITableViewCell *) activeTextField.superview.superview.superview;
    else currentCell =  (UITableViewCell *) [[activeTextField superview] superview];
    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
	[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    BOOL didResign = [activeTextField resignFirstResponder];
    if (!didResign) return;
    
    NSUInteger index = [self.fieldArray indexOfObject:activeTextField];
    if (index == NSNotFound || index == 0) {
        [self deleteBarButton];
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        tableView.tableFooterView = nil;
        return;
    }
    
    id prevField = [fieldArray objectAtIndex:index - 1];
    activeTextField = prevField;
    [prevField becomeFirstResponder];
    
} 



- (void) addBarButton {
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"checked.png"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(doneEditing)];
    self.navigationItem.rightBarButtonItem = backButton;
    self.navigationItem.hidesBackButton = YES;
}
- (void) deleteBarButton {
    [YTOUtils rightImageVodafone:self.navigationItem];
    //self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.hidesBackButton = NO;
}


- (void) initCells
{
    
    NSArray *topLevelObjectsUser = [[NSBundle mainBundle] loadNibNamed:@"CellView_String" owner:self options:nil];
    cellUser = [topLevelObjectsUser objectAtIndex:0];
    txtUser = (UITextField *)[cellUser viewWithTag:2];
    [(UITextField *)[cellUser viewWithTag:2] setKeyboardType:UIKeyboardTypeEmailAddress];
    [(UITextField *)[cellUser viewWithTag:2] setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [(UILabel *)[cellUser viewWithTag:1] setText:@"Adresa de email"];
    [YTOUtils setCellFormularStyle:cellUser];
    
    NSArray *topLevelObjectsUserConfirm = [[NSBundle mainBundle] loadNibNamed:@"CellView_String" owner:self options:nil];
    cellUserConfirm = [topLevelObjectsUserConfirm objectAtIndex:0];
    [(UITextField *)[cellUserConfirm viewWithTag:2] setKeyboardType:UIKeyboardTypeEmailAddress];
    [(UITextField *)[cellUserConfirm viewWithTag:2] setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    txtUserConfirm = (UITextField *)[cellUserConfirm viewWithTag:2];
    [(UILabel *)[cellUserConfirm viewWithTag:1] setText:@"Confirma adresa de email"];
    [YTOUtils setCellFormularStyle:cellUserConfirm];
    
    NSArray *topLevelObjectsPassword = [[NSBundle mainBundle] loadNibNamed:@"CellView_String" owner:self options:nil];
    cellPassword = [topLevelObjectsPassword objectAtIndex:0];
    txtPassword = (UITextField *)[cellPassword viewWithTag:2];
    txtPassword.secureTextEntry = YES;
    [(UILabel *)[cellPassword viewWithTag:1] setText:@"Parola"];
    [YTOUtils setCellFormularStyle:cellPassword];

    NSArray *topLevelObjectsPasswordConfirm = [[NSBundle mainBundle] loadNibNamed:@"CellView_String" owner:self options:nil];
    cellPasswordConfirm = [topLevelObjectsPasswordConfirm objectAtIndex:0];
    txtPasswordConfirm = (UITextField *)[cellPasswordConfirm viewWithTag:2];
    txtPasswordConfirm.secureTextEntry = YES;
    [(UILabel *)[cellPasswordConfirm viewWithTag:1] setText:@"Confirma parola"];
    [YTOUtils setCellFormularStyle:cellPasswordConfirm];
    
    
    NSArray *topLevelObjectsRegister = [[NSBundle mainBundle] loadNibNamed:@"CellCalculeaza" owner:self options:nil];
    cellRegister = [topLevelObjectsRegister objectAtIndex:0];
    UITextField * txtRegister = (UITextField *)[cellRegister viewWithTag:2];
    txtRegister.text = @"Creeaza cont";
    
    fieldArray = [[NSMutableArray alloc] initWithObjects:txtUser,txtUserConfirm, txtPassword, txtPasswordConfirm, nil];
    
}



#pragma mark Consume WebService

- (NSString *) XmlRegister
{
    NSString *pass = [YTOUtils md5:txtPassword.text];
    YTOPersoana * proprietar = [YTOPersoana Proprietar];
    YTOPersoana * proprietarPJ = [YTOPersoana ProprietarPJ];
    NSString *telefon ;
    if (proprietar.telefon && proprietar.telefon.length > 0)
        telefon = proprietar.telefon;
    else if (proprietarPJ.telefon && proprietarPJ.telefon.length > 0)
        telefon = proprietar.telefon;
    NSString * xml = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
    "<soap:Body>"
    "<AccountRegister xmlns=\"http://tempuri.org/\">"
    "<username>vreaurca</username>"
    "<password>123</password>"
    "<account_username>%@</account_username>"
    "<account_password>%@</account_password>"
    "<account_telefon>%@</account_telefon>"
    "</AccountRegister>"
    "</soap:Body>"
    "</soap:Envelope>",txtUser.text,
                      pass,
                      telefon];
    return xml;
}

- (NSString *) XmlCheckEmail
{
    NSString * xml = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                      "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                      "<soap:Body>"
                      "<VerificareEmail xmlns=\"http://tempuri.org/\">"
                      "<username>vreaurca</username>"
                      "<password>123</password>"
                      "<email>%@</email>"
                      "</VerificareEmail>"
                      "</soap:Body>"
                      "</soap:Envelope>",txtUser.text];
    return xml;
}

int back2 = 0;
- (void) callCheckEmail{
   
	paramForRequest = 1;
    emailIsOK = NO;
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@sync.asmx", LinkAPI]];
    
	NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
															cachePolicy:NSURLRequestUseProtocolCachePolicy
														timeoutInterval:10.0];
    
	NSString * parameters = [[NSString alloc] initWithString:[self XmlCheckEmail]];
	NSLog(@"Request=%@", parameters);
	NSString * msgLength = [NSString stringWithFormat:@"%d", [parameters length]];
	
	[request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[request addValue:@"http://tempuri.org/VerificareEmail" forHTTPHeaderField:@"SOAPAction"];
	[request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	if (connection) {
		self.responseData = [NSMutableData data];
	}
}

- (void) callRegister {
    
    [self showLoading];
    if (!wasEmailChecked)
        [self callCheckEmail];
	paramForRequest = 2;
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@sync.asmx", LinkAPI]];
    
	NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
															cachePolicy:NSURLRequestUseProtocolCachePolicy
														timeoutInterval:10.0];
    
	NSString * parameters = [[NSString alloc] initWithString:[self XmlRegister]];
	NSLog(@"Request=%@", parameters);
	NSString * msgLength = [NSString stringWithFormat:@"%d", [parameters length]];
	
	[request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[request addValue:@"http://tempuri.org/AccountRegister" forHTTPHeaderField:@"SOAPAction"];
	[request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	if (connection) {
		self.responseData = [NSMutableData data];
	}
    
    //[self performSelectorOnMainThread:@selector(hideLoading) withObject:nil waitUntilDone:NO];
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
   //     NSError * err = nil;
        NSData *data = [raspuns dataUsingEncoding:NSUTF8StringEncoding];
        
        if (data == nil) {
            if (paramForRequest == 1)
            {
                isOkToRegister = NO;
                [cellUser viewWithTag:10].hidden = YES;
                [cellUserConfirm viewWithTag:10].hidden = YES;
            }
            [self hideLoading];
            return;
        }
        
        if (paramForRequest == 1){
            wasEmailChecked = YES;
            if ([raspuns isEqualToString:@"true"])
            {
                emailIsOK = YES;
                [cellUser viewWithTag:10].hidden = YES;
                [cellUserConfirm viewWithTag:10].hidden = YES;
            }else {
                isOkToRegister = NO;
                [cellUser viewWithTag:10].hidden = NO;
                [cellUserConfirm viewWithTag:10].hidden = NO;
            }
        }else if (paramForRequest == 2){
            if (![raspuns isEqualToString:@""])
            {
                [self showPopup:@"Contul a fost creat!" withDescription:[NSString stringWithFormat:@"Verifica adresa %@ pentru activarea contului. Un e-mail cu linkul de activare a fost trimis",txtUser.text] withCollor:[YTOUtils colorFromHexString:rosuTermeni]];
                back2 = 1;
            }
        }
        
        
    }
    
    [self hideLoading];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"connection:didFailWithError:");
	NSLog(@"%@", [error localizedDescription]);
    [self hideLoading];
    [self showPopup:@"Eroare" withDescription:@"A aparut o eroare,va rugam incercati din nou" withCollor:[YTOUtils colorFromHexString:rosuProfil]];
}

#pragma mark NSXMLParser Methods
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if ([elementName isEqualToString:@"VerificareEmailResult"]) {
        raspuns = currentElementValue;
	}
    if ([elementName isEqualToString:@"AccountRegisterResult"]) {
        raspuns = currentElementValue;
	}
    
	currentElementValue = nil;
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if(!currentElementValue)
		currentElementValue = [[NSMutableString alloc] initWithString:string];
	else
		[currentElementValue appendString:string];
}

#pragma POPUP
- (void) showLoading
{
    [lblLoadingOk setHidden:YES];
    //  [lblLoadingDescription setHidden:YES];
    [loading setHidden:NO];
    [vwLoading setHidden:NO];
}
- (IBAction) hideLoading
{
    [vwLoading setHidden:YES];
}
- (void) showPopup:(NSString *)title withDescription:(NSString *)description withCollor:(UIColor *)color
{
    [btnPopupOk setHidden:NO];
    [lblLoadingOk setHidden:NO];
    [lblPopupDescription setHidden:NO];
    [lblPopupDescription setText:description];
    [lblPopupTitlu setText:title];
    [lblPopupTitlu setTextColor:color];
    [lblTitluPopupSus setText:@"Cont nou"];
  //  [lblPopupTitlu sizeToFit];
    if (title.length > @"Adresa de e-mail indisponibila".length-4){
        [lblPopupTitlu setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:16]];
    }
    [vwLoading setHidden:YES];
    [vwPopup setHidden:NO];
}

- (void) hidePopup:(id)sender
{
    vwPopup.hidden = YES;
    if (back2 == 1)
        [self.navigationController popViewControllerAnimated:YES];
}


@end
