/**
 * Tests for {@link ExceptionSendsEmail}.
 */
@IsTest
private class ExceptionSendsEmailTest {
  @IsTest
  private static void handleException() {
    ExceptionHandler.FakeExceptionHandler fakeExceptionHandler = new ExceptionHandler.FakeExceptionHandler();
    ExceptionParser.FakeExceptionParser fakeExceptionParser = new ExceptionParser.FakeExceptionParser(
      'it failed'
    );
    List<String> toAddresses = new List<String>{ UserInfo.getUserEmail() };
    String processName = 'Testing ExceptionSendsEmail';
    ExceptionSendsEmail exceptionSendsEmail = new ExceptionSendsEmail(
      new List<ExceptionHandler>{ fakeExceptionHandler },
      toAddresses,
      processName
    );
    exceptionSendsEmail.exceptionParser = fakeExceptionParser;

    exceptionSendsEmail.handleException(new IllegalArgumentException());

    Assert.isTrue(exceptionSendsEmail.hasSentEmail);
    AssertUtil.containsExactly(
      toAddresses,
      exceptionSendsEmail.emailMessage.getToAddresses()
    );
    Assert.areEqual(
      '[Exception Handler] Testing ExceptionSendsEmail',
      exceptionSendsEmail.emailMessage.getSubject()
    );
    Assert.areEqual(
      String.join(
        new List<String>{
          'An unhandled exception occurred in: Testing ExceptionSendsEmail',
          '',
          'it failed'
        },
        '\n'
      ),
      exceptionSendsEmail.emailMessage.getPlainTextBody()
    );
  }
}