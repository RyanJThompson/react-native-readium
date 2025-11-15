#ifdef RCT_NEW_ARCH_ENABLED
#import "ReadiumViewComponentView.h"

#import <react/renderer/components/RNReadiumSpec/ComponentDescriptors.h>
#import <react/renderer/components/RNReadiumSpec/EventEmitters.h>
#import <react/renderer/components/RNReadiumSpec/Props.h>
#import <react/renderer/components/RNReadiumSpec/RCTComponentViewHelpers.h>

#import "RCTFabricComponentsPlugins.h"
#import "react-native-readium-Swift.h"

using namespace facebook::react;

@interface ReadiumViewComponentView () <RCTReadiumViewViewProtocol>
@end

@implementation ReadiumViewComponentView {
  ReadiumView *_view;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
  return concreteComponentDescriptorProvider<ReadiumViewComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const ReadiumViewProps>();
    _props = defaultProps;

    _view = [[ReadiumView alloc] init];

    self.contentView = _view;
  }

  return self;
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
  const auto &oldViewProps = *std::static_pointer_cast<ReadiumViewProps const>(_props);
  const auto &newViewProps = *std::static_pointer_cast<ReadiumViewProps const>(props);

  // Update file prop
  if (oldViewProps.file != newViewProps.file && newViewProps.file) {
    auto file = newViewProps.file;
    NSMutableDictionary *fileDict = [[NSMutableDictionary alloc] init];
    if (file.url) {
      fileDict[@"url"] = [NSString stringWithUTF8String:file.url.c_str()];
    }
    [_view setFile:fileDict];
  }

  // Update location prop
  if (oldViewProps.location != newViewProps.location && newViewProps.location) {
    auto location = newViewProps.location;
    NSMutableDictionary *locationDict = [[NSMutableDictionary alloc] init];
    if (location.href) {
      locationDict[@"href"] = [NSString stringWithUTF8String:location.href.c_str()];
    }
    if (location.type) {
      locationDict[@"type"] = [NSString stringWithUTF8String:location.type.c_str()];
    }
    // Add other location fields as needed
    [_view setLocation:locationDict];
  }

  // Update preferences prop
  if (oldViewProps.preferences != newViewProps.preferences && newViewProps.preferences) {
    NSString *preferences = [NSString stringWithUTF8String:newViewProps.preferences.c_str()];
    [_view setPreferences:preferences];
  }

  [super updateProps:props oldProps:oldProps];
}

- (void)prepareForRecycle
{
  [super prepareForRecycle];
  // Reset view state if needed
}

@end

Class<RCTComponentViewProtocol> ReadiumViewCls(void)
{
  return ReadiumViewComponentView.class;
}

#endif /* RCT_NEW_ARCH_ENABLED */
