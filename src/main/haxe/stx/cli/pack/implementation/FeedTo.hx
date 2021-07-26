package stx.cli.pack;

class FeedTo extends Clazz{
  public function new(){
    super();
  }
  public var context : Context;

  public function reply(){
    return Future.sync(None);
  }
}