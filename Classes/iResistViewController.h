//
//  iResistViewController.h
//  iResist
//
//  Created by Jacob Farkas on 7/10/08.
//  Copyright Apple Computer 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResistorColorPicker.h"

@interface iResistViewController : UIViewController <UISearchBarDelegate, UIAccelerometerDelegate> {
    IBOutlet UIPickerView *_colorPickerView;
	IBOutlet UISearchBar *_searchBar;
	IBOutlet UIButton *_expandSearchButton;
    IBOutlet ResistorColorPicker *_colorPicker;
	
	NSMutableArray *_colorBars;
	NSDictionary *_barImages;
}

- (IBAction) _expandButtonPressed: (id) sender;

- (void) _drawResistorBarWithColor: (NSString*)color atRect: (CGRect)rect withTag: (int)tag;
@end

