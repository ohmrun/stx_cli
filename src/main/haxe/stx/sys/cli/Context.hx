package stx.sys.cli;

class Context{

  public var calling_directory(default,null):Option<String>;
  public var working_directory(default,null):String;

  public var method(default,null):ExecutionMethod;
  public var args(default,null):ArgumentsParsed;

  public var handlers(default,null):Queue<Context->Res<Program,CliFailure>>;

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
  static public function unit():Context{

    var inits     = ArgsInitial.inj().unit();
    var rest      = inits.args_not_including_call_directory();
    var interest  = rest.map(
      (str:String) -> (str.contains(" ") || str.contains(" ") || str.contains("\n")).if_else(
        () -> (!StringTools.startsWith(str,'"')).if_else(
          () -> '"$str"',
          () -> str
        ),
        () -> str
      )
    ).join("");
    __.log().info(interest);

    var method    = new Parser().parse(interest.reader()).convert(
      (res:ParseResult<String,Array<CliToken>>) -> res.toRes().map(
        arr -> arr.defv([]) 
      )
    );
    var result    = method.fudge();
    
    __.log().debug(_ -> _.pure(result));
    $type(result);
    var arguments = result.value().fudge();

    __.log().info(_ -> _.pure(arguments));
    
    return make(__.sys().cwd().get(),inits.calling_directory(),inits.method(),arguments);
  }
  static public inline function make(working_directory,calling_directory,method,args):Context{
    return new Context(working_directory,calling_directory,method,args);
  }
}