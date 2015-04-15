//  PARTestCase.h
//  Created by Charles Parnot on 11/21/12.
//  Copyright (c) 2012 Findings Software. All rights reserved.


#import <XCTest/XCTest.h>
// iOS
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>

// Mac
#elif TARGET_OS_MAC
#import <Cocoa/Cocoa.h>
#endif

@interface PARTestCase : XCTestCase

// getting fixtures
- (NSURL *)bundleURLFromFixture:(NSString *)name ofType:(NSString *)extension;
- (NSString *)stringFromFixture:(NSString *)name ofType:(NSString *)extension;
- (id)plistFromFixture:(NSString *)name ofType:(NSString *)extension;

// showing files
- (void)openFile:(NSString *)path;
- (void)createAndShowFileWithData:(NSData *)data name:(NSString *)name extension:(NSString *)extension;
- (void)createAndShowFileWithString:(NSString *)string name:(NSString *)name extension:(NSString *)extension inTextEditor:(BOOL)inTextEditor;
- (void)createAndShowFileWithPlist:(id)plist name:(NSString *)name extension:(NSString *)extension;

// utilities
- (NSURL *)urlWithUniqueTmpDirectory;

@end


#pragma mark - Property List Diff

@interface NSObject (PARPropertyListDiff)
- (BOOL)isPlist;
- (NSString *)differencesWithPropertyList:(id)otherDictionary identifier:(NSString *)identifier excludedKeys:(NSSet *)excludedKeys;
@end


#pragma mark - Image Diff

#if TARGET_OS_IPHONE
@interface UIImage (ImageDiff)
- (BOOL)isPixelEqualToImage:(UIImage *)image;
- (CGFloat)pixelDifferenceWithImage:(UIImage *)image;
@end
#elif TARGET_OS_MAC
@interface NSImage (ImageDiff)
- (BOOL)isPixelEqualToImage:(NSImage *)image;
- (CGFloat)pixelDifferenceWithImage:(NSImage *)image;
@end
#endif

