//
//  YTOComenziViewController.h
//  i-asigurare
//
//  Created by Andi Aparaschivei on 7/26/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTOOferta.h"


@interface YTOComenziViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView * tableView;
    NSMutableArray       * list;
    
    IBOutlet UIView      * vwEmpty;
    BOOL editingMode;
    
    IBOutlet UITableViewCell * cellHead;
    
    IBOutlet UILabel * lblZeroComenzi;
}

@property (nonatomic, retain) UIViewController * controller;

- (void) verifyViewMode;
- (void) reloadData;
- (IBAction)addAsigurare:(id)sender;

@end
