//
//  TarifRCA.h
//  i-Asigurare
//
//  Created by Administrator on 3/23/11.
//  Copyright 2011 i-Tom Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TarifRCA : NSObject
{

}

@property NSInteger idCompanie;
@property (nonatomic, retain) NSString * nume;
@property (nonatomic, retain) NSString * codOferta;
@property (nonatomic, retain) NSString * prima;
@property (nonatomic, retain) NSString * clasa_bm;

- (float) primaInt;

@end

