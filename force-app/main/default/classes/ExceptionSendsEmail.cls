/**
 * Sends an email when handling an exception.
 */
public with sharing class ExceptionSendsEmail extends ExceptionHandler {
  private final List<String> toAddresses;
  private final String processDisplayName;

  @TestVisible
  private Messaging.SingleEmailMessage emailMessage;
  @TestVisible
  private Boolean hasSentEmail = false;

  public ExceptionSendsEmail(
    List<ExceptionHandler> exceptionHandlers,
    List<String> toAddresses,
    String processDisplayName
  ) {
    super(exceptionHandlers);

    this.toAddresses = toAddresses;
    this.processDisplayName = processDisplayName;
  }

  protected override void parseException(Exception e) {
    emailMessage = new Messaging.SingleEmailMessage();
    emailMessage.setToAddresses(toAddresses);
    emailMessage.setSubject(
      String.format(
        '[Exception Handler] {0}',
        new List<Object>{ processDisplayName }
      )
    );
    emailMessage.setPlainTextBody(
      String.join(
        new List<String>{
          String.format(
            'An unhandled exception occurred in: {0}',
            new List<Object>{ processDisplayName }
          ),
          '',
          exceptionParser.getDisplayMessage(e)
        },
        '\n'
      )
    );
  }

  protected override void execute() {
    if (!Test.isRunningTest()) {
      // prettier-ignore
      Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ emailMessage });
    }
    hasSentEmail = true;
  }
}