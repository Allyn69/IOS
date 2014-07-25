//
//  AES.m
//  i-asigurare
//
//  Created by Stern Edi on 17/01/14.
//
//

#import "NSData+AES.h"

@implementation NSData (AES)

- (NSData*)AES256EncryptWithKey:(NSString*)key {
    char keyPtr[kCCKeySizeAES256];
    
    //[key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSASCIIStringEncoding];
    [key cStringUsingEncoding:NSASCIIStringEncoding];
    
    NSString *iv = @"i-Tom Solutions1";
    char ivPtr[kCCKeySizeAES256];
    
    [iv cStringUsingEncoding:NSASCIIStringEncoding];
    
    NSUInteger dataLength = [self length];
    
    size_t bufferSize           = dataLength + kCCBlockSizeAES128;
    void* buffer                = malloc(bufferSize);
    
    size_t numBytesEncrypted    = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionECBMode + kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES128,
                                          ivPtr /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess)
    {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}


@end

