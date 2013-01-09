//
//  YTOPersoana.m
//  i-asigurare
//
//  Created by Andi Aparaschivei on 7/16/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
//

#import "YTOPersoana.h"
#import "YTOAppDelegate.h"
#import "YTOObiectAsigurat.h"
#import "Database.h"

@implementation YTOPersoana

@synthesize responseData;

@synthesize idIntern;
@synthesize nume;
@synthesize codUnic;
@synthesize judet;
@synthesize localitate;
@synthesize adresa;
@synthesize tipPersoana;
@synthesize casatorit;
@synthesize copiiMinori;
@synthesize pensionar;
@synthesize nrBugetari;
@synthesize dataPermis;
@synthesize codCaen;
@synthesize handicapLocomotor;
@synthesize serieAct;
@synthesize elevStudent;
@synthesize boliNeuro;
@synthesize boliCardio;
@synthesize boliInterne;
@synthesize boliAparatRespirator;
@synthesize alteBoli;
@synthesize boliDefinitive;
@synthesize stareSanatate;
@synthesize telefon;
@synthesize email;
@synthesize proprietar;

@synthesize _isDirty;

-(id)initWithGuid:(NSString*)guid
{
    self = [super init];
    self.idIntern = guid;

    return self;
}

- (void) addPersoana
{
    YTOObiectAsigurat * persoana = [[YTOObiectAsigurat alloc] init];
    persoana.IdIntern = self.idIntern;
    persoana.TipObiect = 1;
    persoana.JSONText = [self toJSON];
    [persoana addObiectAsigurat];
    self._isDirty = YES;
    
    [self showLoading];
    
    if ([self.tipPersoana isEqualToString:@"fizica"] && [self.proprietar isEqualToString:@"da"])
        [self performSelectorInBackground:@selector(createAccount) withObject:nil];
    else
        [self performSelectorInBackground:@selector(registerPersoana) withObject:nil];
    [self refresh];
}

- (void) updatePersoana
{
    YTOObiectAsigurat * ob = [YTOObiectAsigurat getObiectAsigurat:self.idIntern];
    ob.JSONText = [self toJSON];
    [ob updateObiectAsigurat];
    
    [self showLoading];

    if ([self.tipPersoana isEqualToString:@"fizica"] && [self.proprietar isEqualToString:@"da"])
        [self performSelectorInBackground:@selector(createAccount) withObject:nil];
    else
        [self performSelectorInBackground:@selector(registerPersoana) withObject:nil];
    
    [self refresh];
}

- (void) deletePersoana
{
    YTOObiectAsigurat * ob = [YTOObiectAsigurat getObiectAsigurat:self.idIntern];
    ob.JSONText = [self toJSON];
    [ob deleteObiectAsigurat];

    [self showLoading];
    
    [self showLoading];
    [self performSelectorInBackground:@selector(markPersoanaAsDeleted) withObject:nil];
    
    [self refresh];
}

+ (YTOPersoana *) getPersoana:(NSString *)_idIntern 
{
    YTOObiectAsigurat * ob = [YTOObiectAsigurat getObiectAsigurat:_idIntern];
    
    if (ob.JSONText)
    {
        YTOPersoana * p = [[YTOPersoana alloc] init];
        [p fromJSON:ob.JSONText];
        p.idIntern = _idIntern;
    
        return p;
    }
    return nil;
}

+ (YTOPersoana *) getPersoanaByCodUnic:(NSString *)_codUnic
{
    YTOAppDelegate * appDelegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];

    NSMutableArray * list = [appDelegate Persoane];
    for (int i=0; i<list.count; i++) {
        YTOPersoana * p = [list objectAtIndex:i];
        if ([p.codUnic isEqualToString:_codUnic]) {
            return p;
        }
    }
    return nil;
}

- (NSMutableArray*)getPersoane 
{
    NSMutableArray * _list = [[NSMutableArray alloc] init];
    
    NSMutableArray * jsonList = [YTOObiectAsigurat getListaByTipObiect:1];
    
    for (int i=0; i<jsonList.count; i++) {        
        YTOObiectAsigurat * ob = (YTOObiectAsigurat *)[jsonList objectAtIndex:i];
        
        YTOPersoana * p = [[YTOPersoana alloc] init];
        [p fromJSON:ob.JSONText];
        p.idIntern = ob.IdIntern;
        
        if(p)
            [_list addObject:p];
    }
    
    return _list;
}

