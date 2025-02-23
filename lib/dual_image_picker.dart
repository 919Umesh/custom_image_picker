import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomImagePicker extends StatefulWidget {
  final File? initialImage;
  final double radius;
  final String defaultImageAsset;
  final Function(File file, MultipartFile multipartFile) onImageSelected;
  final Color? bottomSheetIndicatorColor;
  final Color? tileTextColor;
  final double imageHeight;
  final double? imageWidth;
  final Color borderColor;
  final Function(String error)? onError;
  final int imageQuality;

  const CustomImagePicker({
    super.key,
    this.initialImage,
    this.radius = 50.0,
    required this.defaultImageAsset,
    required this.onImageSelected,
    this.bottomSheetIndicatorColor = Colors.green,
    this.tileTextColor = Colors.black,
    this.imageHeight = 180,
    this.imageWidth,
    this.borderColor = Colors.black,
    this.onError,
    this.imageQuality = 70,
  });

  @override
  State<CustomImagePicker> createState() => _CustomImagePickerState();
}

class _CustomImagePickerState extends State<CustomImagePicker> {
  File? _currentImage;

  @override
  void initState() {
    super.initState();
    _currentImage = widget.initialImage;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showImagePickerBottomSheet(context),
      child: _buildImageContainer(),
    );
  }

  Widget _buildImageContainer() {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: Radius.circular(widget.radius),
      color: widget.borderColor,
      dashPattern: const [4, 4],
      strokeWidth: 1.0,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius - 2),
        ),
        child: _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: _currentImage != null
          ? Image.file(
        _currentImage!,
        width: widget.imageWidth ?? double.infinity,
        height: widget.imageHeight,
        fit: BoxFit.cover,
      )
          : Image.asset(
        widget.defaultImageAsset,
        width: widget.imageWidth ?? double.infinity,
        height: widget.imageHeight,
        fit: BoxFit.cover,
      ),
    );
  }

  Future<void> _showImagePickerBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => _buildBottomSheet(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(widget.radius)),
      ),
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(widget.radius)),
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
                color: widget.bottomSheetIndicatorColor,
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
          color: widget.tileTextColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      tileColor: Colors.transparent,
      hoverColor: Colors.grey.withOpacity(0.1),
    );
  }

  Future<void> _handleImageSelection(BuildContext context, ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? imageFile = await picker.pickImage(
        source: source,
        imageQuality: widget.imageQuality,
      );

      if (imageFile != null) {
        final file = File(imageFile.path);
        final multipartFile = await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.name,
        );
        setState(() {
          _currentImage = file;
        });
        widget.onImageSelected(file, multipartFile);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      widget.onError?.call(e.toString());
    }
    if (context.mounted) {
      Navigator.pop(context);
    }
  }
}