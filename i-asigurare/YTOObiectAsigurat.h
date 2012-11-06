//
//  YTOObiectAsigurat.h
//  i-asigurare
//
//  Created by Administrator on 8/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTOUtils.h"
#import <sqlite3.h>


// TipObiect
// 1 - persoana
// 2 - autovehicul
// 3 - locuinta
// 4 - alerta

@interface YTOObiectAsigurat : NSObject

@property (nonatomic, retain) NSString * IdIntern;
@property int                            TipObiect;
@property (nonatomic, retain) NSString * JSONText;
@property BOOL                           _isDirty;

- (void) addObiectAsigurat;
- (void) updateObiectAsigurat;
- (void) deleteObiectAsigurat;
+ (YTOObiectAsigurat *) getObiectAsigurat:(NSString *)idIntern;
+ (NSMutableArray *) getListaByTipObiect:(int)tip;

@end
