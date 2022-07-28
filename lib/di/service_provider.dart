import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_wallet/service/fire_store_service.dart';
import 'package:my_wallet/service/wallet_service.dart';

final walletServiceProvider =
    ChangeNotifierProvider((ref) => WalletService.getInstance());

final walletConnectProvider = FutureProvider(
    (ref) async => ref.read(walletServiceProvider).initWalletConnect());

final fireStoreServiceProvider =
    ChangeNotifierProvider((ref) => FireStoreService());
