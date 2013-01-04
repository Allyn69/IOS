//
//  YTOCustomPopup.h
//  i-asigurare
//
//  Created by Andi Aparaschivei on 10/2/12.
//
//

#import <UIKit/UIKit.h>

@protocol YTOCustomPopupDelegate

-(void)chosenButton:(UIButton *)button;

@end

@interface YTOCustomPopup : UIViewController
{
    UIViewController     * parent;
    IBOutlet UILabel     * lblTitle;
    IBOutlet UILabel     * lblDescription;
    IBOutlet UIImageView * imgBackground;
    IBOutlet UIImageView * imgPopup;
    IBOutlet UIButton    * btnCustomAlertOK;
    IBOutlet UILabel     * lblCustomAlertOK;
    IBOutlet UIButton    * btnCustomAlertNO;
    IBOutlet UILabel     * lblCustomAlertNO;
    
    id<YTOCustomPopupDelegate> delegate;
}

@property (nonatomic, retain) id<YTOCustomPopupDelegate> delegate;

- (IBAction) buttonClicked:(id)sender;

- (void) showAlert:(NSString *)title withMessage:(NSString *)message andImage:(UIImage *) image delegate:(UIViewController *)parentView;

@end
