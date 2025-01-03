/**
 * Utilities for working with {@link Assert} methods.
 */
public with sharing class AssertUtil {
  /**
   * Asserts that both lists contain the same elements in order.
   */
  public static void containsExactly(
    List<Object> expected,
    List<Object> actual
  ) {
    if (expected == null || actual == null) {
      throw new IllegalArgumentException(
        'Expected and actual lists must be defined. Found expected: ' +
          expected +
          ' actual: ' +
          actual
      );
    }

    Assert.areEqual(
      expected.size(),
      actual.size(),
      'Lists are different lengths'
    );
    for (Integer i = 0; i < expected.size(); i++) {
      Assert.areEqual(
        expected[i],
        actual[i],
        String.format(
          'Element {0} has an unexpected value',
          new List<Object>{ i }
        )
      );
    }
  }
}