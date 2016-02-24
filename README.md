# Titanium Image Cropper

## Description

A cross platform image cropper for Titanium mobile.

The iOS version uses [RSKImageCropper](https://github.com/ruslanskorb/RSKImageCropper) and the
Android version uses [android-crop](https://github.com/jdamcd/android-crop).

## Usage

```js
var imageCropper = require('se.hyperlab.imagecropper');

if (OS_ANDROID){
    imageCropper.open({
      image: originalImage,
      aspect_x: 1,
      aspect_y: 2,
      max_x: 300,
      max_y: 300,
      //size: 960,  // for square images with aspect_x = aspect_y = 1
      error: function (e) {
        console.error('[CROPPING ERROR] ' + e);
      },
      success: function (e) {
        someImageView.image = e.image;
      }
    });    
} else {
    imageCropper.open({
      image: originalImage,
      size: 960,
      error: function (e) {
        console.error('[CROPPING ERROR] ' + e);
      },
      success: function (e) {
        someImageView.image = e.image;
      }
    });
}
```

You will also need to install and include the module in your `tiapp.xml` file.


## Known Issues

* Only crops to squares
* Potential memory issues with big images on android

## Changes

See the releases tab on Github for a list of changes.

## Contributors

**Jonatan Lundin**  
Web: http://hyperlab.se  
Twitter: @mr_lundis  

## License

The MIT License (MIT)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
