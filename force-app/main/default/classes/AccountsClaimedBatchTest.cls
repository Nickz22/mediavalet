/**
 * TODO: rewrite test without custom account fields
 */
@IsTest
public class AccountsClaimedBatchTest {
  @TestSetup
  private static void setupData() {
    TestFactory.generateMasterData();
  }

  @IsTest
  private static void testAccountClaimed() {
    // List<Account> testAccounts = [
    //   SELECT Activated_By__r.FirstName, Activated_By__r.LastName
    //   FROM Account
    // ];
    // TestFactory.activateAccount(testAccounts[0].Id);
    // AccountsClaimedBatch.runBatch();
  }
}