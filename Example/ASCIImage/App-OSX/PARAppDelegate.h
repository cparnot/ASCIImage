//
//  PARAppDelegate.h
//  ASCIImage
//
//  Created by Charles Parnot on 5/31/13.
//  Copyright (c) 2013 Charles Parnot. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PARAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, unsafe_unretained) IBOutlet NSTextView *input;
@property (nonatomic, unsafe_unretained) IBOutlet NSTextView *simplifiedInput;
@property (nonatomic, weak) IBOutlet NSImageView *imageView;

@property (readonly) NSFont *textViewFont;


- (IBAction)run:(id)sender;
- (IBAction)setImage:(id)sender;

@end
