#import "FNetmeraEvent.h"
@implementation FNetmeraEvent
- (NSString *)eventKey {
    return _netmeraEventKey;
}
+ (NSDictionary *)keyPathPropertySelectorMapping {
    return  @{@"prms" : NSStringFromSelector(@selector(eventParameters))};
}
@end