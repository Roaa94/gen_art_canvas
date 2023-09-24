import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gen_art_canvas/auth/data/artist.dart';
import 'package:gen_art_canvas/core/style/app_colors.dart';
import 'package:gen_art_canvas/cuboids/data/cuboid_form_data.dart';
import 'package:gen_art_canvas/cuboids/data/cuboid_form_provider.dart';
import 'package:gen_art_canvas/cuboids/widgets/cuboid_face_form.dart';
import 'package:gen_art_canvas/settings/cuboids_canvas_settings.dart';

class CuboidsCreatorBottomSheet extends ConsumerStatefulWidget {
  const CuboidsCreatorBottomSheet({
    super.key,
    required this.settings,
    required this.authArtist,
  });

  final CuboidsCanvasSettings settings;
  final Artist authArtist;

  @override
  ConsumerState<CuboidsCreatorBottomSheet> createState() =>
      _CuboidsCreatorBottomSheetState();
}

class _CuboidsCreatorBottomSheetState
    extends ConsumerState<CuboidsCreatorBottomSheet> {
  final pageController = PageController();
  static const double cuboidPreviewSectionHeight = 170;

  CuboidFace activeFace = CuboidFace.values[0];

  @override
  Widget build(BuildContext context) {
    final cuboidFormData = ref.watch(cuboidFormProvider);
    return SizedBox.expand(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text(
                  'Create Your Cuboid!',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 10),
                const Text(
                  'This canvas is for everyone to create on, contribute to the artwork by adding your own cuboid!',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: cuboidPreviewSectionHeight,
            color: Colors.black.withOpacity(0.2),
          ),
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
                  child: Center(
                    child: Text(activeFace.title),
                  ),
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
              onPageChanged: (value) =>
                  setState(() => activeFace = CuboidFace.values[value]),
              children: List.generate(
                CuboidFace.values.length,
                (index) => SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    top: 20,
                    bottom: cuboidPreviewSectionHeight,
                  ),
                  child: CuboidFaceForm(
                    colors: widget.settings.colors,
                    fillTypes: widget.settings.fillTypes,
                    formData: cuboidFormData[activeFace] ??
                        const CuboidFaceFormData(),
                    onChanged: (newFormData) =>
                        ref.read(cuboidFormProvider.notifier).updateFaceFormData(
                              CuboidFace.values[index],
                              newFormData,
                            ),
                  ),
                ),
              ),
            ),
          ),
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
                  child: Center(
                    child: Text(activeFace.title),
                  ),
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
