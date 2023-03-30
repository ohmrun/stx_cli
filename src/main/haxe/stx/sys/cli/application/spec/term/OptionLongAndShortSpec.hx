package stx.sys.cli.application.spec.term;

class OptionLongAndShortSpec extends OptionSpecCls{
  final long  : String;
  final short : String;
  public function new(name:String,doc:String,kind,required,long:String,short:String){
    super(name,doc,kind,required);
    this.long   = long;
    this.short  = short;
  }
  public function matches(str:String){
    final long = new OptionLongSpec(name,doc,kind,required,long);
    return if(long.matches(str)){
      true;
    }else{
      final short = new OptionShortSpec(name,doc,kind,required,short);
      short.matches(str);
    }
  }
}