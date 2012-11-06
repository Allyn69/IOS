//
//  YTOWrapper.h
//  i-asigurare
//
//  Created by Administrator on 10/10/12.
//
//

#import <Foundation/Foundation.h>
#import "Setari.h"
#import "YTOPersoana.h"
#import "YTOAutovehicul.h"

@interface YTOWrapper : NSObject

+ (void) savePersonFromSetari:(Setari *)setari;
+ (void) saveAutoFromSetari:(Setari *)setari;

@end
