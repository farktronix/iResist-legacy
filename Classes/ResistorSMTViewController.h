//
//  ResistorSMTViewController.h
//  iResist
//
//  Created by Jacob Farkas on 8/9/08.
//  Copyright 2008 Flying Monkey Enterprises All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ResistorSMTViewController : UIViewController {
    IBOutlet UILabel *_ohms;
    IBOutlet UILabel *_smtLabel;
    
    UIPickerView *_picker;
}

@property (nonatomic, retain) UIPickerView *picker;

@end
