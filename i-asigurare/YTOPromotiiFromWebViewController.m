//
//  YTOPromotiiFromWebViewController.m
//  i-asigurare
//
//  Created by Stern Edi on 6/21/13.
//
//

#import "YTOPromotiiFromWebViewController.h"
#import "YTOUtils.h"
#import "VerifyNet.h"
#import "YTOPromotie.h"
#import "YTOUserDefaults.h"

@interface YTOPromotiiFromWebViewController ()

@end

@implementation YTOPromotiiFromWebViewController

@synthesize promotii;
@synthesize responseData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedStringFromTable(@"i480", [YTOUserDefaults getLanguage],@"PROMOTII");
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
    //self.trackedViewName = @"YTOPromotiiViewController";
    [YTOUtils rightImageVodafone:self.navigationItem];
    [self callGetPromotii];
    lblNoInternet.text = NSLocalizedStringFromTable(@"i450", [YTOUserDefaults getLanguage],@"Ne pare rau! \nCererea nu a fost trimisa pentru ca nu esti conectat la internet. \nTe rugam sa te asiguri ca ai o conexiune la internet activa si sa incerci din nou.\n Iti multumim!");
    lblSeIncarca.text = NSLocalizedStringFromTable(@"i444", [YTOUserDefaults getLanguage],@"se incarca...");
    // Do any additional setup after loading the view from its nib.
    UILabel *lbl11 = (UILabel * ) [cellHead viewWithTag:11];
    UILabel *lbl22 = (UILabel * ) [cellHead viewWithTag:22];
    
    NSString *string1 =  NSLocalizedStringFromTable(@"i712", [YTOUserDefaults getLanguage],@"Promotii");
    NSString *string2 =  NSLocalizedStringFromTable(@"i713", [YTOUserDefaults getLanguage],@"pentru tine");
    NSString *string  =  [[NSString alloc] initWithFormat:@"%@ %@",string1,string2];
    lblEroare.text = NSLocalizedStringFromTable(@"i799", [YTOUserDefaults getLanguage],@"Eroare !");
    lblEroare.textColor = [YTOUtils colorFromHexString:rosuTermeni];
    
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")){
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString beginEditing];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[YTOUtils colorFromHexString:verdePromotii] range:NSMakeRange(0, string1.length+1)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[YTOUtils colorFromHexString:ColorTitlu] range:NSMakeRange(string1.length+1, string2.length)];
    [attributedString beginEditing];
    
    [lbl11 setAttributedText:attributedString];
    }else{
        [lbl11 setText:string];
        [lbl11 setTextColor:[YTOUtils colorFromHexString:verdePromotii]];
    }
    lbl22.text = NSLocalizedStringFromTable(@"i714", [YTOUserDefaults getLanguage],@"fii la curent cu ofertele noastre");
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
    return promotii.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
        YTOPromotie * promotie= [promotii objectAtIndex:indexPath.row];
        cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:promotie.linkImage]]];
        cell.textLabel.text = promotie.title;
        cell.detailTextLabel.text = promotie.desciption;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:18];
    cell.textLabel.textColor = [YTOUtils colorFromHexString:@"#3e3e3e"];
    cell.detailTextLabel.textColor = [YTOUtils colorFromHexString:@"#888888"];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Arial" size:12];
    cell.detailTextLabel.numberOfLines = 0;
    
    cell.textLabel.backgroundColor = cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    if (indexPath.row % 2 != 0) {
        CGRect frame = CGRectMake(0, 0, 320, 70);
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (NSString *) XmlRequest
{
    NSString * xml = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                      "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                      "<soap:Body>"
                      "<GetPromotii xmlns=\"http://tempuri.org/\">"
                      "<user>vreaurca</user>"
                      "<password>123</password>"
                      "</GetPromotii>"
                      "</soap:Body>"
                      "</soap:Envelope>"];
    NSLog(@"xml=%@", xml);
    return xml;
}

- (IBAction) callGetPromotii{
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@utils.asmx", LinkAPI]];
    
    VerifyNet * vn = [[VerifyNet alloc] init];
    if ([vn hasConnectivity]) {
        [self showLoading];
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:30.0];
        
        NSString * parameters = [[NSString alloc] initWithString:[self XmlRequest]];
        NSLog(@"Request=%@", parameters);
        NSString * msgLength = [NSString stringWithFormat:@"%d", [parameters length]];
        
        [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request addValue:@"http://tempuri.org/GetPromotii" forHTTPHeaderField:@"SOAPAction"];
        [request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if (connection) {
            self.responseData = [NSMutableData data];
        }
    }
    else {
        [self arataPopup:NSLocalizedStringFromTable(@"i123", [YTOUserDefaults getLanguage],@"Atentie !") ];
        self.navigationItem.hidesBackButton = NO;
        
    }
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"Response: %@", [response textEncodingName]);
	[self.responseData setLength:0];
    self.navigationItem.hidesBackButton = NO;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSLog(@"connection:DidReceiveData");
	[self.responseData appendData:data];
    self.navigationItem.hidesBackButton = NO;
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
        NSError * err = nil;
        NSData *data = [jsonResponse dataUsingEncoding:NSUTF8StringEncoding];
        if (data!=nil){
            NSDictionary * jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
           promotii = [[NSMutableArray alloc] init];
            
            for(NSDictionary *json in jsonArray) {
                YTOPromotie *promotie= [[YTOPromotie alloc] init];
                promotie.title = [json objectForKey:@"Titlu"];
                promotie.desciption = [json objectForKey:@"Descriere"];
                promotie.linkImage = [json objectForKey:@"LinkPoza"];
                [promotii addObject:promotie];
            }
        }
        [tableView reloadData];
    }
	else {
        
	}
}
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"connection:didFailWithError:");
	NSLog(@"%@", [error localizedDescription]);
    [self hideLoading];
}

#pragma mark NSXMLParser Methods
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if ([elementName isEqualToString:@"GetPromotiiResult"]) {
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

- (void) showLoading
{
    [wvLoading setHidden:NO];
}
- (IBAction) hideLoading
{
    [wvLoading setHidden:YES];
    self.navigationItem.hidesBackButton = NO;
}
- (void) showPopup:(NSString *)title withDescription:(NSString *)description
{
    [wvLoading setHidden:NO];
}


- (void) arataPopup:(NSString *)title
{
    wvPopup.hidden = NO;
    lblPopupTitle.text = title;
}

- (IBAction) hidePopup
{
    //    vwPopup.hidden = YES;
    wvLoading.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}




@end
