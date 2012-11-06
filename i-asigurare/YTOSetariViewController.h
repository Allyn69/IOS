//
//  YTOSetariViewController.h
//  i-asigurare
//
//  Created by Administrator on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTOAppDelegate.h"
#import "YTOAutovehicul.h"

@interface YTOSetariViewController : UIViewController<NSXMLParserDelegate, UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView * tableView;
    UITableViewCell * cellHeader;
    UITableViewCell * cellProfilulMeu;
    UITableViewCell * cellMasinileMele;
    UITableViewCell * cellLocuinteleMele;
    UITableViewCell * cellAltePersoane;
    UITableViewCell * cellComenzileMele;
    
    IBOutlet UIImageView * imgAnimation;
    
    // SYNC
    NSMutableArray       * listaObiecte;
    YTOAutovehicul       * masina;
    NSMutableData        * responseData;
	NSMutableData        * capturedCharactes;
	NSMutableString      * currentElementValue;
    NSString             * jsonMasini;
    NSString             * jsonProprietar;
    
    IBOutlet UIView      * vwLoading;
}

@property (nonatomic, retain) NSMutableData * responseData;

- (void) initCells;
- (void) reloadData;
- (void) startLoadingAnimantion;
- (void) stopLoadingAnimantion;

- (void) showCustomLoading;
- (IBAction) hideCustomLoading;

@end
