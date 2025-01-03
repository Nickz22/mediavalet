/**
 * Tests for {@link TransactionThatNeverFails}.
 */
@IsTest(IsParallel=true)
private class TransactionThatNeverFailsTest {
  @IsTest
  private static void run_divideByZero_doesNotFail() {
    ExceptionHandler.FakeExceptionHandler fakeExceptionHandler = new ExceptionHandler.FakeExceptionHandler();
    DivideByZero divideByZero = new DivideByZero(
      new List<ExceptionHandler>{ fakeExceptionHandler }
    );
    AssertThrows.Throwing throwing = AssertThrows.doesNotThrow();

    try {
      divideByZero.run();
    } catch (Exception e) {
      throwing.threw(e);
    }

    throwing.assertHasNotThrown();
    Assert.areEqual(1, fakeExceptionHandler.getParsedExceptions().size());
    Assert.isInstanceOfType(
      fakeExceptionHandler.getParsedExceptions()[0],
      MathException.class
    );
  }

  @IsTest
  private static void run_nullPointer_doesNotFail() {
    ExceptionHandler.FakeExceptionHandler fakeExceptionHandler = new ExceptionHandler.FakeExceptionHandler();
    NullPointer nullPointer = new NullPointer(
      new List<ExceptionHandler>{ fakeExceptionHandler }
    );
    AssertThrows.Throwing throwing = AssertThrows.doesNotThrow();

    try {
      nullPointer.run();
    } catch (Exception e) {
      throwing.threw(e);
    }

    throwing.assertHasNotThrown();
    Assert.areEqual(1, fakeExceptionHandler.getParsedExceptions().size());
    Assert.isInstanceOfType(
      fakeExceptionHandler.getParsedExceptions()[0],
      NullPointerException.class
    );
  }

  private class DivideByZero extends TransactionThatNeverFails {
    private DivideByZero(List<ExceptionHandler> exceptionHandlers) {
      super(exceptionHandlers);
    }

    protected override void execute() {
      Integer unused = 1 / 0;
    }
  }

  private class NullPointer extends TransactionThatNeverFails {
    private NullPointer(List<ExceptionHandler> exceptionHandlers) {
      super(exceptionHandlers);
    }

    protected override void execute() {
      String str = null;
      List<String> unused = str.split('');
    }
  }
}