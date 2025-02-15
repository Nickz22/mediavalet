@IsTest
class DateLiteralTests {
  static final Integer N = 42;

  static testMethod void testYetserday() {
    Test.startTest();
    String expression = DateLiteral.yesterday().toString();
    Test.stopTest();

    DateLiteral.Expression literal = DateLiteral.Expression.YESTERDAY;
    system.assertEquals(
      String.valueOf(literal),
      expression,
      'The correct expression should be expressed'
    );
  }
  static testMethod void testToday() {
    Test.startTest();
    String expression = DateLiteral.today().toString();
    Test.stopTest();

    DateLiteral.Expression literal = DateLiteral.Expression.TODAY;
    system.assertEquals(
      String.valueOf(literal),
      expression,
      'The correct expression should be expressed'
    );
  }
  static testMethod void testTomorrow() {
    Test.startTest();
    String expression = DateLiteral.tomorrow().toString();
    Test.stopTest();

    DateLiteral.Expression literal = DateLiteral.Expression.TOMORROW;
    system.assertEquals(
      String.valueOf(literal),
      expression,
      'The correct expression should be expressed'
    );
  }

  static testMethod void testLastWeek() {
    Test.startTest();
    String expression = DateLiteral.lastWeek().toString();
    Test.stopTest();

    DateLiteral.Expression literal = DateLiteral.Expression.LAST_WEEK;
    system.assertEquals(
      String.valueOf(literal),
      expression,
      'The correct expression should be expressed'
    );
  }
  static testMethod void testThisWeek() {
    Test.startTest();
    String expression = DateLiteral.thisWeek().toString();
    Test.stopTest();

    DateLiteral.Expression literal = DateLiteral.Expression.THIS_WEEK;
    system.assertEquals(
      String.valueOf(literal),
      expression,
      'The correct expression should be expressed'
    );
  }
  static testMethod void testNextWeek() {
    Test.startTest();
    String expression = DateLiteral.nextWeek().toString();
    Test.stopTest();

    DateLiteral.Expression literal = DateLiteral.Expression.NEXT_WEEK;
    system.assertEquals(
      String.valueOf(literal),
      expression,
      'The correct expression should be expressed'
    );
  }

  static testMethod void testLastMonth() {
    Test.startTest();
    String expression = DateLiteral.lastMonth().toString();
    Test.stopTest();

    DateLiteral.Expression literal = DateLiteral.Expression.LAST_MONTH;
    system.assertEquals(
      String.valueOf(literal),
      expression,
      'The correct expression should be expressed'
    );
  }
  static testMethod void testThisMonth() {
    Test.startTest();
    String expression = DateLiteral.thisMonth().toString();
    Test.stopTest();

    DateLiteral.Expression literal = DateLiteral.Expression.THIS_MONTH;
    system.assertEquals(
      String.valueOf(literal),
      expression,
      'The correct expression should be expressed'
    );
  }
  static testMethod void testNextMonth() {
    Test.startTest();
    String expression = DateLiteral.nextMonth().toString();
    Test.stopTest();

    DateLiteral.Expression literal = DateLiteral.Expression.NEXT_MONTH;
    system.assertEquals(
      String.valueOf(literal),
      expression,
      'The correct expression should be expressed'
    );
  }

  static testMethod void testLastQuarter() {
    Test.startTest();
    String expression = DateLiteral.lastQuarter().toString();
    Test.stopTest();

    DateLiteral.Expression literal = DateLiteral.Expression.LAST_QUARTER;
    system.assertEquals(
      String.valueOf(literal),
      expression,
      'The correct expression should be expressed'
    );
  }
  static testMethod void testThisQuarter() {
    Test.startTest();
    String expression = DateLiteral.thisQuarter().toString();
    Test.stopTest();

    DateLiteral.Expression literal = DateLiteral.Expression.THIS_QUARTER;
    system.assertEquals(
      String.valueOf(literal),
      expression,
      'The correct expression should be expressed'
    );
  }
  static testMethod void testNextQuarter() {
    Test.startTest();
    String expression = DateLiteral.nextQuarter().toString();
    Test.stopTest();

    DateLiteral.Expression literal = DateLiteral.Expression.NEXT_QUARTER;
    system.assertEquals(
      String.valueOf(literal),
      expression,
      'The correct expression should be expressed'
    );
  }

