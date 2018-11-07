//
//  CCRadarView.h
//  HotWallet
//
//  Created by Owen on 2018/8/3.
//  Copyright © 2018年 owen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCRadarView : UIView

/*当前雷达中心缩略图*/
@property (nonatomic,strong)UIImage * thumbnailImage;

-(instancetype)initWithFrame:(CGRect)frame andThumbnail:(NSString *)thumbnailUrl;

@end