+ (NSMutableArray*)AltePersoane 
{
    NSMutableArray * _list = [[NSMutableArray alloc] init];
    
    YTOAppDelegate * appDelegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableArray * listPersoane = [appDelegate Persoane];
    
    for (int i=0; i<listPersoane.count; i++) {        
        YTOPersoana * p = [listPersoane objectAtIndex:i];
        
        if(![p.proprietar isEqualToString:@"da"])
            [_list addObject:p];
    }
    
    return _list;
}

+ (NSMutableArray*)PersoaneFizice
{
    YTOAppDelegate * appDelegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableArray * list = [appDelegate Persoane];
    NSMutableArray * listPF = [[NSMutableArray alloc] init];
    
    for (int i=0; i<list.count; i++) {
        YTOPersoana * p = [list objectAtIndex:i];
        if ([p.tipPersoana isEqualToString:@"fizica"]) {
            [listPF addObject:p];
        }
    }
    
    return listPF;
}

+ (YTOPersoana *) Proprietar
{
    YTOPersoana * p = nil;
    
    YTOAppDelegate * appDelegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableArray * list = [appDelegate Persoane];
    for (int i=0; i<list.count; i++) {
        YTOPersoana * p = [list objectAtIndex:i];
        if ([p.proprietar isEqualToString:@"da"] && [p.tipPersoana isEqualToString:@"fizica"]) {
            return p;
        }
    }
    
    return p;
}

+ (YTOPersoana *) ProprietarPJ
{
    YTOPersoana * p = nil;
    
    YTOAppDelegate * appDelegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableArray * list = [appDelegate Persoane];
    for (int i=0; i<list.count; i++) {
        YTOPersoana * p = [list objectAtIndex:i];
        if ([p.proprietar isEqualToString:@"da"] && [p.tipPersoana isEqualToString:@"juridica"]) {
            return p;
        }
    }
    
    return p;
}

- (NSString *) toJSON
{
    NSError * error;
    
    NSDictionary * dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                           self.nume, @"nume_asigurat",
                           (self.codUnic ? self.codUnic : @""), @"cod_unic",
                           (self.judet ? self.judet : @""), @"judet",
                           (self.localitate ? self.localitate : @""), @"localitate",
                           (self.adresa ? self.adresa : @""), @"adresa",
                           (self.tipPersoana ? self.tipPersoana : @""), @"tip_persoana",
                           (self.casatorit ? self.casatorit : @""), @"casatorit",
                           (self.copiiMinori ? self.copiiMinori : @""), @"copii_minori",
                           (self.pensionar ? self.pensionar : @""), @"pensionar",
                           (self.nrBugetari ? self.nrBugetari : @""), @"nr_bugetari",
                           (self.dataPermis ? self.dataPermis : @""), @"data_permis",
                           (self.codCaen ? self.codCaen : @""), @"cod_caen",
                           (self.handicapLocomotor ? self.handicapLocomotor : @""), @"handicap",
                           (self.serieAct ? self.serieAct : @""), @"serie_act",
                           (self.elevStudent ? self.elevStudent : @""), @"elev",
                           (self.boliNeuro ? self.boliNeuro : @""), @"boli_neuro",
                           (self.boliCardio ? self.boliCardio : @""), @"boli_cardio",
                           (self.boliInterne ? self.boliInterne : @""), @"boli_interne",
                           (self.boliAparatRespirator ? self.boliAparatRespirator : @""), @"boli_aparat_respirator",
                           (self.alteBoli ? self.alteBoli : @""), @"alte_boli",
                           (self.boliDefinitive ? self.boliDefinitive : @""), @"boli_definitive",
                           (self.stareSanatate ? self.stareSanatate : @""), @"stare_sanatate", 
                           (self.telefon ? self.telefon : @""), @"telefon",
                           (self.email ? self.email : @""), @"email",                           
                           (self.proprietar ? self.proprietar : @"nu"), @"proprietar",
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
    
    self.nume = [item objectForKey:@"nume_asigurat"];
    self.codUnic = [item objectForKey:@"cod_unic"];
    self.judet = [item objectForKey:@"judet"];
    self.localitate = [item objectForKey:@"localitate"];
    self.adresa = [item objectForKey:@"adresa"];
    self.tipPersoana = [item objectForKey:@"tip_persoana"];
    self.casatorit = [item objectForKey:@"casatorit"];
    self.copiiMinori = [item objectForKey:@"copii_minori"];
    self.pensionar = [item objectForKey:@"pensionar"];
    self.nrBugetari = [item objectForKey:@"nr_bugetari"];
    self.dataPermis = [item objectForKey:@"data_permis"];
    self.codCaen = [item objectForKey:@"cod_caen"];
    self.handicapLocomotor = [item objectForKey:@"handicap"];
    self.serieAct = [item objectForKey:@"serie_act"];
    self.elevStudent = [item objectForKey:@"elev"];
    self.boliNeuro = [item objectForKey:@"boli_neuro"];
    self.boliCardio = [item objectForKey:@"boli_cardio"];
    self.boliInterne = [item objectForKey:@"boli_interne"];
    self.boliAparatRespirator = [item objectForKey:@"boli_aparat_respirator"];
    self.alteBoli = [item objectForKey:@"alte_boli"];
    self.boliDefinitive = [item objectForKey:@"boli_definitive"];
    self.stareSanatate = [item objectForKey:@"stare_sanatate"];
    self.telefon = [item objectForKey:@"telefon"];
    self.email = [item objectForKey:@"email"];
    self.proprietar = [item objectForKey:@"proprietar"];
    
    self._isDirty = YES;
}

