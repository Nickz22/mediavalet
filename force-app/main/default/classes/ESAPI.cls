/**
 * OWASP Enterprise Security API (ESAPI)
 *
 * This file is part of the Open Web Application Security Project (OWASP)
 * Enterprise Security API (ESAPI) project. For details, please see
 * <a href="http://www.owasp.org/index.php/ESAPI">http://www.owasp.org/index.php/ESAPI</a>.
 *
 * Copyright (c) 2010 - Salesforce.com
 *
 * The Apex ESAPI implementation is published by Salesforce.com under the New BSD license. You should read and accept the
 * LICENSE before you use, modify, and/or redistribute this software.
 *
 * @author Yoel Gluck (securecloud .at. salesforce.com) <a href="http://www.salesforce.com">Salesforce.com</a>
 * @created 2010
 */

/**
 * ESAPI locator class is provided to make it easy to gain access to the current ESAPI classes in use.<br>
 * For example you can use the validator() function to access the validator methods. (i.e. <CODE>ESAPI.validator().isValidCreditCard(creditcard, false)</CODE>)
 */
public with sharing class ESAPI {
  private static SFDCAccessController SFDC_accessController = null;

  /**
   * prevent instantiation of this class
   */
  private ESAPI() {
  }

  /**
   * @return the current ESAPI SFDCAccessController object being used to maintain the access control rules for this application.
   */
  public static SFDCAccessController accessController() {
    if (SFDC_accessController == null) {
      SFDC_accessController = new SFDCAccessController();
    }
    return SFDC_accessController;
  }
}