//
//  ViewController.h
//  ObjectOverlayOnVideoDemo
//
//  Created by Krupa-iMac on 06/05/14.
//  Copyright (c) 2014 TheAppGuruz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"

@interface ViewController : UIViewController
{
    GPUImageMovie *movieFile;
    GPUImageFilter *filter;
    GPUImageMovieWriter *movieWriter;
    GPUImageUIElement *uiElementInput;
}

@property (nonatomic,strong) IBOutlet UIView *vwVideo;

@end
