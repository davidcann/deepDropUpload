@import <AppKit/CPPanel.j>

/*

DCFileDropControllerDropDelegate protocol
- (void)fileDropUploadController:(DCFileDropController)theController setState:(BOOL)visible;

*/

DCFileDropableTargets = [ ];

isWinSafari = false;
if (navigator) {
	isWinSafari = (navigator.userAgent.indexOf("Windows") > 0 && navigator.userAgent.indexOf("AppleWebKit") > 0) ? true : false ;
}

@implementation DCFileDropController : CPObject {
	CPView view @accessors;
    CPArray validFileTypes @accessors;

	DOMElement fileInput;
	id dropDelegate;
	CPURL uploadURL;
	id uploadManager;

	BOOL insertAsFirstSubview;
	BOOL useIframeFileElement;
	id iframeElement;
	id fileDroppedEventImplementation;
	id fileDroppedEventCallback;
	id dragExitEventImplementation;
	id dragExitEventCallback;
}

+ (BOOL)platformRequiresIframeElement {
	if (![CPPlatform isBrowser]) {
		// it's a NativeHost app, so we need to put the file element inside an iframe
		return YES;
	}
	return NO;
}

- (id)initWithView:(CPView)theView dropDelegate:(id)theDropDelegate uploadURL:(CPURL)theUploadURL uploadManager:(id)theUploadManager {
	return [self initWithView:theView dropDelegate:theDropDelegate uploadURL:theUploadURL uploadManager:theUploadManager insertAsFirstSubview:NO];
}

- (id)initWithView:(CPView)theView dropDelegate:(id)theDropDelegate uploadURL:(CPURL)theUploadURL uploadManager:(id)theUploadManager insertAsFirstSubview:(BOOL)shouldInsertAsFirstSubview {
	return [self initWithView:theView dropDelegate:theDropDelegate uploadURL:theUploadURL uploadManager:theUploadManager insertAsFirstSubview:shouldInsertAsFirstSubview useIframeFileElement:[DCFileDropController platformRequiresIframeElement]];
}

- (id)initWithView:(CPView)theView dropDelegate:(id)theDropDelegate uploadURL:(CPURL)theUploadURL uploadManager:(id)theUploadManager insertAsFirstSubview:(BOOL)shouldInsertAsFirstSubview useIframeFileElement:(BOOL)shouldUseIframeFileElement {
	self = [super init];

	view = theView;
	dropDelegate = theDropDelegate;
	uploadURL = theUploadURL;
	uploadManager = theUploadManager;
	insertAsFirstSubview = shouldInsertAsFirstSubview;
	useIframeFileElement = shouldUseIframeFileElement;

	[self setFileDropState:NO];

	var theClass = [self class],
	    dragEnterEventImplementation = class_getMethodImplementation(theClass, @selector(fileDraggingEntered:)),
	    dragEnterEventCallback = function (anEvent) {if (![self validateDraggedFiles:anEvent.dataTransfer.files]){return NO;}else{anEvent.dataTransfer.dropEffect = "copy"; anEvent.stopPropagation(); dragEnterEventImplementation(self, nil, anEvent);}},
        bodyBlockCallback = function(anEvent){if (![DCFileDropableTargets containsObject:anEvent.toElement] || ([DCFileDropableTargets containsObject:anEvent.toElement] && ![self validateDraggedFiles:anEvent.dataTransfer.files])) {anEvent.dataTransfer.dropEffect = "none"; anEvent.preventDefault(); return NO;}else{return YES;}};

	fileDroppedEventImplementation = class_getMethodImplementation(theClass, @selector(fileDropped:));
	fileDroppedEventCallback = function (anEvent) { fileDroppedEventImplementation(self, nil, anEvent); };

	dragExitEventImplementation = class_getMethodImplementation(theClass, @selector(fileDraggingExited:));
	dragExitEventCallback = function (anEvent) { dragExitEventImplementation(self, nil, anEvent); };

    // this prevents the little plus sign from showing up when you drag over the body.
    // Otherwise the user could be confused where they can drop the file and it would
    // cause the browser to redirect to the file they just dropped. 
    window.document.body.addEventListener("dragover", bodyBlockCallback, NO);

	view._DOMElement.addEventListener("dragenter", dragEnterEventCallback, NO);

	if (useIframeFileElement) {
		// in the NativeHost app, we need to put the fileInput element inside an iframe
		iframeElement = document.createElement("iframe");
		iframeElement.style.backgroundColor = "rgba(0,0,0,0)";
		iframeElement.style.border = "0px";
		iframeElement.style.zIndex = "101";
		iframeElement.style.position = "absolute";
		iframeElement.src = "about:blank";
	} else {
		fileInput = document.createElement("input");
		fileInput.type = "file";
		fileInput.id = "filesUpload";
		fileInput.style.position = "absolute";
		fileInput.style.top = "0px";
		fileInput.style.left = "0px";
		fileInput.style.backgroundColor = "#00FF00";
		fileInput.style.opacity = "0";
		if (!isWinSafari) {
			// there seems to be a bug in the Windows version of Safari with multiple files, where all X number of files will be the same file.
			fileInput.setAttribute("multiple",true);
		}
		fileInput.addEventListener("change", fileDroppedEventCallback, NO);
		fileInput.addEventListener("dragleave", dragExitEventCallback, NO);
	    [DCFileDropableTargets addObject:fileInput];
	}

	[self setFileElementVisible:NO];

/*
	if (fileInput) {
		if (shouldInsertAsFirstSubview) {
			if (theView._DOMElement.firstChild) {
				theView._DOMElement.insertBefore(fileInput, theView._DOMElement.firstChild);
			} else {
				theView._DOMElement.appendChild(fileInput);
			}
		} else {

			theView._DOMElement.appendChild(fileInput);
		}
	}
*/

	return self;
}

