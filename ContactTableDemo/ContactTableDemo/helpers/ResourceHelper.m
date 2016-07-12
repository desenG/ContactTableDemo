//
//  ResourceHelper.m
//
//  Created by DesenGuo on 2016-01-22.
//  Copyright © 2016 DIVE Communications Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResourceHelper.h"

@implementation ResourceHelper
{
}

+(NSString*)extractNumberFromString:(NSString*)originalString
{
    NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return [[originalString componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
}

#pragma - addressbook resource
+(void)askPermissionForAddressBook
{
    if([[AccountInfoCache new] getisAddressBookPermissionGranted])
    {
        return;
    }
    
    CFErrorRef  error;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL,&error);
    
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        if(granted)
        {
            NSLog(@"User Grant permission to his address book.");
            [[AccountInfoCache new] saveisAddressBookPermissionGranted:granted];
            [ResourceHelper updateRuntimeAddressBook];
        }
    });
    
}

+(void)updateRuntimeAddressBook
{
    if(![[AccountInfoCache new] getisAddressBookPermissionGranted])
    {
        return;
    }
    CFErrorRef  error;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL,&error);
    [RuntimeDataStorage contactsFromAddressBook: [ResourceHelper getContactsFromAddressbook:addressBook]];
}

+(NSMutableArray*)getContactsFromAddressbook:(ABAddressBookRef)m_addressbook
{
    NSLog(@"getContactsFromAddressbook");
    NSMutableArray *arrayContacts;
    @try{
        arrayContacts = [[NSMutableArray alloc] init];
        
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(m_addressbook);
        CFIndex nPeople = ABAddressBookGetPersonCount(m_addressbook);
        for (int i=0;i < nPeople;i++)
        {
            Contact *contact =[[Contact alloc] init];
            
            ABRecordRef ref = CFArrayGetValueAtIndex(allPeople,i);
            
            //fetch name
            CFStringRef firstName, lastName;
            firstName = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
            lastName  = ABRecordCopyValue(ref, kABPersonLastNameProperty);
            NSString *fname =(__bridge NSString *)(firstName);
            if (fname.length == 0)
            {
                fname = @"";
            }
            NSString *Lname =(__bridge NSString *)(lastName);
            if (Lname.length == 0)
            {
                Lname = fname;
                fname = @"";
            }
            
            // If email is set Create a contact with email address
            NSString *strEmail;
            ABMultiValueRef email = ABRecordCopyValue(ref, kABPersonEmailProperty);
            CFStringRef tempEmailref;
            if (ABMultiValueGetCount(email) > 0)
            {
                tempEmailref = ABMultiValueCopyValueAtIndex(email, 0);
                strEmail = (__bridge  NSString *)tempEmailref;
                contact.firstname = fname;
                contact.lastname = Lname;
                contact.email = strEmail;
                contact.ischeckd = @"no";
                contact.smsNumber = @"";
                CFRelease(tempEmailref);
                [arrayContacts addObject:contact];
            }
            
            // If Phone number is set Create a contact with the phone number
            NSString *strPhone;
            ABMultiValueRef phone = ABRecordCopyValue(ref, kABPersonPhoneProperty);
            CFStringRef phoneNumberRef;
            if (ABMultiValueGetCount(phone) > 0)
            {
                phoneNumberRef = ABMultiValueCopyValueAtIndex(phone, 0);
                strPhone = (__bridge  NSString *)phoneNumberRef;
                contact.firstname = fname;
                contact.lastname = Lname;
                contact.email = @"";
                contact.smsNumber = [ResourceHelper extractNumberFromString:strPhone];
                contact.ischeckd=@"no";
                CFRelease(phoneNumberRef);
                [arrayContacts addObject:contact];
            }
        }
        
        CFRelease(m_addressbook);
        CFRelease(allPeople);
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@",exception);
    }
    return arrayContacts;
}
@end