/*
* This file is part of the SDWebImage package.
* (c) Olivier Poitrey <rs@dailymotion.com>
*
* For the full copyright and license information, please view the LICENSE
* file that was distributed with this source code.
*/

#import <Foundation/Foundation.h>
#import "SDImageIOAnimatedCoder.h"

/**
 HEIC是新出的一种图像格式，苹果的iOS 11更新后，iPhone 7及其后硬件，在拍摄照片时默认存储为HEIC格式。与JPG相比，它占用的空间更小，画质更加无损。HEIC格式照片支持iOS11及macOS High Sierra（10.13）及更新版本。但是此种格式是无法在Windows中直接使用自带的看图软件打开（疑似Windows10 RS4开始支持该格式）。
 
 所以如果想要在电脑中查看HEIC图片，最好先将HEIC转JPG，这样就可以在PC上打开iPhone HEIC照片了。
 
 
 This coder is used for HEIC (HEIF with HEVC container codec) image format.
 Image/IO provide the static HEIC (.heic) support in iOS 11/macOS 10.13/tvOS 11/watchOS 4+.
 Image/IO provide the animated HEIC (.heics) support in iOS 13/macOS 10.15/tvOS 13/watchOS 6+.
 See https://nokiatech.github.io/heif/technical.html for the standard.
 @note This coder is not in the default coder list for now, since HEIC animated image is really rare, and Apple's implementation still contains performance issues. You can enable if you need this.
 @note If you need to support lower firmware version for HEIF, you can have a try at https://github.com/SDWebImage/SDWebImageHEIFCoder
 */
@interface SDImageHEICCoder : SDImageIOAnimatedCoder <SDProgressiveImageCoder, SDAnimatedImageCoder>

@property (nonatomic, class, readonly, nonnull) SDImageHEICCoder *sharedCoder;

@end
