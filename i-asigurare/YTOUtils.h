//
//  YTOUtils.h
//  i-asigurare
//
//  Created by Andi Aparaschivei on 7/18/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
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
static NSString * ColorOrangeInchis = @"#f15f2a";
static NSString * ColorAlbastru = @"#006fbb";
static NSString * ColorAlbastruInchis = @"#004572";

//static NSString * LinkAPI = @"https://api.i-business.ro/MaAsigurApi/";

static NSString * LinkAPI = @"http://i-crm.ro/MaAsigurApiTest/";
//static NSString * LinkAPI = @"http://192.168.1.176:8082/";

#define NSStringIsNullOrEmpty(str) ((str==nil) || [(str) isEqualToString:@""] || [str isKindOfClass:[NSString class]])

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
+ (NSDate *) getDataMinimaInceperePolita;
+ (int) getAnCurent;
+ (int) getAnFromDate:(NSDate *)date;
+ (NSString *) append:(id) first, ...;
+ (UIImage *)scaleImage:(UIImage *) image maxWidth:(float) maxWidth maxHeight:(float) maxHeight;

+ (int) getKeyList:(NSMutableArray *)list forValue:(NSString *)value;
+ (NSString *) getValueList:(NSMutableArray *)list forKey:(int)value;

+ (NSMutableArray *) GETCompaniiAsigurare;
+ (NSMutableArray *) GETTipAlertaList;

+ (NSString *) getHTMLWithStyle:(NSString *)html;
+ (NSString *) reverseString:(NSString *)s;

// VALIDARI
+ (BOOL) validateEmail: (NSString *) email;
+ (BOOL) validateCNP: (NSString* ) cnp;
+ (BOOL) validateCUI: (NSString* ) cui;
+ (BOOL) validateSasiu:(NSString *) sasiu;
+ (BOOL) validateCIV:(NSString *) civ;

+ (NSString *) replacePossibleWrongEmailAddresses:(NSString *) email;
+ (NSString *) replacePossibleWrongSerieSasiu:(NSString *)serie;

@end
