//
//  YTOUtils.m
//  i-asigurare
//
//  Created by Andi Aparaschivei on 7/18/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
//

#import "YTOUtils.h"
#import "KeyValueItem.h"
#import "YTOObiectAsigurat.h"
#import "YTOAppDelegate.h"
#import "YTOAutovehicul.h"
#import <CommonCrypto/CommonDigest.h> // Need to import for CC_MD5 access


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

+ (void) deleteWhenLogOff;
{
    [YTOObiectAsigurat deleteAllRecordsFromObiectAsigurat];
    YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
//    for (int ii = 0; ii<delegate.Masini.count; ii++) {
//        YTOAutovehicul * masina = [delegate.Masini objectAtIndex:ii];
//        if ([masina.savedInCont isEqualToString:@"da"])
//            [masina deleteAutovehicul2];
//    }
    [delegate.Alerte removeAllObjects];
    [delegate.Masini removeAllObjects];
    [delegate.Persoane removeAllObjects];
    [delegate.Locuinte removeAllObjects];
    [delegate setAlerteBadge];
   // [YTO]
}

+ (void) setCellFormularStyle:(UITableViewCell *) cell 
{
    UILabel * lblCell = (UILabel *)[cell viewWithTag:1];
    lblCell.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblCell.font = [UIFont fontWithName:@"Arial" size:14];
    
    if ([[cell viewWithTag:3] isKindOfClass:[UILabel class]])
    {
        UILabel * lblCell2 = (UILabel *)[cell viewWithTag:3];
        if (lblCell2) 
        {
            lblCell2.textColor = [YTOUtils colorFromHexString:ColorTitlu];
            lblCell2.font = [UIFont fontWithName:@"Arial" size:14];
        }
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

+ (NSDate *) getDateFromString:(NSString *) data withFormat:(NSString *)format
{
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:format];
    return [df dateFromString:data];
}

+ (UIImage *) getImageForValue:(NSString *)value;
{
    return [UIImage imageNamed:value];
}

+ (NSString *) getVarsta:(NSString *)cnp
{
    if (cnp.length < 3) return 0;
    NSString * c0 = [NSString stringWithFormat:@"%c",[cnp characterAtIndex:0]];
    NSString * c1;
    if ([c0 isEqualToString:@"1"] || [c0 isEqualToString:@"2"])
        c1 = [NSString stringWithFormat:@"19%c%c",[cnp characterAtIndex:1],[cnp characterAtIndex:2]];
    else
        c1 = [NSString stringWithFormat:@"20%c%c",[cnp characterAtIndex:1],[cnp characterAtIndex:2]];
    //NSString * c2 = [NSString stringWithFormat:@"%c%c",[cnp characterAtIndex:3],[cnp characterAtIndex:4]];
    int an_cnp = [c1 intValue];
    
    //int luna_cnp = [c2 intValue];
    
    NSDate * azi = [NSDate date];
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:azi];
    int an_curent = [dateComponents year];
    
    int varsta = an_curent - an_cnp;
    
    return [NSString stringWithFormat:@"%d", varsta];
    
}

+ (NSString *) getAnMinimPermis:(NSString *)cnp
{
    //NSString * c1 = [NSString stringWithFormat:@"19%c%c",[cnp characterAtIndex:1],[cnp characterAtIndex:2]];
    //NSString * c2 = [NSString stringWithFormat:@"%c%c",[cnp characterAtIndex:3],[cnp characterAtIndex:4]];
    
    NSString * c0 = [NSString stringWithFormat:@"%c",[cnp characterAtIndex:0]];
    NSString * c1;
    if ([c0 isEqualToString:@"1"] || [c0 isEqualToString:@"2"] || [c0 isEqualToString:@"7"] || [c0 isEqualToString:@"8"] || [c0 isEqualToString:@"9"])
        c1 = [NSString stringWithFormat:@"19%c%c",[cnp characterAtIndex:1],[cnp characterAtIndex:2]];
    else
        c1 = [NSString stringWithFormat:@"20%c%c",[cnp characterAtIndex:1],[cnp characterAtIndex:2]];
    
    int an_cnp = [c1 intValue];
    
    
    //int luna_cnp = [c2 intValue];
    
    NSDate * azi = [NSDate date];
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:azi];
    int an_curent = [dateComponents year];
    
    if (an_cnp > an_curent) an_cnp = an_curent;
    
    int varsta = an_curent - an_cnp;
    
    return [NSString stringWithFormat:@"%d", (an_curent - varsta + 18)];
    
}

