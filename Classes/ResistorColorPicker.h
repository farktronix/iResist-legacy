//
//  ResistorColorPicker.h
//  iResist
//
//  Created by Jacob Farkas on 7/10/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iResistViewController;

@interface ResistorColorPicker : NSObject <UIPickerViewDataSource, UIPickerViewDelegate> {
    NSArray *_colorViews;
	NSDictionary *_colors;
	UIImage *_endImg;
	
    IBOutlet UILabel *_ohms;
	IBOutlet UILabel *_tolerance;
	IBOutlet UIImageView *_resistor;
	
	IBOutlet iResistViewController *_viewController;
}

- (UIView*) _colorViewWithRect:(CGRect)rect andColor: (UIColor*)color;
- (void) _drawResistorBarWithColorName: (NSString*)cName andComponent: (int)component;
- (void) _randomSpin:(UIPickerView*)pView;
@end
