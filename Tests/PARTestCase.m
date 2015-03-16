//  Created by Charles Parnot on 08/03/13.
//  Copyright (c) 2012 Findings Software. All rights reserved.

#import "PARTestCase.h"
#import "TargetConditionals.h"

@implementation PARTestCase


#pragma mark Fixtures

- (NSURL *)bundleURLFromFixture:(NSString *)name ofType:(NSString *)extension
{
    // `mainBundle` is the app bundle, not the test bundle
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:name ofType:extension inDirectory:@"fixtures"];
    XCTAssertNotNil(path, @"Could not find resource '%@.%@'", name, extension);
    if (!path)
        return nil;
    return [NSURL fileURLWithPath:path];
}

- (id)plistFromFixture:(NSString *)name ofType:(NSString *)extension
{
    // `mainBundle` is the app bundle, not the test bundle
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:name ofType:extension inDirectory:@"fixtures"];
    XCTAssertNotNil(path, @"Could not find resource '%@.%@'", name, extension);
    if (!path)
        return nil;
    
    // file --> data
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:&error];
    XCTAssertNotNil(data, @"Could not load data from resource '%@.%@' because of error:\n%@", name, extension, error);
    
    // data --> plist
    id plist = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:NULL error:&error];
    XCTAssertNotNil(plist, @"Could not deserialize plist from resource '%@.%@' because of error:\n%@", name, extension, error);
    
    return plist;
}

- (NSString *)stringFromFixture:(NSString *)name ofType:(NSString *)extension
{
    // `mainBundle` is the app bundle, not the test bundle
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:name ofType:extension inDirectory:@"fixtures"];
    XCTAssertNotNil(path, @"Could not find resource '%@.%@'", name, extension);
    if (!path)
        return nil;
    
    NSError *error = nil;
    NSString *content = [NSString stringWithContentsOfFile:path usedEncoding:NULL error:&error];
    XCTAssertNotNil(content, @"Could not load string from resource '%@.%@' because of error:\n%@", name, extension, error);
    return content;
}


#pragma mark Showing Files

- (void)openFile:(NSString *)path
{
#if TARGET_IPHONE_SIMULATOR
    // iOS Simulator
    // TODO: deprecated on iOS 8, switch to posix_spawn
	// NSString *openCommand = [NSString stringWithFormat:@"/usr/bin/open \"%@\"", path];
	// system([openCommand fileSystemRepresentation]);
    NSLog(@"Open file: %@", path);
#elif TARGET_OS_IPHONE
    // iOS device

#elif TARGET_OS_MAC
    // Other kinds of Mac OS
    [[NSWorkspace sharedWorkspace] openFile:path];

#else
    // Unsupported platform
#endif
}

- (void)_openFile:(NSString *)path inTextEditor:(BOOL)inTextEditor
{
#if TARGET_IPHONE_SIMULATOR
    // iOS Simulator
    // TODO: deprecated on iOS 8, switch to posix_spawn
    //NSString *openCommand = [NSString stringWithFormat:@"/usr/bin/open \"%@\"", path];
    //system([openCommand fileSystemRepresentation]);
    NSLog(@"Open file: %@", path);
#elif TARGET_OS_IPHONE
    // iOS device
#elif TARGET_OS_MAC
    // Other kinds of Mac OS
    if (inTextEditor)
    {
        NSRunningApplication *app = [[NSRunningApplication runningApplicationsWithBundleIdentifier:@"com.macromates.textmate"] lastObject];
        if (!app)
            app = [[NSRunningApplication runningApplicationsWithBundleIdentifier:@"com.macromates.TextMate.preview"] lastObject];
        if (!app)
            app = [[NSRunningApplication runningApplicationsWithBundleIdentifier:@"com.apple.TextEdit"] lastObject];
        if (app)
            [[NSWorkspace sharedWorkspace] openFile:path withApplication:[[app bundleURL] lastPathComponent]];
        else
            [[NSWorkspace sharedWorkspace] openFile:path];
    }
    else
        [[NSWorkspace sharedWorkspace] openFile:path];
#else
    // Unsupported platform
#endif
}

