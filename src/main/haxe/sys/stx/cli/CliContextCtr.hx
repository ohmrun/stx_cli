package sys.stx.cli;

class CliContextCtr{
  static public function pull(tag:STX<CliContext>,working_directory:String,sys_args:SysArgs):Produce<CliContext,CliFailure>{
    __.log().debug('pull');
    final method    = SysCliParser.apply(sys_args.data.map((x:Dynamic) -> '$x'));

    return method.map(
      x -> CliContext.make(working_directory,sys_args.calling_directory(),sys_args.method(),x)
    );
  }
}