import type { ViewProps, HostComponent } from 'react-native';
import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';
import type {
  BubblingEventHandler,
  DirectEventHandler,
  Double,
  Int32,
} from 'react-native/Libraries/Types/CodegenTypes';

// Codegen-compatible type definitions
export interface FileStruct {
  url: string;
  initialLocationHref?: string;
  initialLocationTitle?: string;
}

export interface LocatorLocations {
  progression: Double;
  position?: Int32;
  totalProgression?: Double;
}

export interface LocatorEvent {
  href: string;
  type: string;
  target?: Int32;
  title?: string;
  locations?: LocatorLocations;
}

export interface LinkEvent {
  href: string;
  templated: boolean;
  type?: string;
  title?: string;
  height?: Int32;
  width?: Int32;
  bitrate?: Int32;
  duration?: Double;
}

export interface TableOfContentsEvent {
  toc: ReadonlyArray<LinkEvent>;
}

export interface NativeProps extends ViewProps {
  // File configuration
  file?: FileStruct;

  // Location (simplified - we'll pass href as primary identifier)
  locationHref?: string;
  locationTitle?: string;

  // Preferences as JSON string
  preferences?: string;

  // Dimensions
  height?: Double;
  width?: Double;

  // Events
  onLocationChange?: DirectEventHandler<LocatorEvent>;
  onTableOfContents?: DirectEventHandler<TableOfContentsEvent>;
}

export default codegenNativeComponent<NativeProps>('ReadiumView', {
  excludedPlatforms: ['web'],
}) as HostComponent<NativeProps>;
