Deep Drop Upload
==========

[Example](http://davidcann.com/deepDropUpload/index.html)

These classes allow you to turn any CPView in a [Cappuccino](http://github.com/280North/cappuccino) app into a file upload drop zone.  It supports multiple files dropped at once.  It works in Safari and Chrome.  Firefox support is possible, but hasn't been added.

The most useful classes are:

* DCFileDropController.j
* DCFileUploadManager.j
* DCFileUpload.j


## Usage

Import these classes:

	@import "DCFileDropController.j"
	@import "DCFileUploadManager.j"

Apply a DCFileDropController to any CPView:

	var fileDropUploadController = [[DCFileDropController alloc] 
		initWithView:anyView 
		dropDelegate:self 
		uploadURL:[CPURL URLWithString:@"upload.php"] 
		uploadManager:[DCFileUploadManager sharedManager]];

If you want to change visual state of the view, you can do that with this dropDelegate method:

	- (void)fileDropUploadController:(DCFileDropController *)theController setState:(BOOL)visible {
		if (visible) {
			[theController.view setBackgroundColor:[CPColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.2]];
		} else {
			[theController.view setBackgroundColor:[CPColor clearColor]];
		}
	}

If you want to display progress, you can set the DCFileUploadManager delegate:

	[[DCFileUploadManager sharedManager] setDelegate:uploadsPanel];

And process it with this method:

	- (void)fileUploadManagerDidChange:(DCFileUploadManager *)theManager {
		var fileUploads = [theManager fileUploads];
	}


## Attribution

This technique is based on code from [CSS Ninja](http://www.thecssninja.com/javascript/gmail-upload).


## License

[MIT License](http://www.opensource.org/licenses/mit-license.php)