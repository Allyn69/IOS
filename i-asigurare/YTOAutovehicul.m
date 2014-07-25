//
//  YTOAutovehicul.m
//  i-asigurare
//
//  Created by Andi Aparaschivei on 7/18/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
//

#import "YTOAutovehicul.h"
#import "YTOAppDelegate.h"
#import "YTOObiectAsigurat.h"
#import "YTOAlerta.h"
#import "Database.h"
#import "VerifyNet.h"
#import "YTOUserDefaults.h"

@implementation YTOAutovehicul

@synthesize idIntern;
@synthesize judet;
@synthesize localitate;
@synthesize adresa;
@synthesize categorieAuto;
@synthesize subcategorieAuto;
@synthesize nrInmatriculare;
@synthesize serieSasiu;
@synthesize marcaAuto;
@synthesize modelAuto;
@synthesize cm3;
@synthesize nrLocuri;
@synthesize masaMaxima;
@synthesize putere;
@synthesize anFabricatie;
@synthesize destinatieAuto;
@synthesize marimeParc;
@synthesize serieCiv;
@synthesize dauneInUltimulAn;
@synthesize aniFaraDaune;
@synthesize culoare;
@synthesize combustibil;
@synthesize tipInregistrare;
@synthesize autoNouInregistrat;
@synthesize inLeasing;
@synthesize firmaLeasing;
@synthesize nrKm;
@synthesize cascoLa;
@synthesize idFirmaLeasing;
@synthesize idProprietar;
@synthesize idImage;
@synthesize _dataCreare;
@synthesize savedInCont;

@synthesize _isDirty;
@synthesize responseData;

- (id)initWithGuid:(NSString*)guid
{
    self = [super init];
    self.idIntern = guid;
    self._dataCreare = [NSDate date];
    
    return self;
}

- (void) addAutovehicul:(BOOL) local
{
    YTOObiectAsigurat * autovehicul = [[YTOObiectAsigurat alloc] init];
    autovehicul.IdIntern = self.idIntern;
    autovehicul.TipObiect = 2;
    autovehicul.JSONText = [self toJSON];
    [autovehicul addObiectAsigurat];
    self._isDirty = YES;
    
    if (!local) {
        [self showLoading];
        [self performSelectorInBackground:@selector(registerAutovehicul) withObject:nil];
    }
    [self refresh];
}

- (void) updateAutovehicul:(BOOL) local
{
    YTOObiectAsigurat * ob = [YTOObiectAsigurat getObiectAsigurat:self.idIntern];
    ob.JSONText = [self toJSON];
    [ob updateObiectAsigurat];
    
    if (!local) {
    [self showLoading];
    [self performSelectorInBackground:@selector(registerAutovehicul) withObject:nil];
    }

    [self refresh];
}

- (void) deleteAutovehicul
{
    YTOObiectAsigurat * ob = [YTOObiectAsigurat getObiectAsigurat:self.idIntern];
    ob.JSONText = [self toJSON];
    [ob deleteObiectAsigurat];
    
    [self showLoading];
    [self performSelectorInBackground:@selector(markAutovehiculAsDeleted) withObject:nil];
    
    // dupa ce sterg autovehiculul,
    // sterg si alertele, in caz ca exista
    YTOAlerta * alertaRca = [YTOAlerta getAlertaRCA:self.idIntern];
    if (alertaRca)
        [alertaRca deleteAlerta:NO];
    YTOAlerta * alertaItp = [YTOAlerta getAlertaITP:self.idIntern];
    if (alertaItp)
        [alertaItp deleteAlerta:NO];
    YTOAlerta * alertaRovinieta = [YTOAlerta getAlertaRovinieta:self.idIntern];
    if (alertaRovinieta)
        [alertaRovinieta deleteAlerta:NO];
    YTOAlerta * alertaCasco = [YTOAlerta getAlertaCasco:self.idIntern];
    if (alertaCasco)
        [alertaCasco deleteAlerta:NO];
    YTOAlerta * alertaRataCasco = [YTOAlerta getAlertaRataCasco:self.idIntern];
    if (alertaRataCasco)
        [alertaRataCasco deleteAlerta:NO];
    
    [self refresh];
}

