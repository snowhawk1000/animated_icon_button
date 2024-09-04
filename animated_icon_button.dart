/* Copyright 2024 Snowhawk. This entire file is licensed to you under the MIT license. You can find the license written at the end of this file.*/
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
/*
MIT License

Copyright (c) 2024 Snowhawk

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/
