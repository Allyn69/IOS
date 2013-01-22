//
//  YTOTermeniViewController.m
//  i-asigurare
//
//  Created by Andi Aparaschivei on 11/6/12.
//
//

#import "YTOTermeniViewController.h"
#import "YTOUtils.h"
#import "VerifyNet.h"

@interface YTOTermeniViewController ()

@end

@implementation YTOTermeniViewController

@synthesize responseData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Termeni si Conditii", @"Termeni si Conditii");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self callGetTermeni];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Consume WebService

- (NSString *) XmlRequest
{
    NSString * xml = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                      "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                      "<soap:Body>"
                      "<GetTermeni xmlns=\"http://tempuri.org/\">"
                      "<username>vreaurca</username>"
                      "<password>123</password>"
                      "</GetTermeni>"
                      "</soap:Body>"
                      "</soap:Envelope>"];
    return xml;
}

- (IBAction) callGetTermeni {
    
    [self showLoading];
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@sync.asmx", LinkAPI]];
    
    VerifyNet * vn = [[VerifyNet alloc] init];
    if ([vn hasConnectivity]) {
    
	NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
															cachePolicy:NSURLRequestUseProtocolCachePolicy
														timeoutInterval:30.0];
    
	NSString * parameters = [[NSString alloc] initWithString:[self XmlRequest]];
	NSLog(@"Request=%@", parameters);
	NSString * msgLength = [NSString stringWithFormat:@"%d", [parameters length]];
	
	[request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[request addValue:@"http://tempuri.org/GetTermeni" forHTTPHeaderField:@"SOAPAction"];
	[request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	if (connection) {
		self.responseData = [NSMutableData data];
	}
    }
    else {
        
        [self arataPopup:@"Atentie"];
        //vwErrorAlert.hidden = NO;
        
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
        NSDictionary * jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        
        //listFAQ = [[NSMutableArray alloc] init];
        
        for(NSDictionary *json in jsonArray) {
      //     NSString * nume = [json objectForKey:@"Nume"];
           NSString * descriereHTML = [json objectForKey:@"DescriereHTML"];
            
            [webView loadHTMLString:[YTOUtils getHTMLWithStyle:descriereHTML] baseURL:nil];
//            NSString * raspuns = [json objectForKey:@"Raspuns"];
//            
//            YTOFaq * faq = [[YTOFaq alloc] init];
//            faq.Intrebare = intrebare;
//            faq.Raspuns = raspuns;
//            [listFAQ addObject:faq];
        }
        
//        [tableView reloadData];
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
	if ([elementName isEqualToString:@"GetTermeniResult"]) {
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
    self.navigationItem.hidesBackButton = NO;
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

- (void) arataPopup:(NSString *)title
{
    vwPopup.hidden = NO;
    lblPopupTitle.text = title;
}

- (IBAction) hidePopup
{
    vwPopup.hidden = YES;
    vwLoading.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma WebView Methods
- (void)webViewDidStartLoad:(UIWebView *)webView
{
  //  [self showLoading];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideLoading];
    self.navigationItem.hidesBackButton = NO;    
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self showPopup:@"Conexiune esuata" withDescription:@"Pagina nu este disponibila. Verificati conexiunea la internet."];
    self.navigationItem.hidesBackButton = NO;
}

@end
