//
//  YTOPersoana.h
//  i-asigurare
//
//  Created by Andi Aparaschivei on 7/16/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface YTOPersoana : NSObject
{
    NSMutableData * responseData;
	NSMutableData * capturedCharactes;
	NSMutableString * currentElementValue;
    NSString * raspuns;
}

@property (nonatomic, retain) NSMutableData * responseData;

@property (nonatomic, retain) NSString * idIntern;
@property (nonatomic, retain) NSString * nume;
@property (nonatomic, retain) NSString * codUnic;
@property (nonatomic, retain) NSString * judet;
@property (nonatomic, retain) NSString * localitate;
@property (nonatomic, retain) NSString * adresa;
@property (nonatomic, retain) NSString * tipPersoana;
@property (nonatomic, retain) NSString * casatorit;
@property (nonatomic, retain) NSString * copiiMinori;
@property (nonatomic, retain) NSString * pensionar;
@property (nonatomic, retain) NSString * nrBugetari;
@property (nonatomic, retain) NSString * dataPermis;
@property (nonatomic, retain) NSString * codCaen;
@property (nonatomic, retain) NSString * handicapLocomotor;
@property (nonatomic, retain) NSString * serieAct;
@property (nonatomic, retain) NSString * elevStudent;
@property (nonatomic, retain) NSString * varsta;
@property (nonatomic, retain) NSString * boliNeuro;
@property (nonatomic, retain) NSString * boliCardio;
@property (nonatomic, retain) NSString * boliInterne;
@property (nonatomic, retain) NSString * boliAparatRespirator;
@property (nonatomic, retain) NSString * alteBoli;
@property (nonatomic, retain) NSString * boliDefinitive;
@property (nonatomic, retain) NSString * stareSanatate;
@property (nonatomic, retain) NSString * telefon;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * proprietar;
@property (nonatomic, retain) NSString * codPostal;
@property BOOL _isDirty;

- (void) addPersoana:(BOOL) local;
- (void) updatePersoana:(BOOL) local;
- (void) deletePersoana;
+ (YTOPersoana *) getPersoana:(NSString *)_idIntern;
+ (YTOPersoana *) getPersoanaByCodUnic:(NSString *)_codUnic;
+ (YTOPersoana *) Proprietar;
+ (YTOPersoana *) ProprietarPJ;
- (NSMutableArray*)getPersoane;
+ (NSMutableArray*)AltePersoane;
+ (NSMutableArray*)PersoaneFizice;

- (id)initWithGuid:(NSString*)guid;
- (NSString *) toJSON;
- (void) fromJSON:(NSString *)p;
- (void) refresh;
+ (NSString *) getJsonPersoane:(NSMutableArray *) list;

// pentru atentionari date gresite
- (NSString *) mesajOneFieldWrong;
- (NSString *) mesajOneFieldWrongCalatorie;
- (NSString *) mesajOneFieldWrongMyTravels;
- (int) getWrongLabel;

- (BOOL) isValidForCompute;
- (BOOL) isValidForComputeCalatorie;
- (BOOL) isValidForGothaer;

@end
