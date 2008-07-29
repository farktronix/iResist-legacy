//
//  iResistAppDelegate.h
//  iResist
//
//  Created by Jacob Farkas on 7/10/08.
//  Copyright Flying Monkey Enterprises 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iResistViewController;

@interface iResistAppDelegate : NSObject <UIApplicationDelegate> {
	IBOutlet UIWindow *window;
	IBOutlet iResistViewController *viewController;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) iResistViewController *viewController;

@end

