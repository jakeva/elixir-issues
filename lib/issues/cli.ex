defmodule Issues.CLI do
  @default_count 4

  def run(argv) do
    argv
    |> parse_args
    |> process
  end

  def process(:help) do
    IO.puts """
    usage: issues <user> <project> [ count | #{@default_count} ]
    """
    System.halt(0)
  end

  def process({user, project, _count}) do
    Issues.GithubIssues.fetch(user, project)
  end

  def parse_args(argv) do
    OptionParser.parse(argv, switches: [ help: :boolean], 
                              aliases: [ h:    :help   ])
    |> elem(1)
    |> args_to_internal_representation()
  end

  def args_to_internal_representation([user, project, count]) do
    { user, project, String.to_integer(count) }
  end

  def args_to_internal_representation([user, project]) do
    { user, project, @default_count }
  end

  def args_to_internal_representation(_) do
    :help
  end
end