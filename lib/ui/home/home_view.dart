import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_wallet/data/model/area.dart';
import 'package:my_wallet/di/view_model_provider.dart';
import 'package:my_wallet/ui/base/base_view.dart';
import 'package:my_wallet/ui/home/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeView extends BaseView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget onViewCreated() {
    return const Body();
  }

  @override
  ChangeNotifierProvider<HomeViewModel> get viewModelProvider =>
      homeViewModelProvider;
}

class Body extends HookConsumerWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [],
    );
    final HomeViewModel viewModel = ref.watch(homeViewModelProvider);
    final TransformationController transformationController =
        useTransformationController();
    final TextEditingController textEditingController =
        useTextEditingController();
    final currentPosition = useState(const Offset(0, 0));
    final positionAreaClicked = useState(-1);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              flex: 7,
              child: viewModel.asyncValueArea.when(
                  data: (result) => GestureDetector(
                        onLongPressEnd: (details) {
                          currentPosition.value =
                              transformationController.toScene(
                            details.localPosition,
                          );
                          int position = viewModel.getPositionAreaClicked(
                              currentPosition.value, result);
                          positionAreaClicked.value = position;
                          if (position != -1) {
                            textEditingController.text =
                                result[position].description;
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      title: const Text('Description'),
                                      content: TextField(
                                        controller: textEditingController,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            filled: true,
                                            hintStyle: TextStyle(
                                                color: Colors.grey[800]),
                                            hintText: "Your description area",
                                            fillColor: Colors.white70),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                            child: const Text('Cancel'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            }),
                                        TextButton(
                                            child: const Text('Ok'),
                                            onPressed: () {
                                              viewModel.updateDescription(
                                                  result[position].description,
                                                  textEditingController.text);
                                              Navigator.of(context).pop();
                                            })
                                      ],
                                    ));
                          }
                        },
                        onTapUp: (details) {
                          currentPosition.value =
                              transformationController.toScene(
                            details.localPosition,
                          );
                          int position = viewModel.getPositionAreaClicked(
                              currentPosition.value, result);
                          positionAreaClicked.value = position;
                        },
                        child: InteractiveViewer(
                          transformationController: transformationController,
                          maxScale: 3.0,
                          boundaryMargin: const EdgeInsets.all(500),
                          scaleEnabled: true,
                          panEnabled: true,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              RepaintBoundary(
                                child: CustomPaint(
                                  isComplex: true,
                                  willChange: true,
                                  size: Size.infinite,
                                  painter: MyCustomPainter(
                                    positionAreaClicked.value,
                                    result,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  error: (e, t) => Text(e.toString()),
                  loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ))),
          Container(
            height: 180,
            padding: const EdgeInsets.all(15),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: Colors.grey.shade100,
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 15,
                        ),
                        const Text('Shows Areas'),
                        const Spacer(),
                        CupertinoSwitch(
                          value: viewModel.showAreas,
                          onChanged: (value) {
                            viewModel.switchMap(MapType.area, value);
                          },
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      children: [
                        const SizedBox(
                          width: 15,
                        ),
                        const Text('Shows Zones'),
                        const Spacer(),
                        CupertinoSwitch(
                            value: viewModel.showZones,
                            onChanged: (value) {
                              viewModel.switchMap(MapType.zone, value);
                            }),
                        const SizedBox(
                          width: 15,
                        ),
                      ],
                    ),
                    const Divider(),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MyCustomPainter extends CustomPainter {
  final int positionAreaClicked;
  final List<Area> areas;

  MyCustomPainter(this.positionAreaClicked, this.areas);

  @override
  void paint(Canvas canvas, Size size) {
    Paint background = Paint()..color = Colors.transparent;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, background);
    for (int i = 0; i < areas.length; i++) {
      _drawArea(areas[i], canvas);
    }
    //todo draw path after clicked
    if (positionAreaClicked != -1) {
      Paint pPath = Paint()
        ..color = Colors.deepPurpleAccent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;
      Path path = Path();
      path.moveTo(areas[positionAreaClicked].points[0].dx,
          areas[positionAreaClicked].points[0].dy);
      for (int i = 1; i < areas[positionAreaClicked].points.length; i++) {
        path.lineTo(areas[positionAreaClicked].points[i].dx,
            areas[positionAreaClicked].points[i].dy);
      }
      canvas.drawPath(path, pPath);
      canvas.drawPath(path, background);
    }
  }

  @override
  bool shouldRepaint(MyCustomPainter oldDelegate) {
    return true;
  }

  void _drawArea(Area area, Canvas canvas) {
    Paint background = Paint()..color = Color(area.color);
    Paint pPath = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    Path path = Path();
    path.moveTo(area.points[0].dx, area.points[0].dy);
    for (int i = 1; i < area.points.length; i++) {
      path.lineTo(area.points[i].dx, area.points[i].dy);
    }
    canvas.drawPath(path, pPath);
    canvas.drawPath(path, background);
    TextSpan span = TextSpan(
        style: const TextStyle(
            color: Colors.black54, fontSize: 12.0, fontWeight: FontWeight.bold),
        text: area.description);
    TextPainter tp = TextPainter(text: span, textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, area.location);
  }
}
