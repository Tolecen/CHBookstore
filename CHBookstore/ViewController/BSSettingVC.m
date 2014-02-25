//
//  BSSettingVC.m
//  CHBookstore
//
//  Created by liuxiaoyu on 14-2-25.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "BSSettingVC.h"
#import "BSSettingStore.h"

@interface BSSettingVC ()
@property (weak, nonatomic) IBOutlet UIButton *fontWaneBtn;
@property (weak, nonatomic) IBOutlet UIButton *fontWaxBtn;
@property (weak, nonatomic) IBOutlet UIButton *minLinespacingBtn;
@property (weak, nonatomic) IBOutlet UIButton *middleLinespacingBtn;
@property (weak, nonatomic) IBOutlet UIButton *maxLinespacingBtn;
@property (weak, nonatomic) IBOutlet UIButton *dayModeBtn;
@property (weak, nonatomic) IBOutlet UIButton *softModeBtn;
@property (weak, nonatomic) IBOutlet UIButton *nightModeBtn;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (nonatomic, strong) BSSettingStore *settingStore;

@end

@implementation BSSettingVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	BSSettingStore *settingStore = [BSSettingStore defaultStore];
	self.settingStore = settingStore;
	if (settingStore.globalSettings.fontSize == 13) {
		self.fontWaneBtn.enabled = NO;
	} else if (settingStore.globalSettings.fontSize == 17) {
		self.fontWaxBtn.enabled = NO;
	}
	
	switch (settingStore.globalSettings.linespacingMode) {
		case BSLinespacingModeMin:
		{
			[self configFeatureWithButton:self.minLinespacingBtn];
		}
			break;
		case BSLinespacingModeMiddle:
		{
			[self configFeatureWithButton:self.middleLinespacingBtn];
		}
			break;
		case BSLinespacingModeMax:
		{
			[self configFeatureWithButton:self.maxLinespacingBtn];
		}
			break;
		default:
			break;
	}
	
	switch (settingStore.globalSettings.readingMode) {
		case BSReadingModeDay:
		{
			[self configFeatureWithButton:self.dayModeBtn];
		}
			break;
		case BSReadingModeSoft:
		{
			[self configFeatureWithButton:self.softModeBtn];
		}
			break;
		case BSReadingModeNight:
		{
			[self configFeatureWithButton:self.nightModeBtn];
		}
			break;
		default:
			break;
	}
}

- (void)configFeatureWithButton:(UIButton *)button {
	button.enabled = NO;
//	[button setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)changeBrightness:(UISlider *)sender {
	
}

- (IBAction)changeFontSize:(UIButton *)sender {
	if ([sender.titleLabel.text isEqualToString:@"字体变大"]) {
		if (self.settingStore.globalSettings.fontSize == 13.f) {
			self.settingStore.globalSettings.fontSize = 15.f;
			self.fontWaneBtn.enabled = YES;
		}else if (self.settingStore.globalSettings.fontSize == 15.f) {
			self.settingStore.globalSettings.fontSize = 17.f;
			sender.enabled = NO;
		}
	} else {
		if (self.settingStore.globalSettings.fontSize == 17.f) {
			self.settingStore.globalSettings.fontSize = 15.f;
			self.fontWaxBtn.enabled = YES;
		}else if (self.settingStore.globalSettings.fontSize == 15.f) {
			self.settingStore.globalSettings.fontSize = 13.f;
			sender.enabled = NO;
		}
	}
}

- (IBAction)changeLinespacing:(UIButton *)sender {
	if ([sender.titleLabel.text isEqualToString:@"间距最小"]) {
		self.settingStore.globalSettings.linespacingMode = BSLinespacingModeMin;
	} else if ([sender.titleLabel.text isEqualToString:@"间距适中"]) {
		self.settingStore.globalSettings.linespacingMode = BSLinespacingModeMiddle;
	} else {
		self.settingStore.globalSettings.linespacingMode = BSLinespacingModeMax;
	}
	[self changeLinespacingButtonState:sender];
}

- (void)refreshLinespacingBtnState {
	self.maxLinespacingBtn.enabled = YES;
	self.middleLinespacingBtn.enabled = YES;
	self.minLinespacingBtn.enabled = YES;
}

- (void)changeLinespacingButtonState:(UIButton *)button {
	[self refreshLinespacingBtnState];
	[self configFeatureWithButton:button];
}

- (IBAction)changeReadMode:(UIButton *)sender {
	if ([sender.titleLabel.text isEqualToString:@"白天模式"]) {
		self.settingStore.globalSettings.readingMode = BSReadingModeDay;
	} else if ([sender.titleLabel.text isEqualToString:@"柔和模式"]) {
		self.settingStore.globalSettings.readingMode = BSReadingModeSoft;
	} else {
		self.settingStore.globalSettings.readingMode = BSReadingModeNight;
	}
	[self changeReadingButtonState:sender];
}

- (void)refreshReadingModeBtnState {
	self.dayModeBtn.enabled = YES;
	self.softModeBtn.enabled = YES;
	self.nightModeBtn.enabled = YES;
//	[self.dayModeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//	[self.softModeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//	[self.nightModeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
}

- (void)changeReadingButtonState:(UIButton *)button{
	[self refreshReadingModeBtnState];
	[self configFeatureWithButton:button];
}

@end
