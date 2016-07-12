//
//  AccountInfoCache.m
//  ObjectiveC_Demo
//
//  Created by DesenGuo on 2016-03-27.
//

#import "AccountInfoCache.h"

@implementation AccountInfoCache
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.prefs = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

-(void)removeAll
{
    NSLog(@"removeAll");
    [self removeisAddressBookPermissionGranted];
}

#pragma mark - permission
-(void)saveisAddressBookPermissionGranted:(BOOL)isAddressBookPermissionGranted
{
    [self.prefs setBool:isAddressBookPermissionGranted forKey:@"isAddressBookPermissionGranted"];
}

-(BOOL)getisAddressBookPermissionGranted
{
    return [self.prefs boolForKey:@"isAddressBookPermissionGranted"];
}

-(void)removeisAddressBookPermissionGranted
{
    [self.prefs removeObjectForKey:@"isAddressBookPermissionGranted"];
}
@end
