//
//  CategorieAuto.h
//  iRCA
//
//  Created by MacBook on 02.11.2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyValueItem : NSObject {
    NSInteger parentKey;
    NSInteger key;
    NSString * value;
}

@property (nonatomic) NSInteger parentKey;
@property (nonatomic) NSInteger key;
@property (nonatomic, copy) NSString * value;

@end
