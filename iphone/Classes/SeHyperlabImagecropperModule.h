/**
 * TiImageCropper
 *
 * Created by Jonatan Lundin
 * Copyright (c) 2015 Your Company. All rights reserved.
 */

#import "TiModule.h"
#import "RSKImageCropViewController.h"

@interface SeHyperlabImagecropperModule : TiModule  <RSKImageCropViewControllerDelegate>
{
}

@property UINavigationController *cropViewNavigationController;
@property KrollCallback *doneCallback;
@property KrollCallback *cancelCallback;

@end
