import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff1d6586),
      surfaceTint: Color(0xff1d6586),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffc4e7ff),
      onPrimaryContainer: Color(0xff001e2c),
      secondary: Color(0xff1a6585),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffc3e8ff),
      onSecondaryContainer: Color(0xff001e2c),
      tertiary: Color(0xff615690),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffe6deff),
      onTertiaryContainer: Color(0xff1d1148),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfff6fafe),
      onSurface: Color(0xff181c1f),
      onSurfaceVariant: Color(0xff41484d),
      outline: Color(0xff71787e),
      outlineVariant: Color(0xffc0c7cd),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2c3134),
      inversePrimary: Color(0xff90cef4),
      primaryFixed: Color(0xffc4e7ff),
      onPrimaryFixed: Color(0xff001e2c),
      primaryFixedDim: Color(0xff90cef4),
      onPrimaryFixedVariant: Color(0xff004c69),
      secondaryFixed: Color(0xffc3e8ff),
      onSecondaryFixed: Color(0xff001e2c),
      secondaryFixedDim: Color(0xff8fcff3),
      onSecondaryFixedVariant: Color(0xff004d68),
      tertiaryFixed: Color(0xffe6deff),
      onTertiaryFixed: Color(0xff1d1148),
      tertiaryFixedDim: Color(0xffcbbeff),
      onTertiaryFixedVariant: Color(0xff493e76),
      surfaceDim: Color(0xffd7dadf),
      surfaceBright: Color(0xfff6fafe),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff0f4f8),
      surfaceContainer: Color(0xffeaeef3),
      surfaceContainerHigh: Color(0xffe5e8ed),
      surfaceContainerHighest: Color(0xffdfe3e7),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff004864),
      surfaceTint: Color(0xff1d6586),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff3a7b9d),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff004862),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff387c9c),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff453a72),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff786ca8),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff6fafe),
      onSurface: Color(0xff181c1f),
      onSurfaceVariant: Color(0xff3d4449),
      outline: Color(0xff596065),
      outlineVariant: Color(0xff757c81),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2c3134),
      inversePrimary: Color(0xff90cef4),
      primaryFixed: Color(0xff3a7b9d),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff196283),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff387c9c),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff166382),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff786ca8),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff5f548d),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd7dadf),
      surfaceBright: Color(0xfff6fafe),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff0f4f8),
      surfaceContainer: Color(0xffeaeef3),
      surfaceContainerHigh: Color(0xffe5e8ed),
      surfaceContainerHighest: Color(0xffdfe3e7),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff002536),
      surfaceTint: Color(0xff1d6586),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff004864),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff002535),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff004862),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff24184f),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff453a72),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff6fafe),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff1e2529),
      outline: Color(0xff3d4449),
      outlineVariant: Color(0xff3d4449),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2c3134),
      inversePrimary: Color(0xffd9efff),
      primaryFixed: Color(0xff004864),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff003144),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff004862),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff003144),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff453a72),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff2f245a),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd7dadf),
      surfaceBright: Color(0xfff6fafe),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff0f4f8),
      surfaceContainer: Color(0xffeaeef3),
      surfaceContainerHigh: Color(0xffe5e8ed),
      surfaceContainerHighest: Color(0xffdfe3e7),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff90cef4),
      surfaceTint: Color(0xff90cef4),
      onPrimary: Color(0xff00344a),
      primaryContainer: Color(0xff004c69),
      onPrimaryContainer: Color(0xffc4e7ff),
      secondary: Color(0xff8fcff3),
      onSecondary: Color(0xff003549),
      secondaryContainer: Color(0xff004d68),
      onSecondaryContainer: Color(0xffc3e8ff),
      tertiary: Color(0xffcbbeff),
      onTertiary: Color(0xff32285e),
      tertiaryContainer: Color(0xff493e76),
      onTertiaryContainer: Color(0xffe6deff),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff0f1417),
      onSurface: Color(0xffdfe3e7),
      onSurfaceVariant: Color(0xffc0c7cd),
      outline: Color(0xff8b9297),
      outlineVariant: Color(0xff41484d),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdfe3e7),
      inversePrimary: Color(0xff1d6586),
      primaryFixed: Color(0xffc4e7ff),
      onPrimaryFixed: Color(0xff001e2c),
      primaryFixedDim: Color(0xff90cef4),
      onPrimaryFixedVariant: Color(0xff004c69),
      secondaryFixed: Color(0xffc3e8ff),
      onSecondaryFixed: Color(0xff001e2c),
      secondaryFixedDim: Color(0xff8fcff3),
      onSecondaryFixedVariant: Color(0xff004d68),
      tertiaryFixed: Color(0xffe6deff),
      onTertiaryFixed: Color(0xff1d1148),
      tertiaryFixedDim: Color(0xffcbbeff),
      onTertiaryFixedVariant: Color(0xff493e76),
      surfaceDim: Color(0xff0f1417),
      surfaceBright: Color(0xff353a3d),
      surfaceContainerLowest: Color(0xff0a0f12),
      surfaceContainerLow: Color(0xff181c1f),
      surfaceContainer: Color(0xff1c2023),
      surfaceContainerHigh: Color(0xff262b2e),
      surfaceContainerHighest: Color(0xff313539),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff94d3f8),
      surfaceTint: Color(0xff90cef4),
      onPrimary: Color(0xff001925),
      primaryContainer: Color(0xff5998bb),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xff93d3f7),
      onSecondary: Color(0xff001924),
      secondaryContainer: Color(0xff5798ba),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffcfc3ff),
      onTertiary: Color(0xff180a43),
      tertiaryContainer: Color(0xff9488c6),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff0f1417),
      onSurface: Color(0xfff8fbff),
      onSurfaceVariant: Color(0xffc5ccd2),
      outline: Color(0xff9da4aa),
      outlineVariant: Color(0xff7d848a),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdfe3e7),
      inversePrimary: Color(0xff004e6b),
      primaryFixed: Color(0xffc4e7ff),
      onPrimaryFixed: Color(0xff00131e),
      primaryFixedDim: Color(0xff90cef4),
      onPrimaryFixedVariant: Color(0xff003b52),
      secondaryFixed: Color(0xffc3e8ff),
      onSecondaryFixed: Color(0xff00131d),
      secondaryFixedDim: Color(0xff8fcff3),
      onSecondaryFixedVariant: Color(0xff003b51),
      tertiaryFixed: Color(0xffe6deff),
      onTertiaryFixed: Color(0xff12043e),
      tertiaryFixedDim: Color(0xffcbbeff),
      onTertiaryFixedVariant: Color(0xff382e65),
      surfaceDim: Color(0xff0f1417),
      surfaceBright: Color(0xff353a3d),
      surfaceContainerLowest: Color(0xff0a0f12),
      surfaceContainerLow: Color(0xff181c1f),
      surfaceContainer: Color(0xff1c2023),
      surfaceContainerHigh: Color(0xff262b2e),
      surfaceContainerHighest: Color(0xff313539),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfff8fbff),
      surfaceTint: Color(0xff90cef4),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xff94d3f8),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfff8fbff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xff93d3f7),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfffef9ff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffcfc3ff),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff0f1417),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfff8fbff),
      outline: Color(0xffc5ccd2),
      outlineVariant: Color(0xffc5ccd2),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdfe3e7),
      inversePrimary: Color(0xff002e41),
      primaryFixed: Color(0xffceebff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xff94d3f8),
      onPrimaryFixedVariant: Color(0xff001925),
      secondaryFixed: Color(0xffcdebff),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xff93d3f7),
      onSecondaryFixedVariant: Color(0xff001924),
      tertiaryFixed: Color(0xffebe3ff),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffcfc3ff),
      onTertiaryFixedVariant: Color(0xff180a43),
      surfaceDim: Color(0xff0f1417),
      surfaceBright: Color(0xff353a3d),
      surfaceContainerLowest: Color(0xff0a0f12),
      surfaceContainerLow: Color(0xff181c1f),
      surfaceContainer: Color(0xff1c2023),
      surfaceContainerHigh: Color(0xff262b2e),
      surfaceContainerHighest: Color(0xff313539),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.surface,
     canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
