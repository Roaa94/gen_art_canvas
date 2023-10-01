import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gen_art_canvas/core/style/app_colors.dart';
import 'package:gen_art_canvas/cuboids/presentation/widgets/cuboids_canvas.dart';
import 'package:gen_art_canvas/settings/cuboids_canvas_settings.dart';
// ignore: depend_on_referenced_packages
import 'package:widgetbook/widgetbook.dart';

void main() {
  runApp(const WidgetbookApp());
}

class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: [
        WidgetbookFolder(
          name: 'Cuboids Canvas',
          children: [
            WidgetbookComponent(
              name: 'Canvas',
              useCases: [
                WidgetbookUseCase(
                  name: 'Playground',
                  builder: (context) => CuboidsCanvas(
                    animationEnabled: context.knobs.boolean(
                      label: 'Enable Animation',
                      initialValue: true,
                    ),
                    initialGap: context.knobs.double.slider(
                      label: 'Gap',
                      initialValue: 10,
                      min: 0,
                      max: 60,
                      divisions: 60,
                    ),
                    settings: CuboidsCanvasSettings(
                      defaultPrimaryColor:
                          AppColors.firebaseDarkGrey.toMaterial(),
                      cuboidsTotalCount: context.knobs.double
                          .slider(
                            label: 'Cuboids Count',
                            initialValue: 100,
                            min: 2,
                            max: 200,
                            divisions: 198,
                          )
                          .toInt(),
                      maxRandomYOffset: context.knobs.double.slider(
                        label: 'Max Y Offset',
                        initialValue: 100,
                        min: 10,
                        max: 300,
                        divisions: 29,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
