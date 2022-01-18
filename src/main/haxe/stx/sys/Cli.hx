package stx.sys;

using stx.Log;

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
    final log       = __.log().global;
          //log.includes.push('eu/ohmrun/fletcher');
          //log.includes.push('stx/stream');
          //log.includes.push('stx/stream/DEBUG');
          //log.includes.push('stx/parse');
          //log.includes.push('**');
          //log.includes.push('**/*');
          //log.includes.push('**/**/*');
          log.level = DEBUG;
          log.includes.push("stx/asys");
          log.includes.push("stx/io");
             
    handlers.add({ data : new stx.sys.cli.term.Echo() });
    var context   = stx.sys.cli.Context.unit();
    
    __.log().info(context.info());
    var executor  = new Executor(context);
    var result    = executor.execute(); 
        result.environment(
          ()  -> {},
          (e) -> {
            __.log().debug(_ -> _.pure(e));
            std.Sys.exit(1);
          }
        ).submit();
  }
}