//
//  ELCImagePickerController.h
//  ELCImagePickerDemo
//
//  Created by ELC on 9/9/10.
//  Copyright 2010 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCAssetSelectionDelegate.h"

@interface ELCImagePickerController : UINavigationController <ELCAssetSelectionDelegate> {

	id delegate;
}

@property (nonatomic, assign) id delegate;

-(void)cancelImagePicker;

@end

@protocol ELCImagePickerControllerDelegate

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info;
- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker;

@end

