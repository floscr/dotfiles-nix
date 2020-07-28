import os,
       osproc,
       strutils,
       sequtils,
       strformat,
       options
import utils
import argparse
import sugar

let config = expandTilde("~/.config/cmder/cmd.csv")
let splitChar = ",,,"
let commandSplitChar = "​" # Zero Width Space

type
  ConfigItem = ref object
    description: string
    command: string
    binding: Option[string]

proc commands*(xs: seq[ConfigItem]): string =
  xs
    .mapIt(it.description)
    .join("\n")

proc renderBinding(binding: Option[string]): string =
  if binding.isSome:
    &"<span gravity=\"east\" size=\"x-small\" font_style=\"italic\" foreground=\"#5c606b\"> {binding.get}</span>"
  else:
    ""

proc prettyCommands*(xs: seq[ConfigItem]): string =
  xs
    .mapIt(&"<span>{commandSplitChar}{it.description}{commandSplitChar}</span>{renderBinding(it.binding)}")
    .join("\n")

proc parseConfigLine(x:string): ConfigItem =
  let line = x.split(splitChar)
  return ConfigItem(
    description : line[0],
    command : line[1],
    binding : optionIndex(line, 2),
  )

proc parseConfig(): seq[ConfigItem] =
  return config
    .readfile
    .strip()
    .splitLines()
    .map(parseConfigLine)

proc exec(x: string, config = parseConfig()) =
  let y = config
    .findIt(it.description == x.split(splitChar)[1])
  echo y.command

proc main() =
  let config = parseConfig()
  let response = execProcess(&"echo '{config.prettyCommands()}'| rofi -i -levenshtein-sort -dmenu -p \"Run\" -markup-rows").replace("\n", "")
  if response != "":
    let description = response
      .split(commandSplitChar)[1]

    let item = config.findIt(it.description == description)
    discard execShellCmd(item.command)

var p = newParser("cmder"):
  command("items"):
    run:
      parseConfig().prettyCommands() |> echo
  command("main"):
    run:
      main()
  command("exec"):
    arg("cmd")
    run:
      exec(opts.cmd)

p.run()
