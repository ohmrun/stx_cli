package stx.sys.cli.core.spec.term;

class ArgumentSpec extends OptionSpecCls{
  public function new(name,doc,required){
    super(name,doc,ArgumentKind,required);
  }
  public function matches(str:String){
    return !str.startsWith("-");
  }
}