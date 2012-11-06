//
//  CellAlertaCustom.h
//  i-asigurare
//
//  Created by Administrator on 10/30/12.
//
//

#import <UIKit/UIKit.h>

@interface CellAlertaCustom : UITableViewCell
{
    IBOutlet UIImageView * img;
    IBOutlet UILabel     * lblTipAlerta;
    IBOutlet UILabel     * lblDetaliuAlerta;
    IBOutlet UILabel     * lblNumar;
}

- (void) setAlertaImage:(UIImage *)img;
- (void) setTipAlerta:(NSString *) v;
- (void) setDetaliuAlerta:(NSString *)v;
- (void) setNumar:(NSString *)v;

@end
