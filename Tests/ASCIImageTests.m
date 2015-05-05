//
//  ASCIImageTests.m
//  ASCIImageTests
//
//  Created by Charles Parnot on 5/31/13.
//  Copyright (c) 2013 Charles Parnot. All rights reserved.
//

#import "PARTestCase.h"
#import "PARImage+ASCIIInput.h"

@interface ASCIImageTests : PARTestCase
@end

@interface ASCIImageTests (Utilities)
- (void)_testFixtureWithName:(NSString *)fixtureName scaleFactor:(NSUInteger)scaleFactor shouldAntialias:(BOOL)shouldAntialias;
@end


@implementation ASCIImageTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Sleep to avoid test timeout (very annoying Xcode bug??)
    [NSThread sleepForTimeInterval:0.05];
    
    [super tearDown];
}

- (void)testASCIIImage1
{
    [self _testFixtureWithName:@"fixture1"];
}


- (void)testASCIIImage2
{
    [self _testFixtureWithName:@"fixture2"];
}

- (void)testASCIIImage3
{
    [self _testFixtureWithName:@"fixture3"];
}

- (void)testASCIIImage4
{
    [self _testFixtureWithName:@"fixture4"];
}

- (void)testASCIIImage5
{
    [self _testFixtureWithName:@"fixture5"];
}

- (void)testASCIIImage6
{
    [self _testFixtureWithName:@"fixture6"];
}

- (void)testASCIIImage7
{
    [self _testFixtureWithName:@"fixture7"];
}

- (void)testASCIIImage8
{
    [self _testFixtureWithName:@"fixture8"];
}

- (void)testASCIIImage9
{
    [self _testFixtureWithName:@"fixture9" contextHandler:^(NSMutableDictionary *context)
     {
         NSInteger index = [context[ASCIIContextShapeIndex] integerValue];
         if (index == 0)
         {
             context[ASCIIContextFillColor]   = [PARColor grayColor];
         }
         else
         {
             context[ASCIIContextLineWidth]   = @(1.0);
             context[ASCIIContextStrokeColor] = [PARColor whiteColor];
         }
         context[ASCIIContextShouldAntialias] = @(YES);
     }];
}

- (void)testASCIIImage10
{
    [self _testFixtureWithName:@"fixture10" contextHandler:^(NSMutableDictionary *context)
     {
         NSInteger index = [context[ASCIIContextShapeIndex] integerValue];
         if (index == 0)
         {
             context[ASCIIContextLineWidth]   = @(2.0);
             context[ASCIIContextStrokeColor] = [PARColor blackColor];
         }
         else if (index == 2)
         {
             context[ASCIIContextFillColor]   = [PARColor blackColor];
         }
         else
         {
             context[ASCIIContextFillColor]   = [PARColor whiteColor];
         }
         context[ASCIIContextShouldClose]     = @(YES);
         context[ASCIIContextShouldAntialias] = @(YES);
     }];
}

- (void)testASCIIImage11
{
    [self _testFixtureWithName:@"fixture11"];
}

- (PARImage *)deletionImage
{
    NSArray *asciiRep =
    @[
      @"· · · · 1 1 1 · · · ·",
      @"· · 1 · · · · · 1 · ·",
      @"· 1 · · · · · · · 1 ·",
      @"1 · · 2 · · · 3 · · 1",
      @"1 · · · · · · · · · 1",
      @"1 · · · · · · · · · 1",
      @"1 · · · · · · · · · 1",
      @"1 · · 3 · · · 2 · · 1",
      @"· 1 · · · · · · · 1 ·",
      @"· · 1 · · · · · 1 · ·",
      @"· · · 1 1 1 1 1 · · ·",
      ];
    return [PARImage imageWithASCIIRepresentation:asciiRep contextHandler:^(NSMutableDictionary *context)
        {
            NSInteger index = [context[ASCIIContextShapeIndex] integerValue];
            if (index == 0)
            {
                context[ASCIIContextFillColor]   = [PARColor grayColor];
            }
            else
            {
                context[ASCIIContextLineWidth]   = @(1.0);
                context[ASCIIContextStrokeColor] = [PARColor whiteColor];
            }
            context[ASCIIContextShouldAntialias] = @(YES);
        }];
}

