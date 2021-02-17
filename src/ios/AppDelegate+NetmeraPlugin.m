//
//  AppDelegate+NetmeraPlugin.m
//  MyApp
//
//  Created by Enis Terzioğlu on 4.01.2021.
//

#import "AppDelegate+NetmeraPlugin.h"
#import "NetmeraPlugin.h"
#import <objc/runtime.h>
#import <Foundation/Foundation.h>
#import <Netmera/Netmera.h>

@import UserNotifications;

@implementation AppDelegate (NetmeraPlugin)


static NSString *apnsToken;
static NSData *initialPushPayload;
static NSData *lastPush;

//Method swizzling
+ (void)load {
    Method original =  class_getInstanceMethod(self, @selector(application:didFinishLaunchingWithOptions:));
    Method custom =    class_getInstanceMethod(self, @selector(application:customDidFinishLaunchingWithOptions:));
    method_exchangeImplementations(original, custom);
}

- (BOOL)application:(UIApplication *)application customDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self application:application customDidFinishLaunchingWithOptions:launchOptions];
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    [Netmera start];
    [Netmera setPushDelegate:self];
      
    // For On-premise setup
    // [Netmera setBaseURL:@"YOUR PANEL DOMAIN URL"];
      
    // This can be called later, see documentation for details
    //[Netmera setAPIKey:@"QBT4dSEEyRKGPVLbZIazzSnz0D1KJZBQDk_SIUSBonc15Aa2t9HUNg"];
    //[Netmera setLogLevel:(NetmeraLogLevelDebug)];
    
    //[Netmera requestPushNotificationAuthorizationForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound];
    
    //[application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound |UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    //[application registerForRemoteNotifications];
    return YES;
}

+ (NSString*)getAPNSToken {
    return apnsToken;
}

// Delegation methods
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken
{
    const void *devTokenBytes = [devToken bytes];
    NSLog(@"Registration. Token: %@", devToken);
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    NSLog(@"Error in registration. Error: %@", err);
}


//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
//{
//    
//    
//    //NSDictionary *mutableUserInfo = [userInfo mutableCopy];
//        // Print full message.
//      //  NSLog(@"%@", mutableUserInfo);
//        completionHandler(UIBackgroundFetchResultNewData);
//        //[NetmeraPlugin.netmeraPlugin sendNotification:mutableUserInfo];
//}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    NSDictionary *mutableUserInfo = notification.request.content.userInfo;
    [NetmeraPlugin.netmeraPlugin sendNotification:mutableUserInfo];
    completionHandler(UNNotificationPresentationOptionAlert);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(nonnull UNNotificationResponse *)response withCompletionHandler:(nonnull void (^)(void))completionHandler
{
    NSDictionary *mutableUserInfo = response.notification.request.content.userInfo;
    NSError *error;
    lastPush = [NSJSONSerialization dataWithJSONObject:mutableUserInfo options:0 error:&error];
    [AppDelegate setInitialPushPayload:lastPush];
    [NetmeraPlugin.netmeraPlugin sendNotificationClick:mutableUserInfo];
    completionHandler();
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    
    NSLog(@"Hello first openUrl %@", url.absoluteString);
    [NetmeraPlugin.netmeraPlugin sendOpenUrl:url.absoluteString];
    
    return true;
}

- (BOOL)shouldHandleOpenURL:(NSURL *)url forPushObject:(NetmeraPushObject *)object {
//Deeplink is checked(valid or invalid)
  return YES;
}

- (void)handleOpenURL:(NSURL *)url forPushObject:(NetmeraPushObject *)object {
//Control and redirect method
  NSLog(@"handleOpenURL: %@ forPushObject %@", url, object);
}

- (BOOL)application:(UIApplication *)application
continueUserActivity:(NSUserActivity *)userActivity
  restorationHandler:(void (^)(NSArray *restorableObjects))restorationHandler {
  if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
    NSURL *url = userActivity.webpageURL;
    [NetmeraPlugin.netmeraPlugin sendOpenUrl:url.absoluteString];
  }
  return YES;
}

+ (void)setInitialPushPayload:(NSData*)payload {
    if(initialPushPayload == nil) {
        initialPushPayload = payload;
    }
}

+ (NSData*)getInitialPushPayload {
    return initialPushPayload;
}

@end
