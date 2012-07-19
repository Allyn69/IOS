//
//  Database.m
//  iRCA
//
//  Created by Administrator on 11/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Database.h"

static sqlite3 *database = nil;

@implementation Database

#pragma Nomenclatoare

+(NSMutableArray*)MarciAuto
{
    NSMutableArray * marci = [[NSMutableArray alloc] initWithArray:nil];
    
    if (sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK) {
		NSString * sqlstring = @"Select Nume from vehicule_marci";
		const char *sql = [sqlstring UTF8String];
		sqlite3_stmt *selectstmt;
		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
			
			while(sqlite3_step(selectstmt) == SQLITE_ROW) {

                NSString * marca;
				marca = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 0)];

				[marci addObject:marca];
			}
		}
	}
    
	sqlite3_close(database);
    
    return marci;
}

+(NSMutableArray*)Judete
{
    NSMutableArray * judete = [[NSMutableArray alloc] initWithArray:nil];
    
    if (sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK) {
		NSString * sqlstring = @"Select Nume from judete";
		const char *sql = [sqlstring UTF8String];
		sqlite3_stmt *selectstmt;
		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
			
			while(sqlite3_step(selectstmt) == SQLITE_ROW) {
                
                NSString * judet;
				judet = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 0)];
                
				[judete addObject:judet];
			}
		}
	}
    
	sqlite3_close(database);
    
    return judete;
}

+(NSMutableArray*)Localitati:(NSString*)judet
{
    NSMutableArray * localitati = [[NSMutableArray alloc] initWithArray:nil];
    
    if (sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK) {
		NSString * sqlstring = [NSString stringWithFormat:@"Select localitati.localitate from localitati Join judete on localitati.cod_judet = judete.Id Where judete.Nume='%@'", judet];
		const char *sql = [sqlstring UTF8String];
		sqlite3_stmt *selectstmt;
		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
			
			while(sqlite3_step(selectstmt) == SQLITE_ROW) {
                
                NSString * localitate;
				localitate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 0)];
                
				[localitati addObject:localitate];
			}
		}
	}
    
	sqlite3_close(database);
    
    return localitati;
}

+ (NSString*)getDBPath
{
//    NSString * db = [[NSBundle mainBundle] pathForResource:@"vreau_rca" ofType:@"sqlite"];
//    return db;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:@"vreau_rca.sqlite"];
}

+ (void) finalizeStatements {
	
	if(database) sqlite3_close(database);
}

@end