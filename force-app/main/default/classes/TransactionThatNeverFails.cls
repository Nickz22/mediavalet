/**
 * Transaction that is guaranteed to never fail.
 *
 * "Guaranteed" is a strong word here and is not 100% true. This class guarantees that it will catch
 * any catchable exception that occurs in your code, but not all exceptions are catchable in Apex.
 * Specifically the {@link LimitException} and {@link AssertException} exceptions are not catchable
 * and need to be proactively avoided.
 *
 * When these exceptions are thrown, any {@code catch} and {@code finally} blocks are not executed.
 *
 * @see https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_classes_exception_methods.htm
 */
public abstract class TransactionThatNeverFails {
  private final List<ExceptionHandler> exceptionHandlers;

  protected TransactionThatNeverFails(
    List<ExceptionHandler> exceptionHandlers
  ) {
    this.exceptionHandlers = exceptionHandlers;
  }

  /**
   * Runs the transaction that will never fail.
   */
  public void run() {
    try {
      execute();
    } catch (Exception e) {
      for (ExceptionHandler exceptionHandler : exceptionHandlers) {
        exceptionHandler.handleException(e);
      }
    }
  }

  /**
   * Logic to execute in the transaction.
   */
  protected abstract void execute();
}