- (void) deleteAutovehicul2 //sterg doar din telefon fara request si fara sa fac refresh
{
    YTOObiectAsigurat * ob = [YTOObiectAsigurat getObiectAsigurat:self.idIntern];
    ob.JSONText = [self toJSON];
    [ob deleteObiectAsigurat];
    
    YTOAlerta * alertaRca = [YTOAlerta getAlertaRCA:self.idIntern];
    if (alertaRca)
        [alertaRca deleteAlerta:YES];
    YTOAlerta * alertaItp = [YTOAlerta getAlertaITP:self.idIntern];
    if (alertaItp)
        [alertaItp deleteAlerta:YES];
    YTOAlerta * alertaRovinieta = [YTOAlerta getAlertaRovinieta:self.idIntern];
    if (alertaRovinieta)
        [alertaRovinieta deleteAlerta:YES];
    YTOAlerta * alertaCasco = [YTOAlerta getAlertaCasco:self.idIntern];
    if (alertaCasco)
        [alertaCasco deleteAlerta:YES];
    YTOAlerta * alertaRataCasco = [YTOAlerta getAlertaRataCasco:self.idIntern];
    if (alertaRataCasco)
        [alertaRataCasco deleteAlerta:YES];
}

+ (YTOAutovehicul *) getAutovehicul:(NSString *)_idIntern
{
    YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSMutableArray * list = [delegate Masini];
    for (int i=0; i<list.count; i++) {
        YTOAutovehicul * _auto = [list objectAtIndex:i];
        if ([_auto.idIntern isEqualToString:_idIntern])
            return _auto;
    }
    return  nil;
}

+ (YTOAutovehicul *) getAutovehiculByProprietar:(NSString *)_idProprietar
{
    YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableArray * list = [delegate Masini];
    for (int i=0; i<list.count; i++) {
        YTOAutovehicul * _auto = [list objectAtIndex:i];
        if ([_auto.idProprietar isEqualToString:_idProprietar])
            return _auto;
    }
    return  nil;
}

