//
//  AccountInfoCache.h
//  ObjectiveC_Demo
//
//  Created by DesenGuo on 2016-03-27.
//

#import <Foundation/Foundation.h>

@interface AccountInfoCache : NSObject
@property (nonatomic, strong) NSUserDefaults *prefs;

#pragma mark - permission
-(void)saveisAddressBookPermissionGranted:(BOOL)isAddressBookPermissionGranted;

-(BOOL)getisAddressBookPermissionGranted;

-(void)removeisAddressBookPermissionGranted;
@end
