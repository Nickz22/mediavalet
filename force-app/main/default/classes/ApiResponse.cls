public with sharing class ApiResponse {
  @AuraEnabled
  public Boolean isSuccess;
  @AuraEnabled
  public String message;
  @AuraEnabled
  public Object data;
}