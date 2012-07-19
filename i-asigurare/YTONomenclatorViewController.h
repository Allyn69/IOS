//
//  YTONomenclatorViewController.h
//  i-asigurare
//
//  Created by Administrator on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTOUtils.h"
#import "KeyValueItem.h"

@protocol YTONomenclatorDelegate

-(void)nomenclatorChosen:(KeyValueItem *)item rowIndex:(NSIndexPath *)index forView:(id)view;

@end

@interface YTONomenclatorViewController : UIViewController<UIScrollViewDelegate>
{
    IBOutlet UIScrollView * scrollView;
    id<YTONomenclatorDelegate> delegate;
}

@property (nonatomic, retain) NSMutableArray * listOfItems;
@property (nonatomic, retain) id<YTONomenclatorDelegate> delegate;
@property (readwrite) Nomenclatoare nomenclator;

@end
