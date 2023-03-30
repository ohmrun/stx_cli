package stx.sys.cli.application.spec.term;

class PropertyDefaultSpec extends PropertyLongAndShortSpec{
  public function new(name,doc,repeatable,required,?short){
    super(name,doc,repeatable,required,name,__.option(short).defv(name.substr(0,1)));
  }
}