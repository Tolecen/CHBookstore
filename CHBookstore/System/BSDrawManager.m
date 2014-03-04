//
//  BSDrawManager.m
//  CHBookstore
//
//  Created by liuxiaoyu on 14-3-4.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#define BOOK_FONT_NAME    "HelveticaNeue-Light"

#import "BSDrawManager.h"

@implementation BSPageInfo

@end

#import "BSSettingStore.h"
@import CoreText;

@interface BSDrawManager() {
	CFMutableAttributedStringRef _contentStringRef;
	CFMutableAttributedStringRef _volumeStringRef;
}

@property (nonatomic) CGFloat fontSize;

@property (nonatomic) CGFloat linespacingHeight;

@property (nonatomic, strong) UIColor *fontColor;

@property (nonatomic) BSReadingMode readingMode;

@property (nonatomic) CGRect drawFrame;

@property (nonatomic) CGSize viewSize;

@property (nonatomic) CGFloat suggestedHeight;

@property (nonatomic) CGFloat topEmptyHeight;

@property (nonatomic) CGFloat volumeContentHeight;

@property (nonatomic) CGSize contentSize;

@property (nonatomic) CGFloat initPageY;

@end

@implementation BSDrawManager

+ (BSDrawManager *)defaultManager {
	static BSDrawManager *_defaultManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_defaultManager = [[BSDrawManager alloc] init];
		[_defaultManager configDefaults];
	});
	return _defaultManager;
}

- (void)configDefaults {
//	CGFloat scale = [UIScreen mainScreen].scale;
	CGFloat scale = 1;
	_viewSize = CGSizeMake(320.0f, 548.0f);
	CGFloat edgeEmptyLength = 18.0f;
	_contentSize = CGSizeMake(_viewSize.width - 2.0 * edgeEmptyLength, 452.5f);
	_drawFrame = CGRectMake(edgeEmptyLength * scale, 60.0f * scale, _contentSize.width * scale, _contentSize.height * scale);
	_suggestedHeight = 20.0f;
	_topEmptyHeight = 6.0f;
	_volumeContentHeight = 18.0f;
	_initPageY = 46.0f;
}

- (void)acquireGlobalSettingFromSettingStore {
	BSSettingStore *settingStore = [BSSettingStore defaultStore];
	self.fontSize = settingStore.globalSettings.fontSize;
	self.linespacingHeight = linespacingHeightFromLinespacingmode(settingStore.globalSettings.linespacingMode);
	self.readingMode = settingStore.globalSettings.readingMode;
	self.fontColor = colorFromReadingMode(self.readingMode);
}

- (void)setTxtElement:(NSString *)txtElement {
	if (_txtElement == txtElement) {
		return;
	}
	_txtElement = txtElement;
}

- (void)setVolumeName:(NSString *)volumeName {
	if (_volumeName == volumeName) {
		return;
	}
	_volumeName = volumeName;
}

- (void)createVolumeAttribute:(CFStringRef)string {
	[self acquireGlobalSettingFromSettingStore];
	if (_volumeStringRef != NULL) {
		CFRelease(_volumeStringRef);
	}
//	CGFloat scale = [UIScreen mainScreen].scale;
	CGFloat scale = 1;
	_volumeStringRef = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
	//将需要被显示的字符串设置到属性字符串中
	CFAttributedStringReplaceString(_volumeStringRef, CFRangeMake(0, 0), string);
	
	CGColorRef fontColor = [UIColor brownColor].CGColor;
	CFAttributedStringSetAttribute(_volumeStringRef, CFRangeMake(0, CFStringGetLength(string)), kCTForegroundColorAttributeName, fontColor);
	
	CTFontRef font = CTFontCreateWithName(CFSTR(BOOK_FONT_NAME), self.fontSize * scale, &CGAffineTransformIdentity);
	CFAttributedStringSetAttribute(_volumeStringRef, CFRangeMake(0, CFStringGetLength(string)), kCTFontAttributeName, font);
	CFRelease(font);
}

- (void)createContentString:(CFStringRef)string isForRender:(BOOL)render {
	[self acquireGlobalSettingFromSettingStore];
	if (_contentStringRef != NULL) {
		CFRelease(_contentStringRef);
	}
//	CGFloat scale = [UIScreen mainScreen].scale;
	CGFloat scale = 1;
	
	const CGFloat scaleFactor = render?scale:1.f;
	_contentStringRef = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
	
	CFAttributedStringReplaceString(_contentStringRef, CFRangeMake(0, 0), string);
	
	CGColorRef fontColor = self.fontColor.CGColor;
	CFAttributedStringSetAttribute(_contentStringRef, CFRangeMake(0, CFStringGetLength(string)), kCTForegroundColorAttributeName, fontColor);

	CTFontRef font = CTFontCreateWithName(CFSTR(BOOK_FONT_NAME), self.fontSize *scaleFactor, &CGAffineTransformIdentity);
	CFAttributedStringSetAttribute(_contentStringRef, CFRangeMake(0, CFStringGetLength(string)), kCTFontAttributeName, font);
	CFRelease(font);
	
	CTParagraphStyleRef paragraph = CTParagraphStyleCreate((const CTParagraphStyleSetting[]){
		{.spec = kCTParagraphStyleSpecifierLineHeightMultiple, .valueSize = sizeof(CGFloat), .value = (CGFloat[]){self.linespacingHeight} },
        {.spec = kCTParagraphStyleSpecifierFirstLineHeadIndent, .valueSize = sizeof(CGFloat), .value = (CGFloat[]){self.fontSize} }
	}, 2);
	
	CFAttributedStringSetAttribute(_contentStringRef, CFRangeMake(0, CFStringGetLength(string)), kCTParagraphStyleAttributeName, paragraph);
	CFRelease(paragraph);
}

