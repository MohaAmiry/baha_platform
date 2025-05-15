import "package:flutter/material.dart";

import "AssetsManager.dart";
import "ValuesManager.dart";

mixin ColorManager {
  static const Color primary = Color(0xffa0d49b);
  static const Color primaryWOpacity20 = Color(0xda0d49b);
  static const Color surfaceTint = Color(0xffa0d49b);
  static const Color onPrimary = Color(0xff083910);
  static const Color primaryContainer = Color(0xff225024);
  static const Color onPrimaryContainer = Color(0xffbbf0b5);
  static const Color secondary = Color(0xffb9ccb4);
  static const Color onSecondary = Color(0xff253423);
  static const Color secondaryContainer = Color(0xff3b4b39);
  static const Color onSecondaryContainer = Color(0xffd5e8cf);
  static const Color tertiary = Color(0xffa1ced4);
  static const Color onTertiary = Color(0xff00363b);
  static const Color tertiaryContainer = Color(0xff1f4d52);
  static const Color onTertiaryContainer = Color(0xffbcebf1);
  static const Color error = Color(0xffffb4ab);
  static const Color onError = Color(0xff690005);
  static const Color errorContainer = Color(0xff93000a);
  static const Color onErrorContainer = Color(0xffffdad6);
  static const Color background = Color(0xff10140f);
  static const Color onBackground = Color(0xffe0e4db);
  static const Color surface = Color(0xff10140f);
  static const Color onSurface = Color(0xffe0e4db);
  static const Color surfaceVariant = Color(0xff424940);
  static const Color onSurfaceVariant = Color(0xffc2c9bd);
  static const Color outline = Color(0xff8c9388);
  static const Color outlineVariant = Color(0xff424940);
  static const Color shadow = Color(0xff000000);
  static const Color scrim = Color(0xff000000);
  static const Color inverseSurface = Color(0xffe0e4db);
  static const Color inverseOnSurface = Color(0xff2d322c);
  static const Color inversePrimary = Color(0xff3a693a);
  static const Color primaryFixed = Color(0xffbbf0b5);
  static const Color onPrimaryFixed = Color(0xff002205);
  static const Color primaryFixedDim = Color(0xffa0d49b);
  static const Color onPrimaryFixedVariant = Color(0xff225024);
  static const Color secondaryFixed = Color(0xffd5e8cf);
  static const Color onSecondaryFixed = Color(0xff101f10);
  static const Color secondaryFixedDim = Color(0xffb9ccb4);
  static const Color onSecondaryFixedVariant = Color(0xff3b4b39);
  static const Color tertiaryFixed = Color(0xffbcebf1);
  static const Color onTertiaryFixed = Color(0xff001f23);
  static const Color tertiaryFixedDim = Color(0xffa1ced4);
  static const Color onTertiaryFixedVariant = Color(0xff1f4d52);
  static const Color surfaceDim = Color(0xff10140f);
  static const Color surfaceBright = Color(0xff363a34);
  static const Color surfaceContainerLowest = Color(0xff0b0f0a);
  static const Color surfaceContainerLow = Color(0xff181d17);
  static const Color surfaceContainer = Color(0xff1c211b);
  static const Color surfaceContainerHigh = Color(0xff272b25);
  static const Color surfaceContainerHighest = Color(0xff323630);
}

