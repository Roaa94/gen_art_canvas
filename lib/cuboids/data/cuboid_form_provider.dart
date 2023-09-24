import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gen_art_canvas/cuboids/data/cuboid_form_data.dart';

final cuboidFormProvider =
    NotifierProvider<CuboidFormNotifier, Map<CuboidFace, CuboidFaceFormData>>(
  () => CuboidFormNotifier(),
);

class CuboidFormNotifier extends Notifier<Map<CuboidFace, CuboidFaceFormData>> {
  @override
  Map<CuboidFace, CuboidFaceFormData> build() {
    return {
      CuboidFace.top: const CuboidFaceFormData(),
      CuboidFace.right: const CuboidFaceFormData(),
      CuboidFace.left: const CuboidFaceFormData(),
    };
  }

  updateFaceFormData(CuboidFace face, CuboidFaceFormData formData) {
    state = {
      ...state,
      face: formData,
    };
  }
}
