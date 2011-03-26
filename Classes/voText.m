//
//  voText.m
//  rTracker
//
//  Created by Robert Miller on 01/11/2010.
//  Copyright 2010 Robert T. Miller. All rights reserved.
//

#import "voText.h"


@implementation voText

- (int) getValCap {  // NSMutableString size for value
    return 32;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	NSLog(@"tf begin editing");
    //*activeField = textField;
	((trackerObj*) self.vo.parentTracker).activeControl = (UIControl*) textField;
}

- (void)tfvoFinEdit:(UITextField*)tf {
	[self.vo.value setString:tf.text];
	tf.textColor = [UIColor blackColor];
    
	//self.vo.display = nil; // so will redraw this cell only
	[[NSNotificationCenter defaultCenter] postNotificationName:rtValueUpdatedNotification object:self];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	NSLog(@"tf end editing");
	[self tfvoFinEdit:textField];
    //*activeField = nil;
	((trackerObj*) self.vo.parentTracker).activeControl = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	// the user pressed the "Done" button, so dismiss the keyboard
	//NSLog(@"textField done: %@", textField.text);
	[self tfvoFinEdit:textField];
	[textField resignFirstResponder];
	return YES;
}


- (UIView*)voDisplay:(CGRect)bounds {
	CGRect frame = bounds;
	UITextField * dtf = [[UITextField alloc] initWithFrame:frame];
	
	dtf.borderStyle = UITextBorderStyleRoundedRect;  //Bezel;
	dtf.textColor = [UIColor blackColor];
	dtf.font = [UIFont systemFontOfSize:17.0];
	dtf.backgroundColor = [UIColor whiteColor];
	dtf.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
	
	dtf.keyboardType = UIKeyboardTypeDefault;	// use the full keyboard 
	dtf.placeholder = @"<enter text>";
	
	dtf.returnKeyType = UIReturnKeyDone;
	
	dtf.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
	
	dtf.tag = kViewTag;		// tag this control so we can remove it later for recycled cells
	dtf.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
	
	// Add an accessibility label that describes what the text field is for.
	[dtf setAccessibilityLabel:NSLocalizedString(@"NormalTextField", @"")];
	
	NSLog(@"dtf: vo val= %@", self.vo.value);
	if (![self.vo.value isEqualToString:@""]) {
		dtf.text = self.vo.value;
	}
	
	return [dtf autorelease];
}


#pragma mark -
#pragma mark options page 

- (void) setOptDictDflts {
    
    
    return [super setOptDictDflts];
}

- (BOOL) cleanOptDictDflts:(NSString*)key {
    /*
    NSString *val = [self.vo.optDict objectForKey:key];
    if (nil == val) 
        return YES;
    if (([key isEqualToString:@"shrinkb"] && [val isEqualToString:(SHRINKBDFLT ? @"1" : @"0")])
        ) {
        [self.vo.optDict removeObjectForKey:key];
        return YES;
    }
    */
    return [super cleanOptDictDflts:key];
}

- (void) voDrawOptions:(configTVObjVC*)ctvovc {
	CGRect labframe = [ctvovc configLabel:@"Options:" 
								  frame:(CGRect) {MARGIN,ctvovc.lasty,0.0,0.0}
									key:@"gooLab" 
								  addsv:YES ];
	
	ctvovc.lasty += labframe.size.height + MARGIN;
	[super voDrawOptions:ctvovc];
}

@end