+ (int) getAnCurent
{
    NSDate * azi = [NSDate date];
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:azi];
    return [dateComponents year];
}

+ (int) getAnFromDate:(NSDate *)date
{
    NSDate * data = date;
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:data];
    return [components year];
}

+ (NSString *) append:(id) first, ...
{
    NSString * result = @"";
    id eachArg;
    va_list alist;
    if(first)
    {
        result = [result stringByAppendingString:first];
        va_start(alist, first);
        while ((eachArg = va_arg(alist, id))) 
            result = [result stringByAppendingString:eachArg];
        va_end(alist);
    }
    return result;
}

+ (UIImage*) drawText:(NSString*) text inImage:(UIImage*)  image atPoint:(CGPoint)   point drawText2 : (NSString *) text2  atPoint2 :(CGPoint) point2
{
    
    UIFont *font = [UIFont boldSystemFontOfSize:35];
    UIFont *font2 = [UIFont boldSystemFontOfSize:35];
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    CGRect rect = CGRectMake(point.x, point.y, image.size.width, image.size.height);
    CGRect rect2 = CGRectMake(point2.x, point2.y, image.size.width, image.size.height);
    [[UIColor whiteColor] set];
    [text drawInRect:CGRectIntegral(rect) withFont:font];
    [[UIColor blackColor] set];
    [text2 drawInRect:rect2 withFont:font2];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (NSDate *) getDataSfarsitPolita:(NSDate *)dataInceput andDurataInLuni:(int)durata
{
    NSDateComponents* dateComponents = [[NSDateComponents alloc]init];
    [dateComponents setMonth:durata];
    [dateComponents setDay:-1];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    return [calendar dateByAddingComponents:dateComponents toDate:dataInceput options:0];
}

+ (NSDate *) getDataSfarsitPolita:(NSDate *)dataInceput andDurataInZile:(int)durata
{
    NSDateComponents* dateComponents = [[NSDateComponents alloc]init];
    [dateComponents setDay:(durata - 1)];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    return [calendar dateByAddingComponents:dateComponents toDate:dataInceput options:0];
}

+ (NSDate *) getDataMinimaInceperePolita
{
    NSDate * _DataInceput;
    NSDate * acum = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSHourCalendarUnit fromDate:acum];
    int ora = components.hour;
    
    if (ora >= 20) {
        _DataInceput = [[NSDate date] dateByAddingTimeInterval:86400*2];
        trecutDeOra = YES;
    }
    else
        _DataInceput = [[NSDate date] dateByAddingTimeInterval:86400];

    return _DataInceput;
}

