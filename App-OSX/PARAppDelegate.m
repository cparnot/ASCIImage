//
//  PARAppDelegate.m
//  ASCIImage
//
//  Created by Charles Parnot on 5/31/13.
//  Copyright (c) 2013 Charles Parnot. All rights reserved.
//

#import "PARAppDelegate.h"
#import "PARImage+ASCIIInput.h"

@implementation PARAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (void)awakeFromNib
{
    NSArray *asciiRep = nil;
    
    asciiRep = @
    [
     @" 4 · 3",
     @" · · ·",
     @" 1 · 2",
     ];
    
    asciiRep = @
    [
     @" 1 2 · · · · ",
     @" A o o · · · ",
     @" · o o o · · ",
     @" · · o o o · ",
     @" · · · 9 o 3 ",
     @" · · · 8 o 4 ",
     @" · · o o o · ",
     @" · o o o · · ",
     @" 7 o o · · · ",
     @" 6 5 · · · · ",
     ];
    
    asciiRep = @
    [
     @"· C · · · · · · · · · ·",
     @"C · C · · · · · · · · ·",
     @"· C · · · · A · · · · ·",
     @"· · · · · · · · · · · ·",
     @"· · · · · · · · · · · ·",
     @"· · · A · · 1 · · A · 2",
     @"· · · · · · 4 · · · · 3",
     @"· · · · · · · · · · · ·",
     @"· · · · · · A · · · · ·",
     @"· · · · · · · · · · · ·",
     @"· · · · · · · · · · · ·",
     @"· · · · · · · · · · · ·",
     ];
    
    asciiRep = @
    [
     @"· · · · · · · · · · · ·",
     @"· · · · · · · · · · · ·",
     @"· · · · · · · · · · · ·",
     @"· · · · · · 1 · · · · ·",
     @"· · · · · · o o · · · ·",
     @"· · · 7 o o 8 o 2 · · ·",
     @"· · · 6 o o 5 o 3 · · ·",
     @"· · · · · · o o · · · ·",
     @"· · · · · · 4 · · · · ·",
     @"· · · · · · · · · · · ·",
     @"· · · · · · · · · · · ·",
     @"· · · · · · · · · · · ·",
     ];
    
    asciiRep = @
    [
     @"· · · · · · · · · · · · · · · · ·",
     @"· · · 1 · 2 · · · · · 6 · 7 · · ·",
     @"· · · · · · · · · · · · · · · · ·",
     @"· · · · · · · · · · · · · · · · ·",
     @"· · · · · · · · · · · · · · · · ·",
     @"· · · · · · · · · · · · · · · · ·",
     @"· · · · · · · · · · · · · · · · ·",
     @"· · · · · · · · · · · · · · · · ·",
     @"· · · · · · · · · · · · · · · · ·",
     @"· · · · · · · · · · · · · · · · ·",
     @"· · · · · · · · · · · · · · · · ·",
     @"· · · · · · · · · · · · · · · · ·",
     @"· · · · · · · · · · · · · · · · ·",
     @"· · · · · · · · · · · · · · · · ·",
     @"· · · · · · · · · · · · · · · · ·",
     @"· · · 4 · 3 · · · · · 9 · 8 · · ·",
     @"· · · · · · · · · · · · · · · · ·",
     ];

    asciiRep = @
    [
     @"· · · · · 2 3 · · · · ·",
     @"· · · · · 5 4 · · · C ·",
     @"· · · · · 1 1 · · C · ·",
     @"· · · · · · · · · · · ·",
     @"· · · · · · · · · · · ·",
     @"· · · · · · · · · · · ·",
     @"· 1 · · · · 8 · · · 1 ·",
     @"· 1 · · · · · · · · 1 ·",
     @"· · · · · · · · 8 · · ·",
     @"· · · · · · · · · · · ·",
     @"· · · · · · · · · · · ·",
     @"· · · · · 1 1 · · · · ·",
     ];
    
     asciiRep = @
     [
      @"· · · · · · · · · · · ·",
      @"· · · · · · · · · · · ·",
      @"· · · · · 1 1 · · · · ·",
      @"· · · · · · 6 · · · · ·",
      @"· · · 2 · · · · · · · ·",
      @"· · · · · · · · · · · ·",
      @"· 1 C · · · 4 · · · 1 ·",
      @"· 1 · · · 4 2 · 8 · 1 ·",
      @"· · · · · · · · · · · ·",
      @"· · · · · · · · · · · ·",
      @"· · · · · A · · · · · ·",
      @"· · · · · 1 1 · · · · ·",
      @"· · · · · · · · · · · ·",
      ];

    self.input.string = [asciiRep componentsJoinedByString:@"\n"];
}

- (NSFont *)textViewFont
{
    return [NSFont fontWithName:@"Menlo" size:12.0];
}

- (IBAction)run:(id)sender
{
    NSString *inputString = self.input.attributedString.string;
    inputString = [inputString stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSArray *rep = [inputString componentsSeparatedByString:@"\n"];
    NSString *outputString = [[NSImage strictASCIIRepresentationFromLenientASCIIRepresentation:rep] componentsJoinedByString:@"\n"];
    self.simplifiedInput.string = outputString ? outputString : @"ERROR";
    
    self.imageView.image = [NSImage imageWithASCIIRepresentation:rep color:[NSColor blueColor] shouldAntialias:NO];
}


@end
