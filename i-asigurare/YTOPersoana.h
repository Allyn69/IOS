//
//  YTOPersoana.h
//  i-asigurare
//
//  Created by Administrator on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface YTOPersoana : NSObject

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
@property (nonatomic, retain) NSString * boliNeuro;
@property (nonatomic, retain) NSString * boliCardio;
@property (nonatomic, retain) NSString * boliInterne;
@property (nonatomic, retain) NSString * boliAparatRespirator;
@property (nonatomic, retain) NSString * alteBoli;
@property (nonatomic, retain) NSString * boliDefinitive;
@property (nonatomic, retain) NSString * stareSanatate;

@property BOOL _isDirty;

- (void) addPersoana:(YTOPersoana *)p;
- (void) updatePersoana:(YTOPersoana *)p;
+ (YTOPersoana *) getPersoana:(NSString *)_idIntern;
+ (NSMutableArray*)Persoane;

- (id)initWithGuid:(NSString*)guid;

@end
