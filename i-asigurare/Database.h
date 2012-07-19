//
//  Database.h
//  iRCA
//
//  Created by Administrator on 11/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "YTOPersoana.h"

@interface Database : NSObject


// Nomenclatoare
+(NSMutableArray*)MarciAuto;
+(NSMutableArray*)Judete;
+(NSMutableArray*)Localitati:(NSString*)judet;

// Altele
+(NSString*)getDBPath;

@end
