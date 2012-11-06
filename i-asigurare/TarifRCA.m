//
//  TarifRCA.m
//  i-Asigurare
//
//  Created by Administrator on 3/23/11.
//  Copyright 2011 i-Tom Solutions. All rights reserved.
//

#import "TarifRCA.h"


@implementation TarifRCA

@synthesize idCompanie, prima, nume, codOferta, clasa_bm;

- (float) primaInt {
	return [prima floatValue];
}
@end
