//
//  YTOUserDefaults.h
//  i-asigurare
//
//  Created by Administrator on 11/21/12.
//
//

#import <Foundation/Foundation.h>

@interface YTOUserDefaults : NSObject
{
    
}

+ (void) setFirstTime:(BOOL)ok;
+ (BOOL) IsFirstTime;

+ (void) setSyncronized:(BOOL)ok;
+ (BOOL) IsSyncronized;
@end