  static testMethod void testLastFiscalQuarter() {
    Test.startTest();
    String expression = DateLiteral.lastFiscalQuarter().toString();
    Test.stopTest();

    DateLiteral.Expression literal = DateLiteral.Expression.LAST_FISCAL_QUARTER;
    system.assertEquals(
      String.valueOf(literal),
      expression,
      'The correct expression should be expressed'
    );
  }
  static testMethod void testThisFiscalQuarter() {
    Test.startTest();
    String expression = DateLiteral.thisFiscalQuarter().toString();
    Test.stopTest();

    DateLiteral.Expression literal = DateLiteral.Expression.THIS_FISCAL_QUARTER;
    system.assertEquals(
      String.valueOf(literal),
      expression,
      'The correct expression should be expressed'
    );
  }
  static testMethod void testNextFiscalQuarter() {
    Test.startTest();
    String expression = DateLiteral.nextFiscalQuarter().toString();
    Test.stopTest();

    DateLiteral.Expression literal = DateLiteral.Expression.NEXT_FISCAL_QUARTER;
    system.assertEquals(
      String.valueOf(literal),
      expression,
      'The correct expression should be expressed'
    );
  }

  static testMethod void testLastFiscalYear() {
    Test.startTest();
    String expression = DateLiteral.lastFiscalYear().toString();
    Test.stopTest();

    DateLiteral.Expression literal = DateLiteral.Expression.LAST_FISCAL_YEAR;
    system.assertEquals(
      String.valueOf(literal),
      expression,
      'The correct expression should be expressed'
    );
  }
  static testMethod void testThisFiscalYear() {
    Test.startTest();
    String expression = DateLiteral.thisFiscalYear().toString();
    Test.stopTest();

    DateLiteral.Expression literal = DateLiteral.Expression.THIS_FISCAL_YEAR;
    system.assertEquals(
      String.valueOf(literal),
      expression,
      'The correct expression should be expressed'
    );
  }
  static testMethod void testNextFiscalYear() {
    Test.startTest();
    String expression = DateLiteral.nextFiscalYear().toString();
    Test.stopTest();

    DateLiteral.Expression literal = DateLiteral.Expression.NEXT_FISCAL_YEAR;
    system.assertEquals(
      String.valueOf(literal),
      expression,
      'The correct expression should be expressed'
    );
  }

  static testMethod void testLastYear() {
    Test.startTest();
    String expression = DateLiteral.lastYear().toString();
    Test.stopTest();

    DateLiteral.Expression literal = DateLiteral.Expression.LAST_YEAR;
    system.assertEquals(
      String.valueOf(literal),
      expression,
      'The correct expression should be expressed'
    );
  }
  static testMethod void testThisYear() {
    Test.startTest();
    String expression = DateLiteral.thisYear().toString();
    Test.stopTest();

    DateLiteral.Expression literal = DateLiteral.Expression.THIS_YEAR;
    system.assertEquals(
      String.valueOf(literal),
      expression,
      'The correct expression should be expressed'
    );
  }
  static testMethod void testNextYear() {
    Test.startTest();
    String expression = DateLiteral.nextYear().toString();
    Test.stopTest();

    DateLiteral.Expression literal = DateLiteral.Expression.NEXT_YEAR;
    system.assertEquals(
      String.valueOf(literal),
      expression,
      'The correct expression should be expressed'
    );
  }

  static testMethod void testLast90Days() {
    Test.startTest();
    String expression = DateLiteral.last90Days().toString();
    Test.stopTest();

    DateLiteral.Expression literal = DateLiteral.Expression.LAST_90_DAYS;
    system.assertEquals(
      String.valueOf(literal),
      expression,
      'The correct expression should be expressed'
    );
  }
  static testMethod void testNext90Days() {
    Test.startTest();
    String expression = DateLiteral.next90Days().toString();
    Test.stopTest();

    DateLiteral.Expression literal = DateLiteral.Expression.NEXT_90_DAYS;
    system.assertEquals(
      String.valueOf(literal),
      expression,
      'The correct expression should be expressed'
    );
  }

  static testMethod void testLastNDays() {
    Test.startTest();
    String expression = DateLiteral.lastNDays(N).toString();
    Test.stopTest();

    DateLiteral.Expression literal = DateLiteral.Expression.LAST_N_DAYS;
    system.assertEquals(
      String.valueOf(literal) +
      ':' +
      N,
      expression,
      'The correct expression should be expressed'
    );
  }
  static testMethod void testNextNDays() {
    Test.startTest();
    String expression = DateLiteral.nextNDays(N).toString();
    Test.stopTest();

    DateLiteral.Expression literal = DateLiteral.Expression.NEXT_N_DAYS;
    system.assertEquals(
      String.valueOf(literal) +
      ':' +
      N,
      expression,
      'The correct expression should be expressed'
    );
  }

