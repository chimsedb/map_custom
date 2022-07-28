import 'package:my_wallet/di/service_provider.dart';
import 'package:my_wallet/ui/home/home_view_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final homeViewModelProvider = ChangeNotifierProvider<HomeViewModel>(
    (ref) => HomeViewModel(ref.read, ref.read(fireStoreServiceProvider)));
