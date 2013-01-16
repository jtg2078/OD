//
//  SelectionViewController.h
//  OD
//
//  Created by jason on 1/16/13.
//  Copyright (c) 2013 jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SelectionViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    
}

@property (nonatomic, assign) int questionIndex;
@property (nonatomic, assign) NSMutableArray *selectState;

@end
