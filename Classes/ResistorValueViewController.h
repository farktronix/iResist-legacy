//
//  ResistorValueViewController.h
//  iResist
//
//  Created by Jacob Farkas on 7/27/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ResistorValueViewController : UIViewController {
    IBOutlet UILabel *_ohms;
	IBOutlet UILabel *_tolerance;
	IBOutlet UIImageView *_resistor;
    
	NSMutableArray *_colorBars;
	NSDictionary *_barImages;
}

@end
