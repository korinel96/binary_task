//
//  ViewController.h
//  binary_task
//
//  Created by Ким Виталий on 03.02.16.
//  Copyright © 2016 korinel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{

    __weak IBOutlet UITextView *addinfo;
    __weak IBOutlet UITableView *mytable;
}

@property (weak, nonatomic) IBOutlet UIView *popup;
- (void)showInView:(UIView *)aView animated:(BOOL)animated;

@end

