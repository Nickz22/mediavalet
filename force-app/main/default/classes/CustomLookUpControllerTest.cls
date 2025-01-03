@istest
public class CustomLookUpControllerTest {
  @istest
  public static void fetchLookUpValues() {
    List<sObject> result = CustomLookUpController.fetchLookUpValues(
      '1234',
      'Opportunity',
      'id != null ',
      null,
      null,
      null,
      null,
      null,
      new List<String>(),
      true
    );
  }
}