//
//  YTOAlerta.h
//  i-asigurare
//
//  Created by Andi Aparaschivei on 10/29/12.
//
//

#import <Foundation/Foundation.h>

NSDateComponents *difference;

@interface YTOAlerta : NSObject<NSXMLParserDelegate>
{
    NSMutableData * responseData;
	NSMutableData * capturedCharactes;
	NSMutableString * currentElementValue;
    NSString * raspuns;
}

@property int                            idExtern;
@property (nonatomic, retain) NSString * idIntern;
@property int                            tipAlerta;
@property (nonatomic, retain) NSDate *   dataAlerta;
@property (nonatomic, retain) NSString * esteRata;
@property int                            numarTotalRate;
@property int                            numarRata;
@property (nonatomic, retain) NSString * idObiect;
@property (nonatomic, retain) NSDate   * _dataCreare;
@property BOOL _isDirty;

@property (nonatomic, retain) NSMutableData * responseData;

-(id)initWithGuid:(NSString*)guid;
- (void) addAlerta:(BOOL) local;
- (void) updateAlerta:(BOOL) local;
- (void) deleteAlerta:(BOOL) local;
- (void) refresh;

+ (YTOAlerta *) getAlerta:(NSString *)_idIntern;
+ (YTOAlerta *) getAlerta:(NSString *)_idIntern forType:(int)tip;
+ (YTOAlerta *) getAlertaRCA:(NSString *)_idIntern;
+ (YTOAlerta *) getAlertaITP:(NSString *)_idIntern;
+ (YTOAlerta *) getAlertaRovinieta:(NSString *)_idIntern;
+ (YTOAlerta *) getAlertaCasco:(NSString *)_idIntern;
+ (YTOAlerta *) getAlertaLocuinta:(NSString *)_idIntern;
+ (YTOAlerta *) getAlertaRataCasco:(NSString *)_idIntern;
+ (YTOAlerta *) getAlertaRataCasco:(NSString *)_idIntern andNumarRata:(int)x;
+ (YTOAlerta *) getAlertaRataLocuinta:(NSString *)_idIntern;

+ (NSMutableArray*)AlerteActive;
+ (NSMutableArray*)Alerte;
+ (int)GetNrAlerteScadente;
+ (int) getPositionToScroll;

- (NSString *) toJSON;
- (void) fromJSON:(NSString *)p;

@end
