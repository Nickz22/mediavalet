/**
 * Tests for {@link AssertUtil}.
 */
@IsTest
private class AssertUtilTest {
  @IsTest
  private static void containsExactly_expectedIsNull_throws() {
    List<Object> expected = null;
    List<Object> actual = new List<Object>();
    Boolean failed = false;

    try {
      AssertUtil.containsExactly(expected, actual);
    } catch (IllegalArgumentException e) {
      Assert.areEqual(
        'Expected and actual lists must be defined. Found expected: null actual: ()',
        e.getMessage()
      );
      failed = true;
    }

    Assert.areEqual(true, failed);
  }

  @IsTest
  private static void containsExactly_actualIsNull_throws() {
    List<Object> expected = new List<Object>();
    List<Object> actual = null;
    Boolean failed = false;

    try {
      AssertUtil.containsExactly(expected, actual);
    } catch (IllegalArgumentException e) {
      Assert.areEqual(
        'Expected and actual lists must be defined. Found expected: () actual: null',
        e.getMessage()
      );
      failed = true;
    }

    Assert.areEqual(true, failed);
  }

  @IsTest
  private static void containsExactly_sameLists_passes() {
    List<String> expected = new List<String>{ 'foo', 'bar', 'baz' };
    List<String> actual = new List<String>{ 'foo', 'bar', 'baz' };

    AssertUtil.containsExactly(expected, actual);
  }
}