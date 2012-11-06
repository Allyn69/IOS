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
+ (NSMutableArray*)Alerte;

- (NSString *) toJSON;
- (void) fromJSON:(NSString *)p;

@end
