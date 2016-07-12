//
//  Contacts.m
//
#define Contact_FIRSTNAME @"firstname"
#define Contact_LASTNAME @"lastname"
#define Contact_EMAIL @"email"
#define Contact_ISCHECKED @"ischecked"
#define Contact_USERID @"userid"
#define Contact_SMSNUMBER @"smsnumber"
#define Contact_FBID @"fbid"
#import "Contact.h"

@implementation Contact
@synthesize firstname;
@synthesize lastname;
@synthesize email;
@synthesize ischeckd;
@synthesize userID;
@synthesize smsNumber;
@synthesize fbID;
+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    Contact *item = [[Contact alloc] init];
    item.firstname = [aDecoder decodeObjectOfClass:[NSString class] forKey:Contact_FIRSTNAME];
    item.lastname = [aDecoder decodeObjectOfClass:[NSString class] forKey:Contact_LASTNAME];
    item.email = [aDecoder decodeObjectOfClass:[NSString class] forKey:Contact_EMAIL];
    item.ischeckd = [aDecoder decodeObjectOfClass:[NSString class] forKey:Contact_ISCHECKED];
    item.userID = [aDecoder decodeObjectOfClass:[NSString class] forKey:Contact_USERID];
    item.smsNumber = [aDecoder decodeObjectOfClass:[NSString class] forKey:Contact_SMSNUMBER];
    item.fbID = [aDecoder decodeObjectOfClass:[NSString class] forKey:Contact_FBID];
    return item;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.firstname forKey:Contact_FIRSTNAME];
    [aCoder encodeObject:self.lastname forKey:Contact_LASTNAME];
    [aCoder encodeObject:self.email forKey:Contact_EMAIL];
    [aCoder encodeObject:self.ischeckd forKey:Contact_ISCHECKED];
    [aCoder encodeObject:self.userID forKey:Contact_USERID];
    [aCoder encodeObject:self.smsNumber forKey:Contact_SMSNUMBER];
    [aCoder encodeObject:self.fbID forKey:Contact_FBID];
}
@end
