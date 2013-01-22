//
//  YTOSecondViewController.h
//  i-asigurare
//
//  Created by Andi Aparaschivei on 7/12/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YTOAlerteViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UIView          * vwPopup;
    IBOutlet UIButton        * btnAlerte;
    
    IBOutlet UIView          * vwEmpty;
    IBOutlet UITableView     * tableView;
    NSMutableArray           * listAlerte;
    int counter;
}

@property (nonatomic, retain) UIViewController * controller;

- (IBAction)adaugaAlerta:(id)sender;
- (void) reloadData;
- (void) verifyViewMode;
- (IBAction) countClick;

- (IBAction) hidePopup;
@end
