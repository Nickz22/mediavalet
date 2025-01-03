/**
 * @param {String} filterLogic
 * @param {Boolean} disabled
 * @param {Array<FieldFilterRow>} filters
 */
public class FieldFilter {
  public String filterLogic;
  public boolean disabled = false;
  public List<FieldFilterRow> filters;

  public FieldFilter() {
  }

  public FieldFilter(String filterLogic, List<FieldFilterRow> filters) {
    this.filterLogic = filterLogic;
    this.filters = filters;
  }

  /**
   * @param {String} filterLogic
   * @param {Boolean} disabled
   * @param {Array<FieldFilterRow>} filters
   */
  public FieldFilter(
    String filterLogic,
    boolean disabled,
    List<FieldFilterRow> filters
  ) {
    this.filterLogic = filterLogic;
    this.disabled = disabled;
    this.filters = filters;
  }
}