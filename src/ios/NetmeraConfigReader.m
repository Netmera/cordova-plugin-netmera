//
//  ConfigReader.m
//  IonicCordova
//
//  Created by Netmera on 28.05.2025.
//

#import "NetmeraConfigReader.h"

@interface NetmeraConfigReader ()

@property (nonatomic, strong) NSString *currentElement;

@end

@implementation NetmeraConfigReader

- (void)readConfig {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"xml"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    if (!data) {
        NSLog(@"❌ config.xml not found!");
        return;
    }

    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    
    if (![parser parse]) {
        NSLog(@"❌ Failed to parse config.xml");
    }
}

#pragma mark - NSXMLParserDelegate


- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary<NSString *, NSString *> *)attributeDict {

    if ([elementName isEqualToString:@"preference"]) {
        NSString *nameAttr = attributeDict[@"name"];
        if ([nameAttr isEqualToString:@"NetmeraKey"]) {
            self.netmeraKey = attributeDict[@"value"];
        }
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
}

@end
