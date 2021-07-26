package cmd.test;

class TestCliParse extends Implementation{
  public function new(fl:Float,b:Bool,str:String){
    trace(fl);
    trace(b);
    trace(str);
  }
  override public function reply():Execute<CliFailure>{
    trace("here");
    return Execute.unit();
  }
}