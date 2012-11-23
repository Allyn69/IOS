//
//  YTOLocuinta.h
//  i-asigurare
//
//  Created by Administrator on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface YTOLocuinta : NSObject

@property (nonatomic, retain) NSString * idIntern;
@property (nonatomic, retain) NSString * tipLocuinta;
@property (nonatomic, retain) NSString * structuraLocuinta;
@property int                            regimInaltime;
@property int                            etaj;
@property int                            anConstructie;
@property int                            nrCamere;
@property int                            suprafataUtila;
@property int                            nrLocatari;
@property (nonatomic, retain) NSString * tipGeam;
@property (nonatomic, retain) NSString * areAlarma;
@property (nonatomic, retain) NSString * areGrilajeGeam;
@property (nonatomic, retain) NSString * zonaIzolata;
@property (nonatomic, retain) NSString * clauzaFurtBunuri;
@property (nonatomic, retain) NSString * clauzaApaConducta;
@property (nonatomic, retain) NSString * detectieIncendiu;
@property (nonatomic, retain) NSString * arePaza;
@property (nonatomic, retain) NSString * areTeren;
@property (nonatomic, retain) NSString * locuitPermanent;
@property (nonatomic, retain) NSString * judet;
@property (nonatomic, retain) NSString * localitate;
@property (nonatomic, retain) NSString * adresa;
@property (nonatomic, retain) NSString * modEvaluare;
@property int                            nrRate;
@property int                            sumaAsigurata;
@property int                            sumaAsigurataRC;
@property (nonatomic, retain) NSString * idProprietar;
@property (nonatomic, retain) NSDate   * _dataCreare;

@property BOOL _isDirty;

- (void) addLocuinta;
- (void) updateLocuinta;
- (void) deleteLocutina;
+ (YTOLocuinta *) getLocuinta:(NSString *)_idIntern;
+ (YTOLocuinta *) getLocuintaByProprietar:(NSString *)_idProprietar;
+ (NSMutableArray*)Locuinte;

- (id)initWithGuid:(NSString*)guid;
- (NSString *) toJSON;
- (void) fromJSON:(NSString *)p;
- (float) CompletedPercent;

@end
