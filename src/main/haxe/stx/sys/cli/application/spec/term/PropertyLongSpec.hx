package stx.sys.cli.application.spec.term;

class PropertyLongSpec implements OptionSpecApi extends OptionSpecCls{
  public final long : String;
  public function new(name,doc,repeatable,required,long){
    super(name,doc,PropertyKind(repeatable),required);
    this.long = long;
  }
  public function matches(string:String):Bool{
    final incase = string.split("=");
    return incase[0] == '--$long';
  }
}
