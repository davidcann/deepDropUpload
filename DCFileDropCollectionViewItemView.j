@import <AppKit/CPView.j>
@import "DCFileDropController.j"
@import "DCFileUploadManager.j"

@implementation DCFileDropCollectionViewItemView : CPView {
	CPTextField nameField;
}

- (id)initWithFrame:(CGRect)theFrame {
	self = [super initWithFrame:theFrame];

	nameField = [[CPTextField alloc] initWithFrame:[self bounds]];
	[nameField setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
	[nameField setLineBreakMode:CPLineBreakByTruncatingTail];
	[nameField setAlignment:CPCenterTextAlignment];
	[nameField setVerticalAlignment:CPCenterVerticalTextAlignment];
	[nameField setFont:[CPFont systemFontOfSize:12.0]];
    [nameField setValue:[CPColor whiteColor] forThemeAttribute:@"text-color" inState:CPThemeStateSelectedDataView];
	[self addSubview:nameField];

	return self;
}

- (void)setSelected:(BOOL)isSelected {
	if (isSelected) {
		[self setThemeState:CPThemeStateSelected];
	} else {
		[self unsetThemeState:CPThemeStateSelected];
	}
}

- (void)setThemeState:(CPThemeState)aState {
    [super setThemeState:aState];
    [nameField setThemeState:aState];
	if (aState === CPThemeStateSelected) {
		[self setBackgroundColor:[CPColor colorWithRed:0.356 green:0.557 blue:0.691 alpha:1.000]];
		[nameField setTextColor:[CPColor whiteColor]];
	}
}

- (void)unsetThemeState:(CPThemeState)aState {
    [super unsetThemeState:aState];
    [nameField unsetThemeState:aState];
	if (aState === CPThemeStateSelected) {
		[self setBackgroundColor:[CPColor clearColor]];
		[nameField setTextColor:[CPColor blackColor]];
	}
}

- (void)setRepresentedObject:(Object)anObject {
	[nameField setStringValue:anObject];
}

- (id)initWithCoder:(CPCoder)aCoder {
	self = [super initWithCoder:aCoder];
	nameField = [aCoder decodeObjectForKey:"nameField"];

	var fileDropUploadController = [[DCFileDropController alloc] 
		initWithView:self
		dropDelegate:self 
		uploadURL:[CPURL URLWithString:@"upload.php"] 
		uploadManager:[DCFileUploadManager sharedManager]];

	return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder {
	[super encodeWithCoder:aCoder];
	[aCoder encodeObject:nameField forKey:"nameField"];
}


// ******************** DCFileDropControllerDropDelegate *********************

- (void)fileDropUploadController:(DCFileDropController)theController setState:(BOOL)visible {
	if (visible) {
		[self setBackgroundColor:[CPColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:0.7]];
	} else {
		[self setBackgroundColor:[CPColor clearColor]];
	}
}

@end