+ (NSMutableArray*)Masini
{
    NSMutableArray * _list = [[NSMutableArray alloc] init];
    
    NSMutableArray * jsonList = [YTOObiectAsigurat getListaByTipObiect:2];
    
    for (int i=0; i<jsonList.count; i++) {        
        YTOObiectAsigurat * ob = (YTOObiectAsigurat *)[jsonList objectAtIndex:i];
        
        YTOAutovehicul * p = [[YTOAutovehicul alloc] init];
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
    VerifyNet * vn = [[VerifyNet alloc] init];
    if (![[YTOUserDefaults getUserName] isEqualToString:@""] && ![[YTOUserDefaults getPassword] isEqualToString:@""] && [YTOUserDefaults getUserName] != nil && [YTOUserDefaults getPassword] != nil  && vn.hasConnectivity)
    {
            self.savedInCont = @"da";
    }
    NSDictionary * dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                           (self.judet ? self.judet : @""), @"judet",
                           (self.localitate ? self.localitate : @""), @"localitate",
                           (self.adresa ? self.adresa : @""), @"adresa",
                           [NSNumber numberWithInt: self.categorieAuto], @"categorie_auto",
                           (self.subcategorieAuto ? self.subcategorieAuto : @""), @"subcategorie_auto",
                           (self.nrInmatriculare ? self.nrInmatriculare : @""), @"nr_inmatriculare",
                           (self.serieSasiu ? self.serieSasiu : @""), @"serie_sasiu",
                           (self.marcaAuto ? self.marcaAuto : @""), @"marca_auto",
                           (self.modelAuto ? self.modelAuto : @""), @"model_auto",
                           [NSNumber numberWithInt: self.cm3], @"cm3",
                           [NSNumber numberWithInt: self.nrLocuri], @"nr_locuri",
                           [NSNumber numberWithInt: self.masaMaxima], @"masa_maxima",
                           [NSNumber numberWithInt: self.putere], @"putere",
                           [NSNumber numberWithInt: self.anFabricatie], @"an_fabricatie",
                           (self.destinatieAuto ? self.destinatieAuto : @""), @"destinatie_auto",
                           [NSNumber numberWithInt: self.marimeParc], @"marime_parc",
                           (self.serieCiv ? self.serieCiv : @""), @"serie_civ",
                           [NSNumber numberWithInt: self.dauneInUltimulAn], @"daune_ultim_an",
                           [NSNumber numberWithInt: self.aniFaraDaune], @"ani_fara_daune",
                           (self.culoare ? self.culoare : @""), @"culoare",
                           (self.combustibil ? self.combustibil : @""), @"combustibil",
                           (self.tipInregistrare ? self.tipInregistrare : @""), @"tip_inregistrare",
                           (self.autoNouInregistrat ? self.autoNouInregistrat : @""), @"auto_nou_inregistrat",
                           (self.inLeasing ? self.inLeasing : @""), @"in_leasing",
                           (self.firmaLeasing ? self.firmaLeasing : @""), @"firma_leasing",
                           [NSNumber numberWithInt: self.nrKm], @"nr_km",
                           (self.cascoLa ? self.cascoLa : @""), @"casco",
                           (self.idFirmaLeasing ? self.idFirmaLeasing : @""), @"id_firma_leasing",
                           (self.idProprietar ? self.idProprietar : @""), @"id_proprietar",
                           (self.idImage ? self.idImage : @""), @"id_image",
                           (self.savedInCont? savedInCont : @"nu"),@"saved_in_cont",
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
    
    self.judet = [item objectForKey:@"judet"];
    self.localitate = [item objectForKey:@"localitate"];
    self.adresa = [item objectForKey:@"adresa"];
    self.categorieAuto = [[item objectForKey:@"categorie_auto"] intValue];
    self.subcategorieAuto = [item objectForKey:@"subcategorie_auto"];
    self.nrInmatriculare = [item objectForKey:@"nr_inmatriculare"];
    self.serieSasiu = [item objectForKey:@"serie_sasiu"];
    self.marcaAuto = [item objectForKey:@"marca_auto"];
    self.modelAuto = [item objectForKey:@"model_auto"];
    self.cm3 = [[item objectForKey:@"cm3"] intValue];
    self.nrLocuri = [[item objectForKey:@"nr_locuri"] intValue];
    self.masaMaxima = [[item objectForKey:@"masa_maxima"] intValue];
    self.putere = [[item objectForKey:@"putere"] intValue];
    self.anFabricatie = [[item objectForKey:@"an_fabricatie"] intValue];
    self.destinatieAuto = [item objectForKey:@"destinatie_auto"];
    self.marimeParc = [[item objectForKey:@"marime_parc"] intValue];
    self.serieCiv = [item objectForKey:@"serie_civ"];
    self.dauneInUltimulAn = [[item objectForKey:@"daune_ultim_an"] intValue];
    self.aniFaraDaune = [[item objectForKey:@"ani_fara_daune"] intValue];
    self.culoare = [item objectForKey:@"culoare"];
    self.combustibil = [item objectForKey:@"combustibil"];
    self.tipInregistrare = [item objectForKey:@"tip_inregistrare"];
    self.autoNouInregistrat = [item objectForKey:@"auto_nou_inregistrat"];
    self.inLeasing = [item objectForKey:@"in_leasing"];
    self.firmaLeasing = [item objectForKey:@"firma_leasing"];
    self.nrKm = [[item objectForKey:@"nr_km"] intValue];
    self.cascoLa = [item objectForKey:@"casco"];
    self.idFirmaLeasing = [item objectForKey:@"id_firma_leasing"];
    self.idProprietar = [item objectForKey:@"id_proprietar"];
    self.idImage = [item objectForKey:@"id_image"];
    self.savedInCont = [item objectForKey:@"saved_in_cont"];
    
    NSString * dataString = [item objectForKey:@"data_creare"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    self._dataCreare = [dateFormat dateFromString:dataString];
    
    self._isDirty = YES;
}

- (BOOL) isValidForRCA
{
    BOOL valid = YES;
    
    if (!self.judet || self.judet.length == 0)
        valid = NO;
    if (!self.localitate || self.localitate.length == 0)
        valid = NO;
    if (!self.adresa || self.adresa.length == 0)
        valid = NO;
    if (self.categorieAuto == 0)
        valid = NO;
    if (!self.subcategorieAuto || self.subcategorieAuto.length == 0)
        valid = NO;
    if (!self.nrInmatriculare || self.nrInmatriculare.length == 0)
        valid = NO;
    if (!self.serieSasiu || self.serieSasiu.length < 3 || self.serieSasiu.length > 17)
        valid = NO;
    if (!self.marcaAuto || self.marcaAuto.length == 0)
        valid = NO;
    if (!self.modelAuto || self.modelAuto.length == 0)
        valid = NO;
    if (self.categorieAuto == 0 || (self.categorieAuto != 8 && self.cm3 == 0))
        valid = NO;
    if (self.categorieAuto == 0 || (self.categorieAuto != 8 && self.nrLocuri == 0))
        valid = NO;        
    if (self.masaMaxima == 0)
        valid = NO;
    if (self.putere == 0)
        valid = NO;
    if (self.anFabricatie == 0)
        valid = NO;
    
    return valid;
}

- (float) CompletedPercent
{
    int numarCampuri = 14;
    float campuriCompletate = 0;
    
    if (self.judet && self.judet.length > 0)
        campuriCompletate ++;
    if (self.localitate && self.localitate.length > 0)
        campuriCompletate ++;
    if (self.adresa && self.adresa.length > 0)
        campuriCompletate ++;
    if (self.categorieAuto > 0)
        campuriCompletate ++;
    if (self.subcategorieAuto && self.subcategorieAuto.length > 0)
        campuriCompletate ++;
    if (self.nrInmatriculare && self.nrInmatriculare.length > 0)
        campuriCompletate ++;
    if (self.serieSasiu && self.serieSasiu.length > 0)
        campuriCompletate ++;
    if (self.marcaAuto && self.marcaAuto.length > 0)
        campuriCompletate ++;
    if (self.modelAuto && self.modelAuto.length > 0)
        campuriCompletate ++;
    if (self.categorieAuto != 8 && self.cm3 > 0)
        campuriCompletate ++;
    else
        campuriCompletate ++;
    
    if (self.categorieAuto != 8 && self.nrLocuri > 0)
        campuriCompletate ++;
    else
        campuriCompletate ++;
    
    if (self.masaMaxima > 0)
        campuriCompletate ++;
    if (self.putere > 0)
        campuriCompletate ++;
    if (self.anFabricatie > 0)
        campuriCompletate ++;
    
    if ([self.inLeasing isEqualToString:@"da"]) {
        numarCampuri = 15;
        if (self.firmaLeasing && self.firmaLeasing.length > 0)
            campuriCompletate++;
    }
    
    return campuriCompletate/numarCampuri;
}

- (void) refresh
{
    YTOAppDelegate * appDelegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate refreshMasini];
    [appDelegate setAlerteBadge];
}

- (void) registerAutovehicul
{
    
    NSString * xmlRequest = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<RegisterMasina3 xmlns=\"http://tempuri.org/\">"
                             "<user>vreaurca</user>"
                             "<password>123</password>"
                             "<marca>%@</marca>"
                             "<model>%@</model>"
                             "<index_categorie>%d</index_categorie>"
                             "<subcategorie>%@</subcategorie>"
                             "<judet>%@</judet>"
                             "<localitate>%@</localitate>"
                             "<adresa>%@</adresa>"
                             "<nr_inmatriculare>%@</nr_inmatriculare>"
                             "<serie_sasiu>%@</serie_sasiu>"
                             "<cm3>%d</cm3>"
                             "<putere>%d</putere>"
                             "<nr_locuri>%d</nr_locuri>"
                             "<masa_maxima>%d</masa_maxima>"
                             "<an_fabricatie>%d</an_fabricatie>"
                             "<serie_talon>%@</serie_talon>"
                             "<destinatie_auto>%@</destinatie_auto>"
                             "<combustibil>%@</combustibil>"
                             "<in_leasing>%@</in_leasing>"
                             "<firma_leasing>%@</firma_leasing>"
                             "<casco_la>%@</casco_la>"
                             "<nr_km>%d</nr_km>"
                             "<culoare>%@</culoare>"
                             "<udid>%@</udid>"
                             "<id_intern>%@</id_intern>"
                             "<platforma>%@</platforma>"
                             "<cont_user>%@</cont_user>"
                             "<cont_parola>%@</cont_parola>"
                             "<limba>%@</limba>"
                             "<versiune>%@</versiune>"
                             "</RegisterMasina3>"
                             "</soap:Body>"
                             "</soap:Envelope>",
                             self.marcaAuto, self.modelAuto, self.categorieAuto, self.subcategorieAuto,
                             self.judet, self.localitate,self.adresa, self.nrInmatriculare, self.serieSasiu,
                             self.cm3, self.putere, self.nrLocuri, self.masaMaxima, self.anFabricatie,
                             self.serieCiv, self.destinatieAuto, self.combustibil, self.inLeasing, self.firmaLeasing,
                             self.cascoLa, self.nrKm, self.culoare,
                             [[UIDevice currentDevice] xUniqueDeviceIdentifier], self.idIntern,
                             [[UIDevice currentDevice].model stringByReplacingOccurrencesOfString:@" " withString:@"_"],
                             [YTOUserDefaults getUserName],[YTOUserDefaults getPassword],[YTOUserDefaults getLanguage],[NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]];
    
    
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@sync.asmx", LinkAPI]];
    
	NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
															cachePolicy:NSURLRequestUseProtocolCachePolicy
														timeoutInterval:10.0];
    
	NSString * parameters = [[NSString alloc] initWithString:xmlRequest];
	NSLog(@"Request=%@", parameters);
	NSString * msgLength = [NSString stringWithFormat:@"%d", [parameters length]];
	
	[request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[request addValue:@"http://tempuri.org/RegisterMasina3" forHTTPHeaderField:@"SOAPAction"];
	[request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	if (connection) {
		self.responseData = [NSMutableData data];
	}
    
    [self performSelectorOnMainThread:@selector(hideLoading) withObject:nil waitUntilDone:NO];
}

- (void) markAutovehiculAsDeleted
{
    NSString * xmlRequest = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<DeleteMasina2 xmlns=\"http://tempuri.org/\">"
                             "<user>vreaurca</user>"
                             "<password>123</password>"
                             "<udid>%@</udid>"
                             "<id_masina>%@</id_masina>"
                             "<cont_user>%@</cont_user>"
                             "<cont_parola>%@</cont_parola>"
                             "<limba>%@</limba>"
                             "<versiune>%@</versiune>"
                             "</DeleteMasina2>"
                             "</soap:Body>"
                             "</soap:Envelope>",
                             [[UIDevice currentDevice] xUniqueDeviceIdentifier], self.idIntern,
                             [YTOUserDefaults getUserName],[YTOUserDefaults getPassword],[YTOUserDefaults getLanguage],[NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]];
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@sync.asmx", LinkAPI]];
    
	NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
															cachePolicy:NSURLRequestUseProtocolCachePolicy
														timeoutInterval:10.0];
    
	NSString * parameters = [[NSString alloc] initWithString:xmlRequest];
	NSLog(@"Request=%@", parameters);
	NSString * msgLength = [NSString stringWithFormat:@"%d", [parameters length]];
	
	[request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[request addValue:@"http://tempuri.org/DeleteMasina2" forHTTPHeaderField:@"SOAPAction"];
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
