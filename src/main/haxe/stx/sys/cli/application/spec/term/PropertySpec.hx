package stx.sys.cli.application.spec.term;

class PropertySpec extends OptionSpecCls{
  public function new(name,doc,repeatable,required){
    super(name,doc,PropertyKind(repeatable),required);
  }
  public function matches(str:String){
    return !str.startsWith("-");
  }
}