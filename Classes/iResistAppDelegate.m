//
//  iResistAppDelegate.m
//  iResist
//
//  Created by Jacob Farkas on 7/10/08.
//  Copyright Apple Computer 2008. All rights reserved.
//

#import "iResistAppDelegate.h"
#import "iResistViewController.h"

@implementation iResistAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {	

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults valueForKey:@"components"] == nil) {
        NSArray *componentValues = [NSArray arrayWithObjects:[NSNumber numberWithInt:5],
                                    [NSNumber numberWithInt:3],
                                    [NSNumber numberWithInt:1],
                                    [NSNumber numberWithInt:7],
                                    nil];
        [defaults setValue:componentValues forKey:@"components"];
    }
    
	// Override point for customization after app launch	
    [window addSubview:viewController.view];
	[window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] setStatusBarStyle:2];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)dealloc {
    [viewController release];
	[window release];
	[super dealloc];
}


@end
