//
//  YTOLocuinta.m
//  i-asigurare
//
//  Created by Administrator on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YTOLocuinta.h"
#import "YTOObiectAsigurat.h"
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
}

- (void) updateLocuinta
{
    YTOObiectAsigurat * ob = [YTOObiectAsigurat getObiectAsigurat:self.idIntern];
    ob.JSONText = [self toJSON];
    [ob updateObiectAsigurat];
}

- (void) deleteLocutina
{
    YTOObiectAsigurat * ob = [YTOObiectAsigurat getObiectAsigurat:self.idIntern];
    ob.JSONText = [self toJSON];
    [ob deleteObiectAsigurat];
}

+ (YTOLocuinta *) getLocuinta:(NSString *)_idIntern
{
    NSMutableArray * list = [YTOLocuinta Locuinte];
    for (int i=0; i<list.count; i++) {
        YTOLocuinta * _loc = [list objectAtIndex:i];
        if ([_loc.idIntern isEqualToString:_idIntern])
            return _loc;
    }
    return  nil;    
}

+ (YTOLocuinta *) getLocuintaByProprietar:(NSString *)_idProprietar
{
    NSMutableArray * list = [YTOLocuinta Locuinte];
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

- (float) CompletedPercent
{
    int numarCampuri = 11;
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
    if (self.etaj > 0)
        campuriCompletate ++;
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

@end