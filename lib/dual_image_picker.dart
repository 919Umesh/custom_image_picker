library custom_image_picker;

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomImagePicker extends StatelessWidget {
  final File? currentImage;
  final double radius;
  final String defaultImageAsset;
  final Function(File file, MultipartFile multipartFile) onImageSelected;
  final Color? bottomSheetIndicatorColor;
  final Color? tileTextColor;

  const CustomImagePicker({
    super.key,
    this.currentImage,
    this.radius = 50.0,
    required this.defaultImageAsset,
    required this.onImageSelected,
    this.bottomSheetIndicatorColor = Colors.green,
    this.tileTextColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showImagePickerBottomSheet(context),
      child: _buildProfileImage(),
    );
  }

  Widget _buildProfileImage() {
    return CircleAvatar(
      radius: radius,
      backgroundImage: currentImage != null
          ? FileImage(currentImage!)
          : AssetImage(defaultImageAsset) as ImageProvider,
    );
  }

  Future<void> _showImagePickerBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => _buildBottomSheet(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(50.0)),
      ),
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(50.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              height: 7.0,
              width: 50.0,
              decoration: BoxDecoration(
                color: bottomSheetIndicatorColor,
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
          ),
          const SizedBox(height: 30),
          _buildOptionTile(
            context: context,
            title: 'From Gallery 🖼️',
            onTap: () => _handleImageSelection(context, ImageSource.gallery),
          ),
          _buildOptionTile(
            context: context,
            title: 'From Camera 📷',
            onTap: () => _handleImageSelection(context, ImageSource.camera),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required BuildContext context,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: tileTextColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      hoverColor: Colors.grey.withOpacity(0.1),
    );
  }

  Future<void> _handleImageSelection(BuildContext context, ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    try {
      final imageFile = await picker.pickImage(
        source: source,
        imageQuality: 70,
      );

      if (imageFile != null) {
        final file = File(imageFile.path);
        final multipartFile = await MultipartFile.fromFile(imageFile.path);
        onImageSelected(file, multipartFile);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
    if (context.mounted) {
      Navigator.pop(context);
    }
  }
}
