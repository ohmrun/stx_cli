package stx.sys.cli.application.spec;

/**
 * Base description of any type of Cli token
 */
interface OptionSpecApi{
  /**
   * What name is this token given. Note this migh t be different from what it matches
   */
  public final name       : String;
  /**
   * What is the use of this token in the application
   */
  public final doc        : String;
  /**
   * @see stx.sys.cli.application.OptionKind
   */
  public final kind       : OptionKind;
  /**
   * Parsing fails if it is not defined.
   */
  public final required   : Bool;

  /**
   * Definition to use in the SpecParser to identify this token.
   * @param str 
   * @return Bool
   */
  public function matches(str:String):Bool;

  /**
   * Convenience function to create OptionValue
   * @param value 
   * @return OptionValueApi
   */
  public function with(value:Option<String>):OptionValueApi;
  /**
   * As `with` but splits the string over an `=` sign to create a `Property`
   * @param string 
   * @return OptionValueApi
   */
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