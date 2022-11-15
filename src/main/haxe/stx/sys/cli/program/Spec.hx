package stx.sys.cli.program;

import stx.sys.cli.program.spec.term.PropertyDefaultSpec;
import stx.sys.cli.program.spec.term.FlagDefaultSpec;

class Spec extends SpecSlice{
  static public var __(default,never) = new SpecCtr();
  public function new(config,name,doc,opts,args,rest){
    super(config,name,doc,opts,args);
    this.rest = rest;
  }
  public final rest      : Map<String,Spec>;

  public function reply(){
    return SpecParser.makeI(SpecValue.makeI(this));
  }
}
class SpecCtr extends Clazz{
  public function Make(config,name,doc,opts,args,rest:CTR<SpecCtr,Option<Map<String,Spec>>>){
    return new Spec(config,name,doc,opts,args,rest.apply(this).defv(new Map()));
  }
  public function Property(name,doc,repeatable,required,?short){
    return new PropertyDefaultSpec(name,doc,repeatable,required);
  }
  public function Flag(name,doc,?short){
    return new FlagDefaultSpec(name,doc);
  }
  public function Argument(name:String,doc:String,required:Bool){
    return new ArgumentSpec(name,doc,required);
  }
}