- (void)renderInContext:(CGContextRef)ctx pageIndex:(NSUInteger)index {
	NSUInteger textLength = [self.txtElement length];
	unichar *contentBuffer = (unichar *)malloc(sizeof(*contentBuffer) *textLength);
	[self.txtElement getCharacters:contentBuffer];
//	self.txtElement getCharacters:contentBuffer range:NSMakeRange(<#NSUInteger loc#>, <#NSUInteger len#>)
	
	CFStringRef stringRef = CFStringCreateWithCharacters(kCFAllocatorDefault, contentBuffer, textLength);
	[self createContentString:stringRef isForRender:YES];
	CFRelease(stringRef);
	free(contentBuffer);
	
	CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString(_contentStringRef);
	CFRelease(_contentStringRef);
	_contentStringRef = NULL;
	
//	CGFloat scale = [UIScreen mainScreen].scale;
	CGFloat scale = 1;
	
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathAddRect(path, NULL, _drawFrame);
	CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
	CGPathRelease(path);
	CFRelease(frameSetter);
	
	backgroundColorFromReadingMode(self.readingMode, ctx);
	
	CGContextFillRect(ctx, CGRectMake(0, 0, _viewSize.width * scale, _viewSize.height * scale));
	
	CGContextTranslateCTM(ctx, 0.f, _viewSize.height * scale);
	CGContextScaleCTM(ctx, 1.f, -1.f);
	CTFrameDraw(frame, ctx);
	CFRelease(frame);
	
	textLength = [_volumeName length];
	contentBuffer = (unichar *)malloc(sizeof(*contentBuffer) *textLength);
	[_volumeName getCharacters:contentBuffer];
	
	stringRef = CFStringCreateWithCharacters(kCFAllocatorDefault, contentBuffer, textLength);
	[self createVolumeAttribute:stringRef];
	CFRelease(stringRef);
	free(contentBuffer);
	
	frameSetter = CTFramesetterCreateWithAttributedString(_volumeStringRef);
	CFRelease(_volumeStringRef);
	_volumeStringRef = NULL;
	
	CFRange suggestedRange;
	CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter, CFRangeMake(0, CFStringGetLength(stringRef)), NULL, CGSizeMake(_viewSize.width * scale, _suggestedHeight * scale), &suggestedRange);
	
	path = CGPathCreateMutable();
	CGPathAddRect(path, NULL, CGRectMake((_viewSize.width * scale - suggestedSize.width) * scale, (_viewSize.height - _topEmptyHeight - _volumeContentHeight) * scale, _contentSize.width * scale, _volumeContentHeight * scale));
	
	frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
	CGPathRelease(path);
	CFRelease(frameSetter);
	
	CTFrameDraw(frame, ctx);
	CFRelease(frame);
	
	NSString *str = [NSString stringWithFormat:@"第%u页 ／ 共%u页", index + 1, _totalPages];
    textLength = [str length];
    contentBuffer = (unichar*)malloc(sizeof(*contentBuffer) * textLength);
    [str getCharacters:contentBuffer];
    
    stringRef = CFStringCreateWithCharacters(CFAllocatorGetDefault(), contentBuffer, textLength);
    [self createVolumeAttribute:stringRef];
    CFRelease(stringRef);
    free(contentBuffer);
    
    frameSetter = CTFramesetterCreateWithAttributedString(_volumeStringRef);
    
    suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter, CFRangeMake(0, textLength), NULL, CGSizeMake(_viewSize.width * scale, _suggestedHeight * scale), &suggestedRange);
    
    CFRelease(_volumeStringRef);
    _volumeStringRef = NULL;
    
    path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake((_viewSize.width * scale - suggestedSize.width) * 0.5f, _initPageY * scale, _contentSize.width * scale, _volumeContentHeight * scale));
    
    frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    CGPathRelease(path);
    CFRelease(frameSetter);
    
    CTFrameDraw(frame, ctx);
    CFRelease(frame);
}

- (void)divideParagraphs:(NSString *)txtElement flags:(NSMutableArray *)flags {
	NSUInteger textLength = [txtElement length];
	unichar *contentBuffer = (unichar *)malloc(sizeof(*contentBuffer) *textLength);
	[txtElement getCharacters:contentBuffer];
	
	CFMutableStringRef string = CFStringCreateMutable(CFAllocatorGetDefault(), textLength);
    CFStringAppendCharacters(string, contentBuffer, textLength);
    free(contentBuffer);

	[self createContentString:string isForRender:NO];
	NSUInteger index = 0;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0.0f, 0.0f, _contentSize.width, _contentSize.height));
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString(_contentStringRef);
	do
    {
        CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(index, 0), path, NULL);
        
        CFRange range = CTFrameGetVisibleStringRange(frame);
        
        CFRelease(frame);
        
        BSPageInfo *pageInfo = [[BSPageInfo alloc] init];
        pageInfo.pageIndex = index;
        pageInfo.pageLength = range.length;
        [flags addObject:pageInfo];
        
        index += range.length;
    }
    while(index < textLength);
    
    CFRelease(string);
    CGPathRelease(path);
    CFRelease(_contentStringRef);
    CFRelease(frameSetter);
    _contentStringRef = NULL;
}

@end
