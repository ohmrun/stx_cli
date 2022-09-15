package stx.sys.cli.core;

enum OptionKind{
  ArgumentKind;
  FlagKind;
  PropertyKind(repeatable:Bool);    
}