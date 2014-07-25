//
//  TarifRCA.m
//  i-Asigurare
//
//  Created by Andi Aparaschivei on 3/23/11.
//  Copyright 2011 i-Tom Solutions. All rights reserved.
//

#import "TarifRCA.h"


@implementation TarifRCA

@synthesize prima,
primaReducere,
Reducere,
numeCompanie,
codOferta,
clasaBM,
eroare_ws,
idReducere;

- (float) primaInt {
	return [prima floatValue];
}

- (float) primaReducereInt {
	return [primaReducere floatValue];
}
@end
