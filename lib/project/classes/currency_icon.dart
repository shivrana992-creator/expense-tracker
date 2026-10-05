import 'package:flutter/material.dart';
import 'package:money_assistant_2608/project/database_management/shared_preferences_services.dart';

class CurrencyIcon extends StatelessWidget {
  final double size;
  final Color color;

  const CurrencyIcon({super.key, required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: currencySymbol,
      builder: (context, symbol, child) => SizedBox(
        width: size,
        height: size,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            symbol,
            style: TextStyle(
              fontSize: size,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
