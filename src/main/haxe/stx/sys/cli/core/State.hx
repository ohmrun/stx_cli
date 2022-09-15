package stx.sys.cli.core;

class State{
  public function new(opts,args,spec,?parent){
    this.opts   = opts;
    this.args   = args;
    this.spec   = spec;
    this.parent = __.option(parent).defv(this);
  }
  public function is_root(){
    return this.parent == this;
  }
  public final opts     : Cluster<OptionValueApi>;
  public final args     : Cluster<OptionValueApi>;
  public final spec     : SpecSlice;
  public final parent   : State;

  public function copy(?opts,?args,?spec,?parent){
    return new State(
      __.option(opts).defv(this.opts),
      __.option(args).defv(this.args),
      __.option(spec).defv(this.spec),
      __.option(parent).defv(this.parent)
    );
  }
  public function with_option(v:OptionValueApi){
    return copy(opts.snoc(v),null);
  }
  public function put_opt(opt:OptionValueApi){
    return spec.opts.search(
      spec -> opt.is_of(spec)
    ).fold(
      (spec) -> opts.search(optI -> optI.is_of(spec)).is_defined().if_else(
        () -> __.reject(f -> f.of(E_Cli('$opt already defined'))),
        () -> __.accept(with_option(opt))
      ),
      ()  -> __.reject(f -> f.of(E_Cli('no option found $opt')))
    );
  }
  public function with_arg(v:OptionValueApi){
    return copy(null,args.snoc(v));
  }
}