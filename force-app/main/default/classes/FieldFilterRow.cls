public class FieldFilterRow {
  public String field;
  public String operator;
  public String value;

  public FieldFilterRow() {
  }

  /**
   * @param {field}
   * @param {operator}
   * @param {value}
   */
  public FieldFilterRow(String field, String operator, String value) {
    if(operator.containsIgnoreCase('equals')){
      throw new FieldFilterException('Use "=" or "!=" instead of equals/notequals' );
    }
    this.field = field;
    this.operator = operator;
    this.value = value;
  }

  // exception
  class FieldFilterException extends Exception {}
}