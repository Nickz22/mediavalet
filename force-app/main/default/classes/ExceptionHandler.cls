/**
 * Base class that can be used to perform an action with an {@link Exception}.
 */
public inherited sharing abstract class ExceptionHandler extends TransactionThatNeverFails {
  @TestVisible
  protected ExceptionParser exceptionParser = new ExceptionParser();

  protected ExceptionHandler(List<ExceptionHandler> exceptionHandlers) {
    super(exceptionHandlers);
  }

  /**
   * Performs an action with the {@link Exception}.
   */
  public void handleException(Exception e) {
    parseException(e);
    run();
  }

  /**
   * Parses the {@link Exception} into fields that can be used by {@link TransactionThatNeverFails#execute()}.
   */
  protected abstract void parseException(Exception e);

  /**
   * Fake implementation of {@link ExceptionHandler}.
   */
  @TestVisible
  private class FakeExceptionHandler extends ExceptionHandler {
    private final List<Exception> parsedExceptions = new List<Exception>();

    @TestVisible
    private FakeExceptionHandler() {
      super(new List<ExceptionHandler>());
    }

    protected override void parseException(Exception e) {
      parsedExceptions.add(e);
    }

    protected override void execute() {
    }

    /**
     * Returns the {@link Exception} objects that have been parsed.
     */
    @TestVisible
    private List<Exception> getParsedExceptions() {
      return parsedExceptions;
    }
  }

  public static void sendExceptionToUser(Exception e) {
    if (Test.isRunningTest()) {
      // we want to throw errors during tests
      throw e;
    }
    // send email to running user with error message
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    String[] toAddresses = new List<String>{ UserInfo.getUserEmail() };
    mail.setToAddresses(toAddresses);
    mail.setSubject('InsideOutbound hit a snag...');
    mail.setPlainTextBody(e.getMessage());
    Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
  }
}