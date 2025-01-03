@IsTest
public class BooleanExpressionTests {
  public static testMethod void testExpressions() {
    system.assertEquals(true, BooleanExpression.evaluate('true'));
    system.assertEquals(false, BooleanExpression.evaluate('!true'));
    system.assertEquals(true, BooleanExpression.evaluate('!false'));
    system.assertEquals(false, BooleanExpression.evaluate('false'));
    system.assertEquals(false, BooleanExpression.evaluate('true AND !true'));
    system.assertEquals(true, BooleanExpression.evaluate('true AND true'));
    system.assertEquals(false, BooleanExpression.evaluate('false OR false'));
    system.assertEquals(
      true,
      BooleanExpression.evaluate(
        'false OR (false OR (!true OR (false OR true OR false)))'
      )
    );
  }
}