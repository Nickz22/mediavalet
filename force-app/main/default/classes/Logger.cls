public with sharing class Logger {
  public static void log(Object message) {
    System.debug('[OBND] ' + message);
  }
}