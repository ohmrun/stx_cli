package stx.sys.cli;

class CliContext{

  public var calling_directory(default,null):Option<String>;
  public var working_directory(default,null):String;

  public var method(default,null):ExecutionMethod;
  public var args(default,null):Arguments;

  public var handlers(default,null):Queue<CliContext->Res<ProgramApi,CliFailure>>;

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
  static public inline function make(working_directory,calling_directory,method,args):CliContext{
    return new CliContext(working_directory,calling_directory,method,args);
  }
  static public function pull(working_directory:String,sys_args:SysArgs):Produce<CliContext,CliFailure>{
    __.log().debug('pull');
    final method    = new CliParser().parse(sys_args.as_parseable_string().reader()).map(
      (res:ParseResult<String,Cluster<CliToken>>) -> {
        __.log().debug('pulling');
        return res.toRes().map(arr -> arr.defv([]) );
      }
    );
    return method.adjust(
      res -> __.tracer()(res).fold(
        ok -> __.accept(make(working_directory,sys_args.calling_directory(),sys_args.method(),ok)),
        no -> __.reject(_ -> no.errate(E_Cli_Parse))
      )
    );
  }
  public function apply(spec:Spec):ParseResult<CliToken,SpecValue>{
    return spec.reply().apply(this.args.reader());
  }
}