import 'dart:math' as math;

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
  static const section = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    color: AppColors.ink,
  );
  static const year = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w800,
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
    dataTableTheme: const DataTableThemeData(
      headingRowColor: WidgetStatePropertyAll(AppColors.primarySoft),
      headingTextStyle: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        color: AppColors.ink,
      ),
      dataRowMinHeight: 64,
      dataRowMaxHeight: 80,
      columnSpacing: 20,
      dividerThickness: 1,
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

/// Группа кнопок действий. Заменяет Wrap: кнопки выстраиваются
/// на всю ширину карточки, а короткие «Назад»/«В начало» стоят в одном ряду.
class ActionButtons extends StatelessWidget {
  const ActionButtons({
    super.key,
    this.spacing = 12,
    this.runSpacing = 8,
    required this.children,
  });

  final double spacing;
  final double runSpacing;
  final List<Widget> children;

  static String _label(Widget w) {
    if (w is ButtonStyleButton) {
      final child = w.child;
      if (child is Text) return child.data ?? '';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    var lead = 0;
    while (lead < children.length &&
        lead < 2 &&
        children[lead] is OutlinedButton &&
        _label(children[lead]).length <= 10) {
      lead++;
    }
    final blocks = <Widget>[];
    if (lead == 1 && children.length == 2) {
      // «Назад» + основная кнопка: один ряд
      blocks.add(
        Row(
          children: [
            Expanded(flex: 2, child: children[0]),
            SizedBox(width: spacing),
            Expanded(flex: 3, child: children[1]),
          ],
        ),
      );
    } else if (lead == 2 && children.length > 2) {
      // «Назад» + «В начало» в ряд, основная кнопка ниже
      blocks.add(
        Row(
          children: [
            Expanded(child: children[0]),
            SizedBox(width: spacing),
            Expanded(child: children[1]),
          ],
        ),
      );
      blocks.addAll(children.sublist(2));
    } else {
      blocks.addAll(children);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < blocks.length; i++) ...[
          if (i > 0) SizedBox(height: spacing),
          blocks[i],
        ],
      ],
    );
  }
}

/// Кольцо прогресса к цели. Больше 100%: второй круг бирюзовым.
class GoalRing extends StatelessWidget {
  const GoalRing({super.key, required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final percent = (value * 100).round();
    return Semantics(
      label: 'Выполнено $percent% цели',
      child: SizedBox(
        width: 168,
        height: 168,
        child: CustomPaint(
          painter: _RingPainter(value),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$percent%',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
                const Text('от цели', style: AppText.subtitle),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.value);

  final double value;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 14.0;
    final rect = Offset.zero & size;
    final arcRect = rect.deflate(stroke / 2);
    Paint paint(Color color) => Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = color;
    canvas.drawArc(arcRect, 0, 2 * math.pi, false, paint(AppColors.line));
    final first = value.clamp(0.0, 1.0);
    if (first > 0) {
      canvas.drawArc(
        arcRect,
        -math.pi / 2,
        2 * math.pi * first,
        false,
        paint(AppColors.primary),
      );
    }
    final second = (value - 1).clamp(0.0, 1.0);
    if (second > 0) {
      canvas.drawArc(
        arcRect,
        -math.pi / 2,
        2 * math.pi * second,
        false,
        paint(AppColors.teal),
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.value != value;
}
