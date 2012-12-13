//
//  YTOAsigurariViewController.h
//  i-asigurare
//
//  Created by Andi Aparaschivei on 7/12/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTOCalculatorViewController.h"
#import "YTOCalatorieViewController.h"
#import "YTOLocuintaViewController.h"
#import "YTOCASCOViewController.h"

@interface YTOAsigurariViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView * tableView;

    UITableViewCell * cellHeader;
    
    UITableViewCell * cellAsigurareRca;
    UITableViewCell * cellAsigurareCalatorie;
    UITableViewCell * cellAsigurareLocuinta;
    UITableViewCell * cellAsigurareCasco;
    
    UITableViewCell * cellRow1;
    UITableViewCell * cellRow2;
    UITableViewCell * cellFooter;
}

- (void)showRCAView;
- (void)showCalatorieView;
- (void)showLocuintaView;
- (void)showCascoView;

@end
