//
//  YTOOferta.m
//  i-asigurare
//
//  Created by Administrator on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YTOOferta.h"
#import "Database.h"

@implementation YTOOferta

@synthesize idIntern;
@synthesize idExtern;
@synthesize status;
@synthesize tipAsigurare;
@synthesize numeAsigurare;
@synthesize idAsigurat;
@synthesize obiecteAsigurate;
@synthesize detaliiAsigurare;
@synthesize companie;
@synthesize codOferta;
@synthesize prima;
@synthesize moneda;
@synthesize dataInceput;
@synthesize durataAsigurare;
@synthesize dataSfarsit;
@synthesize _isDirty;

-(id)initWithGuid:(NSString*)guid
{
    self = [super init];
    self.idIntern = guid;
    self.status = 1;
    self.detaliiAsigurare = [[NSMutableDictionary alloc] init];
    
    return self;
}

- (void) addOferta
{
    sqlite3 *database;
    sqlite3_stmt *addStmt = nil;
    
    if(sqlite3_open([[Database getDBPath] UTF8String], &database) == SQLITE_OK) 
    {
        
        if(addStmt == nil) {
            const char *sql = "INSERT INTO Oferta (IdExtern, IdIntern, Status, TipProdus, JSONText) Values(?, ?, ?, ?, ?)";
            if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) != SQLITE_OK)
                NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
        }
        
        sqlite3_bind_int(addStmt, 1, idExtern); 
        sqlite3_bind_text(addStmt, 2, [idIntern UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(addStmt, 3, status);
        sqlite3_bind_int(addStmt, 4, tipAsigurare);
        sqlite3_bind_text(addStmt, 5, [[self toJSON] UTF8String], -1, SQLITE_TRANSIENT);
        
        
        if(SQLITE_DONE != sqlite3_step(addStmt))
            NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
        else {
            sqlite3_finalize(addStmt);
            sqlite3_close(database);
            self._isDirty = YES; 
        }
        
    }
}

- (void) updateOferta
{
    sqlite3 *database;
    sqlite3_stmt *updateStmt = nil;
    
    if(sqlite3_open([[Database getDBPath] UTF8String], &database) == SQLITE_OK) 
    {
        
        if(updateStmt == nil) {
            NSString *update = [NSString stringWithFormat:@"UPDATE Oferta SET IdExtern = ?, Status = ?, JSONText = ? WHERE IdIntern='%@'", idIntern];
            
            if(sqlite3_prepare_v2(database, [update UTF8String], -1, &updateStmt, NULL) != SQLITE_OK)
                NSAssert1(0, @"Error while creating update statement. '%s'", sqlite3_errmsg(database));
        }
        
        sqlite3_bind_int(updateStmt, 1, idExtern); 
        sqlite3_bind_int(updateStmt, 2, status);
        sqlite3_bind_text(updateStmt, 3, [[self toJSON] UTF8String], -1, SQLITE_TRANSIENT);                      
        
        if(SQLITE_DONE != sqlite3_step(updateStmt))
            NSAssert1(0, @"Error while updating data. '%s'", sqlite3_errmsg(database));
        else {
            sqlite3_finalize(updateStmt);
            sqlite3_close(database);
        }
    }
}

- (void) deleteOferta
{
    sqlite3 *database;
    sqlite3_stmt *deleteStmt = nil;
    
    if(sqlite3_open([[Database getDBPath] UTF8String], &database) == SQLITE_OK)
    {
        
        if(deleteStmt == nil) {
            NSString *delete = [NSString stringWithFormat:@"DELETE FROM Oferta WHERE IdIntern='%@'", self.idIntern];
            
            if(sqlite3_prepare_v2(database, [delete UTF8String], -1, &deleteStmt, NULL) != SQLITE_OK)
                NSAssert1(0, @"Error while creating delete statement. '%s'", sqlite3_errmsg(database));
        }
        
        if(SQLITE_DONE != sqlite3_step(deleteStmt))
            NSAssert1(0, @"Error while deleting data. '%s'", sqlite3_errmsg(database));
        else {
            sqlite3_finalize(deleteStmt);
            sqlite3_close(database);
        }
    }
}

