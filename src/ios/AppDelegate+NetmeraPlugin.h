#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#import <Cordova/CDVViewController.h>

@interface AppDelegate (NetmeraPlugin)

+ (NSString*)getAPNSToken;
+ (void)setInitialPushPayload:(NSData*)payload;
+ (NSData*)getInitialPushPayload;

@end
