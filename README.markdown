DCFileDropUpload
==========

EKActivityIndicatorView is a class for displaying those "here spins something the app isn't crashed"-wheels for the [Cappuccino](http://www.cappuccino.org) framework.

It works completely without images by drawing the animation with CoreGraphics. This guarantees a stunning performance and the ability of setting the view's size and color with ease. All this is brought to you by a 3.5 KB file.

Click here to see a [DEMO](http://elias.klughammer.com/EKActivityIndicatorView/)


## Installation

Simply import the file in your application's AppController or any other class:

	@import "EKActivityIndicatorView.j"


## Usage

Inserting an EKActivityIndicatorView in your application is dead simple:

	var spinner = [[EKActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
	
Set your favorite color:
	
	[spinner setColor:[CPColor someColor]];

Start the animation:

	[spinner startAnimating];

And if you have enough, stop it:

	[spinner stopAnimating];