+ (YTOOferta *) getOferta:(NSString *)idIntern
{
    YTOOferta * oferta = [[YTOOferta alloc] init];
    sqlite3 *database;
    sqlite3_stmt *selectstmt = nil;
    
    if (sqlite3_open([[Database getDBPath] UTF8String], &database) == SQLITE_OK) {
		NSString * sqlstring = [NSString stringWithFormat:@"SELECT JSONText FROM Oferta WHERE IdIntern='%@'", idIntern];
		const char *sql = [sqlstring UTF8String];
        
		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
			
			while(sqlite3_step(selectstmt) == SQLITE_ROW) {
            
				NSString * jsonText = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 0)];
                [oferta fromJSON:jsonText];
			}
		}
        sqlite3_finalize(selectstmt);
	}
    
	sqlite3_close(database);
    
    return oferta; 
}

+ (NSMutableArray *) Oferte
{
    NSMutableArray * _list = [[NSMutableArray alloc] init];
    sqlite3 *database;
    sqlite3_stmt *selectstmt = nil;
    
    if (sqlite3_open([[Database getDBPath] UTF8String], &database) == SQLITE_OK) {
		NSString * sqlstring = [NSString stringWithFormat:@"SELECT JSONText FROM Oferta"];
		const char *sql = [sqlstring UTF8String];
        
		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
			
			while(sqlite3_step(selectstmt) == SQLITE_ROW) {
                
                YTOOferta * oferta = [[YTOOferta alloc] init];
				
                NSString *jsonText = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 0)];
                [oferta fromJSON:jsonText];
                
				[_list addObject:oferta];
			}
		}
        sqlite3_finalize(selectstmt);
	}
    
	sqlite3_close(database);
    
    return _list;
}

