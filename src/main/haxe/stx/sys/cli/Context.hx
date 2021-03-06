package stx.sys.cli;

class Context{

  public var calling_directory(default,null):Option<String>;
  public var working_directory(default,null):String;

  public var method(default,null):ExecutionMethod;
  public var args(default,null):ArgumentsParsed;

  public var handlers(default,null):Queue<Context->Res<ImplementationApi,CliFailure>>;

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
  static public inline function unit():Context{
    trace(__.sys().args());
    var inits   = ArgsInitial.inj().unit();
    //trace(inits);
    //__.log().close().trace(inits.length);
    //__.log().close().trace(inits.prj()[0]);
    var rest      = inits.args_not_including_call_directory();

    //scooby
    var interest  = rest.map(
      (str:String) -> (str.contains(" ") || str.contains(" ") || str.contains("\n")).if_else(
        () -> (!StringTools.startsWith(str,'"')).if_else(
          () -> __.log().through()('"$str"'),
          () -> str
        ),
        () -> str
      )
    ).join("");
    var arguments = new Parser().parse(interest.reader()).convert(
      (res:ParseResult<String,Array<CliToken>>) -> res.toRes().map(
        arr -> arr.defv([]) 
      )
    ).fudge().value().fudge();

    trace(arguments);
    return make(__.sys().cwd().get(),inits.calling_directory(),inits.method(),arguments);
  }
  static public inline function make(working_directory,calling_directory,method,args):Context{
    return new Context(working_directory,calling_directory,method,args);
  }
}