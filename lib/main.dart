import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() => runApp(const FinConsultantApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can beflutter config --android-sdk "C:\SDK"
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

String fmtNum(double n) {
  final value = n.round();
  final text = value.abs().toString();
  final out = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    if (i > 0 && (text.length - i) % 3 == 0) out.write(' ');
    out.write(text[i]);
  }
  return (value < 0 ? '-' : '') + out.toString();
}

double calculateCardInterest(
  double debt,
  double annualRate,
  int days, {
  DateTime? startDate,
}) {
  if (debt <= 0 || annualRate <= 0 || days <= 0) return 0;
  var date = startDate ?? DateTime.now();
  var remainingDays = days;
  var interest = 0.0;
  while (remainingDays > 0) {
    final daysInYear = DateTime(
      date.year + 1,
      1,
      1,
    ).difference(DateTime(date.year, 1, 1)).inDays;
    final daysToYearEnd = DateTime(
      date.year + 1,
      1,
      1,
    ).difference(DateTime(date.year, date.month, date.day)).inDays;
    final daysInSegment = math.min(remainingDays, daysToYearEnd);
    interest += debt * annualRate / 100 * daysInSegment / daysInYear;
    remainingDays -= daysInSegment;
    date = DateTime(date.year, date.month, date.day + daysInSegment);
  }
  return interest;
}

final appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF1E2A38),
    primary: const Color(0xFF1E2A38),
    secondary: const Color(0xFF3F6B4B),
  ),
  scaffoldBackgroundColor: const Color(0xFFF1EEE2),
  fontFamily: 'Roboto',
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF1E2A38),
      foregroundColor: Colors.white,
    ),
  ),
);

class FinConsultantApp extends StatelessWidget {
  const FinConsultantApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Личный финКонсультант',
    theme: appTheme,
    home: const HomeScreen(),
    debugShowCheckedModeBanner: false,
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Личный финКонсультант',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              'Выберите, с чем хотите поработать',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 32),
            _SectionCard(
              'Расчёт бюджета',
              'Считаем, сколько вы накопите к сроку, и что изменится, если скорректировать необязательные траты.',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BudgetFlowScreen()),
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              'Ассистент',
              'Раздел в разработке.',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AssistantScreen()),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _SectionCard extends StatelessWidget {
  final String title, subtitle;
  final VoidCallback onTap;
  const _SectionCard(this.title, this.subtitle, this.onTap);
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFAF5),
        border: Border.all(color: const Color(0xFFD8D2C0)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
              height: 1.4,
            ),
          ),
        ],
      ),
    ),
  );
}

class AssistantScreen extends StatelessWidget {
  const AssistantScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Ассистент')),
    body: const Center(
      child: Text(
        'Скоро здесь появится финансовый ассистент.\n\nРаздел подключится к отдельному API-сервису.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black54),
      ),
    ),
  );
}

class ExpenseRow {
  final nameCtrl = TextEditingController();
  final amountCtrl = TextEditingController();
  final monthCtrls = <TextEditingController>[];
  final reductionCtrl = TextEditingController();
  double get amount =>
      double.tryParse(amountCtrl.text.replaceAll(',', '.')) ?? 0;
  double get periodTotal => monthCtrls.fold(
    0,
    (total, controller) =>
        total + (double.tryParse(controller.text.replaceAll(',', '.')) ?? 0),
  );
  double get reductionValue =>
      double.tryParse(reductionCtrl.text.replaceAll(',', '.')) ?? 0;
  String get name => nameCtrl.text;

  void ensureMonths(int count) {
    while (monthCtrls.length < count) {
      monthCtrls.add(TextEditingController());
    }
  }
}

enum WizStep {
  goal,
  fixedExpenses,
  periodicExpenses,
  optionalExpenses,
  baseline,
  optionalIntro,
  optionalEdit,
  finalStep,
  recommendations,
  financing,
  creditCard,
  loan,
}

enum ResultScenario { initial, optimized }

class BudgetFlowScreen extends StatefulWidget {
  const BudgetFlowScreen({super.key});

  @override
  State<BudgetFlowScreen> createState() => _BudgetFlowScreenState();
}