+ (UIImage *)scaleImage:(UIImage *) image maxWidth:(float) maxWidth maxHeight:(float) maxHeight
{
    CGImageRef imgRef = image.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    if (width <= maxWidth && height <= maxHeight)
    {
        return image;
    }
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    
    if (width > maxWidth || height > maxHeight)
    {
        CGFloat ratio = width/height;
        
        if (ratio > 1)
        {
            bounds.size.width = maxWidth;
            bounds.size.height = bounds.size.width / ratio;
        }
        else
        {
            bounds.size.height = maxHeight;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, scaleRatio, -scaleRatio);
    CGContextTranslateCTM(context, 0, -height);
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
    
}

+ (int) getKeyList:(NSMutableArray *)list forValue:(NSString *)value
{
    for (int i=0; i<list.count; i++) {
        KeyValueItem * item = (KeyValueItem *)[list objectAtIndex:i];
        if ([item.value isEqualToString:value])
            return item.key;
    }
    
    return 0;
}
+ (NSString *) getValueList:(NSMutableArray *)list forKey:(int)value
{
    for (int i=0; i<list.count; i++) {
        KeyValueItem * item = (KeyValueItem *)[list objectAtIndex:i];
        if (item.key == value)
            return item.value;
    }
    
    return @"";
}

+ (NSMutableArray *) GETCompaniiAsigurare
{
    NSMutableArray * list;
    KeyValueItem * c1 = [[KeyValueItem alloc] init];
    c1.parentKey = 1;
    c1.key = 0;
    c1.value = @"Allianz";
    
    KeyValueItem * c2 = [[KeyValueItem alloc] init];
    c2.parentKey = 1;
    c2.key = 1;
    c2.value = @"Asirom";
    
    KeyValueItem * c3 = [[KeyValueItem alloc] init];
    c3.parentKey = 1;
    c3.key = 2;
    c3.value = @"Astra";
    
    KeyValueItem * c4 = [[KeyValueItem alloc] init];
    c4.parentKey = 1;
    c4.key = 3;
    c4.value = @"Carpatica";
    
    KeyValueItem * c5 = [[KeyValueItem alloc] init];
    c5.parentKey = 1;
    c5.key = 4;
    c5.value = @"Euroins";
    
    KeyValueItem * c6 = [[KeyValueItem alloc] init];
    c6.parentKey = 1;
    c6.key = 5;
    c6.value = @"Generali";
    
    KeyValueItem * c7 = [[KeyValueItem alloc] init];
    c7.parentKey = 1;
    c7.key = 6;
    c7.value = @"Groupama";
    
    KeyValueItem * c8 = [[KeyValueItem alloc] init];
    c8.parentKey = 1;
    c8.key = 7;
    c8.value = @"Omniasig";
    
    KeyValueItem * c9 = [[KeyValueItem alloc] init];
    c9.parentKey = 1;
    c9.key = 8;
    c9.value = @"Uniqa";
    
    KeyValueItem * c10 = [[KeyValueItem alloc] init];
    c10.parentKey = 1;
    c10.key = 9;
    c10.value = @"Neasigurat";
    
    
    list  = [[NSMutableArray alloc] initWithObjects:c1,c2,c3,c4,c5,c6,c7,c8,c9,c10 ,nil];
    return list;
}

+ (NSMutableArray *) GETTipAlertaList
{
    NSMutableArray * list;
    
    KeyValueItem * c1 = [[KeyValueItem alloc] init];
    c1.parentKey = 1;
    c1.key = 1;
    c1.value = @"RCA";
    
    KeyValueItem * c2 = [[KeyValueItem alloc] init];
    c2.parentKey = 1;
    c2.key = 2;
    c2.value = @"ITP";
    
    KeyValueItem * c3 = [[KeyValueItem alloc] init];
    c3.parentKey = 1;
    c3.key = 3;
    c3.value = @"Rovinieta";
    
    KeyValueItem * c4 = [[KeyValueItem alloc] init];
    c4.parentKey = 1;
    c4.key = 5;
    c4.value = @"CASCO";
    
    KeyValueItem * c5 = [[KeyValueItem alloc] init];
    c5.parentKey = 1;
    c5.key = 6;
    c5.value = @"Locuinta";
    
    KeyValueItem * c6 = [[KeyValueItem alloc] init];
    c6.parentKey = 1;
    c6.key = 7;
    c6.value = @"Rata CASCO";
    
    KeyValueItem * c7 = [[KeyValueItem alloc] init];
    c7.parentKey = 1;
    c7.key = 8;
    c7.value = @"Rata Locuinta";
    
    list = [[NSMutableArray alloc] initWithObjects:c1,c2,c3,c4,c5,c6,c7, nil];
    return  list;
}

+ (NSString *) getHTMLWithStyle:(NSString *)html
{
    NSString * htmlPage = [NSString stringWithFormat:@"<!DOCTYPE html PUBLIC \"-//WAPFORUM//DTD XHTML Mobile 1.0//EN\" \"http://www.wapforum.org/DTD/xhtml-mobile10.dtd\"><html><head></head><body style='font-family:Arial; font-size:.9em; color:#464646;'>%@</body></html>", html];
    return htmlPage;
}

+ (NSString *) reverseString:(NSString *)s
{
    NSMutableArray * tempArray = [[NSMutableArray alloc] init];
    for (int i=0; i<[s length]; i++) {
        [tempArray addObject:[NSString stringWithFormat:@"%c", [s characterAtIndex:i]]];
    }
    
    tempArray = [NSMutableArray arrayWithArray:[[tempArray reverseObjectEnumerator] allObjects]];
    NSString * reversed;
    
    for (int j=0; j<tempArray.count; j++) {
        reversed = [NSString stringWithFormat:@"%@%@", (reversed == nil ? @"" : reversed), [tempArray objectAtIndex:j]];
    }
    
    return reversed;
}

+ (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}


// VALDARI
#pragma VALIDARI

+ (BOOL) validateEmail: (NSString *) email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    //	return 0;
    return [emailTest evaluateWithObject:email];
}

