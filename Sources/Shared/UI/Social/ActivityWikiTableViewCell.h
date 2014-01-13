//
//  ActivityWikiTableViewCell.h
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 10/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityBasicTableViewCell.h"



@interface ActivityWikiTableViewCell : ActivityBasicTableViewCell {

    RTLabel*                      _lbMessage;
    RTLabel*                      _lbTitle;
    RTLabel*                      _htmlName;
}


@property (retain, nonatomic) RTLabel* lbMessage;
@property (retain, nonatomic) RTLabel* htmlName;
@property (retain, nonatomic) RTLabel* lbTitle;



@end
