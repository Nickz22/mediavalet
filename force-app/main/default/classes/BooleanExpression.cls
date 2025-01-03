public with sharing class BooleanExpression {
  public static Boolean orJoin(List<String> factors) {
    for (String fact : factors) {
      if (evaluate(fact) == true) {
        return true;
      }
    }
    return false;
  }
  public static Boolean andJoin(List<String> factors) {
    for (String fact : factors) {
      if (evaluate(fact) == false) {
        return false;
      }
    }
    return true;
  }
  public static Boolean isSimpleExpression(String x) {
    return x == 'true' || x == 'false';
  }

  public static String simplify(String x) {
    x = x.trim();
    while (x.contains('(')) {
      String sub = x.substringAfterLast('(').substringBefore(')');
      x = x.replace('(' + sub + ')', String.valueOf(evaluate(sub)));
    }
    return x;
  }

  public static Boolean evaluate(String x) {
    x = simplify(x);
    x = x.toLowerCase();
    if (!isSimpleExpression(x)) {
      if (x.contains('and'))
        return andJoin(x.split('and'));
      if (x.contains('or'))
        return orJoin(x.split('or'));
      if (x.startsWith('!'))
        return !evaluate(x.substring(1));
    }
    return Boolean.valueOf(x);
  }
}