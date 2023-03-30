package stx.sys.cli.application.spec.term;

class OptionShortSpec implements OptionSpecApi extends OptionSpecCls{
  public final short : String;
  public function new(name,doc,kind,required,short){
    super(name,doc,kind,required);
    this.short = short;
  }
  public function matches(string:String):Bool{
    final incase = string.split("=");
    __.log().trace('${incase[0]} == -${short}');
    return incase[0] == '-$short';
  }
}