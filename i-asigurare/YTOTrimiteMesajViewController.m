//
//  YTOTrimiteMesajViewController.m
//  i-asigurare
//
//  Created by Andi Aparaschivei on 10/25/12.
//
//

#import "YTOTrimiteMesajViewController.h"
#import "YTOUtils.h"
#import "VerifyNet.h"

@interface YTOTrimiteMesajViewController ()

@end

@implementation YTOTrimiteMesajViewController

@synthesize responseData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Trimite mesaj", @"Trimite mesaj");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initCells];
    
    proprietar = [YTOPersoana Proprietar];
    if (proprietar)
    {
        //[self setTelefon:proprietar.telefon];
        //[self setEmail:proprietar.email];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3)
        return 120;
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    
    if (indexPath.row == 0) cell = cellEmail;
    else if (indexPath.row == 1) cell = cellTelefon;
    else if (indexPath.row == 2) cell = cellSubiect;
    else if (indexPath.row == 3) cell = cellDescriere;
    else cell = cellTrimite;
    
    if (indexPath.row % 2 == 0) {
        CGRect frame = CGRectMake(0, 0, 320, cell.frame.size.height);
        UIView *bgColor = [[UIView alloc] initWithFrame:frame];
        [cell addSubview:bgColor];
        [cell sendSubviewToBack:bgColor];
        bgColor.backgroundColor = [YTOUtils colorFromHexString:@"#fafafa"];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //am comentat in viewdidload ca sa pot sa testez
    if (indexPath.row == 4) {
        
        [self doneEditing];
        
        if (email.length == 0 && telefon.length == 0)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [tv scrollToRowAtIndexPath:indexPath
                      atScrollPosition:UITableViewScrollPositionTop
                              animated:YES];

            [txtEmail becomeFirstResponder];
            return;
        }
        
        if (subiect.length == 0 && descriere.length == 0)
        {
            [txtSubiect becomeFirstResponder];
            return;
        }
    
        [self callTrimiteMesaj];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    activeTextView = textView;
    [self addBarButton];
    
    UITableViewCell *currentCell = (UITableViewCell *) [[textView superview] superview];
    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
	tableView.contentInset = UIEdgeInsetsMake(currentCell.frame.size.height, 0, 210, 0);
	[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void) textViewDidEndEditing:(UITextView *)textView
{
    [self setDescriere:textView.text];
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    [self addBarButton];
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	btnDone.enabled = YES;
	activeTextField = textField;
	
	UITableViewCell *currentCell = (UITableViewCell *) [[textField superview] superview];
    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
    
    activeTextField.tag = indexPath.row;
    
	tableView.contentInset = UIEdgeInsetsMake(65, 0, 210, 0);
    if (indexPath)
	[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
	return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    
	if(activeTextField == textField)
	{
		activeTextField = nil;
	}
    
	[textField resignFirstResponder];
    [self deleteBarButton]; 
	btnDone.enabled = NO;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
	return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    UITableViewCell *currentCell = (UITableViewCell *) [[textField superview] superview];
    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
    
    int index = 0;
    if (indexPath != nil)
        index = indexPath.row;
    else
        index = textField.tag;
    
    if (index == 0)
        [self setEmail:textField.text];
    else if (index == 1)
        [self setTelefon:textField.text];
    else if (index == 2)
        [self setSubiect:textField.text];
}

-(IBAction) doneEditing
{
    [activeTextField resignFirstResponder];
	activeTextField = nil;
    [activeTextView resignFirstResponder];
    activeTextView = nil;
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

#pragma METHODS

- (void) initCells
{
    NSArray *topLevelObjectsEmail = [[NSBundle mainBundle] loadNibNamed:@"CellView_String" owner:self options:nil];
    cellEmail = [topLevelObjectsEmail objectAtIndex:0];
    txtEmail = (UITextField *)[cellEmail viewWithTag:2];
    [(UILabel *)[cellEmail viewWithTag:1] setText:@"EMAIL-UL TAU"];
    [(UITextField *)[cellEmail viewWithTag:2] setPlaceholder:@""];
    [(UITextField *)[cellEmail viewWithTag:2] setKeyboardType:UIKeyboardTypeEmailAddress];
    [(UITextField *)[cellEmail viewWithTag:2] setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [YTOUtils setCellFormularStyle:cellEmail];
    
    NSArray *topLevelObjectsTelefon = [[NSBundle mainBundle] loadNibNamed:@"CellView_Numeric" owner:self options:nil];
    cellTelefon = [topLevelObjectsTelefon objectAtIndex:0];
    txtTelefon = (UITextField *)[cellTelefon viewWithTag:2];
    [(UILabel *)[cellTelefon viewWithTag:1] setText:@"NUMARUL TAU DE TELEFON"];
    [(UITextField *)[cellTelefon viewWithTag:2] setPlaceholder:@""];
    [(UITextField *)[cellTelefon viewWithTag:2] setKeyboardType:UIKeyboardTypeNumberPad];
    [YTOUtils setCellFormularStyle:cellTelefon];
    
    NSArray *topLevelObjectsSubiect = [[NSBundle mainBundle] loadNibNamed:@"CellView_String" owner:self options:nil];
    cellSubiect = [topLevelObjectsSubiect objectAtIndex:0];
    txtSubiect = (UITextField *)[cellSubiect viewWithTag:2];
    [(UILabel *)[cellSubiect viewWithTag:1] setText:@"SUBIECT MESAJ"];
    [(UITextField *)[cellSubiect viewWithTag:2] setPlaceholder:@"..."];    
    [YTOUtils setCellFormularStyle:cellSubiect];
    
    NSArray *topLevelObjectscalc = [[NSBundle mainBundle] loadNibNamed:@"CellCalculeaza" owner:self options:nil];
    cellTrimite = [topLevelObjectscalc objectAtIndex:0];    
    UIImageView * imgComanda = (UIImageView *)[cellTrimite viewWithTag:1];
    imgComanda.image = [UIImage imageNamed:@"trimite-mesaj-buton.png"];
    UILabel * lblCellC = (UILabel *)[cellTrimite viewWithTag:2];
    lblCellC.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblCellC.text = @"Trimite";
}

- (void) setEmail:(NSString *)v
{
    txtEmail.text = v;
    email = v;
}

- (void) setTelefon:(NSString *)v
{
    txtDescriere.text = v;
    telefon = v;
}

- (void) setSubiect:(NSString *)v
{
    txtSubiect.text = v;
    subiect = v;
}
- (void) setDescriere:(NSString *)v
{
    descriere = v;
}

#pragma mark Consume WebService

- (NSString *) XmlRequest
{
    NSString * xml = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                      "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                      "<soap:Body>"
                        "<CallContactSmartphone xmlns=\"http://tempuri.org/\">"
                            "<user>vreaurca</user>"
                            "<password>123</password>"
                            "<email>%@</email>"
                            "<telefon>%@</telefon>"
                            "<subiect>%@</subiect>"
                            "<descriere>%@</descriere>"
                            "<udid>%@</udid>"
                            "<platforma>%@</platforma>"
                        "</CallContactSmartphone>"
                      "</soap:Body>"
                      "</soap:Envelope>",
                      email, telefon, subiect, descriere, [[UIDevice currentDevice] uniqueIdentifier],
                      [[UIDevice currentDevice].model stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
    return xml;
}

- (IBAction) callTrimiteMesaj {
    [self doneEditing];
    [self showLoading];
    
    self.navigationItem.hidesBackButton = YES;

	NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@utils.asmx", LinkAPI]];
    
    VerifyNet * vn = [[VerifyNet alloc] init];
    if ([vn hasConnectivity]) {
    
	NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
															cachePolicy:NSURLRequestUseProtocolCachePolicy
														timeoutInterval:30.0];
    
	NSString * parameters = [[NSString alloc] initWithString:[self XmlRequest]];
	NSLog(@"Request=%@", parameters);
	NSString * msgLength = [NSString stringWithFormat:@"%d", [parameters length]];
	
	[request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[request addValue:@"http://tempuri.org/CallContactSmartphone" forHTTPHeaderField:@"SOAPAction"];
	[request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	if (connection) {
		self.responseData = [NSMutableData data];
	}
    }
    else {
        
        [self showPopupError:@"Atentie"];
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
	NSLog(@"Response string: %@", responseString);
    self.navigationItem.hidesBackButton = NO;
    [self hideLoading];
	
	NSXMLParser * xmlParser = [[NSXMLParser alloc] initWithData:responseData];
	xmlParser.delegate = self;
	BOOL succes = [xmlParser parse];
	
	if (succes) {
        [self showPopup:@"Mesajul a fost trimis" withDescription:jsonResponse];
    }
	else {

	}
    
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"connection:didFailWithError:");
	NSLog(@"%@", [error localizedDescription]);
	
    //	UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Atentie!" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //	[alertView show];
    [self hideLoading];
}

#pragma mark NSXMLParser Methods
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if ([elementName isEqualToString:@"CallContactSmartphoneResult"]) {
        jsonResponse = currentElementValue;
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
    [btnLoadingOk setHidden:YES];
    [lblLoadingOk setHidden:YES];
    [lblLoadingDescription setHidden:YES];
    [lblLoadingTitlu setText:@"Trimitem mesajul..."];
    [loading setHidden:NO];
    [vwLoading setHidden:NO];
}
- (IBAction) hideLoading
{
    [vwLoading setHidden:YES];
    [self setSubiect:@""];
    ((UITextView *)[cellDescriere viewWithTag:2]).text = @"";
    
}
- (void) showPopup:(NSString *)title withDescription:(NSString *)description
{
    [btnLoadingOk setHidden:NO];
    [lblLoadingOk setHidden:NO];
    [lblLoadingDescription setHidden:NO];
    [lblLoadingDescription setText:description];
    [lblLoadingTitlu setText:title];
    [loading setHidden:YES];
    [vwLoading setHidden:NO];
}

- (void) showPopupError:(NSString *)title
{
    vwPopup.hidden = NO;
    lblPopupTitle.text = title;
}

- (IBAction) hidePopupError
{
    vwLoading.hidden = YES;
    vwPopup.hidden = YES;
}

@end