- (void)createAndShowFileWithData:(NSData *)data name:(NSString *)name extension:(NSString *)extension inTextEditor:(BOOL)inTextEditor
{
    // write data to disk
    NSString *tmpPath = [[NSTemporaryDirectory() stringByAppendingPathComponent:[name lastPathComponent]] stringByAppendingPathExtension:extension];
    NSError *error = nil;
    BOOL successWritingToFile = [data writeToFile:tmpPath options:NSDataWritingAtomic error:&error];
    XCTAssertTrue(successWritingToFile, @"Could not save string to path %@ because of error: %@", tmpPath, error);
    
    [self _openFile:tmpPath inTextEditor:inTextEditor];
}

- (void)createAndShowFileWithData:(NSData *)data name:(NSString *)name extension:(NSString *)extension
{
    [self createAndShowFileWithData:data name:name extension:extension inTextEditor:NO];
}

- (void)createAndShowFileWithString:(NSString *)string name:(NSString *)name extension:(NSString *)extension inTextEditor:(BOOL)inTextEditor
{
    NSError *error = nil;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    XCTAssertNotNil(data, @"error writing string to data: %@", error);
    [self createAndShowFileWithData:data name:name extension:extension inTextEditor:inTextEditor];
}

- (void)createAndShowFileWithPlist:(id)plist name:(NSString *)name extension:(NSString *)extension
{
    // plist --> data
    NSError *error = nil;
    NSData *data = [NSPropertyListSerialization dataWithPropertyList:plist format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];
    XCTAssertNotNil(data, @"error writing plist to data: %@", error);
    
    // write data to disk
    NSString *tmpPath = [[NSTemporaryDirectory() stringByAppendingPathComponent:[name lastPathComponent]] stringByAppendingPathExtension:extension];
    error = nil;
    BOOL successWritingToFile = [data writeToFile:tmpPath options:NSDataWritingAtomic error:&error];
    XCTAssertTrue(successWritingToFile, @"Could not save plist to path %@ because of error: %@", tmpPath, error);
    
    [self _openFile:tmpPath inTextEditor:YES];
}

#pragma mark - Utilities

- (NSURL *)urlWithUniqueTmpDirectory
{
    NSString *parentDir = [[NSBundle mainBundle] bundleIdentifier];
    NSString *uniqueDir = [[[NSDate date] description] stringByAppendingString:[[NSUUID UUID] UUIDString]];
    NSString *path = [[[@"~/Xcode-Tests" stringByAppendingPathComponent:parentDir] stringByAppendingPathComponent:uniqueDir] stringByStandardizingPath];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtURL:url withIntermediateDirectories:YES attributes:nil error:&error];
    XCTAssertTrue(success, @"Could not create temporary directory:\npath: %@\nerror: %@", path, error);
    return url;
}



@end


#pragma mark - Property List Diff


@implementation NSObject (PARPropertyListDiff)

- (BOOL)isPlist
{
    return [self isKindOfClass:[NSString class]] | [self isKindOfClass:[NSArray class]] | [self isKindOfClass:[NSDictionary class]] | [self isKindOfClass:[NSNumber class]];
}

#define MAX_CHARS 60

- (NSString *)diffDescription
{
    if ([self isKindOfClass:[NSDictionary class]] || [self isKindOfClass:[NSArray class]])
    {
        NSString *shortDescription = [self description];
        if ([shortDescription length] > MAX_CHARS)
            shortDescription = [[shortDescription substringToIndex:MAX_CHARS] stringByAppendingString:@"..."];
        return [NSString stringWithFormat:@"%@ entries: %@", @([(id)self count]), shortDescription];
    }
    
    else if ([self isKindOfClass:[NSData class]])
    {
        NSString *shortDescription = [self description];
        if ([shortDescription length] > MAX_CHARS)
            shortDescription = [[shortDescription substringToIndex:MAX_CHARS] stringByAppendingString:@"..."];
        return [NSString stringWithFormat:@"%@ bytes: %@", @([(id)self length]), shortDescription];
    }

    else if ([self isKindOfClass:[NSString class]])
    {
        return [NSString stringWithFormat:@"%@ characters: %@", @([(id)self length]), [self description]];
    }
    
    else
        return [self description];
}

