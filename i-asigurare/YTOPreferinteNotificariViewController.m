//
//  YTOPreferinteNotificariViewController.m
//  i-asigurare
//
//  Created by Stern Edi on 07/02/14.
//
//

#import "YTOPreferinteNotificariViewController.h"
#import "YTOUtils.h"
#import "YTOUserDefaults.h"

@interface YTOPreferinteNotificariViewController ()

@end

@implementation YTOPreferinteNotificariViewController
@synthesize responseData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Setari";
        self.tabBarItem.image = [UIImage imageNamed:@"menu-setari.png"];
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
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    lblUser.text = [YTOUserDefaults getUserName];
    NSString *string1 = @"Preferinte";
    NSString *string2 = @"notificari";
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
    
    lblDetalii.text = @"Info: Pentru a fi notificat direct pe device-ul tau cu privire la datele de expirare ale asigurarilor si promotiile / reducerile existente, asigura-te ca functia Push Notification pentru aplicatia i-Asigurare este activa.\nCum activezi Notificarile Push: \nMergi in Configurari - Centru de Notificari - da click pe aplicatia i-Asigurare si asigura-te ca functia \"Afisare in centrul de notificari\" este activa.";
    

}
- (void) viewDidAppear:(BOOL)animated
{
    lblUser.text = [YTOUserDefaults getUserName];
    [self callGetSettings];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillDisappear:(BOOL)animated {
    [self callSetSettings];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 4;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
        return 90;
    if (indexPath.row == 3)
        return 155;
    return 115;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    if (indexPath.row == 0) cell = cellDetalii;
    else if (indexPath.row == 1) cell = cellExpirare;
    else if (indexPath.row == 2) cell = cellAlteInfo;
    else if (indexPath.row == 3) cell = cellDetalii2;

    cellDetalii.backgroundColor = [YTOUtils colorFromHexString:@"#fafafa"];
    cellAlteInfo.backgroundColor = [YTOUtils colorFromHexString:@"#fafafa"];
    
    
    return cell;
}


#pragma mark Consume WebService

int paramForReq = 0;

- (NSString *) XmlRequestSetSettings
{
    NSString * cAlerte;
    NSString * cInfo;
    if (switchAlerte.on)
        cAlerte = @"da";
    else cAlerte = @"nu";
    
    if (switchInfo.on)
        cInfo = @"da";
    else cInfo = @"nu";
    
    NSString * xml = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                      "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                      "<soap:Body>"
                      "<AccountSetAlertSettings xmlns=\"http://tempuri.org/\">"
                      "<username>%@</username>"
                      "<password>%@</password>"
                      "<notificare_alerte>%@</notificare_alerte>"
                      "<notificare_alte_info>%@</notificare_alte_info>"
                      "</AccountSetAlertSettings>"
                      "</soap:Body>"
                      "</soap:Envelope>",[YTOUserDefaults getUserName],[YTOUserDefaults getPassword],cAlerte,cInfo];
    return xml;
}

- (NSString *) XmlRequestGetSettings
{
    NSString * xml = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                      "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                      "<soap:Body>"
                      "<AccountGetAlertSettings xmlns=\"http://tempuri.org/\">"
                      "<username>%@</username>"
                      "<password>%@</password>"
                      "</AccountGetAlertSettings>"
                      "</soap:Body>"
                      "</soap:Envelope>",[YTOUserDefaults getUserName],[YTOUserDefaults getPassword]];
    return xml;
}

- (void) callSetSettings {
    paramForReq = 2;
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@sync.asmx", LinkAPI]];
    
	NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
															cachePolicy:NSURLRequestUseProtocolCachePolicy
														timeoutInterval:10.0];
    
	NSString * parameters = [[NSString alloc] initWithString:[self XmlRequestSetSettings]];
	NSLog(@"Request=%@", parameters);
	NSString * msgLength = [NSString stringWithFormat:@"%d", [parameters length]];
    
	[request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[request addValue:@"http://tempuri.org/AccountSetAlertSettings" forHTTPHeaderField:@"SOAPAction"];
	[request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
    
	NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
	if (connection) {
		self.responseData = [NSMutableData data];
	}
    
    //[self performSelectorOnMainThread:@selector(hideLoading) withObject:nil waitUntilDone:NO];
}

- (void) callGetSettings {
    paramForReq = 1;

    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@sync.asmx", LinkAPI]];

	NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
															cachePolicy:NSURLRequestUseProtocolCachePolicy
														timeoutInterval:10.0];

	NSString * parameters = [[NSString alloc] initWithString:[self XmlRequestGetSettings]];
	NSLog(@"Request=%@", parameters);
	NSString * msgLength = [NSString stringWithFormat:@"%d", [parameters length]];

	[request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[request addValue:@"http://tempuri.org/AccountGetAlertSettings" forHTTPHeaderField:@"SOAPAction"];
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
        NSError * err = nil;
        NSData *data = [raspuns dataUsingEncoding:NSUTF8StringEncoding];

        if (data == nil) {
            return;
        }
        if (paramForReq == 1){
            NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
            NSLog(@"%@",raspuns);
            NSString * strAlerte = [json objectForKey:@"NotificareAlerte"];
            NSString * strInfo = [json objectForKey:@"NotificareAlteInfo"];
            
            BOOL isOnAlerte;
            BOOL isOnInfo;
            if ([strAlerte isEqualToString:@"da"])
                isOnAlerte = YES;
            else isOnAlerte = NO;
            
            if ([strInfo isEqualToString:@"da"])
                isOnInfo = YES;
            else isOnInfo = NO;
            
            [self setAlerte:isOnAlerte];
            [self setInfo:isOnInfo];
            
        }
        
        


    }
	else {

	}
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"connection:didFailWithError:");
	NSLog(@"%@", [error localizedDescription]);
}

#pragma mark NSXMLParser Methods
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if ([elementName isEqualToString:@"AccountGetAlertSettingsResult"]) {
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



# pragma set

- (void) setAlerte:(BOOL) check
{
    [switchAlerte setOn:check];
}


- (void) setInfo:(BOOL) check
{
    [switchInfo setOn:check];
}



@end
