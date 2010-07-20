@import <AppKit/CPPanel.j>
@import "DCFileDropCollectionViewItemView.j"

@implementation DCFileDropCollectionViewController : CPPanel {
	CPArray	list;
	CPCollectionView collectionView @accessors;
	CPScrollView scrollView @accessors;
	CPView view @accessors;
}

- (id)init {
	self = [super init];
	if (self) {
		list = [[CPArray alloc] init];
		[list addObject:@"Item\nOne"];
		[list addObject:@"Item\nTwo"];
		[list addObject:@"Item\nThree"];
		[list addObject:@"Item\nFour"];
		[list addObject:@"Item\nFive"];

		// create the collection view
		collectionView = [[CPCollectionView alloc] initWithFrame:CGRectMake(0, 0, 98, 98)];
		[collectionView setMinItemSize:CGSizeMake(60, 60)];
		[collectionView setMaxItemSize:CGSizeMake(60, 60)];
		[collectionView setContent:list];
		[collectionView setSelectable:YES];
		[collectionView setAllowsMultipleSelection:NO];
		[collectionView setDelegate:self];
		[collectionView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];

		// create the item prototype
		var itemPrototype = [[CPCollectionViewItem alloc] init];
		var itemView = [[DCFileDropCollectionViewItemView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
		[itemPrototype setView:itemView];
		[collectionView setItemPrototype:itemPrototype];

		var scrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(1, 1, 98, 98)];
		[scrollView setBackgroundColor:[CPColor whiteColor]];
		[scrollView setDocumentView:collectionView];
		[scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
		[scrollView setHasHorizontalScroller:NO];

		var view = [[CPView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
		[view setBackgroundColor:[CPColor lightGrayColor]];
		[view addSubview:scrollView];

		var fileDropUploadController = [[DCFileDropController alloc] 
			initWithView:collectionView
			dropDelegate:self 
			uploadURL:[CPURL URLWithString:@"upload.php"] 
			uploadManager:[DCFileUploadManager sharedManager]
			insertAsFirstSubview:YES];
	}
	return self;
}


// ******************** DCFileDropControllerDropDelegate *********************

- (void)fileDropUploadController:(DCFileDropController)theController setState:(BOOL)visible {
	if (visible) {
		[collectionView setBackgroundColor:[CPColor orangeColor]];
	} else {
		[collectionView setBackgroundColor:[CPColor whiteColor]];
	}
}

@end
