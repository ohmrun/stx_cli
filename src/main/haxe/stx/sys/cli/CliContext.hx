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
    final method    = new Parser().parse(sys_args.as_parseable_string().reader()).convert(
      (res:ParseResult<String,Cluster<CliToken>>) -> res.toRes().map(
        arr -> arr.defv([]) 
      )
    );

    var result    = method.fudge();
    //__.log().debug(_ -> _.pure(result));
    //$type(result);
    var arguments = result.option().fudge();
    return make(working_directory,sys_args.calling_directory(),sys_args.method(),arguments);
  }
  static public inline function make(working_directory,calling_directory,method,args):CliContext{
    return new CliContext(working_directory,calling_directory,method,args);
  }
}