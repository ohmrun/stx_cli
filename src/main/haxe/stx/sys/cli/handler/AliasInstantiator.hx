package stx.sys.cli.handler;

import stx.core.alias.StdType;

class AliasInstantiator implements HandlerApi{

  public var aliases(default,null):Map<String,Alias>;
  public function new(aliases:Array<Alias>){
    this.aliases = new Map();
    for(alias in aliases){
      this.aliases.set(alias.name,alias);
    }
  }
  
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
    var clazz = this.aliases.exists(cmd);
    return if(clazz== null){
      __.reject(__.fault().of(E_CannotFindClass(cmd)));
    }else{
      var instance          = aliases.get(cmd);
          instance.args     = arguments;
      if(instance == null){
        __.reject(__.fault().of(E_CannotFindClass(cmd)));
      }else{
        instance.context = ctx;
        __.accept(instance.asImplementationApi());
      }
    }
  }
}