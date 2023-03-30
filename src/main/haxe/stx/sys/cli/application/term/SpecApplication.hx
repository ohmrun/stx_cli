package stx.sys.cli.application.term;

abstract class SpecApplication extends Base{
  public final spec : Spec;
  public function new(spec){
    this.spec = spec;
  }
}