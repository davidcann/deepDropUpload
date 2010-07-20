@import <AppKit/CPPanel.j>
@import "DCFileDropRowView.j"

@implementation DCFileDropTableViewController : CPPanel {
	CPArray	list;
	CPTableView tableView @accessors;
	CPScrollView scrollView @accessors;
	CPView view @accessors;
}

- (id)init {
	self = [super init];
	if (self) {
		list = [[CPArray alloc] init];
		[list addObject:@"Drop Row One"];
		[list addObject:@"Drop Row Two"];
		[list addObject:@"Drop Row Three"];
		[list addObject:@"Drop Row Four"];
		[list addObject:@"Drop Row Five"];

		// create the table view
		tableView = [[CPTableView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
		[tableView setDataSource:self];
		[tableView setDelegate:self];

		var dataRowView = [[DCFileDropRowView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];

		var column = [[CPTableColumn alloc] initWithIdentifier:"uploads"];
		[[column headerView] setStringValue:"Example Drop Table"];
		[column setWidth:220.0];
		[column setMinWidth:50.0];
		[column setEditable:NO];
		[column setDataView:dataRowView];

		[tableView addTableColumn:column];
		[tableView setColumnAutoresizingStyle:CPTableViewLastColumnOnlyAutoresizingStyle];
		[tableView setRowHeight:40.0];
		//[tableView setSelectionHighlightStyle:CPTableViewSelectionHighlightStyleNone];

		var scrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(1, 1, 98, 98)];
		[scrollView setDocumentView:tableView];
		[scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
		[scrollView setHasHorizontalScroller:NO];

		var view = [[CPView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
		[view setBackgroundColor:[CPColor lightGrayColor]];
		[view addSubview:scrollView];

		var fileDropUploadController = [[DCFileDropController alloc] 
			initWithView:tableView
			dropDelegate:self 
			uploadURL:[CPURL URLWithString:@"upload.php"] 
			uploadManager:[DCFileUploadManager sharedManager]];
	}
	return self;
}


// ******************** CPTableView Delegate *********************

- (void)tableViewSelectionDidChange:(CPNotification)aNotification {
	var selectedRow = [tableView selectedRow];
}

- (id)tableView:(CPTableView)aTableView objectValueForTableColumn:(int)aColumn row:(int)aRow {
	return [list objectAtIndex:aRow];
}

- (int)numberOfRowsInTableView:(CPTableView)aTableView {
	return [list count];
}


// ******************** DCFileDropControllerDropDelegate *********************

- (void)fileDropUploadController:(DCFileDropController)theController setState:(BOOL)visible {
	if (visible) {
		[tableView setBackgroundColor:[CPColor greenColor]];
	} else {
		[tableView setBackgroundColor:[CPColor whiteColor]];
	}
}

@end
