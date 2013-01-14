//
//  YTOValabilitateRCAViewController.m
//  i-asigurare
//
//  Created by Andi Aparaschivei on 10/25/12.
//
//

#import "YTOValabilitateRCAViewController.h"
#import "YTOAppDelegate.h"
#import "YTOAutovehicul.h"
#import "YTOListaAutoViewController.h"
#import "YTOUtils.h"
#import "VerifyNet.h"

@interface YTOValabilitateRCAViewController ()

@end

@implementation YTOValabilitateRCAViewController

@synthesize responseData, masina;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Verifica RCA", @"Verifica RCA");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selecteazaMasina:(id)sender
{
    YTOAppDelegate * appDelegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    // Daca exista masini salvate, afisam lista
    if ([appDelegate Masini].count > 0)
    {
        YTOListaAutoViewController * aView = [[YTOListaAutoViewController alloc] init];
        aView.controller = self;
        [appDelegate.alteleNavigationController pushViewController:aView animated:YES];
    }
}

- (void) setAutovehicul:(YTOAutovehicul *)m
{
    masina = m;
    
    lblMasina.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    if (masina.marcaAuto.length > 0)
    {
        lblMasina.text = [NSString stringWithFormat:@"%@, %@", m.marcaAuto, m.modelAuto];
        lblSerie.text = [NSString stringWithFormat:@"%@, %@", m.nrInmatriculare, m.serieSasiu];
        lblMasina.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    }
}

#pragma mark Consume WebService

- (NSString *) XmlRequest
{
    NSString * xml = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                      "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                      "<soap:Body>"
                      "<VerificaRCA xmlns=\"http://tempuri.org/\">"
                      "<serie>%@</serie>"
                      "<nrinmatriculare>%@</nrinmatriculare>"
                      "</VerificaRCA>"
                      "</soap:Body>"
                      "</soap:Envelope>",
                        masina.serieSasiu, masina.nrInmatriculare];
    return xml;
}

- (IBAction) callVerificaRca {
    if (!masina && (!masina.serieSasiu || !masina.nrInmatriculare))
    {
        lblMasina.textColor = [UIColor redColor];
        return;
    }
    
    self.navigationItem.hidesBackButton = YES;

    VerifyNet * vn = [[VerifyNet alloc] init];
    if ([vn hasConnectivity]) {

        [self showLoading];
        
	NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@utils.asmx", LinkAPI]];
    
	NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
															cachePolicy:NSURLRequestUseProtocolCachePolicy
														timeoutInterval:30.0];
    
	NSString * parameters = [[NSString alloc] initWithString:[self XmlRequest]];
	NSLog(@"Request=%@", parameters);
	NSString * msgLength = [NSString stringWithFormat:@"%d", [parameters length]];
	
	[request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[request addValue:@"http://tempuri.org/VerificaRCA" forHTTPHeaderField:@"SOAPAction"];
	[request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	if (connection) {
		self.responseData = [NSMutableData data];
        }
    }
    else {
        
        vwErrorAlert.hidden = NO;
        
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
        NSError * err = nil;
        NSData *data = [jsonResponse dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        dataExpirare = nil;
        for(NSDictionary *json in jsonArray) {
            NSString * status = [json objectForKey:@"status"];
            NSString * mesaj = [json objectForKey:@"mesaj"];
            
            NSString * dExpirare =[json objectForKey:@"data-expirare"];
            if (dExpirare && dExpirare.length >0)
                dataExpirare = [YTOUtils getDateFromString:dExpirare withFormat:@"dd.MM.yyyy"];
            
            if ([status isEqualToString:@"0"])
                [self showPopup:@"Polita nu a fost gasita!" withDescription:mesaj];
                //vwErrorAlert.hidden = NO;
            else if ([status isEqualToString:@"1"])
                [self showPopup:@"Polita gasita!" withDescription:mesaj];
            else if ([status isEqualToString:@"2"])
                [self showPopup:@"Polita valida!" withDescription:mesaj];
        }
    }
	else {
        
	}
    
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"connection:didFailWithError:");
	NSLog(@"%@", [error localizedDescription]);
	
    [self hideLoading];
    //[self showPopup:@"Polita nu a fost gasita" withDescription:@"Baza de date CEDAM nu a raspuns. Fie nu functioneaza momentan, fie ai introdus gresit seria de sasiu sau numarul de inmatriculare."];
    vwErrorAlert.hidden = NO;
}

#pragma mark NSXMLParser Methods
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if ([elementName isEqualToString:@"VerificaRCAResult"]) {
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
    [lblLoadingTitlu setText:@"Verificam polita..."];
    [loading setHidden:NO];
    [vwLoading setHidden:NO];
}
- (IBAction) hideLoading
{
    [vwLoading setHidden:YES];
    
    /* Poate facem ceva..setam o alerta sau facem o calculatie
    if (dataExpirare != nil)
    {
        
        
        NSDate *fromDate;
        NSDate *toDate;
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
                     interval:NULL forDate:[NSDate date]];
        [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
                     interval:NULL forDate:dataExpirare];
        
        NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                                   fromDate:fromDate toDate:toDate options:0];
        
        
        if ([difference day] < 7)
            NSLog(@"polita expira in mai putin de 7 zile");
        NSLog(@"polita expira in %d zile", [difference day]);
    } */
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

- (IBAction) hideErrorAlert:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    [vwErrorAlert setHidden:YES];
    
    if (btn == btnErrorAlertOK)
        [vwDetailErrorAlert setHidden:NO];
    //else
      //  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) hideDetailErrorAlert
{
    [vwDetailErrorAlert setHidden:YES];
    //[self.navigationController popViewControllerAnimated:YES];
}

@end
