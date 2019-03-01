defmodule Issues.GithubIssues do
	@user_agent [ { "User-agent", "Elixir jakeva@gmail.com" } ]
	@github_url Application.get_env(:issues, :github_url)

	def fetch(user, project) do
		issues_url(user, project)
		|> HTTPoison.get(@user_agent)
		|> handle_response
	end

	def issues_url(user, project) do
		"#{@github_url}/repos/#{user}/#{project}/issues"
	end

	def handle_response({ :ok, %{status_code: 200, body: body}}) do
		{
			status_code |> check_for_error(),
			body        |> Poison.Parser.parse!()
		}
	end

	def check_for_error(200), do :ok
	def check_for_error(_), do :error

	def handle_response({_, %{status_code: _, body: body}}) do
		{ :error, body }
	end
end