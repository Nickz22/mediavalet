/**
 * Tests for {@link ExceptionWritesDebugLog}.
 */
@IsTest(IsParallel=true)
private class ExceptionWritesDebugLogTest {
  @IsTest
  private static void handleException_defaultLoggingLevel_logsTheCorrectMessage() {
    ExceptionParser.FakeExceptionParser fakeExceptionParser = new ExceptionParser.FakeExceptionParser(
      'it failed'
    );
    ExceptionWritesDebugLog exceptionWritesDebugLog = new ExceptionWritesDebugLog();
    exceptionWritesDebugLog.exceptionParser = fakeExceptionParser;

    exceptionWritesDebugLog.handleException(new IllegalArgumentException());

    Assert.areEqual(1, fakeExceptionParser.getDisplayMessageCallTimes());
  }

  @IsTest
  private static void handleException_fineLoggingLevel_logsTheCorrectMessage() {
    ExceptionParser.FakeExceptionParser fakeExceptionParser = new ExceptionParser.FakeExceptionParser(
      'it failed'
    );
    ExceptionWritesDebugLog exceptionWritesDebugLog = new ExceptionWritesDebugLog(
      LoggingLevel.FINE
    );
    exceptionWritesDebugLog.exceptionParser = fakeExceptionParser;

    exceptionWritesDebugLog.handleException(new IllegalArgumentException());

    Assert.areEqual(1, fakeExceptionParser.getDisplayMessageCallTimes());
  }
}