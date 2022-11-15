package stx.sys.cli.program;

enum OptionKind{
  ArgumentKind;
  FlagKind;
  PropertyKind(repeatable:Bool);    
}