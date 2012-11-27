//
//  YTOFAQViewController.m
//  i-asigurare
//
//  Created by Administrator on 11/5/12.
//
//

#import "YTOFAQViewController.h"
#import "YTOWebViewController.h"
#import "YTOUtils.h"
#import "YTOFaq.h"

@interface YTOFAQViewController ()

@end

@implementation YTOFAQViewController

@synthesize responseData;
@synthesize listFAQ;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Intrebari frecvente", @"Intrebari frecvente");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    tipFAQ = @"rca";
    [self callGetFAQ];
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
    return listFAQ.count;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    YTOFaq * faq = (YTOFaq *)[listFAQ objectAtIndex:indexPath.row];
    
    cell.textLabel.text = faq.Intrebare;
    cell.textLabel.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:12];
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YTOFaq * faq = (YTOFaq *)[listFAQ objectAtIndex:indexPath.row];
    YTOWebViewController * aView = [[YTOWebViewController alloc] init];
    NSString * html = [YTOUtils getHTMLWithStyle:[NSString stringWithFormat:@"<h2>%@</h2>%@",faq.Intrebare, faq.Raspuns]];
    aView.title = faq.Intrebare;
    aView.HTMLContent = html;
    [self.navigationController pushViewController:aView animated:YES];
}

#pragma mark Consume WebService

- (NSString *) XmlRequest
{
    NSString * xml = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                      "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                      "<soap:Body>"
                      "<GetFAQ xmlns=\"http://tempuri.org/\">"
                      "<username>vreaurca</username>"
                      "<password>123</password>"
                      "</GetFAQ>"
                      "</soap:Body>"
                      "</soap:Envelope>"];
    return xml;
}

- (IBAction)getFaqDupaTip:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    
    if (btn.tag == 1)
        tipFAQ = @"rca";
    else if (btn.tag == 2)
        tipFAQ = @"calatorie";
    else if (btn.tag == 3)
        tipFAQ = @"locuinta";
    else tipFAQ = @"casco";
    
    [self callGetFAQ];
}

- (IBAction) callGetFAQ {
    
    [self showLoading];
    
    if ([tipFAQ isEqualToString:@"rca"])
    {
        imgTip.image = [UIImage imageNamed:@"faq1.png"];
        lblCalatorie.textColor = lblCasco.textColor = lblLocuinta.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblRca.textColor = [UIColor whiteColor];
    }
    else if ([tipFAQ isEqualToString:@"calatorie"])
    {
        imgTip.image = [UIImage imageNamed:@"faq2.png"];
        lblRca.textColor = lblCasco.textColor = lblLocuinta.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblCalatorie.textColor = [UIColor whiteColor];
    }
    else if ([tipFAQ isEqualToString:@"locuinta"])
    {
        imgTip.image = [UIImage imageNamed:@"faq3.png"];
        lblCalatorie.textColor = lblCasco.textColor = lblRca.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblLocuinta.textColor = [UIColor whiteColor];
    }
    else if ([tipFAQ isEqualToString:@"casco"])
    {
        imgTip.image = [UIImage imageNamed:@"faq4.png"];
        lblCalatorie.textColor = lblRca.textColor = lblLocuinta.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblCasco.textColor = [UIColor whiteColor];
    }
    
    self.navigationItem.hidesBackButton = YES;

    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@sync.asmx", LinkAPI]];
    
	NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
															cachePolicy:NSURLRequestUseProtocolCachePolicy
														timeoutInterval:15.0];
    
	NSString * parameters = [[NSString alloc] initWithString:[self XmlRequest]];
	NSLog(@"Request=%@", parameters);
	NSString * msgLength = [NSString stringWithFormat:@"%d", [parameters length]];
	
	[request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[request addValue:@"http://tempuri.org/GetFAQ" forHTTPHeaderField:@"SOAPAction"];
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
    [self hideLoading];
	//to do parseXML
	NSXMLParser * xmlParser = [[NSXMLParser alloc] initWithData:responseData];
	xmlParser.delegate = self;
	BOOL succes = [xmlParser parse];
	
	if (succes) {
        NSError * err = nil;
        NSData *data = [jsonResponse dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        
        listFAQ = [[NSMutableArray alloc] init];
        
        for(NSDictionary *json in jsonArray) {

           NSString * intrebare = [json objectForKey:@"Intrebare"];
           NSString * raspuns = [json objectForKey:@"Raspuns"];
        
            YTOFaq * faq = [[YTOFaq alloc] init];
            faq.Intrebare = intrebare;
            faq.Raspuns = raspuns;
            [listFAQ addObject:faq];
        }
        
        [tableView reloadData];
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
	if ([elementName isEqualToString:@"GetFAQResult"]) {
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
    [lblLoadingTitlu setText:@"Se incarca..."];
    [loading setHidden:NO];
    [vwLoading setHidden:NO];
}
- (IBAction) hideLoading
{
    [vwLoading setHidden:YES];
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
@end
