# Animated Icon Button
A highly customizable and animated icon button widget made for Flutter. Featuring a shrinking animation while you are pressing the button.


[Video of animation here](https://youtu.be/ChOEYd7uwws?si=TwWAOyFo88WfGCP9)

## Getting Started
Simply add the `animated_icon_button.dart` into the `lib` folder located within your flutter project directory. Then you can use the widget like below.
```dart
AnimatedIconButton(
  leading: Icon(Icons.Add),
  trailing: Text("Add New"),
  onPress(){
    // Code
  },
);
```

No parameters are required for it to work, though at minimum you would have to set an [onPress] function.

```dart
AnimatedIconButton(
  onPress(){
    //Code
  },
);
```
By doing this, the button will just display with red text saying "Temp". Perfect for quickly testing things.

## Features
There are many customizable parameters, including ones for changing the background and hover colors, padding, animation speed, and more. Vibrations are enabled by default if on the Android platform.
