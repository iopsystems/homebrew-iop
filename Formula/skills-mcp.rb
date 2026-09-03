# Brew formula for skills-mcp, the MCP server for embedded agent skills.

class SkillsMcp < Formula
  desc "MCP server for embedded agent skills and workflows over stdio"
  homepage "https://github.com/iopsystems/skills-mcp"
  # Built from the tagged source. `brew test-bot` produces the bottles and
  # `brew pr-pull` fills in the `bottle do` block below on publish.
  url "https://github.com/iopsystems/skills-mcp.git",
    tag: "v0.5.2"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/skills-mcp-0.5.1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f555a6c69c71d60114bf79586f7fb6db8af640bfb649359c7cf1987064f78c43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0236ff73b5afd124e4e168610d4e6be0d35c8fd2dc665da9a4a457c15a040c04"
    sha256 cellar: :any,                 x86_64_linux:  "2663436e9e1f943c0934fc7df17024ad40ee7e27cc022e08e4e9f0d7ddf5f731"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "json"

    request = {
      jsonrpc: "2.0",
      id:      1,
      method:  "initialize",
      params:  {
        protocolVersion: "2025-03-26",
        capabilities:    {},
        clientInfo:      { name: "brew-test", version: "0.1.0" },
      },
    }.to_json

    # skills-mcp is an MCP stdio server, not a flag-oriented CLI: it answers a
    # single `initialize` request on stdin and exits when stdin closes. The
    # server identifies itself by its package name in the response.
    output = pipe_output("#{bin}/skills-mcp", "#{request}\n")
    assert_match "skills-mcp", output
  end
end
