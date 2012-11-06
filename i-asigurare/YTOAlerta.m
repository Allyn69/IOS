//
//  YTOAlerta.m
//  i-asigurare
//
//  Created by Administrator on 10/29/12.
//
//

#import "YTOAlerta.h"
#import "YTOObiectAsigurat.h"
#import "Database.h"

@implementation YTOAlerta

@synthesize idExtern;
@synthesize idIntern;
@synthesize tipAlerta;
@synthesize dataAlerta;
@synthesize esteRata;
@synthesize idObiect;
@synthesize _dataCreare;
@synthesize _isDirty;

- (id)initWithGuid:(NSString*)guid
{
    self = [super init];
    self.idIntern = guid;
    self._dataCreare = [NSDate date];
    return self;
}

- (void) addAlerta
{
    YTOObiectAsigurat * alerta = [[YTOObiectAsigurat alloc] init];
    alerta.IdIntern = self.idIntern;
    alerta.TipObiect = 4;
    alerta.JSONText = [self toJSON];
    [alerta addObiectAsigurat];
    self._isDirty = YES;
}

- (void) updateAlerta
{
    YTOObiectAsigurat * ob = [YTOObiectAsigurat getObiectAsigurat:self.idIntern];
    ob.JSONText = [self toJSON];
    [ob updateObiectAsigurat];
}

- (void) deleteAlerta
{
    YTOObiectAsigurat * ob = [YTOObiectAsigurat getObiectAsigurat:self.idIntern];
    ob.JSONText = [self toJSON];
    [ob deleteObiectAsigurat];
}

+ (NSMutableArray*)Alerte
{
    NSMutableArray * _list = [[NSMutableArray alloc] init];
    
    NSMutableArray * jsonList = [YTOObiectAsigurat getListaByTipObiect:4];
    
    for (int i=0; i<jsonList.count; i++) {
        YTOObiectAsigurat * ob = (YTOObiectAsigurat *)[jsonList objectAtIndex:i];
        
        YTOAlerta * p = [[YTOAlerta alloc] init];
        [p fromJSON:ob.JSONText];
        p.idIntern = ob.IdIntern;
        
        if(p)
        {
            [_list addObject:p];
        }
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dataAlerta" ascending:TRUE];
    [_list sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    return _list;
}

- (NSString *) toJSON
{
    NSError * error;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString=[dateFormat stringFromDate:self._dataCreare];
    
    NSDictionary * dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                            [NSNumber numberWithInt: self.idExtern], @"id_extern",
                           [NSNumber numberWithInt: self.tipAlerta], @"tip_alerta",
                           (self.idObiect ? self.idObiect : @""), @"id_obiect",
                           (self.dataAlerta ? [dateFormat stringFromDate:self.dataAlerta] : @""), @"data_alerta",
                           (self.esteRata ? self.esteRata : @""), @"este_rata",
                           dateString, @"data_creare",
                           nil];
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    NSString * text = [[NSString alloc] initWithData:jsonData
                                            encoding:NSUTF8StringEncoding];
    
    return text;
}

- (void) fromJSON:(NSString *)p
{
    NSError * err = nil;
    NSData *data = [p dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * item = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
    
    self.idExtern = [[item objectForKey:@"id_extern"] intValue];
    self.tipAlerta = [[item objectForKey:@"tip_alerta"] intValue];
    self.idObiect = [item objectForKey:@"id_obiect"];
    self.esteRata = [item objectForKey:@"este_rata"];
    
    NSString * dataString = [item objectForKey:@"data_creare"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString * dataAlertaString = [item objectForKey:@"data_alerta"];
    
    self.dataAlerta = [dateFormat dateFromString:dataAlertaString];
    self._dataCreare = [dateFormat dateFromString:dataString];
    
    self._isDirty = YES;
}
@end