- (NSString *) toJSON
{
    NSError * error;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dataInceputString=[dateFormat stringFromDate:self.dataInceput];
    NSString *dataSfarsitString=[dateFormat stringFromDate:self.dataSfarsit];    
    
    NSDictionary * dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                           [NSNumber numberWithInt: self.idExtern], @"id_extern",
                           (self.idIntern ? self.idIntern : @""), @"id_intern",
                           [NSNumber numberWithInt:self.status], @"status",
                           [NSNumber numberWithInt:self.tipAsigurare], @"tip_asigurare",
                           (self.numeAsigurare ? self.numeAsigurare : @""), @"nume_asigurare",
                           (self.idAsigurat ? self.idAsigurat : @""), @"id_asigurat",
                           self.obiecteAsigurate, @"obiecte_asigurate",
                           self.detaliiAsigurare, @"detalii_asigurare",
                           (self.companie ? self.companie : @""), @"companie",
                           (self.codOferta ? self.codOferta : @""), @"cod_oferta",
                           [NSNumber numberWithFloat:prima], @"prima",
                           (self.moneda ? self.moneda : @""), @"moneda",
                           dataInceputString, @"data_inceput",
                           dataSfarsitString, @"data_sfarsit",
                           [NSNumber numberWithInt:self.durataAsigurare], @"durata_asigurare",                           
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
    
    self.idExtern = [[item objectForKey:@"id_extern"] intValue];
    self.idIntern = [item objectForKey:@"id_intern"];
    self.status = [[item objectForKey:@"status"] intValue];
    self.tipAsigurare = [[item objectForKey:@"tip_asigurare"] intValue];
    self.numeAsigurare = [item objectForKey:@"nume_asigurare"];
    self.idAsigurat = [item objectForKey:@"id_asigurat"];
    self.obiecteAsigurate = [item objectForKey:@"obiecte_asigurate"];
    self.detaliiAsigurare = [item objectForKey:@"detalii_asigurare"];
    self.companie = [item objectForKey:@"companie"];
    self.codOferta = [item objectForKey:@"cod_oferta"];
    self.prima = [[item  objectForKey:@"prima"] floatValue];
    self.moneda = [item objectForKey:@"moneda"];
    NSString * dataInceputString = [item objectForKey:@"data_inceput"];
    NSString * dataSfarsitString = [item objectForKey:@"data_sfarsit"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    self.dataInceput = [dateFormat dateFromString:dataInceputString];
    self.dataSfarsit = [dateFormat dateFromString:dataSfarsitString];
    self.durataAsigurare = [[item objectForKey:@"durata_asigurare"] intValue];
    self._isDirty = YES; 
}

#pragma RCA
- (NSString *) RCABonusMalus
{
    NSString * bm = [self.detaliiAsigurare objectForKey:@"BonusMalus"];
    return bm;
}

- (void) setRCABonusMalus:(NSString *)value
{
    [self.detaliiAsigurare setObject:value forKey:@"BonusMalus"];
}

#pragma CALATORIE

- (NSString *)CalatorieScop
{
    NSString * scopCalatorie = [self.detaliiAsigurare objectForKey:@"ScopCalatorie"];
    return scopCalatorie;
}

- (NSString *)CalatorieDestinatie
{
    NSString * taraDestinatie = [self.detaliiAsigurare objectForKey:@"Destinatie"];
    return taraDestinatie;
}

- (NSString *)CalatorieTranzit
{
    NSString * tranzit = [self.detaliiAsigurare objectForKey:@"Tranzit"];
    return tranzit;
}

- (NSString *)CalatorieProgram
{
    NSString * sumaAsigurata = [self.detaliiAsigurare objectForKey:@"SumaAsigurata"];
    return sumaAsigurata;
}

- (void)setCalatorieScop:(NSString *)value
{
    [self.detaliiAsigurare setObject:value forKey:@"ScopCalatorie"];
}
- (void)setCalatorieDestinatie:(NSString *)value
{
    [self.detaliiAsigurare setObject:value forKey:@"Destinatie"];
}
- (void)setCalatorieTranzit:(NSString *)value
{
    [self.detaliiAsigurare setObject:value forKey:@"Tranzit"];
}
- (void)setCalatorieProgram:(NSString *)value
{
    [self.detaliiAsigurare setObject:value forKey:@"SumaAsigurata"];
}

#pragma LOCUINTA
- (NSString *)LocuintaSumaAsigurata
{
    NSString * x = [self.detaliiAsigurare objectForKey:@"SumaAsigurata"];
    return x;
}
- (void) setLocuintaSA:(NSString *)value
{
    [self.detaliiAsigurare setObject:value forKey:@"SumaAsigurata"];
}

- (NSString *)LocuintaFransiza
{
    NSString * x = [self.detaliiAsigurare objectForKey:@"Fransiza"];
    return x;
}
- (void) setLocuintaFransiza:(NSString *)value
{
    [self.detaliiAsigurare setObject:value forKey:@"Fransiza"];
}

- (NSString *)LocuintaTipProdus
{
    NSString * x = [self.detaliiAsigurare objectForKey:@"TipProdus"];
    return x;
}
- (void) setLocuintaTipProdus:(NSString *)value
{
    [self.detaliiAsigurare setObject:value forKey:@"TipProdus"];
}

- (NSString *)LocuintaSABunuriValoare
{
    NSString * x = [self.detaliiAsigurare objectForKey:@"SABunuriValoare"];
    return x;
}
- (void) setLocuintaSABunuriValoare:(NSString *)value
{
    [self.detaliiAsigurare setObject:value forKey:@"SABunuriValoare"];
}

- (NSString *)LocuintaSABunuriGenerale
{
    NSString * x = [self.detaliiAsigurare objectForKey:@"SABunuriGenerale"];
    return x;
}
- (void) setLocuintaSABunuriGenerale:(NSString *)value
{
    [self.detaliiAsigurare setObject:value forKey:@"SABunuriGenerale"];
}

- (NSString *)LocuintaSARaspundere
{
    NSString * x = [self.detaliiAsigurare objectForKey:@"SARaspundere"];
    return x;
}
- (void) setLocuintaSARaspundere:(NSString *)value
{
    [self.detaliiAsigurare setObject:value forKey:@"SARaspundere"];
}

- (NSString *)LocuintaRiscFurt
{
    NSString * x = [self.detaliiAsigurare objectForKey:@"RiscFurt"];
    return x;
}
- (void) setLocuintaRiscFurt:(NSString *)value
{
    [self.detaliiAsigurare setObject:value forKey:@"RiscFurt"];
}

- (NSString *)LocuintaRiscApa
{
    NSString * x = [self.detaliiAsigurare objectForKey:@"RiscApaConducta"];
    return x;
}
- (void) setLocuintaRiscApa:(NSString *)value
{
    [self.detaliiAsigurare setObject:value forKey:@"RiscApaConducta"];
}

- (NSString *)LocuintaConditii
{
    NSString * x = [self.detaliiAsigurare objectForKey:@"LinkConditii"];
    return x;
}
- (void) setLocuintaConditii:(NSString *)value
{
    [self.detaliiAsigurare setObject:value forKey:@"LinkConditii"];
}

@end
