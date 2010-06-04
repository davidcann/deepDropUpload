@import <AppKit/CPPanel.j>

/*

DCFileUploadDelegate protocol
- (void)fileUploadDidBegin:(DCFileUpload)theController;
- (void)fileUploadProgressDidChange:(DCFileUpload)theController;
- (void)fileUploadDidEnd:(DCFileUpload)theController;

*/

@implementation DCFileUpload : CPObject {
	CPString name @accessors;
	float progress @accessors;
	id delegate @accessors;
	CPURL uploadURL @accessors;

	id file;
	var xhr;
	BOOL isUploading;
}

- (id)initWithFile:(id)theFile {
	self = [super init];
	file = theFile;
	progress = 0.0;
	isUploading = NO;
	return self;
}

- (void)begin {
	[self processXHR];
}

- (void)processXHR {
	xhr = new XMLHttpRequest();

	var fileUpload = xhr.upload;
	
	fileUpload.addEventListener("progress", function(event) {
		if (event.lengthComputable) {
			[self setProgress:event.loaded / event.total];
			[self fileUploadProgressDidChange];
		}
	}, false);
	
	fileUpload.addEventListener("load", function(event) {
		[self fileUploadDidEnd];
	}, false);
	
	fileUpload.addEventListener("error", function(evt) {
		CPLog("error: " + evt.code);
	}, false);

    xhr.addEventListener("load", function(evt) {
        if (xhr.responseText)
            [self fileUploadDidReceiveResponse:xhr.responseText];
    }, NO);

	xhr.open("POST", [uploadURL absoluteURL]);
	xhr.setRequestHeader("If-Modified-Since", "Mon, 26 Jul 1997 05:00:00 GMT");
	xhr.setRequestHeader("Cache-Control", "no-cache");
	xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");
	xhr.setRequestHeader("X-File-Name", file.fileName);
	xhr.setRequestHeader("X-File-Size", file.fileSize);
	xhr.setRequestHeader("Content-Type", "multipart/form-data");
	xhr.send(file);

	[self fileUploadDidBegin];
};

- (void)fileUploadDidBegin {
	isUploading = YES;
	if ([delegate respondsToSelector:@selector(fileUploadDidBegin:)]) {
		[delegate fileUploadDidBegin:self];
	}
}

- (void)fileUploadProgressDidChange {
	isUploading = YES;
	if ([delegate respondsToSelector:@selector(fileUploadProgressDidChange:)]) {
		[delegate fileUploadProgressDidChange:self];
	}
}

- (void)fileUploadDidEnd{
	isUploading = NO;
	if ([delegate respondsToSelector:@selector(fileUploadDidEnd:)])
		[delegate fileUploadDidEnd:self];
}

- (void)fileUploadDidReceiveResponse:(CPString)aResponse
{
    if ([delegate respondsToSelector:@selector(fileUpload:didReceiveResponse:)])
		[delegate fileUpload:self didReceiveResponse:aResponse];
}

- (BOOL)isUploading {
	return isUploading;
}

- (void)cancel {
	isUploading = NO;
	xhr.abort();
}

@end
