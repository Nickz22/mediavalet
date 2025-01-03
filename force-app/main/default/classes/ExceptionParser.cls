/**
 * Parses information out of {@link Exception} objects.
 */
public virtual inherited sharing class ExceptionParser {
  /**
   * Parses and returns a display message for an {@link Exception}.
   */
  public virtual String getDisplayMessage(Exception e) {
    return String.format(
      '{0}: {1}\n\n{2}',
      new List<Object>{
        e.getTypeName(),
        e.getMessage(),
        e.getStackTraceString()
      }
    );
  }

  /**
   * Fake implementation of {@link ExceptionParser}.
   */
  @TestVisible
  private class FakeExceptionParser extends ExceptionParser {
    private final String displayMessage;
    private Integer getDisplayMessageCalls = 0;

    @TestVisible
    private FakeExceptionParser(String displayMessage) {
      this.displayMessage = displayMessage;
    }

    public override String getDisplayMessage(Exception e) {
      getDisplayMessageCalls++;
      return displayMessage;
    }

    /**
     * Returns the number of times {@link ExceptionParser#getDisplayMessage(Exception)} was called.
     */
    @TestVisible
    private Integer getDisplayMessageCallTimes() {
      return getDisplayMessageCalls;
    }
  }
}