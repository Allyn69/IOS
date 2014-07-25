//
//  CellNotificareCustom.h
//  i-asigurare
//
//  Created by Administrator on 4/29/13.
//
//

#import <UIKit/UIKit.h>
#import "UILabel+dynamicSizeMe.h"

@interface CellNotificareCustom : UITableViewCell
{
    
    IBOutlet UILabel     * lblDataNotificare;
    IBOutlet UILabel     * lblDetaliiNotificare;
}

- (void) setDetaliiNotificare:(NSString *) v;
- (void) setDataNotificare:(NSString *) v;
@end
