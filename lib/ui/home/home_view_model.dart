import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_wallet/data/model/area.dart';
import 'package:my_wallet/service/fire_store_service.dart';
import 'package:my_wallet/ui/base/base_view_model.dart';

enum MapType { area, zone }

class HomeViewModel extends BaseViewModel {
  final FireStoreService fireStoreService;

  bool showZones = false, showAreas = true;

  HomeViewModel(Reader reader, this.fireStoreService) : super(reader);

  AsyncValue<List<Area>> asyncValueArea = const AsyncValue.loading();

  Map<String, String> mapDescription = {};

  @override
  Future<void> onViewModelReady() async {
    createMap(MapType.area);
  }

  createMap(MapType type) {
    List<Area> areas = [];
    Stream stream = type == MapType.area
        ? fireStoreService.streamAreas
        : fireStoreService.streamZones;
    stream.listen((event) {
      for (var e in event.docs) {
        Map<String, dynamic> map = e.data();
        mapDescription[e.id] = map['description'];
        List<Offset> listOffset = [];
        for (int i = 0; i < (map['xPoints'] as List).length; i++) {
          listOffset.add(Offset((map['xPoints'][i] as int).toDouble(),
              (map['yPoints'][i] as int).toDouble()));
        }
        Area area = Area(
            points: listOffset,
            color: map['color'],
            location: Offset((map['xDescription'] as int).toDouble(),
                (map['yDescription'] as int).toDouble()),
            description: map['description']);
        areas.add(area);
        notifyListeners();
      }
    });
    asyncValueArea = AsyncValue.data(areas);
  }

  // List<Area> areas = [];

  // @override
  // Future<void> onViewModelReady() async {
  //   createMap();
  // }

  // createMap() {
  //   areas = [];
  //   for (var area in map) {
  //     areas.add(Area.fromJson(area));
  //   }
  //   notifyListeners();
  // }
  //
  // createMap1() {
  //   areas = [];
  //   for (var area in map1) {
  //     areas.add(Area.fromJson(area));
  //   }
  //   notifyListeners();
  // }

  bool checkInsideArea(Offset offset, List<Offset> vs) {
    var x = offset.dx, y = offset.dy;

    var inside = false;
    for (var i = 0, j = vs.length - 1; i < vs.length; j = i++) {
      var xi = vs[i].dx, yi = vs[i].dy;
      var xj = vs[j].dx, yj = vs[j].dy;

      var intersect =
          ((yi > y) != (yj > y)) && (x < (xj - xi) * (y - yi) / (yj - yi) + xi);
      if (intersect) inside = !inside;
    }

    return inside;
  }

  int getPositionAreaClicked(Offset offset, List<Area> areas) {
    for (int i = 0; i < areas.length; i++) {
      if (checkInsideArea(offset, areas[i].points)) {
        return i;
      }
    }
    return -1;
  }

  void switchMap(MapType type, bool value) {
    switch (type) {
      case MapType.zone:
        showZones = value;
        showAreas = false;

        break;
      case MapType.area:
        showAreas = value;
        showZones = false;
        break;
    }
    createMap(type);
    if (!showAreas && !showZones) {
      showAreas = true;
      createMap(MapType.area);
    }
    notifyListeners();
  }

  void updateDescription(String oldDescription, String newDescription) {
    String docId = mapDescription.keys
        .where((e) => mapDescription[e] == oldDescription)
        .first;
    fireStoreService.fireStore
        .collection(showAreas ? 'areas' : 'zones')
        .doc(docId)
        .update({'description': newDescription});
  }
}
