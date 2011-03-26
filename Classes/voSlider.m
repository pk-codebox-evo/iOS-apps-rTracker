//
//  voSlider.m
//  rTracker
//
//  Created by Robert Miller on 01/11/2010.
//  Copyright 2010 Robert T. Miller. All rights reserved.
//

#import "voSlider.h"


@implementation voSlider

//@synthesize sliderFrame,sliderCtl,sdflt;

- (void) dealloc {
//    self.sliderCtl = nil;
//    [sliderCtl release];
	[super dealloc];
}

- (UITableViewCell*) voTVCell:(UITableView *)tableView {
	return [super voTVEnabledCell:tableView];
}

- (void)sliderAction:(UISlider *)sender
{ 
	NSLog(@"slider action value = %f", ((UISlider *)sender).value);
	[self.vo.value setString:[NSString stringWithFormat:@"%f",sender.value]];
	//NSLog(@"slider action value = %f valstr= %@ vs dbl= %f", ((UISlider *)sender).value, self.vo.value, [self.vo.value doubleValue]);
	if (!self.vo.useVO)
		[self.vo enableVO];
    
	//self.vo.display = nil; // so will redraw this cell only  rtm testing
    
	[[NSNotificationCenter defaultCenter] postNotificationName:rtValueUpdatedNotification object:self];
}

/*
- (UISlider*) sliderCtl {
    if (nil == sliderCtl) {
        NSLog(@"create sliderCtl");
        //CGRect frame = CGRectMake(174.0, 12.0, 120.0, kSliderHeight);
        
        sliderCtl = [[UISlider alloc] initWithFrame:self.sliderFrame];
        [sliderCtl addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
        
        // in case the parent view draws with a custom color or gradient, use a transparent color
        sliderCtl.backgroundColor = [UIColor clearColor];
        
        NSNumber *nsmin = [self.vo.optDict objectForKey:@"smin"];
        NSNumber *nsmax = [self.vo.optDict objectForKey:@"smax"];
        NSNumber *nsdflt = [self.vo.optDict objectForKey:@"sdflt"];
        
        CGFloat smin = (nsmin ? [nsmin floatValue] : SLIDRMINDFLT);
        CGFloat smax = (nsmax ? [nsmax floatValue] : SLIDRMAXDFLT);
        self.sdflt = (nsdflt ? [nsdflt floatValue] : SLIDRDFLTDFLT);
        
        sliderCtl.minimumValue = smin;
        sliderCtl.maximumValue = smax;
        sliderCtl.continuous = YES;
        // Add an accessibility label that describes the slider.
        [sliderCtl setAccessibilityLabel:NSLocalizedString(@"StandardSlider", @"")];
        
        sliderCtl.tag = kViewTag;	// tag this view for later so we can remove it from recycled table cells

        if ([self.vo.value isEqualToString:@""]) {
            self.sliderCtl.value = self.sdflt;  
            //[self.sliderCtl setValue:self.sdflt animated:NO];
        } else {
            self.sliderCtl.value = [self.vo.value floatValue];
            //[self.sliderCtl setValue:[self.vo.value floatValue] animated:NO];
        }
        
    }
    
    return sliderCtl;
}

- (UIView*) voDisplay:(CGRect) bounds
{
    self.sliderFrame = bounds;
	return self.sliderCtl;
}
*/

