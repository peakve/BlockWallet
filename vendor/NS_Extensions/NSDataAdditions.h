#import <Foundation/Foundation.h>

@interface NSData (XMPPStreamAdditions)

- (NSData *)md5Digest;

- (NSData *)sha1Digest;

- (NSData *)base64Decoded;

- (NSString *)hexStringValue;

- (NSString *)base64Encoded;

@end
