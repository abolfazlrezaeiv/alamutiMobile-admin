import 'package:flutter/material.dart';
import 'exception_indicator.dart';

/// Indicates that no items were found.
class EmptyListIndicator extends StatelessWidget {
  const EmptyListIndicator({
    required this.onTryAgain,
  });
  final VoidCallback onTryAgain;
  @override
  Widget build(BuildContext context) => ExceptionIndicator(
        title: 'صف انتشار خالی است',
        message: 'در حال حاظر آگهی تایید نشده وجود ندارد',
        buttonTitle: '',
        onTryAgain: onTryAgain,
      );
}
