//
//  ConfigReader.h
//  IonicCordova
//
//  Created by Netmera on 28.05.2025.
//


#import <Foundation/Foundation.h>

@interface NetmeraConfigReader : NSObject <NSXMLParserDelegate>

@property (nonatomic, strong) NSString *netmeraKey;

- (void)readConfig;

@end
