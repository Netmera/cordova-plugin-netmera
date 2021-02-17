#import <Cordova/CDVPlugin.h>

@interface NetmeraPlugin : CDVPlugin {
  // Member variables go here.
}

@property (nonatomic, copy) NSString *notificationCallbackId;
@property (nonatomic, copy) NSString *notificationClickCallbackId;
@property (nonatomic, copy) NSString *notificationButtonClickCallbackId;
@property (nonatomic, copy) NSString *openUrlCallbackId;

+ (NetmeraPlugin *) netmeraPlugin;
- (void)start:(CDVInvokedUrlCommand*)command;
- (void)requestPushNotificationAuthorization:(CDVInvokedUrlCommand*)command;
- (void)subscribePushNotification:(CDVInvokedUrlCommand*)command;
- (void)subscribeOpenUrl:(CDVInvokedUrlCommand*)command;
- (void)subscribePushClick:(CDVInvokedUrlCommand*)command;
- (void)subscribePushButtonClick:(CDVInvokedUrlCommand*)command;
- (void)sendNotification:(NSDictionary*)userInfo;
- (void)sendNotificationClick:(NSDictionary*)userInfo;
- (void)sendNotificationButtonClick:(NSDictionary*)userInfo;
- (void)sendOpenUrl:(NSString*)openUrl;
- (void)sendEvent:(CDVInvokedUrlCommand*)command;
- (void)fetchInboxUsingFilter:(CDVInvokedUrlCommand*)command;
- (void)fetchNextPage:(CDVInvokedUrlCommand*)command;
- (void)countForStatus:(CDVInvokedUrlCommand*)command;
- (void)updatePushStatus:(CDVInvokedUrlCommand*)command;
- (void)updateUser:(CDVInvokedUrlCommand*)command;
- (void)requestLocationAuthorization:(CDVInvokedUrlCommand*)command;
@end
