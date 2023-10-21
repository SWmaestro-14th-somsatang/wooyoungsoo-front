import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wooyoungsoo/utils/constants.dart';

class ProfileImagePickerButton extends StatelessWidget {
  ProfileImagePickerButton({
    super.key,
    required this.setImage,
    required this.profileImage,
  });

  final Function setImage;
  final XFile? profileImage;
  final ImagePicker picker = ImagePicker();

  Future pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        setImage(pickedFile);
      }
    } catch (e) {
      print("접근 권한이 설정되어 있지 않습니다");
    }
  }

  @override
  Widget build(BuildContext context) {
    print(profileImage);
    return ElevatedButton(
      onPressed: () {
        pickImage(ImageSource.gallery);
      },
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(120, 120),
        padding: EdgeInsets.zero,
        backgroundColor: lightGreyColor,
        shape: const CircleBorder(),
        shadowColor: Colors.transparent,
      ),
      child: profileImage != null
          ? Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: FileImage(
                    File(profileImage!.path),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            )
          : const Icon(
              Icons.camera_alt_rounded,
              size: 28,
              color: darkGreyColor,
            ),
    );
  }
}
