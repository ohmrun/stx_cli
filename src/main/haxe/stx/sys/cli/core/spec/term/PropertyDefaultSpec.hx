package stx.sys.cli.core.spec.term;

class PropertyDefaultSpec extends PropertyLongAndShortSpec{
  public function new(name,doc,repeatable,required,?short){
    super(name,doc,repeatable,required,name,__.option(short).defv(name.substr(0)));
  }
}