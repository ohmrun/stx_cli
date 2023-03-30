package stx.sys.cli.application.spec.term;

class PropertyShortSpec implements OptionSpecApi extends OptionSpecCls{
  public final short : String;
  public function new(name,doc,repeatable,required,short){
    super(name,doc,PropertyKind(repeatable),required);
    this.short = short;
  }
  public function matches(string:String):Bool{
    final incase = string.split("=");
    return incase[0] == '-$short';
  }
}