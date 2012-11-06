//
//  YTOWebServiceLocuintaViewController.h
//  i-asigurare
//
//  Created by Administrator on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTOAppDelegate.h"
#import "YTOOferta.h"
#import "CotatieLocuinta.h"
#import "CellTarifCustom.h"

@interface YTOWebServiceLocuintaViewController : UIViewController<NSXMLParserDelegate,UITableViewDataSource, UITableViewDelegate>
{
    NSMutableData * responseData;
	NSMutableData * capturedCharactes;
	NSMutableString * currentElementValue;
	
	CotatieLocuinta * cotatie;
	YTOAppDelegate * appDelegate;
    
    NSString *              jsonString;
    
    IBOutlet UITableView *  tableView;
    IBOutlet UIView *       vwLoading;
    IBOutlet UIImageView *  imgLoading;
}

//@property (nonatomic, retain) CotatieCalatorie * cotatie;
@property (nonatomic, retain) NSMutableArray * listTarife;
@property (nonatomic, retain) NSMutableData * responseData;
@property (nonatomic, retain) YTOOferta *       oferta;

- (void) calculLocuinta;
- (NSString *) XmlRequest;
- (void) startLoadingAnimantion;
- (void) stopLoadingAnimantion;

@end
