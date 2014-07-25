//
//  TarifRCA.h
//  i-Asigurare
//
//  Created by Andi Aparaschivei on 3/23/11.
//  Copyright 2011 i-Tom Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TarifRCA : NSObject
{

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