class _BudgetFlowScreenState extends State<BudgetFlowScreen> {
  static const monthNames = [
    'Январь',
    'Февраль',
    'Март',
    'Апрель',
    'Май',
    'Июнь',
    'Июль',
    'Август',
    'Сентябрь',
    'Октябрь',
    'Ноябрь',
    'Декабрь',
  ];

  static const expenseCategories = [
    'Жилье',
    'Питание',
    'Транспорт',
    'Здравоохранение',
    'Налоги',
    'Долги',
    'Страховки',
    'Связь',
    'Образование',
  ];

  static const cashbackCategories = [
    'Жилье',
    'Питание',
    'Транспорт',
    'Здравоохранение',
  ];

  WizStep step = WizStep.goal;
  final monthsCtrl = TextEditingController();
  final targetCtrl = TextEditingController();
  final incomeCtrl = TextEditingController();
  final reductionCtrl = TextEditingController();
  final depositRateCtrl = TextEditingController(text: '8');
  final loanAmountCtrl = TextEditingController();
  final loanTermCtrl = TextEditingController();
  final rateCtrl = TextEditingController();
  final cardRateCtrl = TextEditingController();
  List<ExpenseRow> fixed = [ExpenseRow()];
  List<ExpenseRow> mandatory = [ExpenseRow()];
  List<ExpenseRow> optional = [ExpenseRow()];
  final Map<ExpenseRow, double> reductions = {};
  int startMonth = DateTime.now().month;
  int startYear = DateTime.now().year;
  int optionalIndex = 0;
  bool loanCalculated = false;
  bool cardCalculated = false;
  bool? cardHas120DayGrace;
  ResultScenario selectedScenario = ResultScenario.initial;
  double baselineMonthly = 0;
  double baselineTotal = 0;
  double finalMonthly = 0;
  double finalTotal = 0;

  double get months =>
      double.tryParse(monthsCtrl.text.replaceAll(',', '.')) ?? 0;
  double get target =>
      double.tryParse(targetCtrl.text.replaceAll(',', '.')) ?? 0;
  double get activeMonthly => selectedScenario == ResultScenario.optimized
      ? finalMonthly
      : baselineMonthly;
  double get activeTotal =>
      selectedScenario == ResultScenario.optimized ? finalTotal : baselineTotal;
  double get shortfall => target - activeTotal;
  double get totalReduction =>
      reductions.values.fold(0, (total, amount) => total + amount);
  double get depositRate =>
      double.tryParse(depositRateCtrl.text.replaceAll(',', '.')) ?? 8;
  double get depositProjection {
    if (activeMonthly <= 0 || months <= 0 || depositRate <= 0) return 0;
    var balance = 0.0;
    final monthlyRate = depositRate / 100 / 12;
    for (var index = 0; index < months.ceil(); index++) {
      balance += activeMonthly;
      balance *= 1 + monthlyRate;
    }
    return balance;
  }

  double get cashbackSavings {
    final rows = <ExpenseRow>[...fixed, ...mandatory, ...optional];
    final total = rows.fold(0.0, (sum, row) {
      final name = row.name.trim();
      if (!cashbackCategories.contains(name)) return sum;
      final amount = row.amount * months + row.periodTotal;
      return sum + amount;
    });
    return total * 0.05;
  }

  double get cardThreshold => (activeMonthly > 0 ? activeMonthly : 0) * 3;
  double get cardInterestPrincipal => cardHas120DayGrace == true
      ? math.max(shortfall - cardThreshold, 0)
      : shortfall;
  int get cardRepaymentDays => activeMonthly > 0 && cardInterestPrincipal > 0
      ? (cardInterestPrincipal / activeMonthly).ceil() * 30
      : 0;
  double get cardInterest => calculateCardInterest(
    cardInterestPrincipal,
    double.tryParse(cardRateCtrl.text.replaceAll(',', '.')) ?? 0,
    cardRepaymentDays,
  );
  double get cardTotalRepayment => shortfall + cardInterest;
  int get loanTerm =>
      (double.tryParse(loanTermCtrl.text.replaceAll(',', '.')) ?? 0).round();
  double get loanAmount =>
      double.tryParse(loanAmountCtrl.text.replaceAll(',', '.')) ?? 0;
  double get annualLoanRate =>
      double.tryParse(rateCtrl.text.replaceAll(',', '.')) ?? 0;
  int get savingMonths => months.ceil();
  double get loanPayment =>
      _monthlyPayment(loanAmount, annualLoanRate, loanTerm);
  int? get shortestAffordableLoanTerm {
    if (activeMonthly <= 0 || loanTerm <= 1) return null;
    for (var term = 1; term < loanTerm; term++) {
      if (_monthlyPayment(loanAmount, annualLoanRate, term) <= activeMonthly) {
        return term;
      }
    }
    return null;
  }