  static testMethod void testLastNWeeks() {
    Test.startTest();
    String expression = DateLiteral.lastNWeeks(N).toString();
    Test.stopTest();

    DateLiteral.Expression literal = DateLiteral.Expression.LAST_N_WEEKS;
    system.assertEquals(
      String.valueOf(literal) +
      ':' +
      N,
      expression,
      'The correct expression should be expressed'
    );
  }
  static testMethod void testNextNWeeks() {
    Test.startTest();
    String expression = DateLiteral.nextNWeeks(N).toString();
    Test.stopTest();

    DateLiteral.Expression literal = DateLiteral.Expression.NEXT_N_WEEKS;
    system.assertEquals(
      String.valueOf(literal) +
      ':' +
      N,
      expression,
      'The correct expression should be expressed'
    );
  }

  static testMethod void testLastNMonths() {
    Test.startTest();
    String expression = DateLiteral.lastNMonths(N).toString();
    Test.stopTest();

    DateLiteral.Expression literal = DateLiteral.Expression.LAST_N_MONTHS;
    system.assertEquals(
      String.valueOf(literal) +
      ':' +
      N,
      expression,
      'The correct expression should be expressed'
    );
  }
  static testMethod void testNextNMonths() {
    Test.startTest();
    String expression = DateLiteral.nextNMonths(N).toString();
    Test.stopTest();

    DateLiteral.Expression literal = DateLiteral.Expression.NEXT_N_MONTHS;
    system.assertEquals(
      String.valueOf(literal) +
      ':' +
      N,
      expression,
      'The correct expression should be expressed'
    );
  }

  static testMethod void testLastNQuarters() {
    Test.startTest();
    String expression = DateLiteral.lastNQuarters(N).toString();
    Test.stopTest();

    DateLiteral.Expression literal = DateLiteral.Expression.LAST_N_QUARTERS;
    system.assertEquals(
      String.valueOf(literal) +
      ':' +
      N,
      expression,
      'The correct expression should be expressed'
    );
  }
  static testMethod void testNextNQuarters() {
    Test.startTest();
    String expression = DateLiteral.nextNQuarters(N).toString();
    Test.stopTest();

    DateLiteral.Expression literal = DateLiteral.Expression.NEXT_N_QUARTERS;
    system.assertEquals(
      String.valueOf(literal) +
      ':' +
      N,
      expression,
      'The correct expression should be expressed'
    );
  }

  static testMethod void testLastNFiscalQuarters() {
    Test.startTest();
    String expression = DateLiteral.lastNFiscalQuarters(N).toString();
    Test.stopTest();

    DateLiteral.Expression literal = DateLiteral.Expression.LAST_N_FISCAL_QUARTERS;
    system.assertEquals(
      String.valueOf(literal) +
      ':' +
      N,
      expression,
      'The correct expression should be expressed'
    );
  }
  static testMethod void testNextNFiscalQuarters() {
    Test.startTest();
    String expression = DateLiteral.nextNFiscalQuarters(N).toString();
    Test.stopTest();

    DateLiteral.Expression literal = DateLiteral.Expression.NEXT_N_FISCAL_QUARTERS;
    system.assertEquals(
      String.valueOf(literal) +
      ':' +
      N,
      expression,
      'The correct expression should be expressed'
    );
  }

  static testMethod void testLastNFiscalYears() {
    Test.startTest();
    String expression = DateLiteral.lastNFiscalYears(N).toString();
    Test.stopTest();

    DateLiteral.Expression literal = DateLiteral.Expression.LAST_N_FISCAL_YEARS;
    system.assertEquals(
      String.valueOf(literal) +
      ':' +
      N,
      expression,
      'The correct expression should be expressed'
    );
  }
  static testMethod void testNextNFiscalYears() {
    Test.startTest();
    String expression = DateLiteral.nextNFiscalYears(N).toString();
    Test.stopTest();

    DateLiteral.Expression literal = DateLiteral.Expression.NEXT_N_FISCAL_YEARS;
    system.assertEquals(
      String.valueOf(literal) +
      ':' +
      N,
      expression,
      'The correct expression should be expressed'
    );
  }

  static testMethod void testLastNYears() {
    Test.startTest();
    String expression = DateLiteral.lastNYears(N).toString();
    Test.stopTest();

    DateLiteral.Expression literal = DateLiteral.Expression.LAST_N_YEARS;
    system.assertEquals(
      String.valueOf(literal) +
      ':' +
      N,
      expression,
      'The correct expression should be expressed'
    );
  }
  static testMethod void testNextNYears() {
    Test.startTest();
    String expression = DateLiteral.nextNYears(N).toString();
    Test.stopTest();

    DateLiteral.Expression literal = DateLiteral.Expression.NEXT_N_YEARS;
    system.assertEquals(
      String.valueOf(literal) +
      ':' +
      N,
      expression,
      'The correct expression should be expressed'
    );
  }
}