import 'package:auto_route/auto_route.dart';
import 'package:my_wallet/ui/home/home_view.dart';

@AdaptiveAutoRouter(
  replaceInRouteName: 'View,Route',
  routes: <AutoRoute>[
    AutoRoute(page: HomeView, initial: true),
    // CustomRoute(
    //     page: ChapterCategoryView,
    //     transitionsBuilder: TransitionsBuilders.fadeIn),
    // CustomRoute(
    //     page: DetailChapterView,
    //     transitionsBuilder: TransitionsBuilders.fadeIn),
  ],
)
class $AppRouter {}