- (UIView*) voDisplay:(CGRect) bounds {
    NSLog(@"create sliderCtl");
    //CGRect frame = CGRectMake(174.0, 12.0, 120.0, kSliderHeight);
    CGRect frame = bounds;
    UISlider *sliderCtl = [[UISlider alloc] initWithFrame:frame];
    [sliderCtl addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    
    // in case the parent view draws with a custom color or gradient, use a transparent color
    sliderCtl.backgroundColor = [UIColor clearColor];
    
    NSNumber *nsmin = [self.vo.optDict objectForKey:@"smin"];
    NSNumber *nsmax = [self.vo.optDict objectForKey:@"smax"];
    NSNumber *nsdflt = [self.vo.optDict objectForKey:@"sdflt"];
    
    CGFloat smin = (nsmin ? [nsmin floatValue] : SLIDRMINDFLT);
    CGFloat smax = (nsmax ? [nsmax floatValue] : SLIDRMAXDFLT);
    CGFloat sdflt = (nsdflt ? [nsdflt floatValue] : SLIDRDFLTDFLT);
    
    sliderCtl.minimumValue = smin;
    sliderCtl.maximumValue = smax;
    sliderCtl.continuous = YES;
    // Add an accessibility label that describes the slider.
    [sliderCtl setAccessibilityLabel:NSLocalizedString(@"StandardSlider", @"")];
    
    sliderCtl.tag = kViewTag;	// tag this view for later so we can remove it from recycled table cells
    
    if ([self.vo.value isEqualToString:@""]) {
        sliderCtl.value = sdflt;  
        //[self.sliderCtl setValue:self.sdflt animated:NO];
    } else {
        sliderCtl.value = [self.vo.value floatValue];
        //[self.sliderCtl setValue:[self.vo.value floatValue] animated:NO];
    }
    
    return [sliderCtl autorelease];
}

- (NSArray*) voGraphSet {
	return [voState voGraphSetNum];
}


- (void) setOptDictDflts {
    if (nil == [self.vo.optDict objectForKey:@"smin"]) 
        [self.vo.optDict setObject:[NSString stringWithFormat:@"%3.1f",SLIDRMINDFLT] forKey:@"smin"];
    if (nil == [self.vo.optDict objectForKey:@"smax"]) 
        [self.vo.optDict setObject:[NSString stringWithFormat:@"%3.1f",SLIDRMAXDFLT] forKey:@"smax"];
    if (nil == [self.vo.optDict objectForKey:@"sdflt"]) 
        [self.vo.optDict setObject:[NSString stringWithFormat:@"%3.1f",SLIDRDFLTDFLT] forKey:@"sdflt"];
    
    return [super setOptDictDflts];
}

- (BOOL) cleanOptDictDflts:(NSString*)key {
    
    NSString *val = [self.vo.optDict objectForKey:key];
    if (nil == val) 
        return YES;
    
    if (([key isEqualToString:@"smin"] && ([val floatValue] == f(SLIDRMINDFLT)))
        ||
        ([key isEqualToString:@"smax"] && ([val floatValue] == f(SLIDRMAXDFLT)))
        ||
        ([key isEqualToString:@"sdflt"] && ([val floatValue] == f(SLIDRDFLTDFLT)))
        ) {
        [self.vo.optDict removeObjectForKey:key];
        return YES;
    }
    
    return [super cleanOptDictDflts:key];
}



- (void) voDrawOptions:(configTVObjVC*)ctvovc {
	CGRect frame = {MARGIN,ctvovc.lasty,0.0,0.0};
	
	CGRect labframe = [ctvovc configLabel:@"Slider range:" frame:frame key:@"srLab" addsv:YES];
	
	frame.origin.x = MARGIN;
	frame.origin.y += labframe.size.height + MARGIN;
	
	labframe = [ctvovc configLabel:@"min:" frame:frame key:@"sminLab" addsv:YES];
	
	frame.origin.x = labframe.size.width + MARGIN + SPACE;
	CGFloat tfWidth = [[NSString stringWithString:@"9999999999"] sizeWithFont:[UIFont systemFontOfSize:18]].width;
	frame.size.width = tfWidth;
	frame.size.height = ctvovc.LFHeight; 
	
	[ctvovc configTextField:frame 
					  key:@"sminTF" 
				   target:nil
				   action:nil
					  num:YES 
					place:[NSString stringWithFormat:@"%3.1f",SLIDRMINDFLT] 
					 text:[self.vo.optDict objectForKey:@"smin"] 
					addsv:YES ];
	
	frame.origin.x += tfWidth + MARGIN;
	labframe = [ctvovc configLabel:@" max:" frame:frame key:@"smaxLab" addsv:YES];
	
	frame.origin.x += labframe.size.width + SPACE;
	frame.size.width = tfWidth;
	frame.size.height = ctvovc.LFHeight; 
	
	[ctvovc configTextField:frame 
					  key:@"smaxTF" 
				   target:nil
				   action:nil
					  num:YES 
					place:[NSString stringWithFormat:@"%3.1f",SLIDRMAXDFLT] 
					 text:[self.vo.optDict objectForKey:@"smax"]
					addsv:YES ];
	
	frame.origin.y += frame.size.height + MARGIN;
	frame.origin.x = 8*MARGIN;
	
	labframe = [ctvovc configLabel:@"default:" frame:frame key:@"sdfltLab" addsv:YES];
	
	frame.origin.x += labframe.size.width + SPACE;
	frame.size.width = tfWidth;
	frame.size.height = ctvovc.LFHeight; 
	
	[ctvovc configTextField:frame 
					  key:@"sdfltTF" 
				   target:nil
				   action:nil
					  num:YES 
					place:[NSString stringWithFormat:@"%3.1f",SLIDRDFLTDFLT]
					 text:[self.vo.optDict objectForKey:@"sdflt"]
					addsv:YES ];
	
	frame.origin.y += frame.size.height + MARGIN;
	frame.origin.x = MARGIN;
	//-- title label
	
	labframe = [ctvovc configLabel:@"Other options:" frame:frame key:@"soLab" addsv:YES];
	
	ctvovc.lasty = frame.origin.y + labframe.size.height + MARGIN;
	[super voDrawOptions:ctvovc];
}


@end