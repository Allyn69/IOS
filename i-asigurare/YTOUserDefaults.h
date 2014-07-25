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

@property (nonatomic, retain) NSString * UdidUpdated;
//@property (nonatomic, retain) NSString * Operator;

+ (BOOL) isUdidUpdated;
+ (void) setUdidUpdated:(BOOL)ok;

+ (void) setFirstTime:(BOOL)ok;
+ (void) setFirstInsuranceRequest:(BOOL)ok;
+ (BOOL) IsFirstTime;
+ (void) setIsRedus:(BOOL)ok;
+ (BOOL) isRedus;
+ (void) setIsFirstCalc:(BOOL)ok;
+ (BOOL) isFirstCalc;



//+ (void) setSyncronized:(BOOL)ok;
//+ (BOOL) IsSyncronized;
+ (BOOL) IsFirstInsuranceRequest;
+ (void) setOperatorMobil : (NSString *) op;
+ (NSString *) getOperator;
+ (void) setPushToken : (NSString *) pt;
+ (NSString *) getPushToken;
+ (void) setUserName : (NSString *) un;
+ (NSString *) getUserName;;
+ (void) setPassword : (NSString *) pas;
+ (NSString *) getPassword;
+ (void) setLanguage : (NSString *) lang;
+ (NSString *) getLanguage;


@end
