/**
 * Tests for {@link ExceptionParser}.
 */
@IsTest
private class ExceptionParserTest {
  @IsTest
  private static void getDisplayMessage_returnsExpectedDisplayMessage() {
    ExceptionParser exceptionParser = new ExceptionParser();
    MathException mathException = makeMathException();

    String displayMessage = exceptionParser.getDisplayMessage(mathException);

    System.assertEquals(
      true,
      displayMessage.contains('MathException:'),
      displayMessage
    );
  }

  @IsTest
  private static void fakeExceptionParser_returnsSpecificMessage() {
    ExceptionParser.FakeExceptionParser fakeExceptionParser = new ExceptionParser.FakeExceptionParser(
      'testing'
    );
    MathException mathException = makeMathException();

    String displayMessage = fakeExceptionParser.getDisplayMessage(
      mathException
    );

    Assert.areEqual('testing', displayMessage);
    Assert.areEqual(1, fakeExceptionParser.getDisplayMessageCallTimes());
  }

  private static MathException makeMathException() {
    try {
      Integer unused = 1 / 0;
      return null;
    } catch (MathException e) {
      return e;
    }
  }
}