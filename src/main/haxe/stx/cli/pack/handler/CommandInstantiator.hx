package stx.cli.pack.handler;

import stx.core.alias.StdType;

class CommandInstantiator implements HandlerApi{
  public function new(){}
  
  private var arguments : ArgumentsParsed;
  private var command   : CliToken;

  public function handle(ctx:Context){
    arguments             = ctx.args;
    command               = arguments[0];
    arguments             = arguments.tail();
    ctx.handlers.whenever(switch(command){
      case null           : (_)   -> __.reject(__.fault().of(E_NoHandler));
      case Accessor(str)  : (ctx) -> def(str,ctx);
      default             : (_)   -> __.reject(__.fault().of(E_CommandShouldBeAccessor(command)));
    });
  }
  private function def(cmd,ctx):Res<ImplementationApi,CliFailure>{
    var clazz = StdType.resolveClass(cmd);
    return if(clazz== null){
      __.reject(__.fault().of(E_CannotFindClass(cmd)));
    }else{
      var args              = arguments.args_without_specials();
      var instance          = Std.downcast(StdType.createInstance(clazz,args),Command);
      
      if(instance == null){
        __.reject(__.fault().of(E_CannotFindClass(cmd)));
      }else{
        instance.context = ctx;
        if(arguments.specials().any((x) -> x == 'sudo')){
          instance = new cmd.Sudo(instance);
        }
        __.accept(instance.asImplementationApi());
      }
    }
  }
}