  List<ExpenseRow> get optionalWithAmounts =>
      optional.where((row) => row.periodTotal > 0).toList();

  double sum(List<ExpenseRow> rows) =>
      rows.fold(0, (total, row) => total + row.amount);

  double get totalPeriodExpenses =>
      mandatory.fold(0.0, (total, row) => total + row.periodTotal) +
      optional.fold(0.0, (total, row) => total + row.periodTotal);

  double get totalSavings =>
      (double.tryParse(incomeCtrl.text.replaceAll(',', '.')) ?? 0) * months -
      sum(fixed) * months -
      totalPeriodExpenses;

  double monthly() => months > 0 ? totalSavings / months : 0;

  double _monthlyPayment(double principal, double annualRate, int term) {
    if (principal <= 0 || annualRate < 0 || term <= 0) return 0;
    final monthlyRate = annualRate / 1200;
    if (monthlyRate == 0) return principal / term;
    return principal *
        monthlyRate /
        (1 - math.pow(1 + monthlyRate, -term).toDouble());
  }

  void _finishOptimization() {
    finalTotal = baselineTotal + totalReduction;
    finalMonthly = months > 0 ? finalTotal / months : 0;
    selectedScenario = ResultScenario.optimized;
    step = WizStep.finalStep;
  }

  void _startOptimization() {
    reductions.clear();
    optionalIndex = 0;
    reductionCtrl.clear();
    if (optionalWithAmounts.isEmpty) {
      _finishOptimization();
    } else {
      for (final row in optionalWithAmounts) {
        row.reductionCtrl.clear();
      }
      step = WizStep.optionalEdit;
    }
  }

