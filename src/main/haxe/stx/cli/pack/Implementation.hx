package stx.cli.pack;

class Implementation implements ImplementationApi{
  public var args                   : ArgumentsParsed;
  public var context                : Context;

  public function asImplementationApi():ImplementationApi{
    return this;
  }
  public function reply(){
    return Execute.fromErr(__.fault().of(E_NoImplementation));
  }
}