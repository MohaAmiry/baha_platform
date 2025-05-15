/*
mixin ThemeManager {
  static final ThemeData lightThemeData = ThemeData(
      fontFamily: FontManager.fontFamily,
      appBarTheme: _appBarTheme,
      textTheme: _textTheme,
      inputDecorationTheme: _textFormFieldTheme,
      cardTheme: _cardTheme,
      iconButtonTheme: _iconButtonThemeData,
      useMaterial3: true);

  static final IconButtonThemeData _iconButtonThemeData = IconButtonThemeData(
      style: IconButton.styleFrom(
    elevation: AppSizeManager.s10,
    backgroundColor: ColorManager.primaryContainer,
    foregroundColor: ColorManager.secondary,
    iconSize: AppSizeManager.s20,
    padding: const EdgeInsets.symmetric(
        horizontal: PaddingValuesManager.p10,
        vertical: PaddingValuesManager.p5),
  ));

  static const CardTheme _cardTheme = CardTheme(
    elevation: AppSizeManager.s10,
    color: ColorManager.primaryContainer,
    surfaceTintColor: ColorManager.primaryContainer,
    shadowColor: ColorManager.shadow,
  );

  static final AppBarTheme _appBarTheme = AppBarTheme(
      shadowColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      foregroundColor: ColorManager.primary,
      titleTextStyle: TextStyleManager.getBoldStyle(size: FontSizeManager.s16));


  static final TextTheme _textTheme = TextTheme(
      bodySmall: TextStyleManager.getRegularStyle(size: FontSizeManager.s10),
      bodyMedium:
          TextStyleManager.getRegularStyle(color: ColorManager.secondary),
      bodyLarge: TextStyleManager.getRegularStyle(size: FontSizeManager.s14),
      headlineMedium: TextStyleManager.getBoldStyle(size: FontSizeManager.s12),
      headlineLarge: TextStyleManager.getBoldStyle(size: FontSizeManager.s14),
      titleMedium: TextStyleManager.getBoldStyle(size: FontSizeManager.s16),
      titleLarge: TextStyleManager.getBoldStyle(size: FontSizeManager.s20));

  static final InputDecorationTheme _textFormFieldTheme = InputDecorationTheme(
      isDense: true,
      fillColor: ColorManager.primaryContainer,
      filled: true,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizeManager.s10)),
      contentPadding: const EdgeInsets.all(PaddingValuesManager.p10),
      hintStyle: TextStyleManager.getRegularStyle(),
      labelStyle:
          TextStyleManager.getRegularStyle(color: ColorManager.secondary),
      errorStyle: TextStyleManager.getRegularStyle(color: ColorManager.error),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizeManager.s10),
          borderSide: const BorderSide(color: ColorManager.onPrimary)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizeManager.s10),
          borderSide: const BorderSide(color: ColorManager.primary)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizeManager.s10),
          borderSide: const BorderSide(color: ColorManager.errorContainer)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizeManager.s10),
          borderSide: const BorderSide(color: ColorManager.tertiary)));
}


 */
