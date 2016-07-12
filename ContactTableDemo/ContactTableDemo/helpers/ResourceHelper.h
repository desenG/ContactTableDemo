//
//  ResourceHelper.h
//

#import <AddressBook/AddressBook.h>
#import "Contact.h"
#import "AccountInfoCache.h"
#import "RuntimeDataStorage.h"

#ifndef ResourceHelper_h
#define ResourceHelper_h


#endif /* ResourceHelper_h */
@interface ResourceHelper: NSObject
{
    
}
#pragma - addressbook resource
+(void)askPermissionForAddressBook;

+(void)updateRuntimeAddressBook;

+(NSMutableArray*)getContactsFromAddressbook:(ABAddressBookRef)m_addressbook;
@end