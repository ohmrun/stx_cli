package stx.sys.cli.application.spec;

/**
 * Enumeration of possible options
 */
enum OptionKind{
  /**
   * Denotes an argument, organised by order.
   */
  ArgumentKind;
  /**
   * Denotes a flag
   */
  FlagKind;
  /**
   * Denotes a property, and whether or not it is repeatable.
   */
  PropertyKind(repeatable:Bool);    
}