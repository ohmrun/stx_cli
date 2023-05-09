package stx.sys.cli;

class CliContext{

  public var calling_directory(default,null):Option<String>;
  public var working_directory(default,null):String;

  public var method(default,null):ExecutionMethod;
  public var args(default,null):Arguments;

  private function new(working_directory:String,calling_directory:Option<String>,method,args){
    __.log().debug('new CliContext');
    this.working_directory  = working_directory;
    this.calling_directory  = calling_directory;
    this.method             = method;
    this.args               = args;

  //  this.handlers           = new Queue();
  }
  public function info(){
    return '$method at $working_directory from $calling_directory with $args}';
  }
  static public inline function make(working_directory,calling_directory,method,args):CliContext{
    return new CliContext(working_directory,calling_directory,method,args);
  }
  
}