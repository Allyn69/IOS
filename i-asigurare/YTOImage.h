//
//  YTOImage.h
//  i-asigurare
//
//  Created by Andi Aparaschivei on 8/20/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
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
