//
//  CotatieRCA2.h
//  i-asigurare
//
//  Created by Stern Edi on 10/16/13.
//
//

#import <Foundation/Foundation.h>

@interface CotatieRCA2 : NSObject {
    
}

@property (nonatomic, retain ) NSString * prima;
@property (nonatomic, retain ) NSString * primaReducere;
@property (nonatomic, retain ) NSString * Reducere;
@property (nonatomic, retain ) NSString * numeCompanie;
@property (nonatomic, retain ) NSString * codOferta;
@property (nonatomic, retain ) NSString * clasaBM;
@property (nonatomic, retain ) NSString * eroare_ws;
@property (nonatomic, retain ) NSString * idReducere;

- (float) primaInt;
- (float) primaReducereInt;
@end
