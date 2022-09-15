package stx.sys.cli.core.spec.term;

class OptionShortSpec implements OptionSpecApi extends OptionSpecCls{
  public final short : String;
  public function new(name,doc,kind,required,short){
    super(name,doc,kind,required);
    this.short = short;
  }
  public function matches(string:String):Bool{
    final incase = string.split("=");
    return incase[0] == '-$short';
  }
}