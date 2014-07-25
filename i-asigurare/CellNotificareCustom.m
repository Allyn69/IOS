//
//  CellNotificareCustom.m
//  i-asigurare
//
//  Created by Administrator on 4/29/13.
//
//

#import "CellNotificareCustom.h"
#import "YTOUtils.h"
#import "UILabel+dynamicSizeMe.h"

@implementation CellNotificareCustom

//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        img = [[UIImageView alloc] initWithFrame:CGRectMake(13, 23, 13, 13)];
//        
//        lblDetaliiNotificare.textColor = [UIColor blackColor];
//        lblDetaliiNotificare.textAlignment = UITextAlignmentCenter;
//        lblDetaliiNotificare.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:14];
//        
//        [self.contentView addSubview:img];
//        [self.contentView addSubview:lblDetaliiNotificare];
//    }
//    return self;
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void) setDataNotificare:(NSString *) v
{
    lblDataNotificare.text = v;
}


- (void) setDetaliiNotificare:(NSString *) v
{
    lblDetaliiNotificare.text = v;
    [lblDetaliiNotificare resizeToFit];
}

@end
