# Stx Cli

## WIP 

Cli Parser for Haxe.

### Usage


```haxe
  using stx.sys.Cli;
  function react(){
    final sctr = __.cli().spec();//Wildcard Static Extension
    final spec = sctr.Make(
      ctr.Config().unit(),
        'any name you like',
        'doc stating purpose',
        [
          ctr.Property('prop0','repeatable property',true,false,'p')
          ctr.Property('prop1','required property',false,true,'q'),
          ctr.Flag('flagged','flag')
        ],
        [
          ctr.Argument('info','what, pray tell me?')
        ],
        [
          "section" => ctr.Make(
            "another name",
            "doesn't have to share name, parser matches on `section`",
            [
              ctr.Property('prop1','property of this section',false,false,'r')
            ]
          ) 
        ]
    );
    final val : stx.sys.cli.program.SpecValue = __.cli().apply(spec);//uses Sys.args() as input
  }
```

Generates a `SpecValue` based on a `Spec`.

Common shortcuts in `stx.sys.cli.program.Spec.SpecCtr`

Can specify optional or required `Arguments` or `Options` 

The `rest` parameter of `SpecCtr.Make` takes a `StringMap` of `Specs`.

Once you have a spec `reply` builds a parser for it

The parser expects tokens of type `CliToken` which can be generated via `stx.sys.cli.CliParser` 