- (BOOL)validateDraggedFiles:(FileList)files
{
    if (![validFileTypes count])
        return YES;

    for (var i = 0; i < files.length; i++)
    {
        // we really can only check the filename :(
        var filename = files.item(i).fileName,
            type = [filename pathExtension];

        return [validFileTypes containsObject:type];
    }

    return YES;
}

- (void)setFileDropState:(BOOL)visible {
	if ([dropDelegate respondsToSelector:@selector(fileDropUploadController:setState:)]) {
		[dropDelegate fileDropUploadController:self setState:visible];
	}
}

- (void)setFileElementVisible:(BOOL)yesNo {
	if (useIframeFileElement) {
		// in the NativeHost app, we need to put the fileInput element inside an iframe
		if (!iframeElement) {
			return;
		}
		if (yesNo) {
			iframeElement.style.width = "100%";
			iframeElement.style.height = "100%";
			if (insertAsFirstSubview == YES && view._DOMElement.firstChild) {
				view._DOMElement.insertBefore(iframeElement, view._DOMElement.firstChild);
			} else {
				view._DOMElement.appendChild(iframeElement);
			}
			window.setTimeout(function() {
				iframeElement.src = "about:blank";
				iframeElement.contentWindow.document.write("<input type='file' id='fileElement' />");
				iframeElement.contentWindow.document.body.style.overflow = "hidden";
				fileInput = iframeElement.contentWindow.document.getElementById("fileElement");
				fileInput.style.position = "absolute";
				fileInput.style.top = "0px";
				fileInput.style.left = "0px";
				fileInput.style.width = "100%";
				fileInput.style.height = "100%";
				fileInput.style.opacity = "0";
				fileInput.style.background = "#CCFFCC";
				if (!isWinSafari) {
					// there seems to be a bug in the Windows version of Safari with multiple files, where all X number of files will be the same file.
					fileInput.setAttribute("multiple",true);
				}
				fileInput.addEventListener("change", fileDroppedEventCallback, NO);
				fileInput.addEventListener("dragleave", dragExitEventCallback, NO);
			}, 0);
		} else {
			iframeElement.style.width = "0%";
			iframeElement.style.height = "0%";
			if (iframeElement.parentNode) {
				iframeElement.parentNode.removeChild(iframeElement);
			}
		}
	} else {
		// use just a file element
		if (yesNo) {
			fileInput.style.width = "100%";
			fileInput.style.height = "100%";
			if (insertAsFirstSubview == YES && view._DOMElement.firstChild) {
				view._DOMElement.insertBefore(fileInput, view._DOMElement.firstChild);
			} else {
				view._DOMElement.appendChild(fileInput);
			}
		} else {
			fileInput.style.width = "0%";
			fileInput.style.height = "0%";
			if (fileInput.parentNode) {
				fileInput.parentNode.removeChild(fileInput);
			}
		}
	}
}

- (void)fileDraggingEntered:(id)sender {
	[self setFileDropState:YES];
	[self setFileElementVisible:YES];
}

- (void)fileDraggingExited:(id)sender {
	[self setFileDropState:NO];
	[self setFileElementVisible:NO];
}

- (void)fileDropped:(id)sender {
	[self setFileDropState:NO];
	[self setFileElementVisible:NO];

	var files = sender.target.files;
	for(var i = 0, len = files.length; i < len; i++) {
		if ([uploadManager respondsToSelector:@selector(fileUploadWithFile:uploadURL:)])
        {
			var upload = [uploadManager fileUploadWithFile:files[i] uploadURL:uploadURL];

            if ([dropDelegate respondsToSelector:@selector(fileDropController:didBeginUpload:)])
                [dropDelegate fileDropController:self didBeginUpload:upload];
        }
        
	}

    // now clear the input 
    fileInput.value = nil;
}

@end