+ (BOOL) validateCNP: (NSString* ) cnp {
	BOOL isValid = YES;

	if (cnp.length != 13)
		isValid = NO;
    
//	else {
//		NSString * s = @"279146358279";
//		int _suma = 0;
//		for (int i=0; i<12; i++) {
//			NSString * a = [NSString stringWithFormat:@"%c",[cnp characterAtIndex:i]];
//			NSString * b = [NSString stringWithFormat:@"%c",[s characterAtIndex:i]];
//			_suma += [a integerValue] * [b integerValue];
//			
//		}
//		NSString * c12 = [NSString stringWithFormat:@"%c",[cnp characterAtIndex:12]];
//		int rest = _suma % 11;
//		if (!((rest < 10) && ([c12 integerValue] == rest)) ||
//            ((rest == 10) && ([c12 integerValue] == 1)))
//			isValid = NO;
//	}
    
	return isValid;
}

+ (BOOL) validateCUI: (NSString* ) cui
{
    BOOL isValid = YES;
    
    NSString * constanta = @"235712357";
    if (cui.length > 10) isValid = NO;
    else
    {
        int suma = 0;
        cui = [self reverseString:cui];
        
        for (int i = 1; i < cui.length; i++) {
            NSString * a = [NSString stringWithFormat:@"%c", [cui characterAtIndex:i]];
            NSString * b = [NSString stringWithFormat:@"%c", [constanta characterAtIndex:i-1]];
            NSLog(@"a=%@, b=%@", a, b);            
            suma = suma +  [a intValue] * [b intValue];
        }
        int rest = (suma * 10) % 11;
        NSString * c0 = [NSString stringWithFormat:@"%c",[cui characterAtIndex:0]];
        
        if (rest == [c0 intValue] || (rest == 10 && [c0 intValue] == 0))
            isValid = YES;
        else
            isValid = NO;
    }
    
    return isValid;
}

+ (BOOL) validateSasiu:(NSString *) sasiu
{
    NSString *regex = @"(([a-h,A-H,j-n,J-N,p-z,P-Z,0-9]{9})([a-h,A-H,j-n,J-N,p,P,r-t,R-T,v-z,V-Z,0-9])([a-h,A-H,j-n,J-N,p-z,P-Z,0-9])(\\d{6}))$";

    NSPredicate *serieSasiu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    //	return 0;
    return [serieSasiu evaluateWithObject:sasiu];
}

