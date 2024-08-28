import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimatedIconButton extends StatefulWidget {
  /// A highly customizeable and animated icon button. Featuring a shrinking animation while you are pressing the button. It will pop back up if you hold it for long enough, and will call [onLongPress].
  ///
  /// ### Minimal Usage:
  /// ```dart
  /// AnimatedIconButton(
  ///   onPress(){
  ///     // Code
  ///   },
  /// );
  /// // The button will display with red text saying "Temp". Perfect for quickly testing something.
  /// ```
  ///
  /// ### Main Usage:
  /// AnimatedIconButton(
  ///   leading: Icon(Icons.Add),
  ///   trailing: Text("Add New"),
  ///   onPress(){
  ///     // Code
  ///   },
  /// );
  ///
  ///
  const AnimatedIconButton({
    super.key,
    this.onPress,
    this.onLongPress,
    this.leading,
    this.trailing,
    this.hasFeedback = true,
    this.borderRadius,
    this.backgroundColor = Colors.transparent,
    this.hoverColor,
    this.splashColor,
    this.padding,
    this.leadingTrailingSpacing,
    this.animationPauseDuration,
    this.animationScaleDuration,
    this.animationScale = 0.9,
    this.tempButtonText = "Temp",
    this.tempButtonTextColor = const Color.fromARGB(255, 213, 93, 84),
  });

  /// Gets called when you click or tap on the button.
  final Function? onPress;

  /// Temporary button mode text color.
  ///
  /// Default is a light red color
  /// ```dart
  /// Color.fromARGB(255, 213, 93, 84)
  /// ```
  final Color tempButtonTextColor;

  /// Temporary button mode text.
  ///
  /// Default is "Temp"
  final String tempButtonText;

  /// Determines if clicking will have vibrations.
  ///
  /// **Only supported on Android**
  final bool hasFeedback;

  /// Gets called when you long press on the button.
  final Function? onLongPress;

  /// The leading and/or trailing widgets to display
  final Widget? leading, trailing;

  /// The padding around the [leading] and [trailing] widgets.
  final EdgeInsetsGeometry? padding;

  /// Border radius of the background splash effect, padding, and background color.
  final BorderRadius? borderRadius;

  final Color backgroundColor;

  /// The color of the splash effect when you click the button.
  final Color? splashColor;

  /// The color of the background when hovering over the button.
  final Color? hoverColor;

  /// Space between the [leading] and [trailing] widgets.
  final double? leadingTrailingSpacing;

  /// The value that the button animation will scale down to [onPress] or [onLongPress].
  ///
  /// See Also:
  /// - [animationPauseDuration] The length of time that the button will stay in a smalller scale.
  /// - [animationScaleDuration] The time it takes to scale down and up. Not including the pause duration.
  final double animationScale;

  /// The length of time that the button will stay in a smalller scale.
  ///
  /// Default is 100 ms.
  ///
  /// See Also:
  /// - [animationScale] The value that the button animation will scale down to [onPress] or [onLongPress].
  /// - [animationScaleDuration] The time it takes to scale down and up. Not including the pause duration.
  final Duration? animationPauseDuration;

  /// The time it takes to scale down and up. Not including the pause duration.
  ///
  ///
  /// See Also:
  /// - [animationPauseDuration] The length of time that the button will stay in a smalller scale.
  /// - [animationScale] The value that the button animation will scale down to [onPress] or [onLongPress].
  final Duration? animationScaleDuration;

  @override
  State<AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton> {
  double currentScale = 1;
  void doButtonAnimation() async {
    if (mounted) {
      setState(() {
        currentScale = widget.animationScale;
      });
    }
    await Future.delayed((widget.animationPauseDuration != null) ? widget.animationPauseDuration! : const Duration(milliseconds: 100));
    if (mounted) {
      setState(() {
        currentScale = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: currentScale,
      duration: (widget.animationScaleDuration != null) ? widget.animationScaleDuration! : const Duration(milliseconds: 100),
      child: GestureDetector(
          child: Material(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          splashColor: widget.splashColor,
          hoverColor: widget.hoverColor,
          borderRadius: (widget.borderRadius != null) ? widget.borderRadius : BorderRadius.circular(360),
          onTapDown: (d) {
            setState(() {
              currentScale = widget.animationScale;
            });
          },
          onTapUp: (d) {
            setState(() {
              currentScale = 1;
            });
          },
          onTapCancel: () {
            setState(() {
              currentScale = 1;
            });
          },
          onTap: () {
            if (Platform.isAndroid && widget.hasFeedback) {
              HapticFeedback.lightImpact();
            }
            doButtonAnimation();
            widget.onPress?.call();
          },
          onLongPress: () {
            if (Platform.isAndroid && widget.hasFeedback) {
              HapticFeedback.lightImpact();
            }
            setState(() {
              currentScale = 1;
            });

            widget.onLongPress?.call();
          },
          child: Padding(
            padding: (widget.padding != null) ? widget.padding! : const EdgeInsets.all(8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                (widget.leading != null)
                    ? widget.leading!
                    : Text(
                        widget.tempButtonText,
                        style: TextStyle(color: widget.tempButtonTextColor),
                      ),
                SizedBox(
                  width: widget.leadingTrailingSpacing,
                ),
                if (widget.trailing != null) widget.trailing!
              ],
            ),
          ),
        ),
      )),
    );
  }
}
