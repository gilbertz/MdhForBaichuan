//
//  UIImage+Overlay.m
//  AHTabBarController

#import "UIImage+Overlay.h"

@implementation UIImage (Overlay)

+ (UIImage *)imageWithColor:(UIColor *)color withSize:(CGSize)size
{
    UIImage *img = nil;

    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
            color.CGColor);
    CGContextFillRect(context, rect);
    img = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return img;


}

@end
