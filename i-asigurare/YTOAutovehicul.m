//
//  YTOAutovehicul.m
//  i-asigurare
//
//  Created by Administrator on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YTOAutovehicul.h"
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
@synthesize nrKm;
@synthesize idFirmaLeasing;
@synthesize idProprietar;
@synthesize _dataCreare;

@synthesize _isDirty;


//idIntern, judet, localitate, categorieAuto, subcategorieAuto, nrInmatriculare, serieSasiu, marcaAuto, modelAuto, cm3, nrLocuri, masaMaxima, putere, anFabricatie, destinatieAuto, marimeParc, serieCiv, dauneInUltimulAn, aniFaraDaune, culoare, combustibil, tipInregistrare, autoNouInregistrat, inLeasing, nrKm, idFirmaLeasing, idProprietar

- (id)initWithGuid:(NSString*)guid
{
    self = [super init];
    self.idIntern = guid;
    
    return self;
}

- (void) addAutovehicul
{
    sqlite3 *database;
    sqlite3_stmt *addStmt = nil;
    
    if(sqlite3_open([[Database getDBPath] UTF8String], &database) == SQLITE_OK) 
    {
        
        if(addStmt == nil) {
            const char *sql = "INSERT INTO AUTOVEHICUL (IdIntern, Judet, Localitate, CategorieAuto, SubcategorieAuto, NrInmatriculare, SerieSasiu, MarcaAuto, ModelAuto, Cm3, NrLocuri, MasaMaxima, Putere, AnFabricatie, DestinatieAuto, MarimeParc, SerieCiv, DauneInUltimulAn, AniFaraDaune, Culoare, Combustibil, TipInregistrare, AutoNouInregistrat, InLeasing, NrKm, IdFirmaLeasing, IdProprietar, _dataCreare) Values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, getDate())";
            if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) != SQLITE_OK)
                NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
        }
        
        sqlite3_bind_text(addStmt, 1, [idIntern UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 2, [judet UTF8String], -1, SQLITE_TRANSIENT); 
        sqlite3_bind_text(addStmt, 3, [localitate UTF8String], -1, SQLITE_TRANSIENT); 
        sqlite3_bind_int(addStmt, 4, categorieAuto);
        sqlite3_bind_text(addStmt, 5, [subcategorieAuto UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 6, [nrInmatriculare UTF8String], -1, SQLITE_TRANSIENT); 
        sqlite3_bind_text(addStmt, 7, [serieSasiu UTF8String], -1, SQLITE_TRANSIENT); 
        sqlite3_bind_text(addStmt, 8, [marcaAuto UTF8String], -1, SQLITE_TRANSIENT); 
        sqlite3_bind_text(addStmt, 9, [modelAuto UTF8String], -1, SQLITE_TRANSIENT); 
        sqlite3_bind_int(addStmt, 10, cm3); 
        sqlite3_bind_int(addStmt, 11, nrLocuri); 
        sqlite3_bind_int(addStmt, 12, masaMaxima); 
        sqlite3_bind_int(addStmt, 13, putere); 
        sqlite3_bind_int(addStmt, 14, anFabricatie);
        sqlite3_bind_text(addStmt, 15, [destinatieAuto UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(addStmt, 16, marimeParc); 
        sqlite3_bind_text(addStmt, 17, [serieCiv UTF8String], -1, SQLITE_TRANSIENT); 
        sqlite3_bind_int(addStmt, 18, dauneInUltimulAn);
        sqlite3_bind_int(addStmt, 19, aniFaraDaune); 
        sqlite3_bind_text(addStmt, 20, [culoare UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 21, [combustibil UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 22, [tipInregistrare UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 23, [autoNouInregistrat UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 24, [inLeasing UTF8String], -1, SQLITE_TRANSIENT); 
        sqlite3_bind_int(addStmt, 25, nrKm);
        sqlite3_bind_text(addStmt, 26, [idFirmaLeasing UTF8String], -1, SQLITE_TRANSIENT); 
        sqlite3_bind_text(addStmt, 27, [idProprietar UTF8String], -1, SQLITE_TRANSIENT);                       
        
        if(SQLITE_DONE != sqlite3_step(addStmt))
            NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
        else {
            sqlite3_finalize(addStmt);
            sqlite3_close(database);
        }
        
    }
}

- (void) updateAutovehicul:(YTOAutovehicul *)a 
{
    sqlite3 *database;
    sqlite3_stmt *updateStmt = nil;
    
    if(sqlite3_open([[Database getDBPath] UTF8String], &database) == SQLITE_OK) 
    {
        
        if(updateStmt == nil) {
            NSString *update = [NSString stringWithFormat:@"UPDATE AUTOVEHICUL SET Judet = ?, Localitate = ?, CategorieAuto = ?, SubcategorieAuto = ?, NrInmatriculare = ?, SerieSasiu = ?, MarcaAuto = ?, ModelAuto = ?, Cm3 = ?, NrLocuri = ?, MasaMaxima = ?, Putere = ?, AnFabricatie = ?, DestinatieAuto = ?, MarimeParc = ?, SerieCiv = ?, DauneInUltimulAn = ?, AniFaraDaune = ?, Culoare = ?, Combustibil = ?, TipInregistrare = ?, AutoNouInregistrat = ?, InLeasing = ?, NrKm = ?, IdFirmaLeasing = ?, IdProprietar = ? WHERE IdIntern='%@'", a.idIntern];
            
            if(sqlite3_prepare_v2(database, [update UTF8String], -1, &updateStmt, NULL) != SQLITE_OK)
                NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
        }
        
        sqlite3_bind_text(updateStmt, 1, [judet UTF8String], -1, SQLITE_TRANSIENT); 
        sqlite3_bind_text(updateStmt, 2, [localitate UTF8String], -1, SQLITE_TRANSIENT); 
        sqlite3_bind_int(updateStmt, 3, categorieAuto);
        sqlite3_bind_text(updateStmt, 4, [subcategorieAuto UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(updateStmt, 5, [nrInmatriculare UTF8String], -1, SQLITE_TRANSIENT); 
        sqlite3_bind_text(updateStmt, 6, [serieSasiu UTF8String], -1, SQLITE_TRANSIENT); 
        sqlite3_bind_text(updateStmt, 7, [marcaAuto UTF8String], -1, SQLITE_TRANSIENT); 
        sqlite3_bind_text(updateStmt, 8, [modelAuto UTF8String], -1, SQLITE_TRANSIENT); 
        sqlite3_bind_int(updateStmt, 9, cm3); 
        sqlite3_bind_int(updateStmt, 10, nrLocuri); 
        sqlite3_bind_int(updateStmt, 11, masaMaxima); 
        sqlite3_bind_int(updateStmt, 12, putere); 
        sqlite3_bind_int(updateStmt, 13, anFabricatie);
        sqlite3_bind_text(updateStmt, 14, [destinatieAuto UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(updateStmt, 15, marimeParc); 
        sqlite3_bind_text(updateStmt, 16, [serieCiv UTF8String], -1, SQLITE_TRANSIENT); 
        sqlite3_bind_int(updateStmt, 17, dauneInUltimulAn);
        sqlite3_bind_int(updateStmt, 18, aniFaraDaune); 
        sqlite3_bind_text(updateStmt, 19, [culoare UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(updateStmt, 20, [combustibil UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(updateStmt, 21, [tipInregistrare UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(updateStmt, 22, [autoNouInregistrat UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(updateStmt, 23, [inLeasing UTF8String], -1, SQLITE_TRANSIENT); 
        sqlite3_bind_int(updateStmt, 24, nrKm);
        sqlite3_bind_text(updateStmt, 25, [idFirmaLeasing UTF8String], -1, SQLITE_TRANSIENT); 
        sqlite3_bind_text(updateStmt, 26, [idProprietar UTF8String], -1, SQLITE_TRANSIENT);                       
        
        if(SQLITE_DONE != sqlite3_step(updateStmt))
            NSAssert1(0, @"Error while updating data. '%s'", sqlite3_errmsg(database));
        else {
            sqlite3_finalize(updateStmt);
            sqlite3_close(database);
        }
        
    }
}

+ (YTOAutovehicul *) getAutovehicul:(NSString *)_idIntern
{
    sqlite3 *database;
    sqlite3_stmt *selectStmt = nil;
    
    if(sqlite3_open([[Database getDBPath] UTF8String], &database) == SQLITE_OK) 
    {
        
        
        NSString *select = [NSString stringWithFormat:@"SELECT IdIntern, Judet, Localitate, CategorieAuto, SubcategorieAuto, NrInmatriculare, SerieSasiu, MarcaAuto, ModelAuto, Cm3, NrLocuri, MasaMaxima, Putere, AnFabricatie, DestinatieAuto, MarimeParc, SerieCiv, DauneInUltimulAn, AniFaraDaune, Culoare, Combustibil, TipInregistrare, AutoNouInregistrat, InLeasing, NrKm, IdFirmaLeasing, IdProprietar, _dataCreare FROM AUTOVEHICUL WHERE IdIntern='%@'", _idIntern];
        
        YTOAutovehicul *a = [[YTOAutovehicul alloc] init];
        if(sqlite3_prepare_v2(database, [select UTF8String], -1, &selectStmt, NULL) == SQLITE_OK) {
            
            if (sqlite3_step(selectStmt) == SQLITE_ROW)
            {
                a._isDirty = YES;
                
                a.idIntern =  [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(selectStmt, 0)];
                
                // to do next props
                // ..
            }
            sqlite3_finalize(selectStmt);
        }
        sqlite3_close(database);
        return a;
    }
    return nil;
}

+ (NSMutableArray*)Masini
{
    NSMutableArray * _list = [[NSMutableArray alloc] init];
    sqlite3 *database;
    sqlite3_stmt *selectstmt = nil;
    
    if (sqlite3_open([[Database getDBPath] UTF8String], &database) == SQLITE_OK) {
		NSString * sqlstring = @"SELECT IdIntern, Judet, Localitate, CategorieAuto, SubcategorieAuto, NrInmatriculare, SerieSasiu, MarcaAuto, ModelAuto, Cm3, NrLocuri, MasaMaxima, Putere, AnFabricatie, DestinatieAuto, MarimeParc, SerieCiv, DauneInUltimulAn, AniFaraDaune, Culoare, Combustibil, TipInregistrare, AutoNouInregistrat, InLeasing, NrKm, IdFirmaLeasing, IdProprietar, _dataCreare FROM AUTOVEHICUL";
		const char *sql = [sqlstring UTF8String];
        
		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
			
			while(sqlite3_step(selectstmt) == SQLITE_ROW) {
                
                YTOAutovehicul *a = [[YTOAutovehicul alloc] init];
                
                a.idIntern =  [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(selectstmt, 0)];
				// to do next props
                // ..
                
				[_list addObject:a];
			}
		}
        sqlite3_finalize(selectstmt);
	}
    
	sqlite3_close(database);
    
    return _list;
}


@end
