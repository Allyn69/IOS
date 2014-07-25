//
//  YTOSetariParolaViewController.m
//  i-asigurare
//
//  Created by Stern Edi on 07/02/14.
//
//

#import "YTOSetariParolaViewController.h"
#import "YTOUserDefaults.h"
#import "YTOUtils.h"
#import "VerifyNet.h"

@interface YTOSetariParolaViewController ()

@end

@implementation YTOSetariParolaViewController
@synthesize fieldArray;
@synthesize responseData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedStringFromTable(@"i443", [YTOUserDefaults getLanguage],@"Persoana");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initCells];
    [tableView setAllowsSelection:YES];
    if (IS_OS_7_OR_LATER){
        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars=NO;
        self.automaticallyAdjustsScrollViewInsets=NO;
    }else [tableView setBackgroundView: nil];
    
    //self.trackedViewName = @"YTOAsiguratViewController";
    
    [YTOUtils rightImageVodafone:self.navigationItem];
}



- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)keyboardWillShow {
    
    keyboardFirstTimeActive = YES;
}





- (void) viewWillDisappear:(BOOL)animated {
    [self doneEditing];
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
    
    if (indexPath.row == 0) cell = cellCont;
    else if (indexPath.row == 1) cell = cellParolaActuala;
    else if (indexPath.row == 2) cell = cellParolaNoua;
    else if (indexPath.row == 3) cell = cellParolaConf;
    else if (indexPath.row == 4) cell = cellSalveaza;
    
    if (indexPath.row % 2 == 0) {
        CGRect frame = CGRectMake(0, 0, 320, 60);
        UIView *bgColor = [[UIView alloc] initWithFrame:frame];
        [cell addSubview:bgColor];
        [cell sendSubviewToBack:bgColor];
        bgColor.backgroundColor = [YTOUtils colorFromHexString:@"#fafafa"];
    }
    
    return cell;
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

#pragma Picker View Nomenclator


- (void) initCells
{
    
    NSArray *topLevelObjectsUser = [[NSBundle mainBundle] loadNibNamed:@"Cell_ContSetari" owner:self options:nil];
    cellCont = [topLevelObjectsUser objectAtIndex:0];
    [(UILabel *)[cellCont viewWithTag:11] setText:[YTOUserDefaults getUserName]];
    [(UILabel *)[cellCont viewWithTag:11] setTextColor:[YTOUtils colorFromHexString:@"#b3b3b3"]];
    [(UILabel *)[cellCont viewWithTag:11] setTextAlignment:NSTextAlignmentCenter];
    cellCont.accessoryType = UITableViewCellAccessoryNone;
    [YTOUtils setCellFormularStyle:cellCont];
    
    NSArray *topLevelObjectsPasswordOld = [[NSBundle mainBundle] loadNibNamed:@"CellView_String" owner:self options:nil];
    cellParolaActuala = [topLevelObjectsPasswordOld objectAtIndex:0];
    txtParolaActuala = (UITextField *)[cellParolaActuala viewWithTag:2];
    txtParolaActuala.secureTextEntry = YES;
    [(UILabel *)[cellParolaActuala viewWithTag:1] setText:@"Parola actuala"];
    [YTOUtils setCellFormularStyle:cellParolaActuala];
    
    NSArray *topLevelObjectsPassword = [[NSBundle mainBundle] loadNibNamed:@"CellView_String" owner:self options:nil];
    cellParolaNoua = [topLevelObjectsPassword objectAtIndex:0];
    txtParolaNoua = (UITextField *)[cellParolaNoua viewWithTag:2];
    txtParolaNoua.secureTextEntry = YES;
    [(UILabel *)[cellParolaNoua viewWithTag:1] setText:@"Parola noua"];
    [YTOUtils setCellFormularStyle:cellParolaNoua];
    
    NSArray *topLevelObjectsPasswordConfirm = [[NSBundle mainBundle] loadNibNamed:@"CellView_String" owner:self options:nil];
    cellParolaConf = [topLevelObjectsPasswordConfirm objectAtIndex:0];
    txtParolaConf = (UITextField *)[cellParolaConf viewWithTag:2];
    txtParolaConf.secureTextEntry = YES;
    [(UILabel *)[cellParolaConf viewWithTag:1] setText:@"Confirma parola noua"];
    [YTOUtils setCellFormularStyle:cellParolaConf];
    
    NSArray *topLevelObjectsSave = [[NSBundle mainBundle] loadNibNamed:@"Cell_ContSetari" owner:self options:nil];
    cellSalveaza = [topLevelObjectsSave objectAtIndex:0];
    [(UILabel *)[cellSalveaza viewWithTag:11] setText:@"Schimba parola"];
    [(UILabel *)[cellSalveaza viewWithTag:11] setTextAlignment:NSTextAlignmentCenter];
    [(UILabel *)[cellSalveaza viewWithTag:11] setTextColor:[YTOUtils colorFromHexString:@"#007aff"]];
    UILabel * label = (UILabel *)[cellSalveaza viewWithTag:10];
    cellSalveaza.accessoryType = UITableViewCellAccessoryNone;
    label.hidden = YES;
    [YTOUtils setCellFormularStyle:cellSalveaza];
    
    fieldArray = [[NSMutableArray alloc] initWithObjects:txtParolaActuala, txtParolaNoua,txtParolaConf,  nil];
    
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self doneEditing];
    if (indexPath.row == 4){
        if (![[YTOUtils md5:txtParolaActuala.text] isEqualToString:[YTOUserDefaults getPassword]])
        {
            [self showPopup:@"Eroare" withDescription:@"Parola introdusa nu este corecta"];
            return;
        }else if ([txtParolaConf.text isEqualToString:txtParolaNoua.text])
        {
            VerifyNet * vn = [[VerifyNet alloc] init];
            if ([vn hasConnectivity])
               [self callChangePassword];
            else {
                [self showPopup:@"Eroare" withDescription:@"Ne pare rau! \nCererea nu a fost trimisa pentru ca nu esti conectat la internet. \nTe rugam sa te asiguri ca ai o conexiune la internet activa si sa incerci din nou.\n Iti multumim!"];
                return;
            }

            
        }else {
            [self showPopup:@"Eroare" withDescription:@"Parola noua este diferita de parola confirmata"];
        }
    }
}








