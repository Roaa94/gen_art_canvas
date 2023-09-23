import 'package:flutter/material.dart';
import 'package:gen_art_canvas/auth/data/artist.dart';
import 'package:gen_art_canvas/core/style/app_colors.dart';
import 'package:gen_art_canvas/cuboids/data/cuboid_form_data.dart';
import 'package:gen_art_canvas/cuboids/widgets/cuboid_face_form.dart';
import 'package:gen_art_canvas/settings/cuboids_canvas_settings.dart';

class CuboidsCreatorBottomSheet extends StatefulWidget {
  const CuboidsCreatorBottomSheet({
    super.key,
    required this.settings,
    required this.authArtist,
  });

  final CuboidsCanvasSettings settings;
  final Artist authArtist;

  @override
  State<CuboidsCreatorBottomSheet> createState() =>
      _CuboidsCreatorBottomSheetState();
}

class _CuboidsCreatorBottomSheetState extends State<CuboidsCreatorBottomSheet> {
  final pageController = PageController();
  CuboidFaceFormData topFaceFormData = const CuboidFaceFormData();
  CuboidFaceFormData leftFaceFormData = const CuboidFaceFormData();
  CuboidFaceFormData rightFaceFormData = const CuboidFaceFormData();

  static const double cuboidPreviewSectionHeight = 170;

  int activePageIndex = 0;
  final List<String> pages = [
    'Top Face',
    'Left Face',
    'Right Face',
  ];

  List<CuboidFaceFormData> get formData => [
        topFaceFormData,
        leftFaceFormData,
        rightFaceFormData,
      ];

  void _updateFaceFormData(CuboidFaceFormData newFormData, int index) {
    if (index == 0) {
      setState(() {
        topFaceFormData = newFormData;
      });
    }
    if (index == 1) {
      setState(() {
        leftFaceFormData = newFormData;
      });
    }
    if (index == 2) {
      setState(() {
        rightFaceFormData = newFormData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        children: [
          Container(
            color: Colors.black.withOpacity(0.2),
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            child: Row(
              children: [
                TextButton.icon(
                  onPressed: () => pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                  label: const Text('Prev'),
                  icon: const Icon(Icons.arrow_back_ios, size: 15),
                ),
                Expanded(
                  child: Center(child: Text(pages[activePageIndex])),
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextButton.icon(
                    onPressed: () => pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ),
                    label: const Text('Next'),
                    icon: const Icon(Icons.arrow_back_ios, size: 15),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              padEnds: false,
              onPageChanged: (value) => setState(() => activePageIndex = value),
              children: List.generate(
                pages.length,
                (index) => SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    top: 20,
                    bottom: cuboidPreviewSectionHeight,
                  ),
                  child: CuboidFaceForm(
                    colors: widget.settings.colors,
                    fillTypes: widget.settings.fillTypes,
                    formData: formData[index],
                    onChanged: (newFormData) =>
                        _updateFaceFormData(newFormData, index),
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: cuboidPreviewSectionHeight,
            color: Colors.black.withOpacity(0.2),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              color: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check, size: 15, color: Colors.black),
                  SizedBox(width: 10),
                  Text(
                    'Submit Your Cuboid',
                    style: TextStyle(color: Colors.black),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
