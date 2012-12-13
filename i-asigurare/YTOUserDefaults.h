//
//  YTOUserDefaults.h
//  i-asigurare
//
//  Created by Andi Aparaschivei on 11/21/12.
//
//

#import <Foundation/Foundation.h>

@interface YTOUserDefaults : NSObject
{
    
}

+ (void) setFirstTime:(BOOL)ok;
+ (void) setFirstInsuranceRequest:(BOOL)ok;
+ (BOOL) IsFirstTime;

+ (void) setSyncronized:(BOOL)ok;
+ (BOOL) IsSyncronized;
+ (BOOL) IsFirstInsuranceRequest;

@end
