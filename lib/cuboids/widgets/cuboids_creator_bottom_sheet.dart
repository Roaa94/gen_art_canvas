import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gen_art_canvas/auth/domain/artist.dart';
import 'package:gen_art_canvas/core/style/app_colors.dart';
import 'package:gen_art_canvas/cuboids/application/cuboid_form_data.dart';
import 'package:gen_art_canvas/cuboids/application/cuboid_form_provider.dart';
import 'package:gen_art_canvas/cuboids/application/cuboids_service.dart';
import 'package:gen_art_canvas/cuboids/widgets/cuboid_face_form.dart';
import 'package:gen_art_canvas/cuboids/widgets/form_preview_cuboid.dart';
import 'package:gen_art_canvas/settings/cuboids_canvas_settings.dart';

final activeFaceIndexProvider = StateProvider<int>((ref) => 0);
final isLoadingSubmitProvider = StateProvider<bool>((ref) => false);

class CuboidsCreatorBottomSheet extends ConsumerStatefulWidget {
  const CuboidsCreatorBottomSheet({
    super.key,
    required this.settings,
    required this.authArtist,
    this.onSubmit,
  });

  final CuboidsCanvasSettings settings;
  final Artist authArtist;
  final VoidCallback? onSubmit;

  @override
  ConsumerState<CuboidsCreatorBottomSheet> createState() =>
      _CuboidsCreatorBottomSheetState();
}

class _CuboidsCreatorBottomSheetState
    extends ConsumerState<CuboidsCreatorBottomSheet> {
  late final PageController pageController;

  void _resetProgress() {
    ref.read(activeFaceIndexProvider.notifier).state = 0;
    ref.read(cuboidFormProvider.notifier).reset();
    pageController.jumpTo(0);
  }

  void _submitCuboid(CuboidFormData formData) {
    ref.read(isLoadingSubmitProvider.notifier).state = true;
    ref
        .read(cuboidsServiceProvider)
        .addCuboid(
          artistId: widget.authArtist.id,
          formData: formData,
        )
        .then((value) {
      _resetProgress();
      ref.read(isLoadingSubmitProvider.notifier).state = false;
      widget.onSubmit?.call();
    });
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(
      initialPage: ref.read(activeFaceIndexProvider),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cuboidPreviewSectionHeight =
        MediaQuery.of(context).size.height * 0.35;
    final activeFaceIndex = ref.watch(activeFaceIndexProvider);
    final activeFace = CuboidFaceDirection.values[activeFaceIndex];
    final cuboidFormData = ref.watch(cuboidFormProvider);
    final isCuboidFormValid =
        ref.watch(cuboidFormProvider.notifier).getIfCuboidFormIsValid();
    final isActiveFaceFormValid =
        ref.watch(cuboidFormProvider.notifier).getIfFaceFormIsValid(activeFace);
    final isCuboidFormEmpty =
        ref.watch(cuboidFormProvider.notifier).getIfEmpty();

    return SizedBox.expand(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Contribute to the artwork by adding your own cuboid!',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            color: Colors.black.withOpacity(0.2),
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 2,
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
                  previewHeight: cuboidPreviewSectionHeight,
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: cuboidPreviewSectionHeight,
                    color: Colors.black.withOpacity(0.3),
                    child: FormPreviewCuboid(
                      formData: cuboidFormData,
                      settings: widget.settings,
                    ),
                  ),
                ),
                if (!isCuboidFormEmpty)
                  AnimatedPositioned(
                    bottom: 10 + (isCuboidFormValid ? 50 : 0),
                    left: 0,
                    right: 10,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: _resetProgress,
                        child: Text(
                          'Reset Progress',
                          style:
                              Theme.of(context).textTheme.labelSmall!.copyWith(
                                    color: AppColors.primary,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.primary,
                                  ),
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 50,
                  child: AnimatedSlide(
                    offset: Offset(0, isCuboidFormValid ? 0 : 1),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: InkWell(
                      onTap: isCuboidFormValid
                          ? () => _submitCuboid(cuboidFormData)
                          : null,
                      child: ColoredBox(
                        color: AppColors.primary,
                        child: ref.watch(isLoadingSubmitProvider)
                            ? const SizedBox(
                                width: 40,
                                height: 40,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.firebaseDarkGrey,
                                  ),
                                ),
                              )
                            : const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 12,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Submit Your Cuboid',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(
                                      Icons.send,
                                      size: 15,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
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
    required double previewHeight,
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
          padding: EdgeInsets.only(bottom: previewHeight + 20.0),
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
