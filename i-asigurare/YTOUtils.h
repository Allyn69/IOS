
//
//  YTOUtils.h
//  i-asigurare
//
//  Created by Andi Aparaschivei on 7/18/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IS_WIDESCREEN (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)

#define IS_IPHONE ([[[UIDevice currentDevice]model] isEqualToString:@"iPhone"] || [[[UIDevice currentDevice]model] isEqualToString:@"iPhone Simulator"])
#define IS_IPOD   ([[[UIDevice currentDevice]model] isEqualToString:@"iPod touch"])

//#define IS_IPHONE_5 (IS_IPHONE && IS_WIDESCREEN)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0)

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)


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
    CASCO,
    MyTravels
} ProdusAsigurare;

static NSString * ColorTitlu = @"#464646";
static NSString * ColorVerde = @"#259c5a";
static NSString * ColorGalben = @"#f7931e";
static NSString * ColorOrange = @"#f15a24";
static NSString * ColorOrangeInchis = @"#f15f2a";
static NSString * ColorAlbastru = @"#006fbb";
static NSString * ColorAlbastruInchis = @"#004572";
static NSString * GalbenNotification = @"#fdf9d8";
BOOL trecutDeOra;

static NSString * LinkAPI = @"http://rc.i-crm.ro/MaAsigurApi/";//RC

//static NSString * language = @"Localizable(Engleza)";
//culori
static NSString * verde = @"#009245";
static NSString * portocaliuCalatorie = @"#f15a24";
static NSString * albastruLocuinta = @"#0071bc";
static NSString * portocaliuCasco = @"#f7931e";
static NSString * rosuProfil = @"#cf3030";
static NSString * albastruAlerte = @"#2d4791";
static NSString * verdePromotii = @"#638e1c";
static NSString * galbenMesaj = @"#dca309";
static NSString * movValabilitate = @"#574d83";
static NSString * rosuTermeni = @"#f44546";
static NSString * menuLighGray = @"#878787";

#define NSStringIsNullOrEmpty(str) ((str==nil) || [(str) isEqualToString:@""] || [str isKindOfClass:[NSString class]])

@interface YTOUtils : NSObject

+ (UIColor *) colorFromHexString:(NSString *)hexString;
+ (NSString *)GenerateUUID;
+ (NSString *) md5:(NSString *) input;
+ (void) setCellFormularStyle:(UITableViewCell *) cell;
+ (NSString *) formatDate:(NSDate *) date withFormat:(NSString *)format;
+ (NSDate *) getDateFromString:(NSString *) data withFormat:(NSString *)format;
+ (UIImage *) getImageForValue:(NSString *)value;
+ (NSString *) getAnMinimPermis:(NSString *)cnp;
+ (NSString *) getVarsta:(NSString *)cnp;
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
+ (void) deleteWhenLogOff;
// VALIDARI
+ (BOOL) validateEmail: (NSString *) email;
+ (BOOL) validateCNP: (NSString* ) cnp;
+ (BOOL) validateCUI: (NSString* ) cui;
+ (BOOL) validateSasiu:(NSString *) sasiu;
+ (BOOL) validateCIV:(NSString *) civ;

+ (BOOL) isWeekend;

+ (NSString *) replacePossibleWrongEmailAddresses:(NSString *) email;
+ (NSString *) replacePossibleWrongSerieSasiu:(NSString *)serie;
+ (UIImage*) drawText:(NSString*) text inImage:(UIImage*)  image atPoint:(CGPoint)   point drawText2 : (NSString *) text2  atPoint2 :(CGPoint) point2;
+ (void) rightImageVodafone :(UINavigationItem *) navBar;

@end
