package stx.sys.cli.core;

import stx.sys.cli.core.spec.term.PropertyDefaultSpec;
import stx.sys.cli.core.spec.term.FlagDefaultSpec;

class Spec extends SpecSlice{
  static public var __(default,never) = new SpecCtr();
  public function new(name,doc,opts,args,rest){
    super(name,doc,opts,args);
    this.rest = rest;
  }
  public final rest      : Map<String,Spec>;

  public function reply(){
    return SpecParser.makeI(SpecValue.makeI(this));
  }
}
class SpecCtr extends Clazz{
  public function Make(name,doc,opts,args,rest:CTR<SpecCtr,Option<Map<String,Spec>>>){
    return new Spec(name,doc,opts,args,rest.apply(this).defv(new Map()));
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