# dual_image_picker

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
  dual_image_picker: ^0.4.0
```

Then run:

```bash
$ flutter pub get
```

### Required Dependencies

The package requires the following dependencies:

```yaml
dependencies:
  image_picker: ^1.1.2
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

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _imageFile;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomImagePicker(
          defaultImageAsset: 'assets/images/default_avatar.png',
          onImageSelected: (file, multipartFile) {
            setState(() {
              _imageFile = file;
            });
            print('Selected image path: ${file.path}');
          },
        ),
      ),
    );
  }
}

```

```dart
//Full Example use of the Package
import 'dart:io';
import 'package:dual_image_picker/dual_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class LedgerFormPage extends StatefulWidget {
  const LedgerFormPage({super.key});

  @override
  State<LedgerFormPage> createState() => _LedgerFormPageState();
}

class _LedgerFormPageState extends State<LedgerFormPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  File? _imageFile;

  @override
  void initState() {
    super.initState();

    context.read<ProductListBloc>().add(ProductListRequested());
  }

  void _onSubmit() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formData = Map<String, dynamic>.from(_formKey.currentState!.value);
      formData['image_file'] = _imageFile;
      debugPrint('--------- Form Fields ------');
      _formKey.currentState!.fields.forEach((key, field) {
        debugPrint('$key: ${field.value}');
      });
      debugPrint('Form Data: $formData');
      debugPrint('Image File Path: ${_imageFile?.path}');
      debugPrint('Complete Form Data: $formData');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Ledger Entry',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              CustomImagePicker(
                defaultImageAsset: 'assets/images/google.png',
                onImageSelected: (file, multipartFile) {
                  setState(() {
                    _imageFile = file;
                  });
                debugPrint('-----File------');
                debugPrint('Path:${file.path}');
                },
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Create Ledger Entry',
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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

Check out the [dual_image_picker](https://github.com/919Umesh/custom_image_picker) in the repository for a complete implementation.

## Contribution

Contributions are welcome! If you find a bug or want to contribute to the code or documentation, please feel free to:

1. Open an issue
2. Create a Pull Request
3. Suggest improvements
4. Share feedback

## License

```
MIT License

Copyright (c) 2024 Umesh Shahi Thakuri

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