  void _applyOptionalReductions() {
    final expenses = optionalWithAmounts;
    final invalid = expenses.where(
      (row) => row.reductionValue < 0 || row.reductionValue > row.periodTotal,
    );
    if (invalid.isNotEmpty) {
      final first = invalid.first;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Укажите сумму от 0 до ${fmtNum(first.periodTotal)} ₽ за весь срок.',
          ),
        ),
      );
      return;
    }

    setState(() {
      reductions.clear();
      for (final expense in expenses) {
        if (expense.reductionValue > 0) {
          reductions[expense] = expense.reductionValue;
        }
      }
      _finishOptimization();
    });
  }

  void _saveReduction(double amount) {
    final expenses = optionalWithAmounts;
    final expense = expenses[optionalIndex];
    if (amount < 0 || amount > expense.periodTotal) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Укажите сумму от 0 до ${fmtNum(expense.periodTotal)} ₽ за весь срок.',
          ),
        ),
      );
      return;
    }
    setState(() {
      reductions[expense] = amount;
      if (optionalIndex + 1 < expenses.length) {
        optionalIndex++;
        reductionCtrl.clear();
      } else {
        _finishOptimization();
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Расчёт бюджета')),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: _screen(),
      ),
    ),
  );

  Widget _screen() {
    switch (step) {
      case WizStep.goal:
        return _goal();
      case WizStep.fixedExpenses:
        return _fixedExpenses();
      case WizStep.periodicExpenses:
        return _periodicExpenses();
      case WizStep.optionalExpenses:
        return _optionalExpenses();
      case WizStep.baseline:
        return _baseline();
      case WizStep.optionalIntro:
        return _optionalIntro();
      case WizStep.optionalEdit:
        return _optionalEdit();
      case WizStep.finalStep:
        return _result();
      case WizStep.recommendations:
        return _recommendations();
      case WizStep.financing:
        return _financing();
      case WizStep.creditCard:
        return _creditCard();
      case WizStep.loan:
        return _loan();
    }
  }

  InputDecoration decoration(String label) => InputDecoration(
    labelText: label,
    isDense: true,
    border: const OutlineInputBorder(),
    filled: true,
    fillColor: Colors.white,
  );

  Widget field(
    TextEditingController controller,
    String label, {
    ValueChanged<String>? onChanged,
  }) => TextField(
    controller: controller,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    decoration: decoration(label),
    onChanged: onChanged,
  );

  Widget card(String title, String hint, Widget child) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      color: const Color(0xFFFBFAF5),
      border: Border.all(color: const Color(0xFFD8D2C0)),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 5),
        Text(hint, style: const TextStyle(fontSize: 13, color: Colors.black54)),
        const SizedBox(height: 18),
        child,
      ],
    ),
  );

  Widget _goal() => card(
    'Какая цель?',
    'Укажите срок, целевую сумму и ежемесячный доход.',
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        field(monthsCtrl, 'Срок накопления, месяцев'),
        const SizedBox(height: 12),
        DropdownButtonFormField<int>(
          initialValue: startMonth,
          decoration: decoration('Первый месяц накоплений'),
          items: [
            for (var month = 1; month <= 12; month++)
              DropdownMenuItem(
                value: month,
                child: Text(monthNames[month - 1]),
              ),
          ],
          onChanged: (value) =>
              setState(() => startMonth = value ?? startMonth),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<int>(
          initialValue: startYear,
          decoration: decoration('Год начала'),
          items: [
            for (
              var year = DateTime.now().year;
              year <= DateTime.now().year + 10;
              year++
            )
              DropdownMenuItem(value: year, child: Text('$year')),
          ],
          onChanged: (value) => setState(() => startYear = value ?? startYear),
        ),
        const SizedBox(height: 12),
        field(targetCtrl, 'Целевая сумма, ₽ (необязательно)'),
        const SizedBox(height: 12),
        field(incomeCtrl, 'Ежемесячный доход, ₽'),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            if (months <= 0 ||
                months != months.roundToDouble() ||
                (double.tryParse(incomeCtrl.text.replaceAll(',', '.')) ?? 0) <=
                    0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Укажите целое число месяцев и доход.'),
                ),
              );
              return;
            }
            setState(() => step = WizStep.fixedExpenses);
          },
          child: const Text('Далее'),
        ),
      ],
    ),
  );

  Widget _fixedExpenses() => card(
    'Обязательные ежемесячные расходы',
    'Укажите только те расходы, которые есть каждый месяц.',
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        rows('Постоянные расходы', fixed),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            OutlinedButton(
              onPressed: () => setState(() => step = WizStep.goal),
              child: const Text('Назад'),
            ),
            ElevatedButton(
              onPressed: () => setState(() => step = WizStep.periodicExpenses),
              child: const Text('Далее'),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _periodicExpenses() => card(
    'Периодические расходы',
    'Укажите суммы в тех месяцах, когда ожидаются расходы.',
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        monthlyRows('Периодические расходы', mandatory),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            OutlinedButton(
              onPressed: () => setState(() => step = WizStep.fixedExpenses),
              child: const Text('Назад'),
            ),
            ElevatedButton(
              onPressed: () => setState(() => step = WizStep.optionalExpenses),
              child: const Text('Далее'),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _optionalExpenses() => card(
    'Необязательные расходы',
    'Укажите необязательные траты по месяцам.',
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        monthlyRows('Необязательные расходы', optional),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            OutlinedButton(
              onPressed: () => setState(() => step = WizStep.periodicExpenses),
              child: const Text('Назад'),
            ),
            ElevatedButton(
              onPressed: () {
                baselineMonthly = monthly();
                baselineTotal = totalSavings;
                finalMonthly = baselineMonthly;
                finalTotal = baselineTotal;
                setState(() => step = WizStep.baseline);
              },
              child: const Text('Рассчитать'),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _expenseCategorySelector(ExpenseRow row) =>
      DropdownButtonFormField<String>(
        initialValue: expenseCategories.contains(row.name.trim())
            ? row.name.trim()
            : null,
        isExpanded: true,
        decoration: decoration('Категория'),
        items: expenseCategories
            .map(
              (category) =>
                  DropdownMenuItem(value: category, child: Text(category)),
            )
            .toList(),
        onChanged: (category) => setState(() {
          if (category != null) {
            row.nameCtrl.text = category;
          }
        }),
      );

  Widget rows(String title, List<ExpenseRow> list) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      ...list.map(
        (row) => Row(
          children: [
            Expanded(flex: 2, child: _expenseCategorySelector(row)),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: row.amountCtrl,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: decoration('₽/мес.'),
              ),
            ),
            IconButton(
              onPressed: () => setState(() {
                list.remove(row);
                if (list.isEmpty) list.add(ExpenseRow());
              }),
              icon: const Icon(Icons.close),
            ),
          ],
        ),
      ),
      OutlinedButton(
        onPressed: () => setState(() => list.add(ExpenseRow())),
        child: const Text('+ Добавить строку'),
      ),
    ],
  );

  Widget monthlyRows(String title, List<ExpenseRow> list) {
    for (final row in list) {
      row.ensureMonths(savingMonths);
    }
    final tables = <Widget>[];
    var firstMonthIndex = 0;
    while (firstMonthIndex < savingMonths) {
      final firstDate = DateTime(startYear, startMonth + firstMonthIndex);
      var endMonthIndex = firstMonthIndex + 1;
      while (endMonthIndex < savingMonths &&
          DateTime(startYear, startMonth + endMonthIndex).year ==
              firstDate.year) {
        endMonthIndex++;
      }
      final monthIndexes = [
        for (var index = firstMonthIndex; index < endMonthIndex; index++) index,
      ];
      tables.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${firstDate.year}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 12,
                  horizontalMargin: 8,
                  columns: [
                    const DataColumn(label: Text('Расход')),
                    for (final index in monthIndexes)
                      DataColumn(
                        label: Text(
                          monthNames[DateTime(
                                startYear,
                                startMonth + index,
                              ).month -
                              1],
                        ),
                      ),
                  ],
                  rows: [
                    for (final row in list)
                      DataRow(
                        cells: [
                          DataCell(
                            SizedBox(
                              width: 190,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: row.nameCtrl,
                                      decoration: decoration('Название'),
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'Растянуть сумму на все месяцы',
                                    onPressed: () => setState(() {
                                      final source = row.monthCtrls
                                          .map((controller) => controller.text)
                                          .firstWhere(
                                            (value) => value.trim().isNotEmpty,
                                            orElse: () => '',
                                          );
                                      if (source.isNotEmpty) {
                                        for (final controller
                                            in row.monthCtrls) {
                                          controller.text = source;
                                        }
                                      }
                                    }),
                                    icon: const Icon(
                                      Icons.keyboard_double_arrow_right,
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'Удалить расход',
                                    onPressed: () => setState(() {
                                      list.remove(row);
                                      if (list.isEmpty) list.add(ExpenseRow());
                                    }),
                                    icon: const Icon(Icons.close),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          for (final index in monthIndexes)
                            DataCell(
                              SizedBox(
                                width: 100,
                                child: TextField(
                                  controller: row.monthCtrls[index],
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  decoration: decoration('₽'),
                                ),
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
      firstMonthIndex = endMonthIndex;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        ...tables,
        OutlinedButton.icon(
          onPressed: () => setState(() => list.add(ExpenseRow())),
          icon: const Icon(Icons.add),
          label: const Text('Добавить расход'),
        ),
      ],
    );
  }

  Widget stat(String label, double value) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(color: Colors.black54)),
      Text(
        '${fmtNum(value)} ₽',
        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
      ),
    ],
  );

  Widget _baseline() => card(
    'Что получается сейчас',
    'Расчёт без изменения расходов.',
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        stat('Свободно в месяц', baselineMonthly),
        const SizedBox(height: 16),
        stat('Накопится за ${months.toStringAsFixed(0)} мес.', baselineTotal),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            OutlinedButton(
              onPressed: () => setState(() => step = WizStep.optionalExpenses),
              child: const Text('Назад'),
            ),
            ElevatedButton(
              onPressed: () => setState(() => step = WizStep.optionalIntro),
              child: const Text('Далее'),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _optionalIntro() => card(
    'Необязательные расходы',
    'Хотите посмотреть, сколько получится накопить, если сократить некоторые траты?',
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (optionalWithAmounts.isEmpty)
          const Text('Необязательные расходы не указаны.')
        else
          ...optionalWithAmounts.map(
            (row) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                '${row.name.trim().isEmpty ? 'Расход' : row.name}: ${fmtNum(row.periodTotal)} ₽ за срок.',
              ),
            ),
          ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            OutlinedButton(
              onPressed: () => setState(() {
                finalMonthly = baselineMonthly;
                finalTotal = baselineTotal;
                step = WizStep.finalStep;
              }),
              child: const Text('Оставить как есть'),
            ),
            ElevatedButton(
              onPressed: () => setState(_startOptimization),
              child: const Text('Изменить расходы'),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _optionalEdit() {
    final expenses = optionalWithAmounts;
    return card(
      'Корректировка расходов',
      'Укажите, сколько можно уменьшить по каждой статье за весь срок.',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Статья')),
                  DataColumn(label: Text('Текущий расход')),
                  DataColumn(label: Text('Сократить, ₽')),
                ],
                rows: expenses.map((expense) {
                  final name = expense.name.trim().isEmpty
                      ? 'Расход'
                      : expense.name;
                  return DataRow(
                    cells: [
                      DataCell(Text(name)),
                      DataCell(Text('${fmtNum(expense.periodTotal)} ₽')),
                      DataCell(
                        SizedBox(
                          width: 120,
                          child: TextField(
                            controller: expense.reductionCtrl,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: decoration('₽'),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              OutlinedButton(
                onPressed: () {
                  for (final row in expenses) {
                    row.reductionCtrl.clear();
                  }
                  _applyOptionalReductions();
                },
                child: const Text('Не менять'),
              ),
              OutlinedButton(
                onPressed: () {
                  for (final row in expenses) {
                    row.reductionCtrl.text = row.periodTotal.toStringAsFixed(0);
                  }
                },
                child: const Text('Отказаться полностью'),
              ),
              ElevatedButton(
                onPressed: _applyOptionalReductions,
                child: const Text('Далее'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _result() {
    final displayMonthly = selectedScenario == ResultScenario.optimized
        ? finalMonthly
        : baselineMonthly;
    final displayTotal = selectedScenario == ResultScenario.optimized
        ? finalTotal
        : baselineTotal;
    return card(
      'Итог',
      'Расчёт накоплений без учёта оптимизации. Сначала смотрим базовый сценарий.',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          stat('Свободно в месяц', displayMonthly),
          const SizedBox(height: 16),
          stat('Экономия', totalReduction),
          const SizedBox(height: 16),
          stat('Накопится за ${months.toStringAsFixed(0)} мес.', displayTotal),
          if (target > 0)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                displayTotal >= target
                    ? 'Цель достигается'
                    : 'Не хватает ${fmtNum(target - displayTotal)} ₽',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              ElevatedButton(
                onPressed: () => setState(() => step = WizStep.recommendations),
                child: const Text('Показать рекомендации'),
              ),
              ElevatedButton(
                onPressed: () {
                  selectedScenario = ResultScenario.initial;
                  loanAmountCtrl.text = shortfall.toStringAsFixed(0);
                  loanTermCtrl.clear();
                  rateCtrl.clear();
                  cardRateCtrl.clear();
                  loanCalculated = false;
                  cardCalculated = false;
                  cardHas120DayGrace = null;
                  setState(() => step = WizStep.financing);
                },
                child: const Text('Рассчитать варианты финансирования'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          OutlinedButton(onPressed: _reset, child: const Text('Начать заново')),
        ],
      ),
    );
  }

  Widget _recommendations() => card(
    'Рекомендации по оптимизации',
    'Под какую ставку можно открыть вклад и какой кешбек можно получить по выбранным категориям.',
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        field(depositRateCtrl, 'Процент по вкладу, %'),
        const SizedBox(height: 16),
        if (cashbackSavings > 0)
          Text(
            'Кешбек по выбранным категориям: ${fmtNum(cashbackSavings)} ₽',
            style: const TextStyle(fontWeight: FontWeight.w600),
          )
        else
          const Text(
            'Укажите категории расходов и суммы, чтобы увидеть кешбек.',
          ),
        const SizedBox(height: 8),
        Text(
          'Вклад: при накоплении ${fmtNum(baselineMonthly)} ₽/мес. под ${depositRate.toStringAsFixed(1)}% годовых итог по вкладу к сроку составит ${fmtNum(depositProjection)} ₽.',
          style: const TextStyle(height: 1.45),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            OutlinedButton(
              onPressed: () => setState(() {
                selectedScenario = ResultScenario.initial;
                step = WizStep.finalStep;
              }),
              child: const Text('Оставить как есть'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedScenario = ResultScenario.optimized;
                  finalMonthly = baselineMonthly + totalReduction / months;
                  finalTotal = baselineTotal + totalReduction;
                  step = WizStep.finalStep;
                });
              },
              child: const Text('Применить рекомендации'),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _financing() {
    final cardRecommended = shortfall < cardThreshold;
    return card(
      'Как покрыть недостающую сумму?',
      'Сначала считаем базовый вариант. Если хотите, на следующем шаге можно выбрать оптимизированный итог.',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<ResultScenario>(
            initialValue: selectedScenario,
            decoration: decoration('Какой итог считать'),
            items: const [
              DropdownMenuItem(
                value: ResultScenario.initial,
                child: Text('Базовый итог'),
              ),
              DropdownMenuItem(
                value: ResultScenario.optimized,
                child: Text('Оптимизированный итог'),
              ),
            ],
            onChanged: (value) => setState(() {
              selectedScenario = value ?? ResultScenario.initial;
            }),
          ),
          const SizedBox(height: 16),
          if (activeMonthly > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                'Перед кредитом можно открыть вклад: свободные накопления ${fmtNum(activeMonthly)} ₽/мес. под ${depositRate.toStringAsFixed(1)}% годовых могут дать ${fmtNum(depositProjection)} ₽ к сроку цели.',
                style: const TextStyle(height: 1.45),
              ),
            ),
          Text(
            cardRecommended
                ? 'Рекомендуем кредитную карту: сумма небольшая относительно ваших свободных накоплений. Если погасить долг в льготный период, можно не переплачивать проценты.'
                : 'Недостающая сумма больше трёх месяцев свободных накоплений. Рассмотрите кредит и сравните переплату с условиями кредитной карты.',
            style: const TextStyle(height: 1.45),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              OutlinedButton(
                onPressed: () => setState(() => step = WizStep.finalStep),
                child: const Text('Назад'),
              ),
              OutlinedButton(
                onPressed: () => setState(() {
                  cardRateCtrl.clear();
                  cardHas120DayGrace = null;
                  cardCalculated = false;
                  step = WizStep.creditCard;
                }),
                child: const Text('Кредитная карта'),
              ),
              ElevatedButton(
                onPressed: () => setState(() {
                  rateCtrl.clear();
                  loanTermCtrl.clear();
                  loanCalculated = false;
                  step = WizStep.loan;
                }),
                child: const Text('Рассчитать кредит'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _creditCard() {
    final cardRate =
        double.tryParse(cardRateCtrl.text.replaceAll(',', '.')) ?? 0;
    final interestPrincipal = cardInterestPrincipal;
    final interest = cardInterest;

    return card(
      'Кредитная карта',
      'Рекомендуем выбрать карту с беспроцентным периодом 120 дней. Уточните условия полного погашения у банка.',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          stat('Нужно покрыть', shortfall),
          const SizedBox(height: 12),
          field(
            cardRateCtrl,
            'Годовая ставка по карте, %',
            onChanged: (_) => setState(() => cardCalculated = false),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<bool>(
            initialValue: cardHas120DayGrace,
            decoration: decoration('Карта с периодом 120 дней без процентов?'),
            items: const [
              DropdownMenuItem(value: true, child: Text('Да')),
              DropdownMenuItem(value: false, child: Text('Нет')),
            ],
            onChanged: (value) => setState(() {
              cardHas120DayGrace = value;
              cardCalculated = false;
            }),
          ),
          if (cardCalculated) ...[
            const SizedBox(height: 20),
            stat('Сумма, на которую начисляются проценты', interestPrincipal),
            const SizedBox(height: 16),
            stat('Оценка процентов за $cardRepaymentDays дней', interest),
            const SizedBox(height: 8),
            Text(
              'Оценка срока рассчитана по свободным накоплениям ${fmtNum(finalMonthly)} ₽ в месяц. При льготном периоде первые 3 месяца накоплений уменьшают долг без начисления процентов; далее проценты считаются за фактическое число дней по ставке ${cardRate.toStringAsFixed(2)}% годовых и календарному году 365/366 дней. Общая сумма к возврату: ${fmtNum(cardTotalRepayment)} ₽.',
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              OutlinedButton(
                onPressed: () => setState(() => step = WizStep.financing),
                child: const Text('Назад'),
              ),
              OutlinedButton(onPressed: _reset, child: const Text('В начало')),
              ElevatedButton(
                onPressed: () {
                  if (cardRateCtrl.text.isEmpty ||
                      cardRate < 0 ||
                      cardHas120DayGrace == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Укажите ставку и выберите ответ про льготный период.',
                        ),
                      ),
                    );
                    return;
                  }
                  setState(() => cardCalculated = true);
                },
                child: const Text('Рассчитать проценты'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _loan() {
    final term = loanTerm;
    final payment = loanPayment;
    final overpayment = payment * term - loanAmount;
    final shorterTerm = loanCalculated ? shortestAffordableLoanTerm : null;
    return card(
      'Расчёт кредита',
      'Укажите сумму, ставку и срок, на который планируете взять кредит.',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          field(
            loanAmountCtrl,
            'Сумма кредита, ₽',
            onChanged: (_) => setState(() => loanCalculated = false),
          ),
          const SizedBox(height: 12),
          field(
            rateCtrl,
            'Годовая ставка, %',
            onChanged: (_) => setState(() => loanCalculated = false),
          ),
          const SizedBox(height: 12),
          field(
            loanTermCtrl,
            'Срок кредита, месяцев',
            onChanged: (_) => setState(() => loanCalculated = false),
          ),
          const SizedBox(height: 20),
          if (loanCalculated) ...[
            stat('Ежемесячный платёж', payment),
            const SizedBox(height: 16),
            stat('Переплата по процентам', overpayment),
            if (payment < finalMonthly && shorterTerm != null) ...[
              const SizedBox(height: 16),
              Text(
                'Платёж меньше свободных накоплений (${fmtNum(finalMonthly)} ₽/мес.). Срок можно сократить до $shorterTerm мес.${shorterTerm > 1 ? '; ещё на месяц короче платёж превысит доступную сумму' : '. Это минимальный срок кредита'}.',
                style: const TextStyle(height: 1.4),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => setState(() {
                  loanTermCtrl.text = shorterTerm.toString();
                  loanCalculated = true;
                }),
                child: Text('Сократить срок до $shorterTerm мес.'),
              ),
            ],
            const SizedBox(height: 20),
          ],
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              OutlinedButton(
                onPressed: () => setState(() => step = WizStep.financing),
                child: const Text('Назад'),
              ),
              OutlinedButton(onPressed: _reset, child: const Text('В начало')),
              ElevatedButton(
                onPressed: () {
                  if (loanAmount <= 0 ||
                      annualLoanRate < 0 ||
                      rateCtrl.text.isEmpty ||
                      loanTerm <= 0 ||
                      loanTermCtrl.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Укажите сумму, ставку не ниже 0% и срок кредита.',
                        ),
                      ),
                    );
                    return;
                  }
                  setState(() => loanCalculated = true);
                },
                child: const Text('Рассчитать'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _reset() => setState(() {
    step = WizStep.goal;
    monthsCtrl.clear();
    targetCtrl.clear();
    incomeCtrl.clear();
    reductionCtrl.clear();
    loanAmountCtrl.clear();
    loanTermCtrl.clear();
    rateCtrl.clear();
    cardRateCtrl.clear();
    loanCalculated = false;
    cardCalculated = false;
    cardHas120DayGrace = null;
    fixed = [ExpenseRow()];
    mandatory = [ExpenseRow()];
    optional = [ExpenseRow()];
    reductions.clear();
  });
}
