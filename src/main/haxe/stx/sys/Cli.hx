package stx.sys;


typedef CliFailure          = stx.fail.CliFailure;

typedef Args                = stx.sys.cli.Args;
typedef ArgsInitial         = stx.sys.cli.ArgsInitial;
typedef ArgumentsParsed     = stx.sys.cli.ArgumentsParsed;
typedef Parser              = stx.sys.cli.Parser;
typedef ExecutionMethod     = stx.sys.cli.ExecutionMethod;
typedef Context             = stx.sys.cli.Context;
typedef CliToken            = stx.sys.cli.CliToken;

typedef Executor            = stx.sys.cli.Executor;
typedef ProgramApi          = stx.sys.cli.Program.ProgramApi;
typedef Program             = stx.sys.cli.Program;

class Cli{
  static public var handlers(default,never) : Queue<ProgramApi> = new Queue();
  static public function main(){

    var context   = stx.sys.cli.Context.unit();
    
    __.log()(context.info());
    var executor  = new Executor(context);
    var result    = executor.execute(); 
        result.environment(
          ()  -> {},
          (e) -> {
            trace(e);
            std.Sys.exit(1);
          }
        ).submit();
  }
}