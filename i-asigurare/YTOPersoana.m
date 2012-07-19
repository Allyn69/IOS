//
//  YTOPersoana.m
//  i-asigurare
//
//  Created by Administrator on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YTOPersoana.h"
#import "Database.h"

@implementation YTOPersoana

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

@synthesize _isDirty;

-(id)initWithGuid:(NSString*)guid
{
    self = [super init];
    self.idIntern = guid;
    
    return self;
}

- (void) addPersoana:(YTOPersoana *)p
{
    sqlite3 *database;
    sqlite3_stmt *addStmt = nil;
    
    if(sqlite3_open([[Database getDBPath] UTF8String], &database) == SQLITE_OK) 
    {
        
        if(addStmt == nil) {
            const char *sql = "INSERT INTO PERSOANA (IdIntern, Nume, CodUnic, Judet, Localitate, Adresa, TipPersoana, Casatorit, CopiiMinori, Pensionar, NrBugetari, DataPermis, CodCaen, HandicapLocomotor, SerieAct, ElevStudent, BoliNeuro, BoliCardio, BoliInterne, BoliAparatRespirator, AlteBoli, BoliDefinitive, StareSanatate) Values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) != SQLITE_OK)
                NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
        }
        
        sqlite3_bind_text(addStmt, 1, [idIntern UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 2, [nume UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 3, [codUnic UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 4, [judet UTF8String], -1, SQLITE_TRANSIENT);    
        sqlite3_bind_text(addStmt, 5, [localitate UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 6, [adresa UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 7, [tipPersoana UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 8, [casatorit UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 9, [copiiMinori UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 10, [pensionar UTF8String], -1, SQLITE_TRANSIENT);        
        sqlite3_bind_text(addStmt, 11, [nrBugetari UTF8String], -1, SQLITE_TRANSIENT);        
        sqlite3_bind_text(addStmt, 12, [dataPermis UTF8String], -1, SQLITE_TRANSIENT);                
        sqlite3_bind_text(addStmt, 13, [codCaen UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 14, [handicapLocomotor UTF8String], -1, SQLITE_TRANSIENT);        
        sqlite3_bind_text(addStmt, 15, [serieAct UTF8String], -1, SQLITE_TRANSIENT);                
        sqlite3_bind_text(addStmt, 16, [elevStudent UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 17, [boliNeuro UTF8String], -1, SQLITE_TRANSIENT);        
        sqlite3_bind_text(addStmt, 18, [boliCardio UTF8String], -1, SQLITE_TRANSIENT);                
        sqlite3_bind_text(addStmt, 19, [boliInterne UTF8String], -1, SQLITE_TRANSIENT);                        
        sqlite3_bind_text(addStmt, 20, [boliAparatRespirator UTF8String], -1, SQLITE_TRANSIENT);                
        sqlite3_bind_text(addStmt, 21, [alteBoli UTF8String], -1, SQLITE_TRANSIENT);                        
        sqlite3_bind_text(addStmt, 22, [boliDefinitive UTF8String], -1, SQLITE_TRANSIENT);                        
        sqlite3_bind_text(addStmt, 23, [stareSanatate UTF8String], -1, SQLITE_TRANSIENT);                        
        
        if(SQLITE_DONE != sqlite3_step(addStmt))
            NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
        else {
            sqlite3_finalize(addStmt);
            sqlite3_close(database);
        }
        
    }
}

- (void) updatePersoana:(YTOPersoana *)p
{
    sqlite3 *database;
    sqlite3_stmt *updateStmt = nil;
    
    if(sqlite3_open([[Database getDBPath] UTF8String], &database) == SQLITE_OK) 
    {
        
        if(updateStmt == nil) {
            NSString *update = [NSString stringWithFormat:@"UPDATE PERSOANA SET Nume = ?, CodUnic = ?, Judet = ?, Localitate = ?, Adresa = ?, TipPersoana = ?, Casatorit = ?, CopiiMinori = ?, Pensionar = ?, NrBugetari = ?, DataPermis = ?, CodCaen = ?, HandicapLocomotor = ?, SerieAct = ?, ElevStudent = ?, BoliNeuro = ?, BoliCardio = ?, BoliInterne = ?, BoliAparatRespirator = ?, AlteBoli = ?, BoliDefinitive = ?, StareSanatate = ? WHERE IdIntern='%@'", p.idIntern];
            
            if(sqlite3_prepare_v2(database, [update UTF8String], -1, &updateStmt, NULL) != SQLITE_OK)
                NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
        }
        
        sqlite3_bind_text(updateStmt, 1, [nume UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(updateStmt, 2, [codUnic UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(updateStmt, 3, [judet UTF8String], -1, SQLITE_TRANSIENT);    
        sqlite3_bind_text(updateStmt, 4, [localitate UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(updateStmt, 5, [adresa UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(updateStmt, 6, [tipPersoana UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(updateStmt, 7, [casatorit UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(updateStmt, 8, [copiiMinori UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(updateStmt, 9, [pensionar UTF8String], -1, SQLITE_TRANSIENT);        
        sqlite3_bind_text(updateStmt, 10, [nrBugetari UTF8String], -1, SQLITE_TRANSIENT);        
        sqlite3_bind_text(updateStmt, 11, [dataPermis UTF8String], -1, SQLITE_TRANSIENT);                
        sqlite3_bind_text(updateStmt, 12, [codCaen UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(updateStmt, 13, [handicapLocomotor UTF8String], -1, SQLITE_TRANSIENT);        
        sqlite3_bind_text(updateStmt, 14, [serieAct UTF8String], -1, SQLITE_TRANSIENT);                
        sqlite3_bind_text(updateStmt, 15, [elevStudent UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(updateStmt, 16, [boliNeuro UTF8String], -1, SQLITE_TRANSIENT);        
        sqlite3_bind_text(updateStmt, 17, [boliCardio UTF8String], -1, SQLITE_TRANSIENT);                
        sqlite3_bind_text(updateStmt, 18, [boliInterne UTF8String], -1, SQLITE_TRANSIENT);                        
        sqlite3_bind_text(updateStmt, 19, [boliAparatRespirator UTF8String], -1, SQLITE_TRANSIENT);                
        sqlite3_bind_text(updateStmt, 20, [alteBoli UTF8String], -1, SQLITE_TRANSIENT);                        
        sqlite3_bind_text(updateStmt, 21, [boliDefinitive UTF8String], -1, SQLITE_TRANSIENT);                        
        sqlite3_bind_text(updateStmt, 22, [stareSanatate UTF8String], -1, SQLITE_TRANSIENT);                        
        
        if(SQLITE_DONE != sqlite3_step(updateStmt))
            NSAssert1(0, @"Error while updating data. '%s'", sqlite3_errmsg(database));
        else {
            sqlite3_finalize(updateStmt);
            sqlite3_close(database);
        }
        
    }
}

+ (YTOPersoana *) getPersoana:(NSString *)_idIntern 
{
    sqlite3 *database;
    sqlite3_stmt *selectStmt = nil;
    
    if(sqlite3_open([[Database getDBPath] UTF8String], &database) == SQLITE_OK) 
    {
        
        
        NSString *select = [NSString stringWithFormat:@"SELECT IdIntern, Nume, CodUnic, Judet, Localitate, Adresa, TipPersoana, Casatorit, CopiiMinori, Pensionar, NrBugetari, DataPermis, CodCaen, HandicapLocomotor, SerieAct, ElevStudent, BoliNeuro, BoliCardio, BoliInterne, BoliAparatRespirator, AlteBoli, BoliDefinitive, StareSanatate FROM PERSOANA WHERE IdIntern='%@'", _idIntern];
        
        YTOPersoana *p = [[YTOPersoana alloc] init];
        if(sqlite3_prepare_v2(database, [select UTF8String], -1, &selectStmt, NULL) == SQLITE_OK) {
            
            if (sqlite3_step(selectStmt) == SQLITE_ROW)
            {
                p._isDirty = YES;
                
                p.idIntern =  [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(selectStmt, 0)];
                p.nume = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(selectStmt, 1)];
                p.codUnic = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(selectStmt, 2)];
                p.judet = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(selectStmt, 3)];
                p.localitate = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(selectStmt, 4)];
                p.adresa = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(selectStmt, 5)];
                // to do next props
                // ..
            }
            sqlite3_finalize(selectStmt);
        }
        sqlite3_close(database);
        return p;
    }
    return nil;
}

+ (NSMutableArray*)Persoane 
{
    NSMutableArray * _list = [[NSMutableArray alloc] init];
    sqlite3 *database;
    sqlite3_stmt *selectstmt = nil;
    
    if (sqlite3_open([[Database getDBPath] UTF8String], &database) == SQLITE_OK) {
		NSString * sqlstring = @"SELECT IdIntern, Nume, CodUnic, Judet, Localitate, Adresa FROM PERSOANA";
		const char *sql = [sqlstring UTF8String];

		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
			
			while(sqlite3_step(selectstmt) == SQLITE_ROW) {
                
                YTOPersoana * persoana = [[YTOPersoana alloc] init];
                
                persoana.idIntern = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 0)];
				persoana.nume = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
                persoana.codUnic = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 2)];
                persoana.judet = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 3)];
                persoana.localitate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 4)];
                persoana.adresa = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 5)];
                
				[_list addObject:persoana];
			}
		}
        sqlite3_finalize(selectstmt);
	}

	sqlite3_close(database);
    
    return _list;
}

@end
