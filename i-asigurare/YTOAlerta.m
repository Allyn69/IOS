//
//  YTOAlerta.m
//  i-asigurare
//
//  Created by Andi Aparaschivei on 10/29/12.
//
//

#import "YTOAlerta.h"
#import "YTOAppDelegate.h"
#import "YTOObiectAsigurat.h"
#import "Database.h"

@implementation YTOAlerta

@synthesize idExtern;
@synthesize idIntern;
@synthesize tipAlerta;
@synthesize dataAlerta;
@synthesize esteRata;
@synthesize numarTotalRate;
@synthesize numarRata;
@synthesize idObiect;
@synthesize _dataCreare;
@synthesize _isDirty;

@synthesize responseData;

- (id)initWithGuid:(NSString*)guid
{
    self = [super init];
    self.idIntern = guid;
    self._dataCreare = [NSDate date];
    return self;
}

- (void) addAlerta
{
    YTOObiectAsigurat * alerta = [[YTOObiectAsigurat alloc] init];
    alerta.IdIntern = self.idIntern;
    alerta.TipObiect = 4;
    alerta.JSONText = [self toJSON];
    [alerta addObiectAsigurat];
    self._isDirty = YES;

    [self showLoading];
    [self performSelectorInBackground:@selector(callInregistrareAlerta) withObject:nil];
    
    [self refresh];
}

- (void) updateAlerta
{
    YTOObiectAsigurat * ob = [YTOObiectAsigurat getObiectAsigurat:self.idIntern];
    ob.JSONText = [self toJSON];
    [ob updateObiectAsigurat];

    [self showLoading];
    [self performSelectorInBackground:@selector(callInregistrareAlerta) withObject:nil];
    
    [self refresh];
}

- (void) deleteAlerta
{
    YTOObiectAsigurat * ob = [YTOObiectAsigurat getObiectAsigurat:self.idIntern];
    ob.JSONText = [self toJSON];
    [ob deleteObiectAsigurat];

    [self showLoading];
    [self performSelectorInBackground:@selector(markAlertaAsDeleted) withObject:nil];
    
    [self refresh];
}

+ (YTOAlerta *) getAlerta:(NSString *)_idIntern
{
    NSMutableArray * list = [YTOAlerta Alerte];
    for (int i=0; i<list.count; i++) {
        YTOAlerta * _alerta = [list objectAtIndex:i];
        if ([_alerta.idIntern isEqualToString:_idIntern])
            return _alerta;
    }
    return  nil;
}

+ (YTOAlerta *) getAlerta:(NSString *)_idIntern forType:(int)tip
{
    NSMutableArray * list = [YTOAlerta Alerte];
    for (int i=0; i<list.count; i++) {
        YTOAlerta * _alerta = [list objectAtIndex:i];
        if ([_alerta.idObiect isEqualToString:_idIntern] &&_alerta.tipAlerta == tip)
            return _alerta;
    }
    return  nil;
}

+ (YTOAlerta *) getAlertaRCA:(NSString *)_idIntern
{
    return [self getAlerta:_idIntern forType:1];
}

+ (YTOAlerta *) getAlertaITP:(NSString *)_idIntern
{
    return [self getAlerta:_idIntern forType:2];
}

+ (YTOAlerta *) getAlertaRovinieta:(NSString *)_idIntern
{
    return [self getAlerta:_idIntern forType:3];
}

+ (YTOAlerta *) getAlertaCasco:(NSString *)_idIntern
{
    return [self getAlerta:_idIntern forType:5];
}

+ (YTOAlerta *) getAlertaLocuinta:(NSString *)_idIntern
{
    return [self getAlerta:_idIntern forType:6];
}

+ (YTOAlerta *) getAlertaRataCasco:(NSString *)_idIntern
{
    NSMutableArray * list = [YTOAlerta Alerte];
    for (int i=0; i<list.count; i++) {
        YTOAlerta * _alerta = [list objectAtIndex:i];
        if ([_alerta.idObiect isEqualToString:_idIntern] &&_alerta.tipAlerta == 7 && _alerta.numarRata == 0)
            return _alerta;
    }
    return  nil;
}

