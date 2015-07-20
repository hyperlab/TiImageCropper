/**
 * TiImageCropper
 *
 * Created by Jonatan Lundin
 * Copyright (c) 2015 Your Company. All rights reserved.
 */

#import "SeHyperlabImagecropperModule.h"

#import "TiApp.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@implementation SeHyperlabImagecropperModule

@synthesize cropViewNavigationController, doneCallback, cancelCallback, maxSize;

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"3f9278fb-c443-430a-8b6c-e7ee932b746c";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"se.hyperlab.imagecropper";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];

	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably

	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup
-(void)cleanup
{
    doneCallback = nil;
    cancelCallback = nil;
    cropViewNavigationController = nil;
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}


#pragma Public APIs

MAKE_SYSTEM_PROP(CROP_MODE_SQUARE, RSKImageCropModeSquare);
MAKE_SYSTEM_PROP(CROP_MODE_CIRCLE, RSKImageCropModeCircle);

-(void)open:(id)args
{
    TiThreadPerformOnMainThread(^{
        TiBlob *blob;
        NSDictionary *dict;
        NSNumber *cropModeArg;
        
        ENSURE_ARG_OR_NIL_AT_INDEX(dict, args, 0, NSDictionary);
        
        ENSURE_ARG_FOR_KEY(blob, dict, @"image", TiBlob);
        ENSURE_ARG_FOR_KEY(doneCallback, dict, @"success", KrollCallback);
        ENSURE_ARG_OR_NIL_FOR_KEY(cancelCallback, dict, @"cancel", KrollCallback);
        ENSURE_ARG_OR_NIL_FOR_KEY(cropModeArg, dict, @"cropMode", NSNumber);

        maxSize = [TiUtils intValue:@"size" properties:dict def:-1];

        RSKImageCropMode cropMode = RSKImageCropModeSquare;
        if (cropModeArg != nil) {
            cropMode = (RSKImageCropMode)[cropModeArg integerValue];
        }
        
        UIImage* image = [blob image];
        
        RSKImageCropViewController *controller = [[RSKImageCropViewController alloc] initWithImage:image
                                                                                          cropMode:cropMode];
        controller.delegate = self;
        controller.rotationEnabled = YES;
        controller.avoidEmptySpaceAroundImage = YES;
        
        cropViewNavigationController = [[UINavigationController alloc] initWithRootViewController:controller];
        [[TiApp app] showModalController:cropViewNavigationController animated:YES];
    }, YES);
}


#pragma RSKImageCropViewControllerDelegate

// Crop image has been canceled.
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    if (cancelCallback != nil) {
        [self _fireEventToListener:@"cancel" withObject:@{} listener:cancelCallback thisObject:self];
    }
    [[TiApp app] hideModalController:cropViewNavigationController animated:YES];
    [self cleanup];
}

// The original image has been cropped. Additionally provides a rotation angle used to produce image.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                   didCropImage:(UIImage *)croppedImage
                  usingCropRect:(CGRect)cropRect
                  rotationAngle:(CGFloat)rotationAngle
{
    if (doneCallback != nil) {
        TiRect *rect = [[TiRect alloc] init];
        [rect setRect:cropRect];
        
        if (maxSize && maxSize > -1) {
            CGSize size = CGSizeMake(maxSize, maxSize);
            croppedImage = [self imageWithImage:croppedImage andSize:size];
        }
        
        NSDictionary *event = @{
                               @"image": [self blobWithImage:croppedImage andCompression:0.9],
                               @"rect": rect,
                               @"rotationAngle": [NSNumber numberWithFloat:rotationAngle]
                               };
        [self _fireEventToListener:@"success" withObject:event listener:doneCallback thisObject:self];
    }
    [[TiApp app] hideModalController:cropViewNavigationController animated:YES];
    [self cleanup];
}

- (UIImage *)imageWithImage:(UIImage *)image andSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

- (TiBlob *)blobWithImage:(UIImage *)image andCompression:(float)compression
{
    return [[TiBlob alloc] initWithData:UIImageJPEGRepresentation(image, compression) mimetype:@"image/jpeg"];
}

@end