mixin ThemeManager {
  static const Color surfaceContainerHighest = Color(0xff323630);

  static MaterialScheme darkScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: ColorManager.primary,
      surfaceTint: ColorManager.surfaceTint,
      onPrimary: ColorManager.onPrimary,
      primaryContainer: ColorManager.primaryContainer,
      onPrimaryContainer: ColorManager.onPrimaryContainer,
      secondary: ColorManager.secondary,
      onSecondary: ColorManager.onSecondary,
      secondaryContainer: ColorManager.secondaryContainer,
      onSecondaryContainer: ColorManager.onSecondaryContainer,
      tertiary: ColorManager.tertiary,
      onTertiary: ColorManager.onTertiary,
      tertiaryContainer: ColorManager.tertiaryContainer,
      onTertiaryContainer: ColorManager.onTertiaryContainer,
      error: ColorManager.error,
      onError: ColorManager.onError,
      errorContainer: ColorManager.errorContainer,
      onErrorContainer: ColorManager.onErrorContainer,
      background: ColorManager.background,
      onBackground: ColorManager.onBackground,
      surface: ColorManager.surface,
      onSurface: ColorManager.onSurface,
      surfaceVariant: ColorManager.surfaceVariant,
      onSurfaceVariant: ColorManager.onSurfaceVariant,
      outline: ColorManager.outline,
      outlineVariant: ColorManager.outlineVariant,
      shadow: ColorManager.shadow,
      scrim: ColorManager.scrim,
      inverseSurface: ColorManager.inverseSurface,
      inverseOnSurface: ColorManager.inverseOnSurface,
      inversePrimary: ColorManager.inversePrimary,
      primaryFixed: ColorManager.primaryFixed,
      onPrimaryFixed: ColorManager.onPrimaryFixed,
      primaryFixedDim: ColorManager.primaryFixedDim,
      onPrimaryFixedVariant: ColorManager.onPrimaryFixedVariant,
      secondaryFixed: ColorManager.secondaryFixed,
      onSecondaryFixed: ColorManager.onSecondaryFixed,
      secondaryFixedDim: ColorManager.secondaryFixedDim,
      onSecondaryFixedVariant: ColorManager.onSecondaryFixedVariant,
      tertiaryFixed: ColorManager.tertiaryFixed,
      onTertiaryFixed: ColorManager.onTertiaryFixed,
      tertiaryFixedDim: ColorManager.tertiaryFixedDim,
      onTertiaryFixedVariant: ColorManager.onTertiaryFixedVariant,
      surfaceDim: ColorManager.surfaceDim,
      surfaceBright: ColorManager.surfaceBright,
      surfaceContainerLowest: ColorManager.surfaceContainerLowest,
      surfaceContainerLow: ColorManager.surfaceContainerLow,
      surfaceContainer: ColorManager.surfaceContainer,
      surfaceContainerHigh: ColorManager.surfaceContainerHigh,
      surfaceContainerHighest: ColorManager.surfaceContainerHigh,
    );
  }

  static ThemeData dark() {
    return theme(
        colorScheme: darkScheme().toColorScheme(),
        buttonThemeData: _buttonTheme,
        elevatedButtonThemeData: getElevatedButtonThemeConfirm());
  }

  static ThemeData theme(
          {required ColorScheme colorScheme,
          ElevatedButtonThemeData? elevatedButtonThemeData,
          ButtonThemeData? buttonThemeData}) =>
      ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: const TextTheme().apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        cardTheme: _cardTheme,
        elevatedButtonTheme: elevatedButtonThemeData,
        buttonTheme: buttonThemeData,
        visualDensity: VisualDensity.compact,
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      );

  static final CardTheme _cardTheme = CardTheme(
    elevation: AppSizeManager.s10,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizeManager.s5)),
    surfaceTintColor: ColorManager.primary,
    shadowColor: ColorManager.shadow,
  );

  static const ButtonThemeData _buttonTheme =
      ButtonThemeData(shape: RoundedRectangleBorder());

  static ElevatedButtonThemeData _elevatedButtonThemeBuilder(
      {double width = AppSizeManager.s135,
      Color foregroundColor = ColorManager.primaryContainer,
      Color backgroundColor = ColorManager.primary}) {
    return ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      elevation: AppSizeManager.s10,
      shadowColor: Colors.transparent,
      padding: const EdgeInsets.symmetric(
          vertical: AppSizeManager.s10, horizontal: AppSizeManager.s10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizeManager.s5)),
      minimumSize: const Size.fromHeight(AppSizeManager.s45),
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
    ));
  }

  static ElevatedButtonThemeData getElevatedButtonThemeConfirm() =>
      _elevatedButtonThemeBuilder();

  static ElevatedButtonThemeData getElevatedButtonThemeEdit() =>
      _elevatedButtonThemeBuilder(
          foregroundColor: ColorManager.onTertiaryContainer,
          backgroundColor: ColorManager.tertiaryContainer);

  static ElevatedButtonThemeData getElevatedButtonThemeSmall(
          {Color? backgroundColor}) =>
      _elevatedButtonThemeBuilder(
          width: AppSizeManager.s10,
          backgroundColor: backgroundColor ?? ColorManager.primaryContainer);

  static ElevatedButtonThemeData getElevatedButtonThemeRisk() =>
      _elevatedButtonThemeBuilder(
          foregroundColor: ColorManager.error,
          backgroundColor: ColorManager.errorContainer);

  static BoxDecoration scaffoldBackground = const BoxDecoration(
    image: DecorationImage(
      image: AssetImage(ImageAssetsManager.scaffoldBackground),
      opacity: .05,
      fit: BoxFit.contain,
    ),
  );

  /// Custom Color
  static const customColor = ExtendedColor(
    seed: Color(0xff3f7ec7),
    value: Color(0xff3f7ec7),
    dark: ColorFamily(
      color: Color(0xffa4c9fe),
      onColor: Color(0xff00315d),
      colorContainer: Color(0xff204876),
      onColorContainer: Color(0xffd3e3ff),
    ),
  );

  List<ExtendedColor> get extendedColors => [
        customColor,
      ];
}

