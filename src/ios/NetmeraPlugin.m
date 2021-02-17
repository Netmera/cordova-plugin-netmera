/********* NetmeraPlugin.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import "NetmeraPlugin.h"
#import <Netmera/Netmera.h>
#import <objc/runtime.h>
#import "FNetmeraUser.h"
#import "FNetmeraEvent.h"
#import "AppDelegate+NetmeraPlugin.h"

#include <sys/types.h>
#include <sys/sysctl.h>
#import <UserNotifications/UserNotifications.h>


@implementation NetmeraPlugin

NetmeraInbox *netmeraInbox = nil;
CDVInvokedUrlCommand *inboxCommandId = nil;
@synthesize notificationCallbackId;
@synthesize notificationClickCallbackId;
@synthesize notificationButtonClickCallbackId;
@synthesize openUrlCallbackId;

static NetmeraPlugin *netmeraPlugin;

+ (NetmeraPlugin *) netmeraPlugin {
    return netmeraPlugin;
}

- (void)pluginInitialize {
    NSLog(@"Starting Netmera plugin");
    netmeraPlugin = self;
}

- (void)start:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    //NSString* key = [command.arguments objectAtIndex:0];
    //NSString* baseUrl = [command.arguments objectAtIndex:2];
    
    NSString *key = [self.commandDelegate.settings objectForKey:[@"NetmeraKey" lowercaseString]];
    NSString *baseUrl = [self.commandDelegate.settings objectForKey:[@"NetmeraBaseUrl" lowercaseString]];
    NSString *appGroupName = [self.commandDelegate.settings objectForKey:[@"AppGroupName" lowercaseString]];
    
    
    if (baseUrl != nil) {
        [Netmera setBaseURL:baseUrl];
    }
    
    if (key != nil) {
        [Netmera setAPIKey:key];
        [Netmera setLogLevel:(NetmeraLogLevelDebug)];
    }
    
    if (appGroupName != nil) {
        [Netmera setAppGroupName:appGroupName];
    }
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:true];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)requestPushNotificationAuthorization:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    [Netmera requestPushNotificationAuthorizationForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:true];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)subscribePushNotification:(CDVInvokedUrlCommand*)command
{
    self.notificationCallbackId = command.callbackId;
}

- (void)subscribeOpenUrl:(CDVInvokedUrlCommand*)command
{
    self.openUrlCallbackId = command.callbackId;
}

- (void)subscribePushClick:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate runInBackground:^{
        NSData* dataPayload = [AppDelegate getInitialPushPayload];
            if (dataPayload == nil) {
                self.notificationClickCallbackId = command.callbackId;
                return;
            }
            NSString *strISOLatin = [[NSString alloc] initWithData:dataPayload encoding:NSISOLatin1StringEncoding];
            NSData *dataPayloadUTF8 = [strISOLatin dataUsingEncoding:NSUTF8StringEncoding];
            NSError* error = nil;
            NSDictionary *payloadDictionary = [NSJSONSerialization JSONObjectWithData:dataPayloadUTF8 options:0 error:&error];
            if (error) {
                NSString* errorMessage = [NSString stringWithFormat:@"%@ => '%@'", [error localizedDescription], strISOLatin];
                NSLog(@"getInitialPushPayload error: %@", errorMessage);
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_JSON_EXCEPTION messageAsString:errorMessage];
                [pluginResult setKeepCallbackAsBool:YES];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                return;
            }
            NSLog(@"getInitialPushPayload value: %@", payloadDictionary);
            NetmeraPushObject *pushObject = [[NetmeraPushObject alloc] initWithDictionary:payloadDictionary];
            NSDictionary* response = [self mapPushObject:pushObject];
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:response];
            [pluginResult setKeepCallbackAsBool:YES];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    self.notificationClickCallbackId = command.callbackId;
}

- (void)subscribePushButtonClick:(CDVInvokedUrlCommand*)command {
    self.notificationButtonClickCallbackId = command.callbackId;
}

- (void)sendNotification:(NSDictionary *)userInfo {
    if (self.notificationCallbackId != nil) {
        NetmeraPushObject *pushObject = [[NetmeraPushObject alloc] initWithDictionary:userInfo];
        
        NSDictionary* response = [self mapPushObject:pushObject];
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:response];
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.notificationCallbackId];
    } else {
        //        if (!self.notificationStack) {
        //            self.notificationStack = [[NSMutableArray alloc] init];
        //        }
        //
        //        // stack notifications until a callback has been registered
        //        [self.notificationStack addObject:userInfo];
        //
        //        if ([self.notificationStack count] >= kNotificationStackSize) {
        //            [self.notificationStack removeLastObject];
        //        }
    }
}

- (void)sendNotificationClick:(NSDictionary *)userInfo {
    if (self.notificationClickCallbackId != nil) {
        NetmeraPushObject *pushObject = [[NetmeraPushObject alloc] initWithDictionary:userInfo];
        
        NSDictionary* response = [self mapPushObject:pushObject];
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:response];
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.notificationClickCallbackId];
    } else {
        //        if (!self.notificationStack) {
        //            self.notificationStack = [[NSMutableArray alloc] init];
        //        }
        //
        //        // stack notifications until a callback has been registered
        //        [self.notificationStack addObject:userInfo];
        //
        //        if ([self.notificationStack count] >= kNotificationStackSize) {
        //            [self.notificationStack removeLastObject];
        //        }
    }
}

- (void)sendNotificationButtonClick:(NSDictionary *)userInfo {
    if (self.notificationButtonClickCallbackId != nil) {
        NetmeraPushObject *pushObject = [[NetmeraPushObject alloc] initWithDictionary:userInfo];
        
        NSDictionary* response = [self mapPushObject:pushObject];
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:response];
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.notificationButtonClickCallbackId];
    } else {
        //        if (!self.notificationStack) {
        //            self.notificationStack = [[NSMutableArray alloc] init];
        //        }
        //
        //        // stack notifications until a callback has been registered
        //        [self.notificationStack addObject:userInfo];
        //
        //        if ([self.notificationStack count] >= kNotificationStackSize) {
        //            [self.notificationStack removeLastObject];
        //        }
    }
}

- (void)sendOpenUrl:(NSString*)openUrl
{
    if (self.openUrlCallbackId != nil) {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:openUrl];
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.openUrlCallbackId];
    }
}


- (void)sendEvent:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSMutableDictionary* mutableEventDictionary = [command.arguments objectAtIndex:0];
    NSArray *keysForNullValues = [mutableEventDictionary allKeysForObject:[NSNull null]];
    [mutableEventDictionary removeObjectsForKeys:keysForNullValues];
    FNetmeraEvent *event = [FNetmeraEvent event];
    event.netmeraEventKey = mutableEventDictionary[@"code"];
    [mutableEventDictionary removeObjectForKey:@"code"];
    event.eventParameters = mutableEventDictionary;
    [Netmera sendEvent:event];
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:true];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    
}

- (void)fetchInboxUsingFilter:(CDVInvokedUrlCommand*)command
{
    NSDictionary* userFilter = [command.arguments objectAtIndex:0];
    inboxCommandId = command;
    
    NetmeraInboxFilter *filter = [[NetmeraInboxFilter alloc] init];
    filter.status = [[userFilter valueForKey:@"status"] intValue];
    filter.pageSize = [[userFilter valueForKey:@"pageSize"] intValue];
    filter.categories = [userFilter valueForKey:@"categories"];
    filter.shouldIncludeExpiredObjects = [userFilter valueForKey:@"shouldIncludeExpiredObjects"];
    
    [Netmera fetchInboxUsingFilter:filter
                        completion:^(NetmeraInbox *inbox, NSError *error) {
        CDVPluginResult* pluginResult = nil;
        if(error) {
            NSLog(@"Error : %@", [error debugDescription]);
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        }
        else {
            netmeraInbox = inbox;
            
            NSDictionary *pluginResponse = [self getInboxList:inbox];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:pluginResponse];
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (NSDictionary*)getInboxList:(NetmeraInbox*)inbox
{
   
    
    NSMutableArray *inboxList = [NSMutableArray array];
    for(NetmeraPushObject *pushObject in inbox.objects)
    {
        NSDictionary* dict = [self mapPushObject:pushObject];
        [inboxList addObject:dict];
    }
    NSDictionary *pluginResponse = @{
        @"hasNextPage": @(inbox.hasNextPage),
        @"inbox": inboxList
    };
    
    return pluginResponse;
}

-(NSDictionary*)mapPushObject:(NetmeraPushObject*)pushObject
{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"pushId"] = [pushObject pushId];
    data[@"pushInstanceId"] = [pushObject pushInstanceId];
    data[@"pushType"] = [NSNumber numberWithInteger:[pushObject pushType]];
    data[@"title"] = [[pushObject alert] title];
    data[@"subtitle"] = [[pushObject alert] subtitle];
    data[@"body"] = [[pushObject alert] body];
    data[@"inboxStatus"] = [NSNumber numberWithInteger:[pushObject inboxStatus]];
    if(pushObject.sendDate){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        data[@"sendDate"] = [dateFormatter stringFromDate:pushObject.sendDate];
    }
    data[@"deeplinkUrl"] = [pushObject action].deeplinkURLString;

    
    return data;
}

- (void)fetchNextPage:(CDVInvokedUrlCommand*)command
{
    [netmeraInbox fetchNextPageWithCompletionBlock:^(NSError *error) {
        CDVPluginResult* pluginResult = nil;
        if(error) {
            NSLog(@"Error : %@", [error debugDescription]);
        }
        else {
            NSDictionary *pluginResponse = [self getInboxList:netmeraInbox];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:pluginResponse];
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)countForStatus:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSNumber* countType = [command.arguments objectAtIndex:0];
    int countInt = [countType intValue];
    NSUInteger numberOfValue = 0;
    numberOfValue = [netmeraInbox countForStatus:countInt];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:(int) numberOfValue];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)updatePushStatus:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    int index = [[command.arguments objectAtIndex:0] intValue];
    int length = [[command.arguments objectAtIndex:1] intValue];
    int status = [[command.arguments objectAtIndex:2] intValue];
    
    NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, length)];
    NSArray *objectList = [netmeraInbox.objects objectsAtIndexes:set];
    [netmeraInbox updateStatus:status
                forPushObjects:objectList
                    completion:^(NSError *error) {
        if(error) {
            NSLog(@"Error : %@", [error debugDescription]);
        } else {
            NSLog(@"OK");
        }
    }];
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:true];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)updateUser:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    
    NSMutableDictionary *userMutableDictionary = [command.arguments objectAtIndex:0];
    NSArray *keysForNullValues = [userMutableDictionary allKeysForObject:[NSNull null]];
    [userMutableDictionary removeObjectsForKeys:keysForNullValues];
    FNetmeraUser *user = [[FNetmeraUser alloc] init];
    user.userId=[userMutableDictionary objectForKey:@"userId"];
    user.MSISDN=[userMutableDictionary objectForKey:@"msisdn"];
    user.email=[userMutableDictionary objectForKey:@"email"];
    [userMutableDictionary removeObjectForKey:@"userId"];
    [userMutableDictionary removeObjectForKey:@"email"];
    [userMutableDictionary removeObjectForKey:@"msisdn"];
    user.userParameters = userMutableDictionary;
    [Netmera updateUser:user];
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:true];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)requestLocationAuthorization:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult = nil;
    [Netmera requestLocationAuthorization];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:true];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
