
#import <Foundation/Foundation.h>
#import "FNetmeraUser.h"

@implementation FNetmeraUser
+ (NSDictionary *)keyPathPropertySelectorMapping {
    return @{@"prms" : NSStringFromSelector(@selector(userParameters))};
}
@end
