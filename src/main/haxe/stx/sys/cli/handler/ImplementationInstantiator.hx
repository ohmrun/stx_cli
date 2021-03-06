package stx.sys.cli.handler;

import stx.core.alias.StdType;

class ImplementationInstantiator implements HandlerApi{
  public function new(){}
  
  private var arguments : ArgumentsParsed;
  private var command   : CliToken;

  public function handle(ctx:Context){
    arguments             = ctx.args;
    command               = arguments[0];
    arguments             = arguments.tail();
    ctx.handlers.whenever(switch(command){
      case null           : (_) -> __.reject(__.fault().of(E_NoHandler));
      case Accessor(str)  : (_) -> def(str,ctx);
      default             : (_) -> __.reject(__.fault().of(E_CommandShouldBeAccessor(command)));
    });
  }
  private function def(cmd,ctx):Res<ImplementationApi,CliFailure>{
    var clazz = StdType.resolveClass(cmd);
    return if(clazz== null){
      __.reject(__.fault().of(E_CannotFindClass(cmd)));
    }else{
      var instance          = Std.downcast(StdType.createInstance(clazz,[]),ImplementationApi);
          instance.args     = arguments;
      if(instance == null){
        __.reject(__.fault().of(E_CannotFindClass(cmd)));
      }else{
        instance.context = ctx;
        __.accept(instance);
      }
    }
  }
}