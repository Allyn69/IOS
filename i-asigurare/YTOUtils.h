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
    kDestinatieAuto,
    kDescriereLocuinta,
    kCoduriCaen,
    kCompaniiAsigurare
} Nomenclatoare;

typedef enum
{
    RCA,
    Calatorie,
    Locuinta,
    CASCO
} ProdusAsigurare;

static NSString * ColorTitlu = @"#464646";
static NSString * ColorVerde = @"#259c5a";
static NSString * ColorGalben = @"#f7931e";
static NSString * ColorOrange = @"#f15a24";

@interface YTOUtils : NSObject

+ (UIColor *) colorFromHexString:(NSString *)hexString;
+ (NSString *)GenerateUUID;
+ (void) setCellFormularStyle:(UITableViewCell *) cell;
+ (NSString *) formatDate:(NSDate *) date withFormat:(NSString *)format;
+ (NSDate *) getDateFromString:(NSString *) data withFormat:(NSString *)format;
+ (UIImage *) getImageForValue:(NSString *)value;
+ (NSString *) getAnMinimPermis:(NSString *)cnp;
+ (NSDate *) getDataSfarsitPolita:(NSDate *)dataInceput andDurataInLuni:(int)durata;
+ (NSDate *) getDataSfarsitPolita:(NSDate *)dataInceput andDurataInZile:(int)durata;
+ (int) getAnCurent;
+ (NSString *) append:(id) first, ...;
+ (UIImage *)scaleImage:(UIImage *) image maxWidth:(float) maxWidth maxHeight:(float) maxHeight;

+ (int) getKeyList:(NSMutableArray *)list forValue:(NSString *)value;
+ (NSString *) getValueList:(NSMutableArray *)list forKey:(int)value;

+ (NSMutableArray *) GETCompaniiAsigurare;
+ (NSMutableArray *) GETTipAlertaList;

@end
