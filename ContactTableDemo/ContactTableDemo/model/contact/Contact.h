//
//  Contacts.h
//
//


@interface Contact : NSObject<NSSecureCoding>
@property(nonatomic,strong)NSString* firstname;
@property(nonatomic,strong)NSString* lastname;
@property(nonatomic,strong)NSString* email;
@property(nonatomic,strong)NSString* ischeckd;
@property(nonatomic,strong)NSString* userID;
@property(nonatomic,strong)NSString* smsNumber;
@property(nonatomic,strong)NSString* fbID;
@end
