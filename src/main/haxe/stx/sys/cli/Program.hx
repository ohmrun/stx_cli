package stx.sys.cli;

typedef Program = Res<CliContext,CliFailure> -> Agenda<CliFailure>;