- (PARImage *)lockImage
{
    NSArray *asciiRep =
    @[
      @"· · · · 1 1 1 · · · ·",
      @"· · 1 · · · · · 1 · ·",
      @"· 1 · · · · · · · 1 ·",
      @"1 · · 2 · · · 3 · · 1",
      @"1 · · · · · · · · · 1",
      @"1 · · · · · · · · · 1",
      @"1 · · · · · · · · · 1",
      @"1 · · 3 · · · 2 · · 1",
      @"· 1 · · · · · · · 1 ·",
      @"· · 1 · · · · · 1 · ·",
      @"· · · 1 1 1 1 1 · · ·",
      ];
    return [PARImage imageWithASCIIRepresentation:asciiRep contextHandler:^(NSMutableDictionary *context)
        {
            NSInteger index = [context[ASCIIContextShapeIndex] integerValue];
            if (index == 0 || index == 2)
            {
                context[ASCIIContextFillColor]   = [PARColor blackColor];
            }
            else
            {
                context[ASCIIContextFillColor]   = [PARColor whiteColor];
            }
            context[ASCIIContextShouldClose]     = @(YES);
            context[ASCIIContextShouldAntialias] = @(YES);
        }];
}

- (void)_testFixtureWithName:(NSString *)fixtureName
{
    [self _testFixtureWithName:fixtureName scaleFactor:1.0 shouldAntialias:NO  contextHandler:nil];
    [self _testFixtureWithName:fixtureName scaleFactor:1.0 shouldAntialias:YES contextHandler:nil];
    [self _testFixtureWithName:fixtureName scaleFactor:2.0 shouldAntialias:NO  contextHandler:nil];
    [self _testFixtureWithName:fixtureName scaleFactor:2.0 shouldAntialias:YES contextHandler:nil];
    [self _testFixtureWithName:fixtureName scaleFactor:3.0 shouldAntialias:NO  contextHandler:nil];
    [self _testFixtureWithName:fixtureName scaleFactor:3.0 shouldAntialias:YES contextHandler:nil];
}

- (void)_testFixtureWithName:(NSString *)fixtureName contextHandler:(void(^)(NSMutableDictionary *context))contextHandler
{
    [self _testFixtureWithName:fixtureName scaleFactor:1.0 shouldAntialias:YES contextHandler:contextHandler];
    [self _testFixtureWithName:fixtureName scaleFactor:2.0 shouldAntialias:YES contextHandler:contextHandler];
    [self _testFixtureWithName:fixtureName scaleFactor:3.0 shouldAntialias:YES contextHandler:contextHandler];
}


#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

- (void)_testFixtureWithName:(NSString *)fixtureName scaleFactor:(NSUInteger)scaleFactor shouldAntialias:(BOOL)shouldAntialias contextHandler:(void(^)(NSMutableDictionary *context))contextHandler
{
    // image from ascii
    NSString *input = [self stringFromFixture:fixtureName ofType:@"txt"];
    NSArray *inputASCIIRep = [input componentsSeparatedByString:@"\n"];
    XCTAssertNotNil(input, @"Could not load input from test bundle, for fixture with name %@", fixtureName);
    if (!input)
        return;
    UIImage *actualImage = nil;
    if (contextHandler)
    {
        actualImage = [UIImage imageWithASCIIRepresentation:inputASCIIRep scaleFactor:scaleFactor contextHandler:contextHandler];
    }
    else
    {
        actualImage = [UIImage imageWithASCIIRepresentation:inputASCIIRep scaleFactor:scaleFactor color:[UIColor blackColor] shouldAntialias:shouldAntialias];
    }
    XCTAssertNotNil(actualImage, @"Could not generate image output, for fixture with name %@", fixtureName);
    if (!actualImage)
        return;
    NSData *actualImagePNGData = UIImagePNGRepresentation(actualImage);
    UIImage *actualImagePNG = [UIImage imageWithData:actualImagePNGData];
    
    // expected output
    NSString *expectedImageFileName = [NSString stringWithFormat:@"%@-%@@%@x", fixtureName, shouldAntialias ? @"antialiased" : @"aliased", @((NSInteger)scaleFactor)];
    UIImage *expectedImage = [[UIImage alloc] initWithContentsOfFile:[self bundleURLFromFixture:expectedImageFileName ofType:@"png"].path];
    XCTAssertNotNil(expectedImage, @"No image in test bundle with name %@", expectedImageFileName);
    
    // compare images
    CGFloat pixelDiff = [actualImagePNG pixelDifferenceWithImage:expectedImage];
    if (expectedImage == nil || (pixelDiff > 0.05))
    {
        XCTAssertTrue(NO, @"Expected image is different from actual image for fixture with name %@: pixel diff = %@", expectedImageFileName, @(pixelDiff));
        if (actualImagePNGData)
        {
            [self createAndShowFileWithData:actualImagePNGData name:expectedImageFileName extension:@"png"];
        }
        
        // [self createAndShowFileWithString:[[NSImage numberedASCIIRepresentationFromASCIIRepresentation:inputASCIIRep] componentsJoinedByString:@"\n"] name:fixtureName extension:@"text" inTextEditor:YES];
    }
}


