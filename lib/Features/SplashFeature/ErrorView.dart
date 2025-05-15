import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ErrorView extends ConsumerWidget {
  final Object error;

  const ErrorView({super.key, required this.error});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverFillRemaining(
          child: Center(
            child: Text(error.toString().replaceAll("Exception:", ""),
                textAlign: TextAlign.center),
          ),
        ),
      ],
    );
  }
}
