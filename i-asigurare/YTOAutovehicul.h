//
//  YTOAutovehicul.h
//  i-asigurare
//
//  Created by Administrator on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface YTOAutovehicul : NSObject

@property (nonatomic, retain) NSString * idIntern;
@property (nonatomic, retain) NSString * judet;
@property (nonatomic, retain) NSString * localitate;
@property int                            categorieAuto;
@property (nonatomic, retain) NSString * subcategorieAuto;
@property (nonatomic, retain) NSString * nrInmatriculare;
@property (nonatomic, retain) NSString * serieSasiu;
@property (nonatomic, retain) NSString * marcaAuto;
@property (nonatomic, retain) NSString * modelAuto;
@property int                            cm3;
@property int                            nrLocuri;
@property int                            masaMaxima;
@property int                            putere;
@property int                            anFabricatie;
@property (nonatomic, retain) NSString * destinatieAuto;
@property int                            marimeParc;
@property (nonatomic, retain) NSString * serieCiv;
@property int                            dauneInUltimulAn;
@property int                            aniFaraDaune;
@property (nonatomic, retain) NSString * culoare;
@property (nonatomic, retain) NSString * combustibil;
@property (nonatomic, retain) NSString * tipInregistrare;
@property (nonatomic, retain) NSString * autoNouInregistrat;
@property (nonatomic, retain) NSString * inLeasing;
@property int                            nrKm;
@property (nonatomic, retain) NSString * idFirmaLeasing;
@property (nonatomic, retain) NSString * idProprietar;
@property (nonatomic, retain) NSDate   * _dataCreare;                     

@property BOOL _isDirty;

- (void) addAutovehicul;
- (void) updateAutovehicul:(YTOAutovehicul *)a;
+ (YTOAutovehicul *) getAutovehicul:(NSString *)_idIntern;
+ (NSMutableArray*)Masini;

- (id)initWithGuid:(NSString*)guid;

@end
