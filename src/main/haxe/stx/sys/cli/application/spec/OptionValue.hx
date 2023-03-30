package stx.sys.cli.application.spec;

interface OptionValueApi {
  public function is_assignment()     : Bool;
  public function is_literal()        : Bool;
  public final data                   : Option<String>;
  public final type                   : OptionSpecApi;

  public function is_of(type:OptionSpecApi):Bool;
}
class OptionValueCls implements OptionValueApi{
  public final type                   : OptionSpecApi;
  public final data                   : Option<String>;
  
  public function new(type,data){
    this.type = type;
    this.data = data;
  }
  public function is_literal(){
    final result = this.data.fold(
      (str) -> {
        return str.startsWith("'") || str.startsWith('"');
      },
      () -> false
    );
    return result;
  }
  public function is_assignment(){
    __.log().trace(data.fold(s -> s.split("=")[1],() -> ">?>>"));
    return is_literal() ? false : data.fold(s -> Chars.lift(__.option(s.split("=")[1]).defv('')).is_defined(), () -> false);
  }
  public function is_of(type:OptionSpecApi){
    return this.type.name == type.name;
  }
  public function toString(){
    return '${this.type.name}=${data}';
  }
} 