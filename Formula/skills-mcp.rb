# Brew formula for skills-mcp, the MCP server for embedded agent skills.

class SkillsMcp < Formula
  desc "MCP server for embedded agent skills and workflows over stdio"
  homepage "https://github.com/iopsystems/skills-mcp"
  # Built from the tagged source. `brew test-bot` produces the bottles and
  # `brew pr-pull` fills in the `bottle do` block below on publish.
  url "https://github.com/iopsystems/skills-mcp.git",
    tag: "v0.5.3"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/skills-mcp-0.5.2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7227bc72199c992013197a3e9827b4df52a85c0480c7c6ad29730e74e7125b3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52bace5399149f98f5bcd8c05afd7b8ef1f34f4d13807df7abc0261ccc181c31"
    sha256 cellar: :any,                 x86_64_linux:  "b1dac91ece8edf3e72f1f2392c32b45ddee7967ce007444f0e3737d10b8c4d77"
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
