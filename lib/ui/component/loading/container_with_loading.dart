import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_wallet/ui/base/base_view_model.dart';

class ContainerWithLoading<T extends BaseViewModel> extends ConsumerWidget {
  final ChangeNotifierProvider<T> provider;
  final Widget child;

  const ContainerWithLoading(
      {required this.provider, required this.child, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    BaseViewModel viewModel = ref.watch(provider);
    return viewModel.isBusy
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : child;
  }
}