- (void)appendToString:(NSMutableString *)diff diffWithObject:(id)otherObject identifier:(id)identifier excludedKeys:(NSSet *)excludedKeys
{
    id object1 = self;
    id object2 = otherObject;
    BOOL bothArrays  = [object1 isKindOfClass:[NSArray class]]      && [object2 isKindOfClass:[NSArray class]];
    BOOL bothSets    = [object1 isKindOfClass:[NSSet class]]        && [object2 isKindOfClass:[NSSet class]];
    BOOL bothDics    = [object1 isKindOfClass:[NSDictionary class]] && [object2 isKindOfClass:[NSDictionary class]];

    if (bothArrays)
    {
        NSArray *array1 = object1;
        NSArray *array2 = object2;
        if ([array1 count] != [array2 count])
        {
            [diff appendFormat:@"@@ %@.@count @@\n", identifier];
            [diff appendFormat:@"- %@ objects\n", @([array1 count])];
            [diff appendFormat:@"+ %@ objects\n", @([array2 count])];
            return;
        }
        for (NSUInteger index = 0; index < [array1 count]; index++)
        {
            id arrayObject1 = array1[index];
            id arrayObject2 = array2[index];
            [arrayObject1 appendToString:diff diffWithObject:arrayObject2 identifier:[NSString stringWithFormat:@"%@[%@]", identifier, @(index)] excludedKeys:excludedKeys];
        }
    }

    else if (bothSets)
    {
        NSSet *set1 = object1;
        NSSet *set2 = object2;
        if ([set1 count] != [set2 count])
        {
            [diff appendFormat:@"@@ %@.@count @@\n", identifier];
            [diff appendFormat:@"- %@ objects\n", @([set1 count])];
            [diff appendFormat:@"+ %@ objects\n", @([set2 count])];
            return;
        }
        if (![set1 isEqualToSet:set2])
        {
            NSMutableSet *onlySet1 = [NSMutableSet setWithSet:set1];
            NSMutableSet *onlySet2 = [NSMutableSet setWithSet:set2];
            [onlySet1 minusSet:set2];
            [onlySet2 minusSet:set1];
            NSArray *array1 = [onlySet1 allObjects];
            NSArray *array2 = [onlySet2 allObjects];
            [array1 appendToString:diff diffWithObject:array2 identifier:[NSString stringWithFormat:@"%@.allObjects", identifier] excludedKeys:excludedKeys];
        }
    }

    else if (bothDics)
    {
        // distinct keys and shared keys
        NSDictionary *dic1 = object1;
        NSDictionary *dic2 = object2;
        NSSet *keys1 = [NSSet setWithArray:[dic1 allKeys]];
        NSSet *keys2 = [NSSet setWithArray:[dic2 allKeys]];
        NSMutableSet *distinctKeys1 = nil;
        NSMutableSet *distinctKeys2 = nil;
        NSMutableSet *sharedKeys = [NSMutableSet setWithSet:keys1];
        [sharedKeys minusSet:excludedKeys];
        if (![keys1 isEqualToSet:keys2])
        {
            distinctKeys1 = [NSMutableSet setWithSet:keys1];
            [distinctKeys1 minusSet:excludedKeys];
            [distinctKeys1 minusSet:keys2];
            distinctKeys2 = [NSMutableSet setWithSet:keys2];
            [distinctKeys2 minusSet:excludedKeys];
            [distinctKeys2 minusSet:keys1];
            [sharedKeys minusSet:distinctKeys1];
            [sharedKeys minusSet:distinctKeys2];
        }
        
        // distinct keys
        if ([distinctKeys1 count] > 0 || [distinctKeys2 count] > 0)
        {
            for (NSString *key in distinctKeys1)
            {
                [diff appendFormat:@"@@ %@.%@ @@\n", identifier, key];
                [diff appendFormat:@"- %@\n", [dic1[key] diffDescription]];
            }
            for (NSString *key in distinctKeys2)
            {
                [diff appendFormat:@"@@ %@.%@ @@\n", identifier, key];
                [diff appendFormat:@"+ %@\n", [dic2[key] diffDescription]];
            }
        }
        
        // shared keys
        for (NSString *key in sharedKeys)
        {
            id dicObject1 = dic1[key];
            id dicObject2 = dic2[key];
            [dicObject1 appendToString:diff diffWithObject:dicObject2 identifier:[NSString stringWithFormat:@"%@.%@", identifier, key] excludedKeys:excludedKeys];
        }
    }
    
    else if (![object1 isEqual:object2])
    {
        [diff appendFormat:@"@@ %@ @@\n", identifier];
        [diff appendFormat:@"- [%@] %@\n", NSStringFromClass([object1 class]), [object1 diffDescription]];
        [diff appendFormat:@"+ [%@] %@\n", NSStringFromClass([object2 class]), [object2 diffDescription]];
    }
}

