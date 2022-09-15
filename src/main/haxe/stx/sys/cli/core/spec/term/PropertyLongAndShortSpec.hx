package stx.sys.cli.core.spec.term;

class PropertyLongAndShortSpec extends OptionLongAndShortSpec{
  public function new(name:String,doc:String,repeatable,required,long:String,short:String){
    super(name,doc,PropertyKind(repeatable),required,long,short);
  }
}