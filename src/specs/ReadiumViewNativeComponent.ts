import type { ViewProps, HostComponent } from 'react-native';
import type { DirectEventHandler } from 'react-native/Libraries/Types/CodegenTypes';
import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';

export interface LocatorData {
  href: string;
  type: string;
  target?: number;
  title?: string;
  locations?: {
    progression: number;
    position?: number;
    totalProgression?: number;
  };
}

export interface LinkData {
  href: string;
  templated: boolean;
  type?: string | null;
  title?: string | null;
  height?: number | null;
  width?: number | null;
  bitrate?: number | null;
  duration?: number | null;
}

export interface FileData {
  url: string;
}

export interface LocationChangeEvent {
  locator: LocatorData;
}

export interface TableOfContentsEvent {
  toc: ReadonlyArray<LinkData> | null;
}

export interface NativeProps extends ViewProps {
  file?: FileData;
  location?: LocatorData | LinkData;
  preferences?: string;
  height?: number;
  width?: number;
  onLocationChange?: DirectEventHandler<LocationChangeEvent>;
  onTableOfContents?: DirectEventHandler<TableOfContentsEvent>;
}

export default codegenNativeComponent<NativeProps>(
  'ReadiumView'
) as HostComponent<NativeProps>;
