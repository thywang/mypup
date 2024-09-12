import 'package:flutter/material.dart';
import 'package:my_pup_simple/src/constants/app_sizes.dart';

class AppButton extends StatefulWidget {
  const AppButton({
    required this.text,
    required this.textColor,
    required this.backgroundColor,
    required this.shadowColor,
    super.key,
    this.onPressed,
    this.fontSize = 14,
    this.child,
  }) : assert(
          (child == null && text != '') || (child != null && text == ''),
          'Either child must be null or text must be empty.',
        );
  final String text;
  final Widget? child;
  final VoidCallback? onPressed;
  final double fontSize;
  final Color textColor;
  final Color backgroundColor;
  final Color shadowColor;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  var _shadow = 6.0;
  var _paddingTop = 0.0;
  var _paddingBottom = 5.0;
  var _colorPressed = Colors.transparent;

  @override
  void initState() {
    if (widget.onPressed == null) _pressButton();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTapDown: (tapDetails) {
        if (widget.onPressed != null) _pressButton();
      },
      onTapUp: (TapUpDetails tapDetails) {
        if (widget.onPressed != null) {
          _releaseButton();
          widget.onPressed!();
        }
      },
      onTapCancel: _releaseButton,
      onLongPress: _releaseButton,
      radius: 16,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 60),
        margin: EdgeInsets.only(top: _paddingTop, bottom: _paddingBottom),
        padding: const EdgeInsets.all(Sizes.p24),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: widget.shadowColor,
              offset: Offset(_shadow, _shadow),
            ),
          ],
        ),
        foregroundDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _colorPressed,
        ),
        child: widget.text != ''
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    widget.text,
                    style: TextStyle(
                      color: widget.textColor,
                      fontSize: widget.fontSize,
                    ),
                  ),
                ],
              )
            : widget.child,
      ),
    );
  }

  void _pressButton() {
    setState(() {
      _paddingTop = 5.0;
      _paddingBottom = 0.0;
      _colorPressed = Colors.black12;
      _shadow = 0.0;
    });
  }

  void _releaseButton() {
    setState(() {
      _paddingTop = 0.0;
      _paddingBottom = 5.0;
      _colorPressed = Colors.transparent;
      _shadow = 6.0;
    });
  }
}
