//
//  YTOAlerta.h
//  i-asigurare
//
//  Created by Administrator on 10/29/12.
//
//

#import <Foundation/Foundation.h>

@interface YTOAlerta : NSObject

@property int                            idExtern;
@property (nonatomic, retain) NSString * idIntern;
@property int                            tipAlerta;
@property (nonatomic, retain) NSDate *   dataAlerta;
@property (nonatomic, retain) NSString * esteRata;
@property (nonatomic, retain) NSString * idObiect;
@property (nonatomic, retain) NSDate   * _dataCreare;
@property BOOL _isDirty;

-(id)initWithGuid:(NSString*)guid;
- (void) addAlerta;
- (void) updateAlerta;
- (void) deleteAlerta;
+ (YTOAlerta *) getAlerta:(NSString *)_idIntern;
+ (YTOAlerta *) getAlerta:(NSString *)_idIntern forType:(int)tip;
+ (YTOAlerta *) getAlertaRCA:(NSString *)_idIntern;
+ (YTOAlerta *) getAlertaITP:(NSString *)_idIntern;
+ (YTOAlerta *) getAlertaRovinieta:(NSString *)_idIntern;
+ (YTOAlerta *) getAlertaCasco:(NSString *)_idIntern;
+ (YTOAlerta *) getAlertaLocuinta:(NSString *)_idIntern;
+ (YTOAlerta *) getAlertaRataCasco:(NSString *)_idIntern;
+ (YTOAlerta *) getAlertaRataLocuinta:(NSString *)_idIntern;

+ (NSMutableArray*)Alerte;
+ (int)GetNrAlerteScadente;

- (NSString *) toJSON;
- (void) fromJSON:(NSString *)p;

@end
