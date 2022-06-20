package cmd.haxelib;

class Haxelib extends Command{
  override public function reply(){
    var res = Sys.command('haxelib',["run"].concat(args.args_without_specials().map(Std.string)));
    var out = res == 0 ? None : Some(__.fault().of(E_Cli_ErrorCode(res)));

    return Execute.fromOption(out);
  }
}
class SpecificHaxelib extends Implementation{
  public var name(default,null):String;
  public function new(name:String){
    this.name = name;
  }
  override public function reply(){
    var res = Sys.command('haxelib',["run",name].concat(args.args_without_specials().map(Std.string)));
    var out = res == 0 ? None : Some(__.fault().of(E_Cli_ErrorCode(res)));

    return Execute.fromOption(out);
  }
}