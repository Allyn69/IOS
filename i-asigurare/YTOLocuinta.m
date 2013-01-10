//
//  YTOLocuinta.m
//  i-asigurare
//
//  Created by Andi Aparaschivei on 8/2/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
//

#import "YTOLocuinta.h"
#import "YTOAppDelegate.h"
#import "YTOObiectAsigurat.h"
#import "YTOAlerta.h"
#import "Database.h"

@implementation YTOLocuinta

@synthesize idIntern;
@synthesize tipLocuinta;
@synthesize structuraLocuinta;
@synthesize regimInaltime;
@synthesize etaj;
@synthesize anConstructie;
@synthesize nrCamere;
@synthesize suprafataUtila;
@synthesize nrLocatari;
@synthesize tipGeam;
@synthesize areAlarma;
@synthesize areGrilajeGeam;
@synthesize zonaIzolata;
@synthesize clauzaFurtBunuri;
@synthesize clauzaApaConducta;
@synthesize detectieIncendiu;
@synthesize arePaza;
@synthesize areTeren;
@synthesize locuitPermanent;
@synthesize judet;
@synthesize localitate;
@synthesize adresa;
@synthesize modEvaluare;
@synthesize nrRate;
@synthesize sumaAsigurata;
@synthesize sumaAsigurataRC;
@synthesize idProprietar;
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

//IdIntern, Tip, Structura, Inaltime, Etaj, AnConstructie, NrCamere, Suprafata, NrLocatari, TipGeam, AreAlarma, AreGrilajeGeam, zonaIzolata, ClauzaFurtBunuri, ClauzaApaConducta, DetectieIncendiu, ArePaza, LocuitPermanent, Judet, Localitate, Adresa, ModEvaluare, NrRate, SumaAsigurata, SumaAsigurataRC, IdProprietar, _dataCreare

- (void) addLocuinta
{
    YTOObiectAsigurat * locuinta = [[YTOObiectAsigurat alloc] init];
    locuinta.IdIntern = self.idIntern;
    locuinta.TipObiect = 3;
    locuinta.JSONText = [self toJSON];
    [locuinta addObiectAsigurat];
    self._isDirty = YES;
    
    [self showLoading];
    [self performSelectorInBackground:@selector(registerLocuinta) withObject:nil];
    
    [self refresh];
}

- (void) updateLocuinta
{
    YTOObiectAsigurat * ob = [YTOObiectAsigurat getObiectAsigurat:self.idIntern];
    ob.JSONText = [self toJSON];
    [ob updateObiectAsigurat];
   
    [self showLoading];
    [self performSelectorInBackground:@selector(registerLocuinta) withObject:nil];
    
    [self refresh];
}

- (void) deleteLocutina
{
    YTOObiectAsigurat * ob = [YTOObiectAsigurat getObiectAsigurat:self.idIntern];
    ob.JSONText = [self toJSON];
    [ob deleteObiectAsigurat];

    [self showLoading];
    [self performSelectorInBackground:@selector(markLocuintaAsDeleted) withObject:nil];
    
    [self refresh];
    
    // dupa ce sterg locuinta,
    // sterg si alertele, in caz ca exista
    YTOAlerta * alertaLocuinta = [YTOAlerta getAlertaLocuinta:self.idIntern];
    if (alertaLocuinta)
        [alertaLocuinta deleteAlerta];
    YTOAlerta * alertaRataLocuinta = [YTOAlerta getAlertaRataLocuinta:self.idIntern];
    if (alertaRataLocuinta)
        [alertaRataLocuinta deleteAlerta];
}

+ (YTOLocuinta *) getLocuinta:(NSString *)_idIntern
{
    YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];    
    NSMutableArray * list = [delegate Locuinte];
    for (int i=0; i<list.count; i++) {
        YTOLocuinta * _loc = [list objectAtIndex:i];
        if ([_loc.idIntern isEqualToString:_idIntern])
            return _loc;
    }
    return  nil;    
}

