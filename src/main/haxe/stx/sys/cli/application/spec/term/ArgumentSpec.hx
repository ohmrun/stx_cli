package stx.sys.cli.application.spec.term;

/**
 * 
 */
class ArgumentSpec extends OptionSpecCls{
  public function new(name,doc,required){
    super(name,doc,ArgumentKind,required);
  }
  public function matches(str:String){
    return !str.startsWith("-");
  }
}