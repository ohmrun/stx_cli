package stx.sys;

using stx.Log;
using stx.sys.cli.Logging;

typedef CliFailure          = stx.fail.CliFailure;

typedef Args                = stx.sys.cli.Args;
typedef ArgsInitial         = stx.sys.cli.ArgsInitial;
typedef ArgumentsParsed     = stx.sys.cli.ArgumentsParsed;
typedef Parser              = stx.sys.cli.Parser;
typedef ExecutionMethod     = stx.sys.cli.ExecutionMethod;
typedef CliContext          = stx.sys.cli.CliContext;
typedef CliToken            = stx.sys.cli.CliToken;
typedef CliTokenSum         = stx.sys.cli.CliToken.CliTokenSum;

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
          log.includes.push("stx/sys/cli");
          log.includes.push('stx/io');
          //log.includes.push('**/**/*');
          log.level = DEBUG;
          log.includes.push("stx/asys");
          log.includes.push("stx/io");
    
    //handlers.add({ data : new stx.sys.cli.term.Command() });
    //handlers.add({ data : new stx.sys.cli.term.Echo() });
    var context   = stx.sys.cli.CliContext.unit();
    
    __.log().info(context.info());
    var executor  = new Executor(context);
    var result    = 
      executor.execute()
              .convert(process -> new stx.io.processor.term.Unit(process).reply())
              .flat_map(
                processor -> 
                  processor
                    .toOutlet()
                    .pledge()
                    .errate(E_Cli_ProcessFailure)
              );

        result.environment(
          (opt)  -> {
            for(x in opt){
              std.Sys.print(x);
            }
          },
          (e) -> {
            __.log().debug(_ -> _.pure(e));
            std.Sys.exit(1);
          }
        ).submit();
  }
}