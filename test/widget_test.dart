import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_dart_app/main.dart';

void main() {
  test('calculates card interest by actual days', () {
    expect(
      calculateCardInterest(50000, 25, 20, startDate: DateTime(2025, 1, 1)),
      closeTo(684.93, 0.01),
    );
    expect(
      calculateCardInterest(50000, 25, 20, startDate: DateTime(2024, 1, 1)),
      closeTo(683.06, 0.01),
    );
  });

  testWidgets(
    'offers category dropdowns and recommendations before optimization',
    (tester) async {
      await tester.pumpWidget(const FinConsultantApp());
      await tester.tap(find.text('Расчёт бюджета'));
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);
      await tester.enterText(fields.at(0), '12');
      await tester.enterText(fields.at(1), '1100000');
      await tester.enterText(fields.at(2), '50000');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Далее'));
      await tester.pumpAndSettle();

      expect(find.byType(DropdownButtonFormField<String>), findsWidgets);
      await tester.tap(find.byType(DropdownButtonFormField<String>).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Жилье').last);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, '20000');

      await tester.tap(find.widgetWithText(ElevatedButton, 'Далее'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'Далее'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).at(0), 'Кофе');
      await tester.enterText(find.byType(TextField).at(1), '1000');
      await tester.tap(find.byTooltip('Растянуть сумму на все месяцы').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Рассчитать'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'Далее'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Изменить расходы'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, '4800');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Далее'));
      await tester.pumpAndSettle();

      expect(find.text('Экономия'), findsOneWidget);
      await tester.tap(find.text('Показать рекомендации'));
      await tester.pumpAndSettle();
      expect(find.textContaining('вклад'), findsWidgets);
      expect(find.textContaining('кешбек'), findsWidgets);

      await tester.tap(find.text('Применить рекомендации'));
      await tester.pumpAndSettle();
      expect(find.text('Экономия'), findsOneWidget);
    },
  );

  testWidgets(
    'calculates financing for the current result and supports optimization choice',
    (tester) async {
      await tester.pumpWidget(const FinConsultantApp());
      await tester.tap(find.text('Расчёт бюджета'));
      await tester.pumpAndSettle();

      final buttonTheme = Theme.of(
        tester.element(find.widgetWithText(ElevatedButton, 'Далее')),
      ).elevatedButtonTheme;
      expect(buttonTheme.style?.foregroundColor?.resolve({}), Colors.white);

      await tester.enterText(find.byType(TextField).at(0), '12');
      await tester.enterText(find.byType(TextField).at(1), '1100000');
      await tester.enterText(find.byType(TextField).at(2), '50000');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Далее'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'Далее'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'Далее'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).at(0), 'Кофе');
      await tester.enterText(find.byType(TextField).at(1), '1000');
      await tester.tap(find.byTooltip('Растянуть сумму на все месяцы').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Рассчитать'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'Далее'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Изменить расходы'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, '4800');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Далее'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Рассчитать варианты финансирования'));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Как покрыть недостающую сумму?'),
        findsOneWidget,
      );

      await tester.tap(find.text('Кредитная карта'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).last, '24');
      await tester.tap(find.byType(DropdownButtonFormField<bool>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Да').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Рассчитать проценты'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Оценка процентов за'), findsOneWidget);

      await tester.ensureVisible(find.text('Назад'));
      await tester.tap(find.text('Назад'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Рассчитать кредит'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).at(1), '12');
      await tester.enterText(find.byType(TextField).at(2), '12');
      await tester.tap(find.text('Рассчитать'));
      await tester.pumpAndSettle();

      expect(find.text('Ежемесячный платёж'), findsOneWidget);
      expect(find.text('Переплата по процентам'), findsOneWidget);
    },
  );
}
