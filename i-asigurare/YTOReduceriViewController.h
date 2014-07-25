//
//  YTOReduceriViewController.h
//  i-asigurare
//
//  Created by Stern Edi on 5/16/13.
//
//

#import <UIKit/UIKit.h>
#import "YTOPersoana.h"

@interface YTOReduceriViewController : UIViewController <UITableViewDataSource , UITableViewDelegate>
{
    IBOutlet UITableView        *tableView;
    IBOutlet UITableViewCell    *cellFields;
    IBOutlet UIStepper          *stepperAnPermis;
    IBOutlet UIStepper          *stepperNrBugetari;
    
    IBOutlet UILabel * lblToateInfo;
    IBOutlet UILabel * lblAspecte;
    IBOutlet UILabel * lblCasatorit;
    IBOutlet UILabel * lblCopii;
    IBOutlet UILabel * lblPensionar;
    IBOutlet UILabel * lblHandicap;
    
    IBOutlet UILabel * lblNumarBugetari;
    IBOutlet UILabel * lblAnPermis;
    IBOutlet UILabel * lblAtentie;
    
}

@property (nonatomic, retain) YTOPersoana   *asigurat;

- (IBAction)checkboxSelected:(id)sender;
- (IBAction)nrBugetariSepper_Changed:(id)sender;
- (IBAction)anPermisSepper_Changed:(id)sender;
- (IBAction)okButton:(id)sender;
- (void)setAsigurat;
- (void) setNrBugetari:(int)k;
- (void) setAnPermis:(int)k;
- (void) setCasatorit:(BOOL)k;
- (BOOL) getCasatorit;
- (void) setCopiiMinori:(BOOL)k;
- (BOOL) getCopiiMinori;
- (void) setPensionar:(BOOL)k;
- (BOOL) getPensionar;
- (void) setHandicap:(BOOL)k;
- (BOOL) getHandicap;
@end