+ (YTOAlerta *) getAlertaRataCasco:(NSString *)_idIntern andNumarRata:(int)x
{
    NSMutableArray * list = [YTOAlerta Alerte];
    for (int i=0; i<list.count; i++) {
        YTOAlerta * _alerta = [list objectAtIndex:i];
        if ([_alerta.idObiect isEqualToString:_idIntern] &&_alerta.tipAlerta == 7 && _alerta.numarRata == x)
            return _alerta;
    }
    return  nil;
}

+ (YTOAlerta *) getAlertaRataLocuinta:(NSString *)_idIntern
{
    return [self getAlerta:_idIntern forType:8];
}

+ (NSMutableArray*)Alerte
{
    NSMutableArray * _list = [[NSMutableArray alloc] init];
    
    NSMutableArray * jsonList = [YTOObiectAsigurat getListaByTipObiect:4];
    
    for (int i=0; i<jsonList.count; i++) {
        YTOObiectAsigurat * ob = (YTOObiectAsigurat *)[jsonList objectAtIndex:i];
        
        YTOAlerta * p = [[YTOAlerta alloc] init];
        [p fromJSON:ob.JSONText];
        p.idIntern = ob.IdIntern;
        
        if(p)
        {
            [_list addObject:p];
        }
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dataAlerta" ascending:TRUE];
    [_list sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    return _list;
}

+ (int)GetNrAlerteScadente
{
    YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    int count=0;
    NSMutableArray * list = [delegate Alerte];
    NSDate * peste4zile = [NSDate date];
    for (int i=0; i<list.count; i++)
    {
        YTOAlerta * alerta = [list objectAtIndex:i];
        
        NSDate *fromDate;
        NSDate *toDate;
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
                     interval:NULL forDate:peste4zile];
        [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
                     interval:NULL forDate:alerta.dataAlerta];
        
        NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                                   fromDate:fromDate toDate:toDate options:0];
        
        //NSLog(@"%d",[difference day]);
        if ([difference day] < 5)
            count++;
    }
    return count;
}

- (NSString *) toJSON
{
    NSError * error;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString=[dateFormat stringFromDate:self._dataCreare];
    
    NSDictionary * dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                            [NSNumber numberWithInt: self.idExtern], @"id_extern",
                           [NSNumber numberWithInt: self.tipAlerta], @"tip_alerta",
                           (self.idObiect ? self.idObiect : @""), @"id_obiect",
                           (self.dataAlerta ? [dateFormat stringFromDate:self.dataAlerta] : @""), @"data_alerta",
                           (self.esteRata ? self.esteRata : @""), @"este_rata",
                           [NSNumber numberWithInt:self.numarTotalRate], @"numar_total_rate",
                           [NSNumber numberWithInt:self.numarRata], @"numar_rata",
                           dateString, @"data_creare",
                           nil];
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    NSString * text = [[NSString alloc] initWithData:jsonData
                                            encoding:NSUTF8StringEncoding];
    
    return text;
}

