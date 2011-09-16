#import <SenTestingKit/SenTestingKit.h>

//#undef STFail
//
//#undef STAssertNil
//#undef STAssertNotNil
//
//#undef STAssertTrue
//#undef STAssertFalse
//
//#undef STAssertEquals
//#undef STAssertEqualObjects
//#undef STAssertEqualsWithAccuracy
//
//#undef STAssertThrows
//#undef STAssertThrowsSpecific
//#undef STAssertThrowsSpecificNamed
//
//#undef STAssertNoThrow
//#undef STAssertNoThrowSpecific
//#undef STAssertNoThrowSpecificNamed
//
//#undef STAssertTrueNoThrow
//#undef STAssertFalseNoThrow

#define VMFail STFail(@"fail");

#define VMAssertNil(a1) STAssertNil(a1, nil);
#define VMAssertNotNil(a1) STAssertNotNil(a1, nil);

#define VMAssertTrue(expr) STAssertTrue(expr, nil);
#define VMAssertFalse(expr) STAssertFalse(expr, nil);

#define VMAssertEquals(a1, a2) STAssertEquals(a1, a2, nil)
#define VMAssertEqualObjects(a1, a2) STAssertEqualObjects(a1, a2, nil)

#define VMAssertThrows(a1) STAssertThrows(a1, nil)
