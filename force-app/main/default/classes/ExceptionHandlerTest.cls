/**
 * Tests for {@link ExceptionHandler}.
 */
@IsTest(IsParallel=true)
private class ExceptionHandlerTest {
  @IsTest
  private static void fakeExceptionHandler() {
    ExceptionHandler.FakeExceptionHandler fakeExceptionHandler = new ExceptionHandler.FakeExceptionHandler();
    AuraHandledException auraHandledException = new AuraHandledException(
      'it failed'
    );

    fakeExceptionHandler.handleException(auraHandledException);

    Assert.areEqual(1, fakeExceptionHandler.getParsedExceptions().size());
    Assert.isInstanceOfType(
      fakeExceptionHandler.getParsedExceptions()[0],
      System.AuraHandledException.class
    );
  }
}