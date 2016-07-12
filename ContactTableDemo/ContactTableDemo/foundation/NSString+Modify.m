//
//  NSString+Modify.m
//
//  Created by DesenGuo on 2016-03-03.
//

#import <Foundation/Foundation.h>
#import "NSString+Modify.h"
@implementation NSString (Modify)
- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceCharacterSet]];
}
@end