import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fin_assistant/budget_goals.dart';
import 'package:fin_assistant/main.dart';

class InMemoryBudgetGoalsRepository implements BudgetGoalsRepository {
  final Map<String, BudgetGoal> goals = {};

  @override
  Future<void> delete(String id) async {
    goals.remove(id);
  }

  @override
  Future<List<BudgetGoal>> load() async => goals.values.toList();

  @override
  Future<void> save(BudgetGoal goal) async {
    goals[goal.id] = goal;
  }
}

Future<InMemoryBudgetGoalsRepository> openNewBudgetFlow(
  WidgetTester tester, {
  String name = 'Тестовая цель',
}) async {
  final repository = InMemoryBudgetGoalsRepository();
  await tester.pumpWidget(FinConsultantApp(repository: repository));
  await tester.tap(find.text('Новый расчёт'));
  await tester.pumpAndSettle();
  await tester.enterText(find.byKey(const ValueKey('goalNameField')), name);
  await tester.tap(find.widgetWithText(FilledButton, 'Создать'));
  await tester.pumpAndSettle();
  return repository;
}

Future<void> createGoalFromList(WidgetTester tester, String name) async {
  await tester.tap(find.text('Новый расчёт'));
  await tester.pumpAndSettle();
  await tester.enterText(find.byKey(const ValueKey('goalNameField')), name);
  await tester.tap(find.widgetWithText(FilledButton, 'Создать'));
  await tester.pumpAndSettle();
  await tester.pageBack();
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows calculations and bottom navigation', (tester) async {
    await tester.pumpWidget(
      FinConsultantApp(repository: InMemoryBudgetGoalsRepository()),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Ваши средства'), findsOneWidget);
    expect(find.text('Расчёты'), findsOneWidget);
    expect(find.text('Ассистент'), findsOneWidget);
    expect(find.text('Настройки'), findsOneWidget);
    expect(find.text('Новый расчёт'), findsOneWidget);
    expect(find.text('Сохранённых расчётов пока нет.'), findsOneWidget);

    await tester.tap(find.text('Ассистент'));
    await tester.pumpAndSettle();
    expect(find.text('Скоро здесь появится ассистент'), findsOneWidget);
  });

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

  testWidgets('keeps named budget goals separate and allows deleting one', (
    tester,
  ) async {
    final repository = await openNewBudgetFlow(tester, name: 'Цель 1');
    await tester.enterText(find.byType(TextField).first, '12');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();

    await createGoalFromList(tester, 'Цель 2');
    expect(find.text('Цель 1'), findsOneWidget);
    expect(find.text('Цель 2'), findsOneWidget);
    expect(repository.goals, hasLength(2));

    await tester.tap(find.text('Цель 1'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<TextField>(find.byType(TextField).first).controller!.text,
      '12',
    );
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Удалить расчёт Цель 2'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Удалить'));
    await tester.pumpAndSettle();
    expect(find.text('Цель 1'), findsOneWidget);
    expect(find.text('Цель 2'), findsNothing);
    expect(repository.goals, hasLength(1));
  });

  testWidgets('prevents duplicate optional expenses and skips empty ones', (
    tester,
  ) async {
    Future<void> openOptionalExpenses() async {
      await openNewBudgetFlow(tester);
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
    await openNewBudgetFlow(tester);
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
      await openNewBudgetFlow(tester);

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
      await tester.ensureVisible(find.text('Рассчитать'));
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
      expect(find.textContaining('кешбэк'), findsWidgets);
      final cashbackRateField = find.byWidgetPredicate(
        (widget) =>
            widget is TextField &&
            widget.decoration?.labelText == 'Примерный кешбэк, %',
      );
      await tester.enterText(cashbackRateField, '10');
      await tester.pumpAndSettle();
      final cashbackEstimate = find.text(
        'Оценка кешбэка: 100 ₽ в месяц. За весь период вы сэкономите 1 200 ₽.',
      );
      expect(cashbackEstimate, findsOneWidget);
      final depositEstimate = find.textContaining('При ставке 8.0%');
      expect(depositEstimate, findsOneWidget);
      expect(
        tester.getTopLeft(find.text('Рассчитать рекомендации')).dy,
        greaterThan(tester.getTopLeft(depositEstimate).dy),
      );
      expect(
        tester
            .getTopLeft(
              find.text(
                'Согласны следовать рекомендациям по оптимизации расходов?',
              ),
            )
            .dy,
        greaterThan(tester.getTopLeft(find.text('Рассчитать рекомендации')).dy),
      );
      expect(
        find.text('Согласны следовать рекомендациям по оптимизации расходов?'),
        findsOneWidget,
      );
      await tester.enterText(find.byType(TextField).first, '12');
      await tester.tap(find.text('Рассчитать рекомендации'));
      await tester.pumpAndSettle();
      expect(cashbackEstimate, findsOneWidget);
      var expectedDepositBalance = 0.0;
      for (var month = 0; month < 12; month++) {
        expectedDepositBalance += 28400;
        expectedDepositBalance *= 1.01;
      }
      final expectedDepositInterest = expectedDepositBalance - 28400 * 12;
      final depositResult = tester
          .widget<Text>(find.textContaining('При ставке 12.0% годовых'))
          .data!;
      expect(depositResult, contains('начислится'));
      expect(depositResult, contains(fmtNum(expectedDepositInterest)));

      await tester.ensureVisible(find.text('Да, применить рекомендации'));
      await tester.tap(find.text('Да, применить рекомендации'));
      await tester.pumpAndSettle();
      expect(find.text('Экономия'), findsOneWidget);
      final expectedOptimizedTotal =
          28000 * 12 + 4800 + 100 * 12 + expectedDepositInterest;
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
      expect(find.textContaining('Кешбэк:'), findsNothing);
      expect(find.textContaining('Проценты по вкладу:'), findsNothing);

      await tester.tap(find.text('Назад'));
      await tester.pumpAndSettle();
      expect(find.text('Экономия'), findsNothing);
      await tester.tap(find.text('Рассчитать варианты финансирования'));
      await tester.pumpAndSettle();
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
      expect(
        find.text('Кешбэк: 100 ₽ в месяц, 1 200 ₽ за срок.'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'calculates financing for the current result and supports optimization choice',
    (tester) async {
      await openNewBudgetFlow(tester);

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
      await tester.ensureVisible(find.text('Рассчитать'));
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
      expect(find.textContaining('Сравнение сценариев'), findsOneWidget);
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