- (void) refresh
{
    YTOAppDelegate * appDelegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate refreshPersoane];
}

+ (NSString *) getJsonPersoane:(NSMutableArray *) list
{
    NSString * jsonText = @"[";
    for (int i=0; i<list.count; i++) {
        YTOPersoana * p = (YTOPersoana *)[list objectAtIndex:i];
        
        NSDictionary * dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                               @"buna", @"stare_sanatate",
                               p.alteBoli, @"alte_boli",
                               p.boliInterne, @"boli_interne",
                               p.boliNeuro, @"boli_neuro",
                               p.handicapLocomotor, @"grad_invaliditate",
                               p.boliDefinitive, @"boli_definitive",
                               p.boliAparatRespirator, @"boli_aparat_respirator",
                               p.boliCardio, @"boli_cardio",
                               @"28", @"varsta",
                               p.elevStudent, @"elev",
                               @"nu", @"sport_agrement",
                               @"0", @"sa_bagaje",
                               @"0", @"sa_echipament",
                               p.nume, @"nume_asigurat",
                               p.codUnic, @"cod_unic",
                               p.adresa, @"adresa",
                               p.idIntern, @"id_intern",
                               p.judet, @"judet",
                               p.localitate, @"localitate",
                               p.serieAct, @"pasaport_ci",
                               nil];
        
        NSError * error;
        
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                           options:NSJSONWritingPrettyPrinted error:&error];
        NSString * text = [[NSString alloc] initWithData:jsonData
                                                encoding:NSUTF8StringEncoding];
        if (i == list.count-1)
            jsonText = [YTOUtils append:jsonText, text, nil];
        else
            jsonText = [YTOUtils append:jsonText, text, @",", nil];
    }
    jsonText = [YTOUtils append:jsonText, @"]", nil];
    
    return jsonText;
}

- (BOOL) isValidForCompute
{
    BOOL valid = YES;
    
    if (!self.nume || self.nume.length == 0)
        valid = NO;
    if (!self.codUnic || self.codUnic.length == 0)
        valid = NO;
    if (!self.judet || self.judet.length == 0)
        valid = NO;
    if (!self.localitate || self.localitate.length == 0)
        valid = NO;

    return  valid;
}


