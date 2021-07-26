package stx.cli.pack;

class Alias extends Implementation{
  public function new(name:String,delegate:Implementation){
    this.name       = name;
    this.delegate   = delegate;
  }
  public var name(default,null):String;
  public var delegate(default,null):Implementation;

  override public function reply(){
    this.delegate.context = this.context;
    this.delegate.args    = this.args;
    return this.delegate.reply();
  }
}