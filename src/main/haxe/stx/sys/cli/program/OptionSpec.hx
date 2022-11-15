package stx.sys.cli.program;

interface OptionSpecApi{
  public final name       : String;
  public final doc        : String;
  public final kind       : OptionKind;
  public final required   : Bool;

  public function matches(str:String):Bool;
  public function with(value:Option<String>):OptionValueApi;
  public function with_assignment(string:String):OptionValueApi;
}
abstract class OptionSpecCls implements OptionSpecApi{
  public final name       : String;
  public final doc        : String;
  public final kind       : OptionKind;
  public final required   : Bool;
 
  public function new(name,doc,kind,required){
    this.name     = name;
    this.doc      = doc;
    this.kind     = kind;
    this.required = required;
  }
  abstract public function matches(str:String):Bool;
  
  public function with(data:Option<String>):OptionValueApi{
    return new OptionValueCls(this,data);
  }
  public function with_assignment(data:String):OptionValueApi{
    return new OptionValueCls(this,__.option(data.split("=")[1]));
  }
}
class OptionSpecLift{

}
class OptionSpecCtr extends Clazz{
  static public function unit(){
    return new OptionSpecCtr();
  }
}