package stx.sys.cli.core.spec.term;

class FlagLongAndShortSpec extends OptionLongAndShortSpec{
  public function new(name:String,doc:String,long:String,short:String){
    super(name,doc,FlagKind,false,long,short);
  }
}
