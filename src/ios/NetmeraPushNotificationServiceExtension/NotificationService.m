#import "NotificationService.h"

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent *contentToDeliver))contentHandler {
    [super didReceiveNotificationRequest:request withContentHandler:contentHandler];
}

- (void)serviceExtensionTimeWillExpire {
    [super serviceExtensionTimeWillExpire];
}

@end