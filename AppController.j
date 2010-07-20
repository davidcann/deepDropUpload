/*
 * AppController.j
 * NewApplication
 *
 * Created by You on April 9, 2010.
 * Copyright 2010, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>
@import "DCFileDropController.j"
@import "DCFileUploadManager.j"
@import "DCFileUploadsPanel.j"
@import "DCFileDropTableViewController.j"
@import "DCFileDropCollectionViewController.j"

@implementation AppController : CPObject {
	
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification {
	var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
		contentView = [theWindow contentView];

	// draw some text
	var titleLabel = [[CPTextField alloc] initWithFrame:CGRectMake(30, 30, 500, 40)];
	[titleLabel setStringValue:@"Deep Drop Upload Example"];
	[titleLabel setFont:[CPFont boldSystemFontOfSize:24.0]];
	[contentView addSubview:titleLabel];
	var descriptionLabel = [[CPTextField alloc] initWithFrame:CGRectMake(30, 70, 350, 50)];
	[descriptionLabel setStringValue:@"Drag any file(s) (less than 1 MB) from Finder to the target below or to any row in the table.  This currently works in Safari and Chrome.  Firefox support is possible, but not implemented."];
	[descriptionLabel setFont:[CPFont systemFontOfSize:12.0]];
	[descriptionLabel setLineBreakMode:CPLineBreakByWordWrapping];
	[contentView addSubview:descriptionLabel];

	// link to github
	var button = [[CPButton alloc] initWithFrame:CGRectMake(390, 35, 110, 24)];
	[button setTitle:@"Code on GitHub"];
	[button setTarget:self];
	[button setAction:@selector(gitHubAction)];
	[contentView addSubview:button];

	// drop view
	var anyView = [[CPImageView alloc] initWithFrame:CGRectMake(50, 140, 200, 200)];
	[anyView setImage:[[CPImage alloc] initWithContentsOfFile:[[CPBundle mainBundle] pathForResource:@"upload.png"] size:CPSizeMake(200, 200)]];
	[contentView addSubview:anyView];

	// create a window to show the upload progress
	var uploadsPanel = [[DCFileUploadsPanel alloc] initWithFrame:CGRectMake(600.0, 50.0, 250.0, 300.0)];
	[[DCFileUploadManager sharedManager] setDelegate:uploadsPanel];

	// activate the view as a drop zone
	var fileDropUploadController = [[DCFileDropController alloc] 
		initWithView:anyView 
		dropDelegate:self 
		uploadURL:[CPURL URLWithString:@"upload.php"] 
		uploadManager:[DCFileUploadManager sharedManager]];

	// add the example drop table view
	var dropTableViewController = [[DCFileDropTableViewController alloc] init];
	[[dropTableViewController view] setFrame:CGRectMake(340, 150, 200, 300)];
	[contentView addSubview:[dropTableViewController view]];

	// add a collection view example
	var dropCollectionViewController = [[DCFileDropCollectionViewController alloc] init];
	[[dropCollectionViewController view] setFrame:CGRectMake(40, 370, 240, 150)];
	[contentView addSubview:[dropCollectionViewController view]];

	[theWindow orderFront:self];
	[uploadsPanel orderFront:nil];
}

- (void)gitHubAction {
	window.location = "http://github.com/davidcann/deepdropupload";
}


// ******************** DCFileDropControllerDropDelegate *********************

- (void)fileDropUploadController:(DCFileDropController)theController setState:(BOOL)visible {
	if (visible) {
		[theController.view setBackgroundColor:[CPColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.2]];
	} else {
		[theController.view setBackgroundColor:[CPColor clearColor]];
	}
}

@end
