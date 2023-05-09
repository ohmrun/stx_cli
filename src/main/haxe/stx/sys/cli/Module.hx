package stx.sys.cli;

using stx.Parse;

class Module extends Clazz{
  public function spec(){
    return Spec.__;
  }
  public function apply(spec:Spec):Upshot<Option<SpecValue>,CliFailure>{
    return (sys.stx.cli.SysCliParser.reply().flat_map(
      x -> spec.reply().apply(x.reader()).toUpshot().errate(
        x -> E_Cli_Parse(x)
      )
    ));
  }
}