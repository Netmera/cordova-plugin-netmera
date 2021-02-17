#import <Foundation/Foundation.h>
#import <Netmera/NetmeraEvent.h>
@interface FNetmeraEvent : NetmeraEvent
@property (nonatomic, strong) NSString  *netmeraEventKey;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *eventParameters;
@end