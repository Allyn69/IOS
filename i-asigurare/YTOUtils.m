//
//  YTOUtils.m
//  i-asigurare
//
//  Created by Administrator on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YTOUtils.h"

@implementation YTOUtils

+ (NSString *)GenerateUUID
{
	CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}

+ (UIColor *) colorFromHexString:(NSString *)hexString {
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@", 
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (void) setCellFormularStyle:(UITableViewCell *) cell 
{
    UILabel * lblCell = (UILabel *)[cell viewWithTag:1];
    lblCell.textColor = [YTOUtils colorFromHexString:@"1c8387"];
    lblCell.font = [UIFont fontWithName:@"Myriad Pro" size:16];
    
    UILabel * lblCell2 = (UILabel *)[cell viewWithTag:3];
    if (lblCell2) 
    {
        lblCell2.textColor = [YTOUtils colorFromHexString:@"1c8387"];
        lblCell2.font = [UIFont fontWithName:@"Myriad Pro" size:16];
    }
    cell.backgroundColor = [UIColor clearColor]; 
    cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
}

+ (NSString *) formatDate:(NSDate *)date withFormat:(NSString *)format 
{
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:format];
    return [df stringFromDate:date];
}

@end
