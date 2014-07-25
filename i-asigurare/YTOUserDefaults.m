//
//  YTOUserDefaults.m
//  i-asigurare
//
//  Created by Andi Aparaschivei on 11/21/12.
//
//

#import "YTOUserDefaults.h"

@implementation YTOUserDefaults

@synthesize UdidUpdated;

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

+ (void) setIsRedus:(BOOL)ok
{
    NSUserDefaults *myUserDefault = [NSUserDefaults standardUserDefaults];
    
    [myUserDefault setBool:ok forKey:@"Reducere"];
}
+ (BOOL) isRedus
{
    NSUserDefaults *myUserDefault = [NSUserDefaults standardUserDefaults];
    BOOL x = [myUserDefault boolForKey:@"Reducere"];
    return x;
}

+ (void) setIsFirstCalc:(BOOL)ok
{
    NSUserDefaults *myUserDefault = [NSUserDefaults standardUserDefaults];
    
    [myUserDefault setBool:ok forKey:@"First_calc"];
}
+ (BOOL) isFirstCalc
{
    NSUserDefaults *myUserDefault = [NSUserDefaults standardUserDefaults];
    BOOL x = [myUserDefault boolForKey:@"First_calc"];
    return x;
}

+ (void) setUdidUpdated:(BOOL)ok
{
    NSUserDefaults *myUserDefault = [NSUserDefaults standardUserDefaults];
    
    [myUserDefault setBool:ok forKey:@"UdidUpdated2"];
}

+ (BOOL) isUdidUpdated
{
    NSUserDefaults *myUserDefault = [NSUserDefaults standardUserDefaults];
    return [myUserDefault boolForKey:@"UdidUpdated2"];
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

+ (void) setOperatorMobil:(NSString *)op
{
    NSUserDefaults *myUserDefault = [NSUserDefaults standardUserDefaults];
    [myUserDefault setValue:op forKey:@"Operator"];
}

+ (NSString *) getOperator
{
    NSUserDefaults *myUserDefault = [NSUserDefaults standardUserDefaults];
    return [myUserDefault valueForKey:@"Operator"];
}

+ (void) setPushToken:(NSString *)pt
{
    NSUserDefaults *myUserDefault = [NSUserDefaults standardUserDefaults];
    [myUserDefault setValue:pt forKey:@"PushToken"];
}

+ (NSString *) getPushToken
{
    NSUserDefaults *myUserDefault = [NSUserDefaults standardUserDefaults];
    return [myUserDefault valueForKey:@"PushToken"];
}

+ (void) setUserName:(NSString *)un
{
    NSUserDefaults *myUserDefault = [NSUserDefaults standardUserDefaults];
    [myUserDefault setValue:un forKey:@"UserName"];
}

+ (NSString *) getUserName
{
    NSUserDefaults *myUserDefault = [NSUserDefaults standardUserDefaults];
    return [myUserDefault valueForKey:@"UserName"];
}

+ (void) setPassword:(NSString *)pas
{
    NSUserDefaults *myUserDefault = [NSUserDefaults standardUserDefaults];
    [myUserDefault setValue:pas forKey:@"Password"];
}

+ (NSString *) getPassword
{
    NSUserDefaults *myUserDefault = [NSUserDefaults standardUserDefaults];
    return [myUserDefault valueForKey:@"Password"];
}

+ (void) setLanguage:(NSString *)lang
{
    NSUserDefaults *myUserDefault = [NSUserDefaults standardUserDefaults];
    [myUserDefault setValue:lang forKey:@"Language"];
}

+ (NSString *) getLanguage
{
    NSUserDefaults *myUserDefault = [NSUserDefaults standardUserDefaults];
    return [myUserDefault valueForKey:@"Language"];
}




@end
