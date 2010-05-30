@import <AppKit/CPProgressIndicator.j>

@implementation DCProgressIndicator : CPProgressIndicator {

}

@end

@implementation CPProgressIndicator (CPCoding)

- (id)initWithCoder:(CPCoder)aCoder {
	self = [super initWithCoder:aCoder];
	if (self) {
        _minValue = 0.0;
        _maxValue = 100.0;
        
        _doubleValue = 0.0;
        
        _style = CPProgressIndicatorHUDBarStyle;
        _isDisplayedWhenStoppedSet = NO;
        
        _controlSize = CPRegularControlSize;
        
        [self updateBackgroundColor];
        [self drawBar];

		[self setMinValue:[aCoder decodeObjectForKey:@"minValue"]];
		[self setMaxValue:[aCoder decodeObjectForKey:@"maxValue"]];

        [self setNeedsLayout];
        [self setNeedsDisplay:YES];
	}
	return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder {
	[super encodeWithCoder:aCoder];
	[aCoder encodeObject:[self minValue] forKey:@"minValue"];
	[aCoder encodeObject:[self maxValue] forKey:@"maxValue"];
}

@end
