//
//  ResistorGenericViewController.h
//  iResist
//
//  Created by Ryan Joseph on 8/19/08.
//  Copyright 2008 Flying Monkey Enterprises. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ResistorScrollViewController.h"

@interface ResistorGenericViewController : UIViewController {
    UIPickerView *_picker;
	ResistorScrollViewController *_scrollView;
}

@property (nonatomic, retain) UIPickerView *picker;
@property (nonatomic, assign) ResistorScrollViewController *scrollView;

@end
