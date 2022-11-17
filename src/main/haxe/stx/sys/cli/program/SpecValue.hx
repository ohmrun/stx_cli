package stx.sys.cli.program;

class SpecValue{
  static public function make(spec,args,opts,rest){
    return new SpecValue(spec,args,opts,rest);
  }
  static public function makeI(spec){
    return make(spec,[],[],None);
  }
  public function new(spec,args,opts,rest){
    this.spec = spec;
    this.args = args;
    this.opts = opts;
    this.rest = rest;
  }
  public final spec : Spec;
  public final args : Cluster<OptionValueApi>;
  public final opts : Cluster<OptionValueApi>;

  public final rest : Option<SpecValue>;

  public function copy(?spec,?args,?opts,?rest){
    return new SpecValue(
      __.option(spec).defv(this.spec),
      __.option(args).defv(this.args),
      __.option(opts).defv(this.opts),
      __.option(rest).defv(this.rest)
    );
  }
  public function with_rest(x){
    return copy(null,null,null,x);
  }
  public function with_arg(x){
    return copy(null,args.snoc(x));
  }
  public function with_opt(x){
    return copy(null,null,opts.snoc(x));
  }
  public function get_section(name:String):Option<Spec>{
    return spec.rest.get(name);
  }
  public function get_arg():Option<ArgumentSpec>{
    return this.spec.args.ldropn(this.args.length).search(x -> true);
  }
  public function is_args_full():Bool{
    return this.args.length >= this.spec.args.length;
  }
  public function get_opt(str:String):Option<OptionSpecApi>{
    return this.spec.opts.search(x -> x.matches(str));
  }
  public function get_opt_value(opt:OptionSpecApi):Option<OptionValueApi>{
    return this.opts.search(val -> val.type.name == opt.name);
  }
  public function is_opt_defined(opt:OptionSpecApi){
    return get_opt_value(opt).is_defined();
  }
  public function get_missing_options():Cluster<OptionSpecApi>{
    final leftover =  spec.opts.filter(
      (spec) -> {
        final is_remaining = opts.any(opt -> opt.type.name == spec.name);
        if(is_remaining){
          spec.required;
        }else{
          true;
        } 
      }
    );
    return leftover;
  }
  public function get_missing_arguments():Cluster<ArgumentSpec>{
    final leftover =  spec.args.filter(
      (spec) -> {
        final is_remaining = !args.any(opt -> opt.type.name == spec.name);
        if(is_remaining){
          spec.required;
        }else{
          false;
        } 
      }
    );
    return leftover;
  }
  
}