+ (YTOLocuinta *) getLocuintaByProprietar:(NSString *)_idProprietar
{
    YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];    
    NSMutableArray * list = [delegate Locuinte];
    for (int i=0; i<list.count; i++) {
        YTOLocuinta * _loc = [list objectAtIndex:i];
        if ([_loc.idProprietar isEqualToString:_idProprietar])
            return _loc;
    }
    return  nil;
}

+ (NSMutableArray*)Locuinte
{
    NSMutableArray * _list = [[NSMutableArray alloc] init];
   
    NSMutableArray * jsonList = [YTOObiectAsigurat getListaByTipObiect:3];
    
    for (int i=0; i<jsonList.count; i++) {        
        YTOObiectAsigurat * ob = (YTOObiectAsigurat *)[jsonList objectAtIndex:i];
        
        YTOLocuinta * p = [[YTOLocuinta alloc] init];
        [p fromJSON:ob.JSONText];
        p.idIntern = ob.IdIntern;
        
        if(p)
            [_list addObject:p];
    }
    
    return _list;
}

- (NSString *) toJSON
{
    NSError * error;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString=[dateFormat stringFromDate:self._dataCreare];
    
    NSDictionary * dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                           (self.tipLocuinta ? self.tipLocuinta : @""), @"tip_locuinta",
                           (self.structuraLocuinta ? self.structuraLocuinta : @""), @"structura_rezistenta",
                           [NSNumber numberWithInt:self.regimInaltime], @"regim_inaltime",
                           [NSNumber numberWithInt:self.etaj], @"etaj",
                           [NSNumber numberWithInt:self.anConstructie], @"an_constructie",
                           [NSNumber numberWithInt:self.nrCamere], @"nr_camere",
                           [NSNumber numberWithInt:self.suprafataUtila], @"suprafata_utila",
                           [NSNumber numberWithInt:self.nrLocatari], @"nr_locatari",
                           (self.tipGeam ? self.tipGeam : @""), @"tip_geam",
                           (self.areAlarma ? self.areAlarma : @""), @"are_alarma",
                           (self.areGrilajeGeam ? self.areGrilajeGeam : @""), @"are_grilaje_geam",
                           (self.zonaIzolata ? self.zonaIzolata : @""), @"zona_izolata",
                           (self.clauzaFurtBunuri ? self.clauzaFurtBunuri : @""), @"clauza_furt_bunuri",
                           (self.clauzaApaConducta ? self.clauzaApaConducta : @""), @"clauza_apa_conducta",
                           (self.detectieIncendiu ? self.detectieIncendiu : @""), @"detectie_incendiu",
                           (self.arePaza ? self.arePaza : @""), @"are_paza",
                           (self.areTeren ? self.areTeren : @""), @"are_teren",
                           (self.locuitPermanent ? self.locuitPermanent : @""), @"locuit_permanent",
                           (self.judet ? self.judet : @""), @"judet",
                           (self.localitate ? self.localitate : @""), @"localitate",
                           (self.adresa ? self.adresa : @""), @"adresa",
                           (self.modEvaluare ? self.modEvaluare : @""), @"mod_evaluare",
                           [NSNumber numberWithInt:self.nrRate], @"nr_rate",
                           [NSNumber numberWithInt:self.sumaAsigurata], @"suma_asigurata",
                           [NSNumber numberWithInt:self.sumaAsigurataRC], @"suma_asigurata_rc",
                           (self.idProprietar ? self.idProprietar : @""), @"id_proprietar",
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
    
    self.tipLocuinta = [item objectForKey:@"tip_locuinta"];
    self.structuraLocuinta = [item objectForKey:@"structura_rezistenta"];
    self.regimInaltime = [[item objectForKey:@"regim_inaltime"] intValue];
    self.etaj = [[item objectForKey:@"etaj"] intValue];
    self.anConstructie = [[item objectForKey:@"an_constructie"] intValue];
    self.nrCamere = [[item objectForKey:@"nr_camere"] intValue];
    self.suprafataUtila = [[item objectForKey:@"suprafata_utila"] intValue];
    self.nrLocatari = [[item objectForKey:@"nr_locatari"] intValue];
    self.tipGeam = [item objectForKey:@"tip_geam"];
    self.areAlarma = [item objectForKey:@"are_alarma"];
    self.areGrilajeGeam = [item objectForKey:@"are_grilaje_geam"];
    self.zonaIzolata = [item objectForKey:@"zona_izolata"];
    self.clauzaFurtBunuri = [item objectForKey:@"clauza_furt_bunuri"];
    self.clauzaApaConducta = [item objectForKey:@"clauza_apa_conducta"];
    self.detectieIncendiu = [item objectForKey:@"detectie_incendiu"];
    self.arePaza = [item objectForKey:@"are_paza"];
    self.areTeren = [item objectForKey:@"are_teren"];
    self.locuitPermanent = [item objectForKey:@"locuit_permanent"];
    self.judet = [item objectForKey:@"judet"];
    self.localitate = [item objectForKey:@"localitate"];
    self.adresa = [item objectForKey:@"adresa"];
    self.modEvaluare = [item objectForKey:@"mod_evaluare"];
    self.nrRate = [[item objectForKey:@"nr_rate"] intValue];
    self.sumaAsigurata = [[item objectForKey:@"suma_asigurata"] intValue];
    self.sumaAsigurataRC = [[item objectForKey:@"suma_asigurata_rc"] intValue];
    self.idProprietar = [item objectForKey:@"id_proprietar"];
    
    NSString * dataString = [item objectForKey:@"data_creare"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    self._dataCreare = [dateFormat dateFromString:dataString];
    
    self._isDirty = YES;
}

- (BOOL) isValidForLocuinta
{
    BOOL valid = YES;
    
    if (!self.judet || self.judet.length == 0)
        valid = NO;
    if (!self.localitate || self.localitate.length == 0)
        valid = NO;
    if (!self.tipLocuinta || self.tipLocuinta.length == 0)
        valid = NO;
    if (!self.structuraLocuinta || self.structuraLocuinta.length == 0)
        valid = NO;
    if (self.regimInaltime == 0)
        valid = NO;
    if ([tipLocuinta isEqualToString:@"apartament-in-bloc"])
        if (self.etaj == 0)
        valid = NO;
    if (self.anConstructie == 0)
        valid = NO;
    if (self.nrCamere == 0)
        valid = NO;
    if (self.suprafataUtila == 0)
        valid = NO;
    if (self.nrLocatari == 0)
        valid = NO;
    if (!self.areAlarma || !self.areGrilajeGeam || !self.detectieIncendiu || !self.arePaza || !self.zonaIzolata || !self.locuitPermanent || !self.clauzaFurtBunuri || !self.clauzaApaConducta || !self.areTeren)
        valid = NO;
    
    return valid;
}


- (float) CompletedPercent
{
    int numarCampuri = 10;
    float campuriCompletate = 0;
    
    if (self.judet && self.judet.length > 0)
        campuriCompletate ++;
    if (self.localitate && self.localitate.length > 0)
        campuriCompletate ++;
    if (self.adresa && self.adresa.length > 0)
        campuriCompletate ++;
    if (self.tipLocuinta && self.tipLocuinta.length > 0)
        campuriCompletate ++;
    if (self.structuraLocuinta && self.structuraLocuinta.length > 0)
        campuriCompletate ++;
    if (self.regimInaltime > 0)
        campuriCompletate ++;
//    if ( [self.tipLocuinta isEqualToString:@"apartament-in-bloc"] self.etaj > 0 && )
//        campuriCompletate ++;
    if (self.anConstructie > 0)
        campuriCompletate ++;
    if (self.nrCamere > 0)
        campuriCompletate ++;
    if (self.suprafataUtila > 0)
        campuriCompletate ++;
    if (self.nrLocatari > 0)
        campuriCompletate ++;
    
    
    return campuriCompletate/numarCampuri;
}

- (void) refresh
{
    YTOAppDelegate * appDelegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate refreshLocuinte];
}

