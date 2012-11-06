//
//  CategorieAuto.m
//  iRCA
//
//  Created by MacBook on 02.11.2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "KeyValueItem.h"

@implementation KeyValueItem

@synthesize parentKey, key, value, value2;

-(void) encodeWithCoder:(NSCoder *)encoder {	
	[encoder encodeInt:parentKey forKey:@"ParentKey"];
	[encoder encodeInt:key forKey:@"Key"];	
	
	[encoder encodeObject:value forKey:@"Value"];
	[encoder encodeObject:value2 forKey:@"Value2"];	
}

-(id) initWithCoder:(NSCoder *)decoder {
	if (self = [super init]) {
		parentKey = [decoder decodeIntegerForKey:@"ParentKey"];
		key = [decoder decodeIntegerForKey:@"Key"];
        
		value = [decoder decodeObjectForKey:@"Value"];
		value2 = [decoder decodeObjectForKey:@"Value2"];    
	}
	return self;
}

@end
