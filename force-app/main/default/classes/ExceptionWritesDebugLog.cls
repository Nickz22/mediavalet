/**
 * Writes information about an exception to the debug log.
 *
 * This {@link ExceptionHandler} should be used as a last resort. Most commonly to handle exceptions that occur in other
 * {@link ExceptionHandler} implementations.
 */
public with sharing class ExceptionWritesDebugLog extends ExceptionHandler {
  private final LoggingLevel loggingLevel;
  private String errorMessage;

  public ExceptionWritesDebugLog() {
    // Using an empty list because we don't want to recover from an exception that happens here.
    super(new List<ExceptionHandler>());

    loggingLevel = System.LoggingLevel.DEBUG;
  }

  public ExceptionWritesDebugLog(LoggingLevel loggingLevel) {
    // Using an empty list because we don't want to recover from an exception that happens here.
    super(new List<ExceptionHandler>());

    this.loggingLevel = loggingLevel;
  }

  protected override void parseException(Exception e) {
    errorMessage = exceptionParser.getDisplayMessage(e);
  }

  protected override void execute() {
    System.debug(loggingLevel, errorMessage);
  }
}