class MaterialScheme {
  const MaterialScheme({
    required this.brightness,
    required this.primary,
    required this.surfaceTint,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.tertiary,
    required this.onTertiary,
    required this.tertiaryContainer,
    required this.onTertiaryContainer,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.surfaceVariant,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.shadow,
    required this.scrim,
    required this.inverseSurface,
    required this.inverseOnSurface,
    required this.inversePrimary,
    required this.primaryFixed,
    required this.onPrimaryFixed,
    required this.primaryFixedDim,
    required this.onPrimaryFixedVariant,
    required this.secondaryFixed,
    required this.onSecondaryFixed,
    required this.secondaryFixedDim,
    required this.onSecondaryFixedVariant,
    required this.tertiaryFixed,
    required this.onTertiaryFixed,
    required this.tertiaryFixedDim,
    required this.onTertiaryFixedVariant,
    required this.surfaceDim,
    required this.surfaceBright,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
  });

  final Brightness brightness;
  final Color primary;
  final Color surfaceTint;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color shadow;
  final Color scrim;
  final Color inverseSurface;
  final Color inverseOnSurface;
  final Color inversePrimary;
  final Color primaryFixed;
  final Color onPrimaryFixed;
  final Color primaryFixedDim;
  final Color onPrimaryFixedVariant;
  final Color secondaryFixed;
  final Color onSecondaryFixed;
  final Color secondaryFixedDim;
  final Color onSecondaryFixedVariant;
  final Color tertiaryFixed;
  final Color onTertiaryFixed;
  final Color tertiaryFixedDim;
  final Color onTertiaryFixedVariant;
  final Color surfaceDim;
  final Color surfaceBright;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
}

extension MaterialSchemeUtils on MaterialScheme {
  ColorScheme toColorScheme() {
    return ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      onTertiary: onTertiary,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      error: error,
      onError: onError,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      background: background,
      onBackground: onBackground,
      surface: surface,
      onSurface: onSurface,
      surfaceVariant: surfaceVariant,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      shadow: shadow,
      scrim: scrim,
      inverseSurface: inverseSurface,
      onInverseSurface: inverseOnSurface,
      inversePrimary: inversePrimary,
    );
  }
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily dark;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.dark,
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
