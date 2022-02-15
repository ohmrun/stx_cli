package stx.sys.cli;

class CliContext{

  public var calling_directory(default,null):Option<String>;
  public var working_directory(default,null):String;

  public var method(default,null):ExecutionMethod;
  public var args(default,null):Arguments;

  public var handlers(default,null):Queue<CliContext->Res<Program,CliFailure>>;

  private function new(working_directory:String,calling_directory:Option<String>,method,args){
    this.working_directory  = working_directory;
    this.calling_directory  = calling_directory;
    this.method             = method;
    this.args               = args;

    this.handlers           = new Queue();
  }
  public function info(){
    return '$method at $working_directory from $calling_directory with $args}';
  }
  static public function unit():CliContext{
    return make0(__.sys().cwd().get(),SysArgs.unit());
  }
  static public inline function make0(working_directory:String,sys_args:SysArgs){
    final rest      = sys_args.args_not_including_call_directory();
    final method    = new Parser().parse(rest.reader()).convert(
      (res:ParseResult<String,Cluster<CliToken>>) -> res.toRes().map(
        arr -> arr.defv([]) 
      )
    );
        // .map(
    //   (str:String) -> (str.contains(" ") || str.contains(" ") || str.contains("\n")).if_else(
    //     () -> (!StringTools.startsWith(str,'"')).if_else(
    //       () -> '"$str"',
    //       () -> str
    //     ),
    //     () -> str
    //   )
    // ).join("");
    //__.log().info(interest);

    var result    = method.fudge();
    //__.log().debug(_ -> _.pure(result));
    //$type(result);
    var arguments = result.value().fudge();
    return make(working_directory,sys_args.calling_directory(),sys_args.method(),arguments);
  }
  static public inline function make(working_directory,calling_directory,method,args):CliContext{
    return new CliContext(working_directory,calling_directory,method,args);
  }
}