- (void) registerLocuinta
{
    
    NSString * xmlRequest = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<RegisterLocuinta xmlns=\"http://tempuri.org/\">"
                             "<user>vreaurca</user>"
                             "<password>123</password>"
                             "<tip_locuinta>%@</tip_locuinta>"
                             "<structura>%@</structura>"
                             "<inaltime>%d</inaltime>"
                             "<etaj>%d</etaj>"
                             "<an_constructie>%d</an_constructie>"
                             "<nr_camere>%d</nr_camere>"
                             "<suprafata>%d</suprafata>"
                             "<nr_locatari>%d</nr_locatari>"
                             "<tip_geam>%@</tip_geam>"
                             "<are_alarma>%@</are_alarma>"
                             "<are_grilaje_geam>%@</are_grilaje_geam>"
                             "<zona_izolata>%@</zona_izolata>"
                             "<clauza_furt_bunuri>%@</clauza_furt_bunuri>"
                             "<clauza_apa_conducta>%@</clauza_apa_conducta>"
                             "<detectie_incendiu>%@</detectie_incendiu>"
                             "<are_paza>%@</are_paza>"
                             "<are_teren>%@</are_teren>"
                             "<locuit_permanent>%@</locuit_permanent>"
                             "<judet>%@</judet>"
                             "<localitate>%@</localitate>"
                             "<adresa>%@</adresa>"
                             "<mod_evaluare>%@</mod_evaluare>"
                             "<nr_rate>%d</nr_rate>"
                             "<suma_asigurata>%d</suma_asigurata>"
                             "<suma_asigurata_rc>%d</suma_asigurata_rc>"
                             "<udid>%@</udid>"
                             "<id_locuinta>%@</id_locuinta>"
                             "<platforma>%@</platforma>"
                             "</RegisterLocuinta>"
                             "</soap:Body>"
                             "</soap:Envelope>",
                             self.tipLocuinta, self.structuraLocuinta, self.regimInaltime, self.etaj, self.anConstructie,
                             self.nrCamere, self.suprafataUtila, self.nrLocatari,
                             @"termopan", //self.tipGeam,
                             self.areAlarma, self.areGrilajeGeam, self.zonaIzolata,
                             self.clauzaFurtBunuri, self.clauzaApaConducta, self.detectieIncendiu, self.arePaza, self.areTeren, self.locuitPermanent,
                             self.judet, self.localitate, self.adresa, self.modEvaluare, self.nrRate, self.sumaAsigurata, self.sumaAsigurataRC,
                             [[UIDevice currentDevice] uniqueIdentifier], self.idIntern,
                             [[UIDevice currentDevice].model stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@sync.asmx", LinkAPI]];
    
	NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
															cachePolicy:NSURLRequestUseProtocolCachePolicy
														timeoutInterval:10.0];
    
	NSString * parameters = [[NSString alloc] initWithString:xmlRequest];
	NSLog(@"Request=%@", parameters);
	NSString * msgLength = [NSString stringWithFormat:@"%d", [parameters length]];
	
	[request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[request addValue:@"http://tempuri.org/RegisterLocuinta" forHTTPHeaderField:@"SOAPAction"];
	[request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	if (connection) {
		self.responseData = [NSMutableData data];
	}
    
    [self performSelectorOnMainThread:@selector(hideLoading) withObject:nil waitUntilDone:NO];
}

- (void) markLocuintaAsDeleted
{
    NSString * xmlRequest = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<DeleteLocuinta xmlns=\"http://tempuri.org/\">"
                             "<user>vreaurca</user>"
                             "<password>123</password>"
                             "<udid>%@</udid>"
                             "<id_locuinta>%@</id_locuinta>"
                             "</DeleteLocuinta>"
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
	[request addValue:@"http://tempuri.org/DeleteLocuinta" forHTTPHeaderField:@"SOAPAction"];
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
