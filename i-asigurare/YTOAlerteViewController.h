//
//  YTOSecondViewController.h
//  i-asigurare
//
//  Created by Administrator on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YTOAlerteViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UIView          * vwEmpty;
    IBOutlet UITableView     * tableView;
    NSMutableArray           * listAlerte;
}

@property (nonatomic, retain) UIViewController * controller;

- (IBAction)adaugaAlerta:(id)sender;
- (void) reloadData;
- (void) verifyViewMode;

@end
