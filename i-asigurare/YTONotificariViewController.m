//
//  YTONotificariViewController.m
//  i-asigurare
//
//  Created by Administrator on 4/29/13.
//
//

#import "YTONotificariViewController.h"
#import "VerifyNet.h"
#import "YTOUtils.h"
#import "YTONotificare.h"
#import "CellNotificareCustom.h"
#import <QuartzCore/QuartzCore.h>

@interface YTONotificariViewController ()

@end
@implementation YTONotificariViewController
@synthesize responseData;
@synthesize notificari;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) verifyViewMode
{
    if (notificari.count == 0)
    {
        [tableView setHidden:YES];
        wvZeroNot.hidden = NO;
        lbl1ZeroNot.text = @"Pana acum nu ai primit notificari.\nAsigura-te ca functia Push Notifications\npentru aplicatia i-Asigurare este activa.\n\nAstfel vei fi anuntat cand se apropie data de expirare pentru alertele setate de tine.";
    }
    else
    {
        [tableView setHidden:NO];
        wvZeroNot.hidden = YES;
        lbl1ZeroNot.text = @"";
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Notificari";
    [self callGetNotificari];
    
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *) XmlRequest
{
    NSString * xml = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                      "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                      "<soap:Body>"
                      "<GetNotificari xmlns=\"http://tempuri.org/\">"
                      "<username>vreaurca</username>"
                      "<password>123</password>"
                      "<udid>%@</udid>"
                      "</GetNotificari>"
                      "</soap:Body>"
                      "</soap:Envelope>",@"182e1881a48670d24ad192548c5901655ca08b28"];//udid telefon
    return xml;
}

- (IBAction) callGetNotificari{
    
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
        [request addValue:@"http://tempuri.org/GetNotificari" forHTTPHeaderField:@"SOAPAction"];
        [request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if (connection) {
            self.responseData = [NSMutableData data];
        }
    }
    else {
        [self hideLoading];
        [self arataPopup:@"Atentie"];
        self.navigationItem.hidesBackButton = NO;
        
    }
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    wvPopup.hidden = YES;
    wvLoading.hidden = YES;
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
        notificari = [[NSMutableArray alloc] init];
        
        for(NSDictionary *json in jsonArray) {
            YTONotificare *notificare = [[YTONotificare alloc] init];
            notificare._id = [[json objectForKey:@"Id"] intValue];
            notificare.dataAlerta = [json objectForKey:@"DataCreareAsString"];
            notificare.subiect = [json objectForKey:@"Subiect"];
            notificare.tipAlerta = [[json objectForKey:@"Sursa"] intValue];
            [notificari addObject:notificare];
        }
        
        [tableView reloadData];
    }
	else {
        
	}
[self verifyViewMode];

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
	if ([elementName isEqualToString:@"GetNotificariResult"]) {
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



#pragma mark - Table view data source

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return notificari.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 300, 15)];
    label.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:12];
    label.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    label.backgroundColor = [UIColor clearColor];

    YTONotificare * n = (YTONotificare *)[notificari objectAtIndex:section];
    label.text = n.dataAlerta;
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    //    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor whiteColor] CGColor], nil];
    gradient.colors = [NSArray arrayWithObjects:(id)[[YTOUtils colorFromHexString:@"#f5f5f5"] CGColor], (id)[[YTOUtils colorFromHexString:@"#e0e1e2"] CGColor], nil];
    [view.layer insertSublayer:gradient atIndex:0];
    //view.backgroundColor = [YTOUtils colorFromHexString:@"#e0e1e2"];
    [view addSubview:label];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellView_Notificare";
    
    CellNotificareCustom *cell = (CellNotificareCustom *)[tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (CellNotificareCustom *)[nib objectAtIndex:0];
    }

    YTONotificare * notificare = [notificari objectAtIndex:indexPath.row];
    
    NSString * val = @"";
    NSString * detaliu = @"";
    UIImage * img = nil;

    detaliu = notificare.subiect;
    if (notificare.tipAlerta == 1) // RCA
    {
        img = [UIImage imageNamed:@"icon-alerta-rca.png"];
    }
    else if (notificare.tipAlerta == 2) // ITP
    {
        img = [UIImage imageNamed:@"icon-alerta-itp.png"];
    }
    else if (notificare.tipAlerta == 3) // Rovinieta
    {
        img = [UIImage imageNamed:@"icon-alerta-rovinieta.png"];
    }
    else if (notificare.tipAlerta == 5) // CASCO
    {
        img = [UIImage imageNamed:@"icon-alerta-casco.png"];
    }
    else if (notificare.tipAlerta == 6) // Locuinta
    {
        img = [UIImage imageNamed:@"icon-alerta-locuinta.png"];
    }
    else if (notificare.tipAlerta == 7)
    {
        img = [UIImage imageNamed:@"icon-alerta-rata-casco.png"];
    }
    else if (notificare.tipAlerta == 8)
    {
        img = [UIImage imageNamed:@"icon-alerta-rata-locuinta.png"];
    }
    else
    {
        img = [UIImage imageNamed:@"logo.png"];
    }

    [cell setDetaliiNotificare:detaliu];
  //  [cell setNotificareImage:img];
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

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

@end
