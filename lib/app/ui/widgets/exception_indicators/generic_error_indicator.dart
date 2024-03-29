import 'package:admin_alamuti/app/ui/widgets/exception_indicators/exception_indicator.dart';
import 'package:flutter/cupertino.dart';

/// Indicates that an unknown error occurred.
class GenericErrorIndicator extends StatelessWidget {
  const GenericErrorIndicator({
    required this.onTryAgain,
  });

  final VoidCallback onTryAgain;

  @override
  Widget build(BuildContext context) => ExceptionIndicator(
        title: 'ارتباط برقرار نشد',
        message: 'لطفا اتصال به اینترنت دستگاه خود را بررسی کنید',
        onTryAgain: onTryAgain,
        buttonTitle: 'دوباره امتحان کنید',
      );
}
