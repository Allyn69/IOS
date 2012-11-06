//
//  YTOLocuintaViewController.h
//  i-asigurare
//
//  Created by Administrator on 8/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTOLocuinta.h"
#import "YTOPersoana.h"
#import "YTOOferta.h"

@interface YTOLocuintaViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    IBOutlet UITableView * tableView;
    
    UITableViewCell *           cellHeader;
    UITableViewCell *           cellLocuinta;
    UITableViewCell *           cellProprietar;
    IBOutlet UITableViewCell *  cellModEvaluare;
    UITableViewCell *           cellSumaAsigurata;
    UITableViewCell *           cellSumaAsigurataRC;
    UITableViewCell *           cellDataInceput;
    UITableViewCell *           cellCalculeaza;
    YTOPersoana *  asigurat;
    YTOLocuinta *  locuinta;
    YTOOferta *    oferta; 
    UITextField * activeTextField;
}

@property (nonatomic, retain) NSDate *   DataInceput;
- (IBAction)btnModeEvaluare_Clicked:(id)sender;

- (void) initCells;
- (void) addBarButton;
- (void) deleteBarButton;

- (void) setDataInceput:(NSDate *)DataInceput;
- (void) setAsigurat:(YTOPersoana *) a;
- (void) setLocuinta:(YTOLocuinta *) a;

- (void) setSumaAsigurata:(NSString *)p;
- (void) setSumaAsigurataRC:(NSString *)p;

@end
