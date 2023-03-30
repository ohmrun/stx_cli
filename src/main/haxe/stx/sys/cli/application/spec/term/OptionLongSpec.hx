package stx.sys.cli.application.spec.term;

class OptionLongSpec implements OptionSpecApi extends OptionSpecCls{
  public final long : String;
  public function new(name,doc,kind,required,long){
    super(name,doc,kind,required);
    this.long = long;
  }
  public function matches(string:String):Bool{
    final incase = string.split("=");
    return incase[0] == '--$long';
  }
}