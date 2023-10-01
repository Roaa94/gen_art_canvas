import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gen_art_canvas/cuboids/presentation/cuboid_form_data.dart';

final cuboidFormProvider = NotifierProvider<CuboidFormNotifier, CuboidFormData>(
  CuboidFormNotifier.new,
);

class CuboidFormNotifier extends Notifier<CuboidFormData> {
  @override
  CuboidFormData build() {
    return _buildEmpty();
  }

  CuboidFormData _buildEmpty() => {
        for (final face in CuboidFaceDirection.values)
          face: const CuboidFaceFormData(),
      };

  void updateFaceFormData(
    CuboidFaceDirection face,
    CuboidFaceFormData formData,
  ) {
    state = {
      ...state,
      face: formData,
    };
  }

  bool getIfEmpty() {
    return CuboidFaceDirection.values.every((direction) {
      return state[direction] == null || state[direction]!.isEmpty;
    });
  }

  bool getIfFaceFormIsValid(CuboidFaceDirection face) {
    return state[face] != null && state[face]!.isValid;
  }

  void reset() {
    state = _buildEmpty();
  }

  bool getIfCuboidFormIsValid() {
    return CuboidFaceDirection.values.every((direction) {
      return state[direction] != null && state[direction]!.isValid;
    });
  }
}
