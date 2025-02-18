# custom_image_picker

A Flutter package that provides a customizable image picker widget with options to select images from gallery or camera. Features an elegant bottom sheet design and seamless integration with Flutter applications.


## Features

- 🖼️ Customizable profile image with default image asset support
- 📸 Integrated gallery and camera image selection
- 🎨 Elegant bottom sheet design for image source selection
- ⚙️ Flexible customization options (avatar radius, colors, etc.)
- 📤 Built-in support for Dio uploads
- 🔄 Automatic image compression and optimization
- ✨ Clean and intuitive UI

## Getting Started

### Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  custom_image_picker: ^1.0.0
```

Then run:

```bash
$ flutter pub get
```

### Required Dependencies

The package requires the following dependencies:

```yaml
dependencies:
  image_picker: ^0.8.5+3
  dio: ^5.0.0
```

### Android Setup

Add the following permissions to your `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

### iOS Setup

Add the following keys to your `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to take photos for profile picture.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs photos access to select profile picture from gallery.</string>
```

## Usage

### Basic Implementation

```dart
import 'package:flutter/material.dart';
import 'package:custom_image_picker/custom_image_picker.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomImagePicker(
          defaultImageAsset: 'assets/images/default_avatar.png',
          onImageSelected: (file, multipartFile) {
            // Handle the selected image
            print('Selected image path: ${file.path}');
          },
        ),
      ),
    );
  }
}
```

### Advanced Implementation

```dart
CustomImagePicker(
  currentImage: existingImageFile, // File object of existing image
  defaultImageAsset: 'assets/images/default_avatar.png',
  radius: 60.0,
  bottomSheetIndicatorColor: Colors.blue,
  tileTextColor: Colors.blueGrey,
  onImageSelected: (file, multipartFile) async {
    try {
      // Example: Upload to server using Dio
      final formData = FormData.fromMap({
        'profile_image': multipartFile,
      });
      
      final response = await Dio().post(
        'your-api-endpoint',
        data: formData,
      );
      
      if (response.statusCode == 200) {
        print('Image uploaded successfully');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  },
)
```

## Available Properties

| Property | Type | Description | Default |
|----------|------|-------------|---------|
| `currentImage` | `File?` | Currently selected image file | `null` |
| `radius` | `double` | Radius of the circular avatar | `50.0` |
| `defaultImageAsset` | `String` | Asset path for default image | Required |
| `onImageSelected` | `Function(File, MultipartFile)` | Callback when image is selected | Required |
| `bottomSheetIndicatorColor` | `Color?` | Color of bottom sheet indicator | `Colors.green` |
| `tileTextColor` | `Color?` | Color of option text in bottom sheet | `Colors.black` |

## Example Project

Check out the [example project](https://github.com/yourusername/custom_image_picker/tree/main/example) in the repository for a complete implementation.

```dart
import 'package:flutter/material.dart';
import 'package:custom_image_picker/custom_image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Custom Image Picker Example'),
        ),
        body: Center(
          child: CustomImagePicker(
            defaultImageAsset: 'assets/images/default_avatar.png',
            radius: 75.0,
            bottomSheetIndicatorColor: Colors.blue,
            onImageSelected: (file, multipartFile) {
              print('Image selected: ${file.path}');
            },
          ),
        ),
      ),
    );
  }
}
```

## Contribution

Contributions are welcome! If you find a bug or want to contribute to the code or documentation, please feel free to:

1. Open an issue
2. Create a Pull Request
3. Suggest improvements
4. Share feedback

## License

```
MIT License

Copyright (c) 2024 Your Name

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```