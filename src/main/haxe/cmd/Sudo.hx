package cmd;

class Sudo extends Command{
  var delegate : Command;
  public function new(delegate){
    super('sudo');
    this.delegate = delegate;
  }
  override public function reply(){
    var arg = [this.delegate.command].concat(this.delegate.args.args_without_specials().map(Std.string));
    var res = Sys.command(command,arg);
    return Execute.fromOption(res == 0 ? None : Some(__.fault().of(E_Cli_ErrorCode(res))));
  }
}