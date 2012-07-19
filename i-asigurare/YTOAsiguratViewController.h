//
//  YTOAsiguratViewController.h
//  i-asigurare
//
//  Created by Administrator on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerVCSearch.h"
#import "YTOPersoana.h"

@interface YTOAsiguratViewController : UIViewController<UITabBarDelegate, UITableViewDataSource, UITextFieldDelegate, PickerVCSearchDelegate>
{
    IBOutlet UITableView * tableView;
    UITextField * activeTextField;
    IBOutlet UIBarButtonItem * btnDone;
    YTOPersoana * asigurat;
    UITableViewCell * cellNume;
    UITableViewCell * cellCodUnic;
    UITableViewCell * cellJudet;
    UITableViewCell * cellLocalitate;
    UITableViewCell * cellAdresa;
    IBOutlet UITableViewCell * cellReduceri;
    IBOutlet UIButton * btnCasatorit;
    BOOL goingBack;
}

@property (nonatomic, retain) YTOPersoana * asigurat;
- (IBAction)checkboxSelected:(id)sender;
- (void) addBarButton;
- (void) deleteBarButton;
- (void) save;
- (void) load:(YTOPersoana *)a;
@end