#elif TARGET_OS_MAC

// Testing for 1x and 2x output. The output is generated by drawing into a bitmap context of 1x or 2x the image size. I manully checked that the 2x output is the same as what one gets with on-screen retina drawing.
- (void)_testFixtureWithName:(NSString *)fixtureName scaleFactor:(NSUInteger)scaleFactor shouldAntialias:(BOOL)shouldAntialias contextHandler:(void(^)(NSMutableDictionary *context))contextHandler
{
    // image from ascii
    NSString *input = [self stringFromFixture:fixtureName ofType:@"txt"];
    NSArray *inputASCIIRep = [input componentsSeparatedByString:@"\n"];
    XCTAssertNotNil(input, @"Could not load input from test bundle, for fixture with name %@", fixtureName);
    if (!input)
        return;
    NSImage *actualImage = nil;
    if (contextHandler)
    {
        actualImage = [NSImage imageWithASCIIRepresentation:inputASCIIRep contextHandler:contextHandler];
    }
    else
    {
        actualImage = [NSImage imageWithASCIIRepresentation:inputASCIIRep color:[NSColor blackColor] shouldAntialias:shouldAntialias];
    }
    XCTAssertNotNil(actualImage, @"Could not generate image output, for fixture with name %@", fixtureName);
    if (!actualImage)
        return;
    
    // scaled output
    NSSize size = actualImage.size;
    size.width  *= scaleFactor;
    size.height *= scaleFactor;
    NSImage *actualImageScaled = [[NSImage alloc] initWithSize:size];
    [actualImageScaled lockFocus];
    {
        [actualImage drawInRect:NSMakeRect(0.0, 0.0, size.width, size.height) fromRect:NSMakeRect(0.0, 0.0, actualImage.size.width, actualImage.size.height) operation:NSCompositeSourceOver fraction:1.0];
    }
    [actualImageScaled unlockFocus];
    NSImage *tiffImage = [[NSImage alloc] initWithData:actualImageScaled.TIFFRepresentation];
    NSData *pngData = [tiffImage.representations[0] representationUsingType:NSPNGFileType properties: nil]; ;
    NSData *tifData = tiffImage.TIFFRepresentation;
    XCTAssertNotNil(pngData, @"Could not generate image PNG data, for fixture with name %@", fixtureName);
    XCTAssertNotNil(tifData, @"Could not generate image TIF data, for fixture with name %@", fixtureName);
    NSImage *actualImageFromPNG = [[NSImage alloc] initWithData:pngData];
    NSImage *actualImageFromTIF = [[NSImage alloc] initWithData:tifData];
    
    // expected output PNG and TIF
    NSString *expectedImageFileName = [NSString stringWithFormat:@"%@-%@@%@x", fixtureName, shouldAntialias ? @"antialiased" : @"aliased", @(scaleFactor)];
    NSImage *expectedImagePNG = [[NSImage alloc] initWithContentsOfURL:[self bundleURLFromFixture:expectedImageFileName ofType:@"png"]];
    NSImage *expectedImageTIF = [[NSImage alloc] initWithContentsOfURL:[self bundleURLFromFixture:expectedImageFileName ofType:@"tif"]];
    XCTAssertNotNil(expectedImagePNG, @"No PNG image in test bundle with name %@", expectedImageFileName);
    XCTAssertNotNil(expectedImageTIF, @"No TIF image in test bundle with name %@", expectedImageFileName);

    // compare TIF and PNG just to be sure
    CGFloat tifpngDiff = [expectedImagePNG pixelDifferenceWithImage:expectedImageTIF];
    XCTAssertTrue(tifpngDiff < 0.05, @"PNG and TIF images have a pixel-diff = %@, but should be the same for file name %@", @(tifpngDiff), expectedImageFileName);
    
    // compare images
    CGFloat pixelDiff = [actualImageFromPNG pixelDifferenceWithImage:expectedImagePNG];
    if (expectedImagePNG == nil || (pixelDiff > 0.05))
    {
        XCTAssertTrue(NO, @"Expected image is different from actual image for fixture with name %@: pixel diff = %@", expectedImageFileName, @(pixelDiff));

        if (pngData)
        {
            [self createAndShowFileWithData:pngData name:expectedImageFileName extension:@"png"];
        }
        if (tifData)
        {
            [self createAndShowFileWithData:tifData name:expectedImageFileName extension:@"tif"];
        }
    }
}

#endif


@end