- (void) fromJSON:(NSString *)p
{
    NSError * err = nil;
    NSData *data = [p dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * item = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
    
    self.idExtern = [[item objectForKey:@"id_extern"] intValue];
    self.tipAlerta = [[item objectForKey:@"tip_alerta"] intValue];
    self.idObiect = [item objectForKey:@"id_obiect"];
    self.esteRata = [item objectForKey:@"este_rata"];
    self.numarTotalRate = [[item objectForKey:@"numar_total_rate"] intValue];
    self.numarRata = [[item objectForKey:@"numar_rata"] intValue];
    NSString * dataString = [item objectForKey:@"data_creare"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString * dataAlertaString = [item objectForKey:@"data_alerta"];
    
    self.dataAlerta = [dateFormat dateFromString:dataAlertaString];
    self._dataCreare = [dateFormat dateFromString:dataString];
    
    self._isDirty = YES;
}

- (void) refresh
{
    YTOAppDelegate * appDelegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate refreshAlerte];
}


#pragma mark Consume WebService

- (NSString *) XmlRequest
{
    YTOPersoana * proprietar = [YTOPersoana Proprietar];
    if (!proprietar)
        proprietar = [YTOPersoana ProprietarPJ];
        
    NSString * xml = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                      "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                      "<soap:Body>"
                      "<InregistrareAlerte3 xmlns=\"http://tempuri.org/\">"
                      "<user>vreaurca</user>"
                      "<password>123</password>"
                      "<tip>%d</tip>"
                      "<data_alerta>%@</data_alerta>"
                      "<nr_rata>%d</nr_rata>"
                      "<prima>%.2f</prima>"
                      "<moneda>%@</moneda>"
                      "<udid>%@</udid>"
                      "<id_intern>%@</id_intern>"
                      "<platforma>%@</platforma>"
                      "<email>%@</email>"
                      "</InregistrareAlerte3>"
                      "</soap:Body>"
                      "</soap:Envelope>",
                      self.tipAlerta, [YTOUtils formatDate:self.dataAlerta withFormat:@"dd.MM.yyyy"],
                      self.numarRata,
                      0.0,      // prima
                      @"lei",   // moneda
                      [[UIDevice currentDevice] uniqueIdentifier],
                      self.idObiect,
                      [[UIDevice currentDevice].model stringByReplacingOccurrencesOfString:@" " withString:@"_"],
                      (proprietar != nil ?  proprietar.email : @"fara email")];
    return xml;
}

- (void) markAlertaAsDeleted
{
    NSString * xmlRequest = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<DisableAlert xmlns=\"http://tempuri.org/\">"
                             "<user>vreaurca</user>"
                             "<password>123</password>"
                             "<udid>%@</udid>"
                             "<id_intern>%@</id_intern>"
                             "</DisableAlert>"
                             "</soap:Body>"
                             "</soap:Envelope>",
                             [[UIDevice currentDevice] uniqueIdentifier], self.idObiect];
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@sync.asmx", LinkAPI]];
    
	NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
															cachePolicy:NSURLRequestUseProtocolCachePolicy
														timeoutInterval:5.0];
    
	NSString * parameters = [[NSString alloc] initWithString:xmlRequest];
	NSLog(@"Request=%@", parameters);
	NSString * msgLength = [NSString stringWithFormat:@"%d", [parameters length]];
	
	[request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[request addValue:@"http://tempuri.org/DisableAlert" forHTTPHeaderField:@"SOAPAction"];
	[request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	if (connection) {
		self.responseData = [NSMutableData data];
	}
    
    [self performSelectorOnMainThread:@selector(hideLoading) withObject:nil waitUntilDone:NO];
}

- (void) callInregistrareAlerta {

	NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@rca.asmx", LinkAPI]];
    
	NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
															cachePolicy:NSURLRequestUseProtocolCachePolicy
														timeoutInterval:5.0];
    
	NSString * parameters = [[NSString alloc] initWithString:[self XmlRequest]];
	NSLog(@"Request=%@", parameters);
	NSString * msgLength = [NSString stringWithFormat:@"%d", [parameters length]];
	
	[request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[request addValue:@"http://tempuri.org/InregistrareAlerte3" forHTTPHeaderField:@"SOAPAction"];
	[request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	if (connection) {
		self.responseData = [NSMutableData data];
	}
    
    [self performSelectorOnMainThread:@selector(hideLoading) withObject:nil waitUntilDone:NO];
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
        NSLog(@"alerta inregistrata");
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
	if ([elementName isEqualToString:@"InregistrareAlerte3Result"]) {
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


#pragma LOADING
- (void) showLoading
{
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
}
- (void) hideLoading
{
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO;
}
@end
