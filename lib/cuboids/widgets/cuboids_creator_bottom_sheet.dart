import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gen_art_canvas/auth/data/artist.dart';
import 'package:gen_art_canvas/core/style/app_colors.dart';
import 'package:gen_art_canvas/cuboids/data/cuboid_form_data.dart';
import 'package:gen_art_canvas/cuboids/data/cuboid_form_provider.dart';
import 'package:gen_art_canvas/cuboids/widgets/cuboid_face_form.dart';
import 'package:gen_art_canvas/settings/cuboids_canvas_settings.dart';

final activeFaceIndexProvider = StateProvider<int>((ref) => 0);

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
  late final PageController pageController;
  static const double cuboidPreviewSectionHeight = 220;

  @override
  void initState() {
    super.initState();
    pageController = PageController(
      initialPage: ref.read(activeFaceIndexProvider),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeFaceIndex = ref.watch(activeFaceIndexProvider);
    final activeFace = CuboidFaceDirection.values[activeFaceIndex];
    final cuboidFormData = ref.watch(cuboidFormProvider);
    final isCuboidFormValid =
        ref.watch(cuboidFormProvider.notifier).getIfCuboidFormIsValid();
    final isActiveFaceFormValid =
        ref.watch(cuboidFormProvider.notifier).getIfFaceFormIsValid(activeFace);

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
            color: Colors.black.withOpacity(0.2),
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            child: Row(
              children: [
                TextButton.icon(
                  onPressed: activeFaceIndex > 0
                      ? () => pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          )
                      : null,
                  label: const Text('Prev'),
                  icon: const Icon(Icons.arrow_back_ios, size: 15),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      '${activeFace.title} '
                      '(${activeFaceIndex + 1}/'
                      '${CuboidFaceDirection.values.length})',
                    ),
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextButton.icon(
                    onPressed: isActiveFaceFormValid &&
                            activeFaceIndex <
                                CuboidFaceDirection.values.length - 1
                        ? () => pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            )
                        : null,
                    label: const Text('Next'),
                    icon: const Icon(Icons.arrow_back_ios, size: 15),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                _buildFormPageView(
                  context,
                  cuboidFormData: cuboidFormData,
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: cuboidPreviewSectionHeight,
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: AnimatedSlide(
                    offset: Offset(0, isCuboidFormValid ? 0 : 1),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: InkWell(
                      onTap: isCuboidFormValid ? () {} : null,
                      child: Container(
                        color: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 12),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Submit Your Cuboid',
                              style: TextStyle(color: Colors.black),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.send, size: 15, color: Colors.black),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormPageView(
    BuildContext context, {
    required CuboidFormData cuboidFormData,
  }) {
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: pageController,
      padEnds: false,
      onPageChanged: (value) =>
          ref.read(activeFaceIndexProvider.notifier).state = value,
      children: List.generate(
        CuboidFaceDirection.values.length,
        (index) => SingleChildScrollView(
          padding: const EdgeInsets.only(
            top: 20,
            bottom: cuboidPreviewSectionHeight + 20,
          ),
          child: CuboidFaceForm(
            colors: widget.settings.colors,
            face: CuboidFaceDirection.values[index],
            fillTypes: widget.settings.fillTypes,
            formData: cuboidFormData[CuboidFaceDirection.values[index]] ??
                const CuboidFaceFormData(),
            onChanged: (newFormData) =>
                ref.read(cuboidFormProvider.notifier).updateFaceFormData(
                      CuboidFaceDirection.values[index],
                      newFormData,
                    ),
          ),
        ),
      ),
    );
  }
}
