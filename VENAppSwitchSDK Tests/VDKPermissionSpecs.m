#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <Specta/Specta.h>

#import "VDKPermission.h"

SpecBegin(VDKPermission)

describe(@"Initialization", ^{

    it(@"should have unknown type when first initialized", ^{
        VDKPermission *permission = [[VDKPermission alloc] init];
        expect(permission.type).to.equal(VDKPermissionTypeUnknown);
    });

    it(@"should be initalized with specified type", ^{
        VDKPermission *permission = [[VDKPermission alloc] initWithType:VDKPermissionTypeMakePayments];
        expect(permission.type).to.equal(VDKPermissionTypeMakePayments);
    });
});

describe(@"Description", ^{

    it(@"should return correct description for VDKPermissionTypeAccessFriends", ^{
        VDKPermission *permission = [[VDKPermission alloc] initWithType:VDKPermissionTypeAccessFriends];
        expect([permission displayText]).to.equal(@"access friends");
    });

    it(@"should return correct description for VDKPermissionTypeAccessEmail", ^{
        VDKPermission *permission = [[VDKPermission alloc] initWithType:VDKPermissionTypeAccessEmail];
        expect([permission displayText]).to.equal(@"access email");
    });

    it(@"should return correct description for VDKPermissionTypeAccessPhone", ^{
        VDKPermission *permission = [[VDKPermission alloc] initWithType:VDKPermissionTypeAccessPhone];
        expect([permission displayText]).to.equal(@"access phone");
    });

    it(@"should return correct description for VDKPermissionTypeAccessProfile", ^{
        VDKPermission *permission = [[VDKPermission alloc] initWithType:VDKPermissionTypeAccessProfile];
        expect([permission displayText]).to.equal(@"access profile");
    });

    it(@"should return correct description for VDKPermissionTypeAccessBalance", ^{
        VDKPermission *permission = [[VDKPermission alloc] initWithType:VDKPermissionTypeAccessBalance];
        expect([permission displayText]).to.equal(@"access balance");
    });

    it(@"should return correct description for VDKPermissionTypeMakePayments", ^{
        VDKPermission *permission = [[VDKPermission alloc] initWithType:VDKPermissionTypeMakePayments];
        expect([permission displayText]).to.equal(@"make payments and charges");
    });

});

describe(@"Name", ^{

    it(@"should return correct name for VDKPermissionTypeAccessFriends", ^{
        VDKPermission *permission = [[VDKPermission alloc] initWithType:VDKPermissionTypeAccessFriends];
        expect([permission name]).to.equal(@"access_friends");
    });

    it(@"should return correct name for VDKPermissionTypeAccessEmail", ^{
        VDKPermission *permission = [[VDKPermission alloc] initWithType:VDKPermissionTypeAccessEmail];
        expect([permission name]).to.equal(@"access_email");
    });

    it(@"should return correct name for VDKPermissionTypeAccessPhone", ^{
        VDKPermission *permission = [[VDKPermission alloc] initWithType:VDKPermissionTypeAccessPhone];
        expect([permission name]).to.equal(@"access_phone");
    });

    it(@"should return correct name for VDKPermissionTypeAccessProfile", ^{
        VDKPermission *permission = [[VDKPermission alloc] initWithType:VDKPermissionTypeAccessProfile];
        expect([permission name]).to.equal(@"access_profile");
    });

    it(@"should return correct name for VDKPermissionTypeAccessBalance", ^{
        VDKPermission *permission = [[VDKPermission alloc] initWithType:VDKPermissionTypeAccessBalance];
        expect([permission name]).to.equal(@"access_balance");
    });

    it(@"should return correct name for VDKPermissionTypeMakePayments", ^{
        VDKPermission *permission = [[VDKPermission alloc] initWithType:VDKPermissionTypeMakePayments];
        expect([permission name]).to.equal(@"make_payments");
    });

});

SpecEnd