+ (BOOL) validateCIV:(NSString *) civ
{
    NSString *regex = @"(([a-h,A-H,j-n,J-N,p-z,P-Z]{1})(\\d{6}))$";
    NSString *regex2 = @"(([a-h,A-H,j-n,J-N,p-z,P-Z]{1})(\\d{7}))$";
    
    NSPredicate *serieCiv = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    NSPredicate *serieCiv2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    //	return 0;
    return [serieCiv evaluateWithObject:civ] || [serieCiv2 evaluateWithObject:civ];
}

+ (NSString *) replacePossibleWrongEmailAddresses:(NSString *) email
{
    NSMutableArray * listGmail = [[NSMutableArray alloc] initWithObjects:@"@gmail.coml",
                                  @"@gmal.com", @"@gmail.cim", @"@gmail.col", @"@gmail.con",@"@gmai.com", @"@gma.com", @"@gmail.vom", nil];
    
    NSMutableArray * listYahoo = [[NSMutableArray alloc] initWithObjects:@"@yahoo.con",
                                  @"@yagoo.com", @"@yaahoo.com", @"@yahoo.cim", @"@yah00.com", @"@yahoo.rom", @"@yakoo.com",
                                  @"@yahoo.cm", @"@yahoo..com", @"@yah.com", @"@yahu.com", @"@yaho.coj", @"@yaoo.com", @"@yahoo.om", @"@yhoo.com",
                                  @"@ya.com", @"@yaho.com", @"@yahho.com", @"@yahoo.vom", @"@yahop.com", @"@yahh.com", @"@yah00.vcom", @"@yahol.com", nil];
    
    NSString * s = [email lowercaseString];
    
    for (int i=0; i<listGmail.count; i++) {
        NSRange aRange = [email rangeOfString:[listGmail objectAtIndex:i]];
        if (aRange.location != NSNotFound)
        {
            s = [s stringByReplacingOccurrencesOfString:[listGmail objectAtIndex:i] withString:@"@gmail.com"];
            return s;
        }
    }
    
    for (int i=0; i<listYahoo.count; i++) {
        NSRange aRange = [email rangeOfString:[listYahoo objectAtIndex:i]];
        if (aRange.location != NSNotFound)
        {
            s = [s stringByReplacingOccurrencesOfString:[listYahoo objectAtIndex:i] withString:@"@yahoo.com"];
            return s;
        }
    }
    
    return s;
}

+ (NSString *) replacePossibleWrongSerieSasiu:(NSString *)serie
{
    NSString * s = serie;
    s = [s stringByReplacingOccurrencesOfString:@"O" withString:@"0"];
    s = [s stringByReplacingOccurrencesOfString:@"I" withString:@"1"];
    return s;
}

+ (void) rightImageVodafone :(UINavigationItem *) navBar
{
    UIButton *vdf = [UIButton buttonWithType:UIButtonTypeCustom];
    [vdf setFrame:CGRectMake(10, 0, 50, 44)];
    [vdf setImage:[UIImage imageNamed:@"powered-by-vdf.png"] forState:UIControlStateNormal];
    [vdf setImage:[UIImage imageNamed:@"powered-by-vdf.png"] forState:UIControlStateHighlighted];
    vdf.contentEdgeInsets = (UIEdgeInsets){.right=-10};
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithCustomView:vdf];
    
    navBar.rightBarButtonItem = btn;
    
}


+ (BOOL) isWeekend
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    int weekday = [comps weekday];
    NSLog(@"%d",weekday);
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSHourCalendarUnit fromDate:now];
    NSLog(@"%d",[components hour]);
    int hour = [components hour];
    if (weekday == 7 || weekday == 1)
        return YES;
    if (weekday == 6 && hour >= 16)
        return YES;
    if (weekday == 2 && hour < 6)
        return YES;
    return NO;
}

@end