#pragma mark Consume WebService
int back1 = 0;
- (NSString *) XmlRequest
{
    NSString * xml = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                      "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                      "<soap:Body>"
                      "<AccountChangePassword xmlns=\"http://tempuri.org/\">"
                      "<username>%@</username>"
                      "<password>%@</password>"
                      "<newpassword>%@</newpassword>"
                      "</AccountChangePassword>"
                      "</soap:Body>"
                      "</soap:Envelope>",
                      [YTOUserDefaults getUserName],
                      [YTOUserDefaults getPassword],
                      [YTOUtils md5:txtParolaNoua.text]];
    return xml;
}

- (void) callChangePassword {
    
    [self showLoading];
	
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@sync.asmx", LinkAPI]];
    
	NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
															cachePolicy:NSURLRequestUseProtocolCachePolicy
														timeoutInterval:10.0];
    
	NSString * parameters = [[NSString alloc] initWithString:[self XmlRequest]];
	NSLog(@"Request=%@", parameters);
	NSString * msgLength = [NSString stringWithFormat:@"%d", [parameters length]];
	
	[request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[request addValue:@"http://tempuri.org/AccountChangePassword" forHTTPHeaderField:@"SOAPAction"];
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

        if ([raspuns isEqualToString:@"ok"]){
            [self showPopup:@"Parola schimbata" withDescription:@"Autentificarea in cont se va face utilizand noua parola."];
            [YTOUserDefaults setPassword:[YTOUtils md5:txtParolaNoua.text]];
            back1 =1 ;
        }else [self showPopup:@"Eroare" withDescription:@"A aparut o eroare,va rugam incercati din nou."];
        
       
    }
	else {
        
	}
    
    [self hideLoading];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"connection:didFailWithError:");
	NSLog(@"%@", [error localizedDescription]);
    [self hideLoading];
    [self showPopup:@"Eroare" withDescription:@"A aparut o eroare,va rugam incercati din nou"];
   
}

#pragma mark NSXMLParser Methods
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if ([elementName isEqualToString:@"AccountChangePasswordResult"]) {
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
    vwLoading.hidden = NO;
}
- (IBAction) hideLoading
{
    vwLoading.hidden = YES;
}
- (void) showPopup:(NSString *)title withDescription:(NSString *)description
{
    lblTitlu1.text = @"";
    lblTitlu2.text = title;
    lblTitlu2.textColor = [YTOUtils colorFromHexString:verde];
    if ([title isEqualToString:@"Eroare"])
        lblTitlu2.textColor = [YTOUtils colorFromHexString:rosuTermeni];
    lblPopDesc.text = description;
    [vwPopup setHidden:NO];
}

- (IBAction)hidePopUp:(id)sender
{
    vwPopup.hidden = YES;
    if (back1 == 1)
        [self.navigationController popViewControllerAnimated:YES];
}




@end