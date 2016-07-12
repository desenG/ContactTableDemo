//
//  RuntimeDataStorage.m


#import <Foundation/Foundation.h>
#import "RuntimeDataStorage.h"
static RuntimeDataStorage *_sharedInstance;

static NSMutableArray *contactsFromAddressBook;

@implementation RuntimeDataStorage
{

}

+ (void)initialize {
    if (self == [RuntimeDataStorage class]) {
        // Makes sure this isn't executed more than once
        
    }
}

+(NSMutableArray *) contactsFromAddressBook
{
    return contactsFromAddressBook;
}

+(void) contactsFromAddressBook: (NSMutableArray *) value
{
    contactsFromAddressBook=[value copy];
}

@end