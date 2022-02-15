package stx.sys.cli;

typedef ProgramApi = ModulateApi<CliContext,stx.io.Process,CliFailure>;

@:forward abstract Program(ProgramApi) from ProgramApi to ProgramApi{
  public function new(self) this = self;
  static public function lift(self:ProgramApi):Program return new Program(self);

  public function prj():ProgramApi return this;
  private var self(get,never):Program;
  private function get_self():Program return lift(this);
}