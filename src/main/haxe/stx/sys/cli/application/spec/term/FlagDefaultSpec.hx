package stx.sys.cli.application.spec.term;

class FlagDefaultSpec extends FlagLongAndShortSpec{
  public function new(name:String,doc:String,?short){
    super(name,doc,name,__.option(short).defv(name.substr(0,1)));
  }
}