- (void) createAccount
{
    
    NSString * xmlRequest = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                                "<soap:Body>"
                                    "<CreateAccount xmlns=\"http://tempuri.org/\">"
                                    "<user>vreaurca</user>"
                                    "<password>123</password>"
                                    "<nume>%@</nume>"
                                    "<cod_unic>%@</cod_unic>"
                                    "<judet>%@</judet>"
                                    "<localitate>%@</localitate>"
                                    "<adresa>%@</adresa>"
                                    "<telefon>%@</telefon>"
                                    "<email>%@</email>"
                                    "<udid>%@</udid>"
                                    "<platforma>%@</platforma>"
                                    "</CreateAccount>"
                                "</soap:Body>"
                             "</soap:Envelope>", self.nume, self.codUnic, self.judet, self.localitate, self.adresa, self.telefon, self.email,
                             [[UIDevice currentDevice] uniqueIdentifier],
                             [[UIDevice currentDevice].model stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@sync.asmx", LinkAPI]];
    
	NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
															cachePolicy:NSURLRequestUseProtocolCachePolicy
														timeoutInterval:10.0];
    
	NSString * parameters = [[NSString alloc] initWithString:xmlRequest];
	NSLog(@"Request=%@", parameters);
	NSString * msgLength = [NSString stringWithFormat:@"%d", [parameters length]];
	
	[request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[request addValue:@"http://tempuri.org/CreateAccount" forHTTPHeaderField:@"SOAPAction"];
	[request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	if (connection) {
		self.responseData = [NSMutableData data];
	}
    
    [self performSelectorOnMainThread:@selector(hideLoading) withObject:nil waitUntilDone:NO];
}

- (void) registerPersoana
{
    
    NSString * xmlRequest = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<RegisterPersoana xmlns=\"http://tempuri.org/\">"
                             "<user>vreaurca</user>"
                             "<password>123</password>"
                             "<nume>%@</nume>"
                             "<tip_persoana>%@</tip_persoana>"
                             "<cod_unic>%@</cod_unic>"
                             "<judet>%@</judet>"
                             "<localitate>%@</localitate>"
                             "<adresa>%@</adresa>"
                             "<telefon>%@</telefon>"
                             "<email>%@</email>"
                             "<udid>%@</udid>"
                             "<id_intern>%@</id_intern>"
                             "<proprietar>%@</proprietar>"
                             "<platforma>%@</platforma>"
                             "</RegisterPersoana>"
                             "</soap:Body>"
                             "</soap:Envelope>", self.nume, self.tipPersoana, self.codUnic, self.judet, self.localitate, self.adresa, self.telefon, self.email,
                             [[UIDevice currentDevice] uniqueIdentifier], self.idIntern, self.proprietar,
                             [[UIDevice currentDevice].model stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@sync.asmx", LinkAPI]];
    
	NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
															cachePolicy:NSURLRequestUseProtocolCachePolicy
														timeoutInterval:10.0];
    
	NSString * parameters = [[NSString alloc] initWithString:xmlRequest];
	NSLog(@"Request=%@", parameters);
	NSString * msgLength = [NSString stringWithFormat:@"%d", [parameters length]];
	
	[request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[request addValue:@"http://tempuri.org/RegisterPersoana" forHTTPHeaderField:@"SOAPAction"];
	[request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	if (connection) {
		self.responseData = [NSMutableData data];
	}
    
    [self performSelectorOnMainThread:@selector(hideLoading) withObject:nil waitUntilDone:NO];
}

- (void) markPersoanaAsDeleted
{
    NSString * xmlRequest = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<DeletePersoana xmlns=\"http://tempuri.org/\">"
                             "<user>vreaurca</user>"
                             "<password>123</password>"
                             "<udid>%@</udid>"
                             "<id_persoana>%@</id_persoana>"
                             "</DeletePersoana>"
                             "</soap:Body>"
                             "</soap:Envelope>",
                             [[UIDevice currentDevice] uniqueIdentifier], self.idIntern];
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@sync.asmx", LinkAPI]];
    
	NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
															cachePolicy:NSURLRequestUseProtocolCachePolicy
														timeoutInterval:10.0];
    
	NSString * parameters = [[NSString alloc] initWithString:xmlRequest];
	NSLog(@"Request=%@", parameters);
	NSString * msgLength = [NSString stringWithFormat:@"%d", [parameters length]];
	
	[request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[request addValue:@"http://tempuri.org/DeletePersoana" forHTTPHeaderField:@"SOAPAction"];
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
    [self hideLoading];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
	NSString * responseString = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
	NSLog(@"Response string: %@", responseString);
    
    [self hideLoading];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"connection:didFailWithError:");
	NSLog(@"%@", [error localizedDescription]);
    [self hideLoading];
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
