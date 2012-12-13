//
//  YTOObiectAsigurat.m
//  i-asigurare
//
//  Created by Andi Aparaschivei on 8/8/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
//

#import "YTOObiectAsigurat.h"
#import "Database.h"

@implementation YTOObiectAsigurat

@synthesize IdIntern, TipObiect, JSONText, _isDirty;

- (void) addObiectAsigurat
{
    sqlite3 *database;
    sqlite3_stmt *addStmt = nil;
    
    if(sqlite3_open([[Database getDBPath] UTF8String], &database) == SQLITE_OK) 
    {
        
        if(addStmt == nil) {
            const char *sql = "INSERT INTO ObiectAsigurat (IdIntern, TipObiect, JSONText) Values(?, ?, ?)";
            if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) != SQLITE_OK)
                NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
        }
        
        sqlite3_bind_text(addStmt, 1, [IdIntern UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(addStmt, 2, TipObiect); 
        sqlite3_bind_text(addStmt, 3, [JSONText UTF8String], -1, SQLITE_TRANSIENT);
                             
        
        if(SQLITE_DONE != sqlite3_step(addStmt))
            NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
        else {
            sqlite3_finalize(addStmt);
            sqlite3_close(database);
        }
        
    }
}

- (void) updateObiectAsigurat
{
    sqlite3 *database;
    sqlite3_stmt *updateStmt = nil;
    
    if(sqlite3_open([[Database getDBPath] UTF8String], &database) == SQLITE_OK) 
    {
        
        if(updateStmt == nil) {
            NSString *update = [NSString stringWithFormat:@"UPDATE ObiectAsigurat SET JSONText = ? WHERE IdIntern='%@'", IdIntern];
            
            if(sqlite3_prepare_v2(database, [update UTF8String], -1, &updateStmt, NULL) != SQLITE_OK)
                NSAssert1(0, @"Error while creating update statement. '%s'", sqlite3_errmsg(database));
        }
        
        sqlite3_bind_text(updateStmt, 1, [JSONText UTF8String], -1, SQLITE_TRANSIENT);                       
        
        if(SQLITE_DONE != sqlite3_step(updateStmt))
            NSAssert1(0, @"Error while updating data. '%s'", sqlite3_errmsg(database));
        else {
            sqlite3_finalize(updateStmt);
            sqlite3_close(database);
        }
    } 
}

- (void) deleteObiectAsigurat
{
    sqlite3 *database;
    sqlite3_stmt *deleteStmt = nil;
    
    if(sqlite3_open([[Database getDBPath] UTF8String], &database) == SQLITE_OK) 
    {
        
        if(deleteStmt == nil) {
            NSString *delete = [NSString stringWithFormat:@"DELETE FROM ObiectAsigurat WHERE IdIntern='%@'", IdIntern];
            
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

+ (YTOObiectAsigurat *) getObiectAsigurat:(NSString *)idIntern
{
    YTOObiectAsigurat * ob = [[YTOObiectAsigurat alloc] init];
    sqlite3 *database;
    sqlite3_stmt *selectstmt = nil;
    
    if (sqlite3_open([[Database getDBPath] UTF8String], &database) == SQLITE_OK) {
		NSString * sqlstring = [NSString stringWithFormat:@"SELECT IdIntern, TipObiect, JSONText FROM ObiectAsigurat WHERE IdIntern='%@'", idIntern];
		const char *sql = [sqlstring UTF8String];
        
		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
			
			while(sqlite3_step(selectstmt) == SQLITE_ROW) {
                ob._isDirty = YES;
                
                ob.IdIntern = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 0)];
                ob.TipObiect = sqlite3_column_int(selectstmt, 1);
				ob.JSONText = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 2)];
			}
		}
        sqlite3_finalize(selectstmt);
	}
    
	sqlite3_close(database);
    
    return ob;
}

+ (NSMutableArray *) getListaByTipObiect:(int)tip;
{
    NSMutableArray * _list = [[NSMutableArray alloc] init];
    sqlite3 *database;
    sqlite3_stmt *selectstmt = nil;
    
    if (sqlite3_open([[Database getDBPath] UTF8String], &database) == SQLITE_OK) {
		NSString * sqlstring = [NSString stringWithFormat:@"SELECT IdIntern, TipObiect, JSONText FROM ObiectAsigurat WHERE TipObiect=%d",tip];
		const char *sql = [sqlstring UTF8String];
        
		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
			
			while(sqlite3_step(selectstmt) == SQLITE_ROW) {
                
                YTOObiectAsigurat * ob = [[YTOObiectAsigurat alloc] init];
                ob._isDirty = YES;
                
                ob.IdIntern = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 0)];
                ob.TipObiect = sqlite3_column_int(selectstmt, 1);
				ob.JSONText = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 2)];
                
				[_list addObject:ob];
			}
		}
        sqlite3_finalize(selectstmt);
	}
    
	sqlite3_close(database);
    
    return _list;
}

@end
