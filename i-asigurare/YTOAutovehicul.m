//
//  YTOAutovehicul.m
//  i-asigurare
//
//  Created by Administrator on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YTOAutovehicul.h"
#import "YTOAppDelegate.h"
#import "YTOObiectAsigurat.h"
#import "Database.h"

@implementation YTOAutovehicul

@synthesize idIntern;
@synthesize judet;
@synthesize localitate;
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

@synthesize _isDirty;

- (id)initWithGuid:(NSString*)guid
{
    self = [super init];
    self.idIntern = guid;
    self._dataCreare = [NSDate date];
    
    return self;
}

- (void) addAutovehicul
{
    YTOObiectAsigurat * autovehicul = [[YTOObiectAsigurat alloc] init];
    autovehicul.IdIntern = self.idIntern;
    autovehicul.TipObiect = 2;
    autovehicul.JSONText = [self toJSON];
    [autovehicul addObiectAsigurat];
    self._isDirty = YES;
    
    [self refresh];
}

- (void) updateAutovehicul
{
    YTOObiectAsigurat * ob = [YTOObiectAsigurat getObiectAsigurat:self.idIntern];
    ob.JSONText = [self toJSON];
    [ob updateObiectAsigurat];
    
    [self refresh];
}

- (void) deleteAutovehicul
{
    YTOObiectAsigurat * ob = [YTOObiectAsigurat getObiectAsigurat:self.idIntern];
    ob.JSONText = [self toJSON];
    [ob deleteObiectAsigurat];
    
    [self refresh];    
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
    
    NSDictionary * dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                           (self.judet ? self.judet : @""), @"judet",
                           (self.localitate ? self.localitate : @""), @"localitate",
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
    if (self.categorieAuto == 0)
        valid = NO;
    if (!self.subcategorieAuto || self.subcategorieAuto.length == 0)
        valid = NO;
    if (!self.nrInmatriculare || self.nrInmatriculare.length == 0)
        valid = NO;
    if (!self.serieSasiu || self.serieSasiu.length == 0)
        valid = NO;
    if (!self.marcaAuto || self.marcaAuto.length == 0)
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
    int numarCampuri = 12;
    float campuriCompletate = 0;
    
    if (self.judet && self.judet.length > 0)
        campuriCompletate ++;
    if (self.localitate && self.localitate.length > 0)
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
        numarCampuri = 13;
        if (self.firmaLeasing && self.firmaLeasing.length > 0)
            campuriCompletate++;
    }
    
    return campuriCompletate/numarCampuri;
}

- (void) refresh
{
    YTOAppDelegate * appDelegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate refreshMasini];
}

@end
