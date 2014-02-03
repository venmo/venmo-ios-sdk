#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <Specta/Specta.h>

#import "VDKPermission.h"

SpecBegin(VDKPermission)

describe(@"Initialization", ^{

    it(@"should have unknown type when first initialized", ^{
        VDKPermission *permission = [[VDKPermission alloc] init];
        expect(permission.type).to.equal(VDKInternalPermissionTypeUnknown);
    });

    it(@"should be initalized with specified type", ^{
        VDKPermission *permission = [[VDKPermission alloc] initWithType:VDKInternalPermissionTypeMakePayments];
        expect(permission.type).to.equal(VDKInternalPermissionTypeMakePayments);
    });
});

describe(@"Description", ^{

    it(@"should return correct description for VDKInternalPermissionTypeAccessFriends", ^{
        VDKPermission *permission = [[VDKPermission alloc] initWithType:VDKInternalPermissionTypeAccessFriends];
        expect([permission displayText]).to.equal(@"access friends");
    });

    it(@"should return correct description for VDKInternalPermissionTypeAccessEmail", ^{
        VDKPermission *permission = [[VDKPermission alloc] initWithType:VDKInternalPermissionTypeAccessEmail];
        expect([permission displayText]).to.equal(@"access email");
    });

    it(@"should return correct description for VDKInternalPermissionTypeAccessPhone", ^{
        VDKPermission *permission = [[VDKPermission alloc] initWithType:VDKInternalPermissionTypeAccessPhone];
        expect([permission displayText]).to.equal(@"access phone");
    });

    it(@"should return correct description for VDKInternalPermissionTypeAccessProfile", ^{
        VDKPermission *permission = [[VDKPermission alloc] initWithType:VDKInternalPermissionTypeAccessProfile];
        expect([permission displayText]).to.equal(@"access profile");
    });

    it(@"should return correct description for VDKInternalPermissionTypeAccessBalance", ^{
        VDKPermission *permission = [[VDKPermission alloc] initWithType:VDKInternalPermissionTypeAccessBalance];
        expect([permission displayText]).to.equal(@"access balance");
    });

    it(@"should return correct description for VDKInternalPermissionTypeMakePayments", ^{
        VDKPermission *permission = [[VDKPermission alloc] initWithType:VDKInternalPermissionTypeMakePayments];
        expect([permission displayText]).to.equal(@"make payments and charges");
    });

});

describe(@"Name", ^{

    it(@"should return correct name for VDKInternalPermissionTypeAccessFriends", ^{
        VDKPermission *permission = [[VDKPermission alloc] initWithType:VDKInternalPermissionTypeAccessFriends];
        expect([permission name]).to.equal(@"access_friends");
    });

    it(@"should return correct name for VDKInternalPermissionTypeAccessEmail", ^{
        VDKPermission *permission = [[VDKPermission alloc] initWithType:VDKInternalPermissionTypeAccessEmail];
        expect([permission name]).to.equal(@"access_email");
    });

    it(@"should return correct name for VDKInternalPermissionTypeAccessPhone", ^{
        VDKPermission *permission = [[VDKPermission alloc] initWithType:VDKInternalPermissionTypeAccessPhone];
        expect([permission name]).to.equal(@"access_phone");
    });

    it(@"should return correct name for VDKInternalPermissionTypeAccessProfile", ^{
        VDKPermission *permission = [[VDKPermission alloc] initWithType:VDKInternalPermissionTypeAccessProfile];
        expect([permission name]).to.equal(@"access_profile");
    });

    it(@"should return correct name for VDKInternalPermissionTypeAccessBalance", ^{
        VDKPermission *permission = [[VDKPermission alloc] initWithType:VDKInternalPermissionTypeAccessBalance];
        expect([permission name]).to.equal(@"access_balance");
    });

    it(@"should return correct name for VDKInternalPermissionTypeMakePayments", ^{
        VDKPermission *permission = [[VDKPermission alloc] initWithType:VDKInternalPermissionTypeMakePayments];
        expect([permission name]).to.equal(@"make_payments");
    });

});

SpecEnd