- (NSString *)differencesWithPropertyList:(id)otherPlist identifier:(NSString *)identifier excludedKeys:(NSSet *)excludedKeys
{
    NSMutableString *diff = [NSMutableString string];
    [self appendToString:diff diffWithObject:otherPlist identifier:identifier excludedKeys:excludedKeys];
    return [NSString stringWithString:diff];
}

@end


#pragma mark - Image Diff

// iOS
#if TARGET_OS_IPHONE
#define PARImage UIImage

// Mac
#elif TARGET_OS_MAC
#define PARImage NSImage
@implementation NSImage (CGImage)
- (CGImageRef)CGImage { return [self CGImageForProposedRect:NULL context:nil hints:nil]; }
@end
#endif

@implementation PARImage (PixelComparison)

- (BOOL)isPixelEqualToImage:(PARImage *)image
{
    CFDataRef data1 = CGDataProviderCopyData(CGImageGetDataProvider(self.CGImage));
    CFDataRef data2 = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
    
    BOOL result = NO;
    if (data1 == NULL && data2 == NULL)
        result = YES;
    else if (data1 == NULL || data2 == NULL)
        result = NO;
    else
        result = CFEqual(data1, data2);
    
    if (data1)
        CFRelease(data1);
    if (data2)
        CFRelease(data2);
    return result;
}

- (CGFloat)pixelDifferenceWithImage:(PARImage *)image
{
    if (image == nil)
        return 1.0;
    
    CFDataRef data1 = CGDataProviderCopyData(CGImageGetDataProvider([self  CGImage]));
    CFDataRef data2 = CGDataProviderCopyData(CGImageGetDataProvider([image CGImage]));
    
    CGFloat result = 1.0;
    if (data1 == NULL && data2 == NULL)
        result = 0.0;
    else if (data1 == NULL || data2 == NULL)
        result = 1.0;
    else if (CFDataGetLength(data1) != CFDataGetLength(data2))
        result = 1.0;
    else
    {
        const UInt8 *bytes1 = CFDataGetBytePtr(data1);
        const UInt8 *bytes2 = CFDataGetBytePtr(data2);
        NSUInteger length = CFDataGetLength(data1);
        NSUInteger diff = 0;
        for (NSUInteger i = 0; i < length; i++)
            diff += abs((int)(bytes1[i]) - (int)(bytes2[i]));
        diff /= length;
        result = (CGFloat)diff / (CGFloat)0xFF;
    }
    
    if (data1)
        CFRelease(data1);
    if (data2)
        CFRelease(data2);
    return result;
}

@end
