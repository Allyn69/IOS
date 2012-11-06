//
//  YTOImage.h
//  i-asigurare
//
//  Created by Administrator on 8/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeyValueItem.h"
#import "YTOUtils.h"
#import <sqlite3.h>

@interface YTOImage : NSObject

@property (nonatomic, retain) NSString *        idIntern;
@property (nonatomic, retain) UIImage  *        image;
@property (nonatomic, retain) UIImage  *        thumb;

-(id)initWithGuid:(NSString *)guid;
- (void) addImage;
- (void) updateImage;
+ (YTOImage *) getImage:(NSString *)_id;
@end
