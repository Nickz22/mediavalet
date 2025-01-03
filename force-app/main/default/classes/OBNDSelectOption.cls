/**
 * Simple POJO class to convert key valye pair object transmission to response like Picklist response
 * Added On :: 15th Jan 2020
 * Test Class :: PerformanceResultTest
 */
public class OBNDSelectOption {
  @AuraEnabled
  public String label { get; set; }
  @AuraEnabled
  public String value { get; set; }

  public OBNDSelectOption(String label, String value) {
    this.label = label;
    this.value = value;
  }

  public OBNDSelectOption() {
  }
}