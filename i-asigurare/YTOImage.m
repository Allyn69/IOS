//
//  YTOImage.m
//  i-asigurare
//
//  Created by Administrator on 8/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YTOImage.h"
#import "Database.h"

@implementation YTOImage

@synthesize idIntern, image, thumb;

-(id)initWithGuid:(NSString *)guid
{
    self = [super init];
    self.idIntern = guid;
    
    return self;
}

- (void) addImage
{
    sqlite3 *database;
    sqlite3_stmt *addStmt = nil;
    
    if(sqlite3_open([[Database getDBPath] UTF8String], &database) == SQLITE_OK) 
    {
        
        if(addStmt == nil) {
            const char *sql = "INSERT INTO Media (IdIntern, Image, Thumbnail) Values(?, ?, ?)";
            if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) != SQLITE_OK)
                NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
        }
        
        sqlite3_bind_text(addStmt, 1, [idIntern UTF8String], -1, SQLITE_TRANSIENT);

        NSData * dataImg = UIImagePNGRepresentation(image);
        int returnValueImg = -1;
        if (dataImg != nil)
            returnValueImg = sqlite3_bind_blob(addStmt, 2, [dataImg bytes], [dataImg length], NULL);
        else returnValueImg = sqlite3_bind_blob(addStmt, 2, nil, -1, NULL);
        
        NSData * dataThumb = UIImagePNGRepresentation(thumb);
        int returnValueThumb = -1;
        if (dataThumb != nil)
            returnValueThumb = sqlite3_bind_blob(addStmt, 3, [dataThumb bytes], [dataThumb length], NULL);
        else returnValueThumb = sqlite3_bind_blob(addStmt, 3, nil, -1, NULL);
        
        if (returnValueImg != SQLITE_OK || returnValueThumb != SQLITE_OK)
            NSLog(@"Image not ok.");
        
        if(SQLITE_DONE != sqlite3_step(addStmt))
            NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
        else {
            sqlite3_finalize(addStmt);
            sqlite3_close(database);
        }
        
    }

}

- (void) updateImage
{
    
}

+ (YTOImage *) getImage:(NSString *)_id
{
    YTOImage * objImage = nil;
    
    sqlite3 *database;
    sqlite3_stmt *selectstmt = nil;
    
    if (sqlite3_open([[Database getDBPath] UTF8String], &database) == SQLITE_OK) {
		NSString * sqlstring = [NSString stringWithFormat:@"SELECT IdIntern, Image, Thumbnail FROM Media WHERE IdIntern='%@'", _id];
		const char *sql = [sqlstring UTF8String];
        
		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
			
			while(sqlite3_step(selectstmt) == SQLITE_ROW) {
                
                objImage = [[YTOImage alloc] initWithGuid:_id];
                
				NSData * imgData = [[NSData alloc] initWithBytes:sqlite3_column_blob(selectstmt, 1) length:sqlite3_column_bytes(selectstmt, 1)];
                if (imgData)
                    objImage.image = [UIImage imageWithData:imgData];
                
                NSData * thumbData = [[NSData alloc] initWithBytes:sqlite3_column_blob(selectstmt, 2) length:sqlite3_column_bytes(selectstmt, 2)];
                if (thumbData)
                    objImage.thumb = [UIImage imageWithData:thumbData];
			}
		}
        sqlite3_finalize(selectstmt);
	}
    
	sqlite3_close(database);
    
    return objImage;
}

@end
