//
//  YTOUserDefaults.m
//  i-asigurare
//
//  Created by Andi Aparaschivei on 11/21/12.
//
//

#import "YTOUserDefaults.h"

@implementation YTOUserDefaults

+ (void) setFirstTime:(BOOL)ok
{
    NSUserDefaults *myUserDefault = [NSUserDefaults standardUserDefaults];
    
    [myUserDefault setBool:ok forKey:@"FirstTime"];
}
+ (BOOL) IsFirstTime
{
    NSUserDefaults *myUserDefault = [NSUserDefaults standardUserDefaults];
    BOOL x = [myUserDefault boolForKey:@"FirstTime"];
    return !x;
}

+ (void) setSyncronized:(BOOL)ok
{
    NSUserDefaults *myUserDefault = [NSUserDefaults standardUserDefaults];
    
    [myUserDefault setBool:ok forKey:@"Syncronized"];
}
+ (BOOL) IsSyncronized
{
    NSUserDefaults *myUserDefault = [NSUserDefaults standardUserDefaults];
    return [myUserDefault boolForKey:@"Syncronized"];
}

+ (void) setFirstInsuranceRequest:(BOOL)ok
{
    NSUserDefaults *myUserDefault = [NSUserDefaults standardUserDefaults];
    
    [myUserDefault setBool:ok forKey:@"FirstInsuranceRequest"];
}

+ (BOOL) IsFirstInsuranceRequest
{
    NSUserDefaults *myUserDefault = [NSUserDefaults standardUserDefaults];
    return ![myUserDefault boolForKey:@"FirstInsuranceRequest"];
}
@end
