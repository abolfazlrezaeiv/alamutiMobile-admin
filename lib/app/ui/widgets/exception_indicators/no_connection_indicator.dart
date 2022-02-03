import 'package:admin_alamuti/app/ui/widgets/exception_indicators/exception_indicator.dart';
import 'package:flutter/cupertino.dart';

/// Indicates that a connection error occurred.
class NoConnectionIndicator extends StatelessWidget {
  const NoConnectionIndicator({
    required this.onTryAgain,
  });

  final VoidCallback onTryAgain;

  @override
  Widget build(BuildContext context) => ExceptionIndicator(
        title: 'ارتباط ناموفق',
        message: 'لطفا اتصال به اینترنت دستگاه خود را بررسی کنید',
        onTryAgain: onTryAgain,
        buttonTitle: 'دوباره امتحان کنید',
      );
}
