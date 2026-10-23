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

  test('calculates annuity and differentiated loan payments', () {
    final annuityPayment = calculateLoanPayment(
      120000,
      12,
      12,
      LoanPaymentType.annuity,
    );
    final differentiatedPayment = calculateLoanPayment(
      120000,
      12,
      12,
      LoanPaymentType.differentiated,
    );

    expect(differentiatedPayment, closeTo(11200, 0.01));
    expect(
      calculateLoanOverpayment(120000, 12, 12, LoanPaymentType.differentiated),
      closeTo(7800, 0.01),
    );
    expect(
      calculateLoanOverpayment(120000, 12, 12, LoanPaymentType.differentiated),
      lessThan(
        calculateLoanOverpayment(120000, 12, 12, LoanPaymentType.annuity),
      ),
    );
    expect(annuityPayment, lessThan(differentiatedPayment));
  });

  testWidgets('prevents duplicate optional expenses and skips empty ones', (
    tester,
  ) async {
    Future<void> openOptionalExpenses() async {
      await tester.pumpWidget(const FinConsultantApp());
      await tester.tap(find.text('Расчёт бюджета'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).at(0), '12');
      await tester.enterText(find.byType(TextField).at(2), '100000');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Далее'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'Далее'));
      await tester.pumpAndSettle();
    }

    await openOptionalExpenses();
    await tester.tap(find.text('Добавить расход'));
    await tester.pumpAndSettle();
    final categoryFields = find.byWidgetPredicate(
      (widget) =>
          widget is TextField &&
          widget.decoration?.labelText == 'Категория или свой расход',
    );
    await tester.enterText(categoryFields.at(0), 'Уход за питомцем');
    await tester.enterText(categoryFields.at(1), ' уход за питомцем ');
    await tester.ensureVisible(find.text('Рассчитать'));
    await tester.tap(find.text('Рассчитать'));
    await tester.pumpAndSettle();
    expect(
      find.text('Один и тот же расход нельзя указать дважды.'),
      findsOneWidget,
    );

    await tester.ensureVisible(find.byTooltip('Удалить расход').last);
    await tester.tap(find.byTooltip('Удалить расход').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Рассчитать'));
    await tester.tap(find.text('Рассчитать'));
    await tester.pumpAndSettle();
    expect(find.text('Изменить расходы'), findsNothing);
  });

  testWidgets('shows one optional expense in each year of the budget', (
    tester,
  ) async {
    await tester.pumpWidget(const FinConsultantApp());
    await tester.tap(find.text('Расчёт бюджета'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), '13');
    await tester.enterText(find.byType(TextField).at(2), '100000');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Далее'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Далее'));
    await tester.pumpAndSettle();

    final categoryField = find.byWidgetPredicate(
      (widget) =>
          widget is TextField &&
          widget.decoration?.labelText == 'Категория или свой расход',
    );
    await tester.enterText(categoryField, 'Кофе');
    await tester.enterText(find.byType(TextField).at(1), '2000');
    expect(find.text('Кофе'), findsOneWidget);
  });

  testWidgets(
    'allows custom monthly expense categories and calculates deposit on demand',
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

      await tester.enterText(find.byType(TextField).first, 'Уход за питомцем');
      await tester.enterText(find.byType(TextField).at(1), '20000');
      await tester.tap(find.text('+ Добавить строку'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<TextField>(find.byType(TextField).first).controller!.text,
        'Уход за питомцем',
      );
      await tester.enterText(find.byType(TextField).at(2), 'Питание');
      await tester.enterText(find.byType(TextField).at(3), '1000');

      await tester.tap(find.widgetWithText(ElevatedButton, 'Далее'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).at(0), 'Кофе');
      await tester.enterText(find.byType(TextField).at(1), '1000');
      await tester.tap(find.byTooltip('Растянуть сумму на все месяцы').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Рассчитать'));
      await tester.pumpAndSettle();
      expect(find.text('28 000 ₽'), findsOneWidget);
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
      expect(
        find.text('Согласны следовать рекомендациям по оптимизации расходов?'),
        findsOneWidget,
      );
      await tester.enterText(find.byType(TextField).first, '12');
      await tester.tap(find.text('Рассчитать вклад'));
      await tester.pumpAndSettle();
      var expectedDepositBalance = 0.0;
      for (var month = 0; month < 12; month++) {
        expectedDepositBalance += 28400;
        expectedDepositBalance *= 1.01;
      }
      final expectedDepositInterest = expectedDepositBalance - 28400 * 12;
      final depositResult = tester
          .widget<Text>(find.textContaining('12.0% годовых'))
          .data!;
      expect(depositResult, contains('начислится'));
      expect(depositResult, contains(fmtNum(expectedDepositInterest)));

      await tester.tap(find.text('Да, применить рекомендации'));
      await tester.pumpAndSettle();
      expect(find.text('Экономия'), findsOneWidget);
      final expectedOptimizedTotal =
          28000 * 12 + 4800 + 600 + expectedDepositInterest;
      expect(find.text('${fmtNum(expectedOptimizedTotal)} ₽'), findsOneWidget);

      await tester.tap(find.text('Рассчитать варианты финансирования'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(DropdownButtonFormField<ResultScenario>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Базовый итог').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Показать итог'));
      await tester.pumpAndSettle();
      expect(
        find.text('Базовый итог: 28 000 ₽ в месяц, 336 000 ₽ за срок.'),
        findsOneWidget,
      );

      await tester.tap(find.byType(DropdownButtonFormField<ResultScenario>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Оптимизированный итог').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Показать итог'));
      await tester.pumpAndSettle();
      expect(
        find.text(
          'Оптимизированный итог: ${fmtNum(expectedOptimizedTotal / 12)} ₽ в месяц, ${fmtNum(expectedOptimizedTotal)} ₽ за срок.',
        ),
        findsOneWidget,
      );
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
      expect(find.text('Кредитная карта'), findsNothing);
      await tester.tap(find.byType(DropdownButtonFormField<ResultScenario>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Оптимизированный итог').last);
      await tester.pumpAndSettle();
      expect(find.text('Кредитная карта'), findsNothing);
      await tester.tap(find.text('Показать итог'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Оптимизированный итог:'), findsOneWidget);

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
      expect(
        find.textContaining('Платёж меньше свободных накоплений'),
        findsOneWidget,
      );
      expect(find.text('Сократить срок до 11 мес.'), findsOneWidget);

      await tester.ensureVisible(find.text('В начало'));
      await tester.tap(find.text('В начало'));
      await tester.pumpAndSettle();
      expect(find.text('Рассчитать кредит'), findsNothing);
      expect(
        tester.widget<TextField>(find.byType(TextField).first).controller!.text,
        isEmpty,
      );
    },
  );
}
