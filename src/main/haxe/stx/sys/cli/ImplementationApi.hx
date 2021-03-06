package stx.sys.cli;

interface ImplementationApi{
  public var context  : Context;
  public var args     : ArgumentsParsed;

  public function reply():Execute<CliFailure>;
  public function asImplementationApi():ImplementationApi;
}