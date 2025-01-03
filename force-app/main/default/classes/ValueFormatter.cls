global class ValueFormatter {
  global class FormattingException extends Exception {
  }
  global static String format(Object input) {
    if (input == null)
      return '' + String.valueOf(input);
    if (input instanceof Builder)
      return '(' + String.valueOf(input) + ')';
    if (input instanceof DateLiteral)
      return String.valueOf(input);
    if (input instanceof Boolean)
      return String.valueOf(input);
    if (input instanceof Double)
      return String.valueOf(input);
    if (input instanceof String)
      return formatString(input);

    // any Date instance is also an instance of Datetime, and hence Date must preceed Datetime
    if (input instanceof Date)
      return formatDate(input); // Date must preceed Datetime
    if (input instanceof Datetime)
      return formatDatetime(input); // Date must preceed Datetime

    return formatCollection(input);
  }
  global static String formatString(Object input) {
    return '\'' + String.escapeSingleQuotes((String) input) + '\'';
  }
  global static String formatDate(Object input) {
    Date d = (Date) input;
    return Datetime.newInstance(d.year(), d.month(), d.day())
      .format('yyyy-MM-dd');
  }
  global static String formatDatetime(Object input) {
    return Datetime.valueOf(input).format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
  }
  global static String formatCollection(Object input) {
    if (input instanceof List<Object>) {
      List<String> values = new List<String>();
      for (Object element : (List<Object>) input)
        values.add(format(element));
      return '(' + String.join(values, ',') + ')';
    }
    if (input instanceof Set<String>)
      return formatCollection(new List<String>((Set<String>) input));
    if (input instanceof Set<Integer>)
      return formatCollection(new List<Integer>((Set<Integer>) input));
    if (input instanceof Set<Decimal>)
      return formatCollection(new List<Decimal>((Set<Decimal>) input));
    if (input instanceof Set<Double>)
      return formatCollection(new List<Double>((Set<Double>) input));
    if (input instanceof Set<Long>)
      return formatCollection(new List<Long>((Set<Long>) input));
    if (input instanceof Set<Date>)
      return formatCollection(new List<Date>((Set<Date>) input));
    if (input instanceof Set<Datetime>)
      return formatCollection(new List<Datetime>((Set<Datetime>) input));
    else
      throw new FormattingException('Could not format value - ' + input);
  }
}