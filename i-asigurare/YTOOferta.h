//
//  YTOOferta.h
//  i-asigurare
//
//  Created by Administrator on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeyValueItem.h"
#import "YTOUtils.h"
#import <sqlite3.h>

@interface YTOOferta : NSObject

@property int                                   idExtern;
@property (nonatomic, retain) NSString *        idIntern;
@property int                                   status;
@property int                                   tipAsigurare;
@property (nonatomic, retain) NSString *        numeAsigurare;
@property (nonatomic, retain) NSString *        idAsigurat;
@property (nonatomic, retain) NSMutableArray *  obiecteAsigurate;
@property (nonatomic, retain) NSMutableDictionary   *  detaliiAsigurare;
@property (nonatomic, retain) NSString *        companie;
@property (nonatomic, retain) NSString *        codOferta;
@property float                                 prima;
@property (nonatomic, retain) NSString *        moneda;
@property (nonatomic, retain) NSDate *          dataInceput;
@property int                                   durataAsigurare;
@property (nonatomic, retain) NSDate *          dataSfarsit;
@property BOOL _isDirty;

-(id)initWithGuid:(NSString*)guid;
- (void) addOferta;
- (void) updateOferta;
- (void) deleteOferta;
+ (YTOOferta *) getOferta:(NSString *)idIntern;
+ (NSMutableArray *) Oferte;

- (NSString *) toJSON;
- (void) fromJSON:(NSString *)p;



// CALATORIE key-values
- (NSString *)CalatorieScop;
- (NSString *)CalatorieDestinatie;
- (NSString *)CalatorieTranzit;
- (NSString *)CalatorieProgram;

- (void)setCalatorieScop:(NSString *)value;
- (void)setCalatorieDestinatie:(NSString *)value;
- (void)setCalatorieTranzit:(NSString *)value;
- (void)setCalatorieProgram:(NSString *)value;

// LOCUINTA key-values
- (NSString *)LocuintaSumaAsigurata;
- (NSString *)LocuintaFransiza;
- (NSString *)LocuintaTipProdus;
- (NSString *)LocuintaSABunuriValoare;
- (NSString *)LocuintaSABunuriGenerale;
- (NSString *)LocuintaSARaspundere;
- (NSString *)LocuintaRiscFurt;
- (NSString *)LocuintaRiscApa;
- (NSString *)LocuintaConditii;

- (void) setLocuintaSA:(NSString *)value;
- (void) setLocuintaFransiza:(NSString *)value;
- (void) setLocuintaTipProdus:(NSString *)value;
- (void) setLocuintaSABunuriValoare:(NSString *)value;
- (void) setLocuintaSABunuriGenerale:(NSString *)value;
- (void) setLocuintaSARaspundere:(NSString *)value;
- (void) setLocuintaRiscFurt:(NSString *)value;
- (void) setLocuintaRiscApa:(NSString *)value;
- (void) setLocuintaConditii:(NSString *)value;

@end
