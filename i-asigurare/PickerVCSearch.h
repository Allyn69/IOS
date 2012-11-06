//
//  PickerVCSearch.h
//  iRCA
//
//  Created by Administrator on 11/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTOUtils.h"
//#import "OverlayViewControllerPVCSV2.h"

@class OverlayViewControllerPVCSV2;

@protocol PickerVCSearchDelegate 

-(void)chosenIndexAfterSearch:(NSString*)selected rowIndex:(NSIndexPath *)index forView:(id)view;

@end

@interface PickerVCSearch : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>
{
    NSMutableArray *listOfItems;
    NSIndexPath * _indexPath;
    NSMutableArray *copyListOfItems;
    IBOutlet UINavigationItem * navBar;
    IBOutlet UISearchBar *searchBar;
    BOOL searching;
    BOOL letUserSelectRow;
//    OverlayViewControllerPVCSV2 * ovController;
    IBOutlet UITableView * tableView;
    id<PickerVCSearchDelegate> delegate;
    NSString * titlu;
}

@property (nonatomic, retain) NSMutableArray * listValoriMultipleIndecsi;
@property (nonatomic, retain) UITableView * tableView;
@property (nonatomic, retain) id<PickerVCSearchDelegate> delegate;
@property (nonatomic, retain) NSString * titlu;
@property (nonatomic, retain) NSMutableArray *listOfItems;
@property (nonatomic, retain) NSIndexPath * _indexPath;
@property (readwrite) Nomenclatoare nomenclator;

- (void) searchTableView;
- (void) doneSearching_Clicked:(id)sender;
- (IBAction) inapoi;

@end
