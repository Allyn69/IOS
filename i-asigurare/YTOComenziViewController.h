//
//  YTOComenziViewController.h
//  i-asigurare
//
//  Created by Administrator on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTOOferta.h"

@interface YTOComenziViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView * tableView;
    NSMutableArray       * list;
    
    IBOutlet UIView      * vwEmpty;
    BOOL editingMode;    
}

- (void) verifyViewMode;
- (void) reloadData;
- (IBAction)addAsigurare:(id)sender;

@end
