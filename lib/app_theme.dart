import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Палитра из рекламного макета: сиреневый, бирюзовый, персиковый.
class AppColors {
  static const primary = Color(0xFF5B3FB5);
  static const primarySoft = Color(0xFFEFE8FA);
  static const lilac = Color(0xFF9370D3);
  static const teal = Color(0xFF86D9DB);
  static const tealSoft = Color(0xFFD9F2F2);
  static const tealDark = Color(0xFF0B5B5E);
  static const peach = Color(0xFFFBC9B8);
  static const peachSoft = Color(0xFFFFF1EA);
  static const peachDark = Color(0xFF5A2A1A);
  static const background = Color(0xFFF6F2FC);
  static const outline = Color(0xFFD9CCF0);
  static const line = Color(0xFFE4DAF5);
  static const ink = Color(0xFF1E1B3A);
  static const muted = Color(0xFF5E5A78);
}

/// Шрифты: Lora для заголовков, Manrope для остального.
/// Если файлы шрифтов не подключены в pubspec.yaml, Flutter берёт системный.
class AppText {
  static const display = TextStyle(
    fontFamily: 'Lora',
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: AppColors.ink,
  );
  static const cardTitle = TextStyle(
    fontFamily: 'Lora',
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: AppColors.ink,
  );
  static const subtitle = TextStyle(fontSize: 14, color: AppColors.muted);
  static const step = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );
  static const bigNumber = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AppColors.ink,
  );
}

BoxDecoration appCardDecoration({Color color = Colors.white}) => BoxDecoration(
  color: color,
  borderRadius: BorderRadius.circular(24),
  boxShadow: const [BoxShadow(color: AppColors.line, offset: Offset(0, 2))],
);

OutlineInputBorder _border(Color color, [double width = 2]) =>
    OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color, width: width),
    );

ThemeData buildAppTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    primary: AppColors.primary,
    onPrimary: Colors.white,
    secondary: AppColors.tealDark,
    secondaryContainer: AppColors.tealSoft,
    tertiary: AppColors.peach,
    surface: Colors.white,
    onSurface: AppColors.ink,
    outline: AppColors.outline,
  );
  const stadium = StadiumBorder();
  const buttonText = TextStyle(fontSize: 16, fontWeight: FontWeight.w700);
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: 'Manrope',
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0,
      centerTitle: false,
      foregroundColor: AppColors.ink,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: TextStyle(
        fontFamily: 'Lora',
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.ink,
      ),
    ),
    // Тест проверяет, что у ElevatedButton белый текст, поэтому
    // foregroundColor здесь задан явно.
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size(0, 52),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        shape: stadium,
        textStyle: buttonText,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(0, 52),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        shape: stadium,
        textStyle: buttonText,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        backgroundColor: Colors.white,
        minimumSize: const Size(0, 52),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        side: const BorderSide(color: AppColors.primary, width: 2),
        shape: stadium,
        textStyle: buttonText,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: buttonText,
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: AppColors.muted),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
      labelStyle: const TextStyle(
        color: AppColors.muted,
        fontWeight: FontWeight.w600,
      ),
      border: _border(AppColors.outline),
      enabledBorder: _border(AppColors.outline),
      focusedBorder: _border(AppColors.primary),
      errorBorder: _border(const Color(0xFFB3261E)),
      focusedErrorBorder: _border(const Color(0xFFB3261E)),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
      linearTrackColor: AppColors.line,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.ink,
      contentTextStyle: const TextStyle(color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}

final appTheme = buildAppTheme();

/// Круглая метка приложения (по мотивам рекламы).
class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) => Container(
    width: 40,
    height: 40,
    decoration: const BoxDecoration(
      color: AppColors.teal,
      shape: BoxShape.circle,
    ),
    child: Center(
      child: Container(
        width: 26,
        height: 26,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.trending_up, size: 16, color: AppColors.peach),
      ),
    ),
  );
}

/// Статус цели: бирюзовый, если достигается, персиковый, если нет.
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.ok, required this.text});

  final bool ok;
  final String text;

  @override
  Widget build(BuildContext context) {
    final fg = ok ? AppColors.tealDark : AppColors.peachDark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: ok ? AppColors.tealSoft : AppColors.peach,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            ok ? Icons.check_circle_outline : Icons.info_outline,
            size: 16,
            color: fg,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: fg,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Пояснение мелким шрифтом на тёплом фоне (оговорки, предупреждения).
class InfoNote extends StatelessWidget {
  const InfoNote(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppColors.peachSoft,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.info_outline, size: 18, color: AppColors.peachDark),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              height: 1.4,
              color: Color(0xFF4A2A20),
            ),
          ),
        ),
      ],
    ),
  );
}
