//
//  YTOUtils.h
//  i-asigurare
//
//  Created by Administrator on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    kMarci,
    kJudete,
    kLocalitati,
    kCategoriiAuto,
    kTipCombustibil,
    kDestinatieAuto
} Nomenclatoare;

@interface YTOUtils : NSObject

+ (UIColor *) colorFromHexString:(NSString *)hexString;
+ (NSString *)GenerateUUID;
+ (void) setCellFormularStyle:(UITableViewCell *) cell;
+ (NSString *) formatDate:(NSDate *) date withFormat:(NSString *)format;

@end
