package stx.sys.cli;
class Command extends Implementation{
  
  public var command(default,null)    : String;

  public function new(command,?arguments){
    this.command    = command; 
    this.args       = __.option(args).defv([]);
  }
  public function src(){
    return '$command ${args.args_without_specials().join(" ")}';
  }
  override public function reply(){
    var res = std.Sys.command(command,args.args_without_specials().map(Std.string));
    var out = res == 0 ? None : Some(__.fault().of(E_ErrorCode(res)));

    return Execute.fromOption(out);
  }
}