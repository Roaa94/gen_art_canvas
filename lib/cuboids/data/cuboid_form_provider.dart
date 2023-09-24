import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gen_art_canvas/cuboids/data/cuboid_form_data.dart';

final cuboidFormProvider = NotifierProvider<CuboidFormNotifier, CuboidFormData>(
  () => CuboidFormNotifier(),
);

class CuboidFormNotifier extends Notifier<CuboidFormData> {
  @override
  CuboidFormData build() {
    return {
      for (final face in CuboidFaceDirection.values)
        face: const CuboidFaceFormData(),
    };
  }

  updateFaceFormData(CuboidFaceDirection face, CuboidFaceFormData formData) {
    state = {
      ...state,
      face: formData,
    };
  }

  getIfFaceFormIsValid(CuboidFaceDirection face) {
    return state[face] != null && state[face]!.isValid;
  }

  getIfCuboidFormIsValid() {
    return CuboidFaceDirection.values.every((direction) {
      return state[direction] != null && state[direction]!.isValid;
    });
  }
}
