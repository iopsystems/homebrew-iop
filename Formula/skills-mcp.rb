# Brew formula for skills-mcp, the MCP server for embedded agent skills.

class SkillsMcp < Formula
  desc "MCP server for embedded agent skills and workflows over stdio"
  homepage "https://github.com/iopsystems/skills-mcp"
  # Built from the tagged source. `brew test-bot` produces the bottles and
  # `brew pr-pull` fills in the `bottle do` block below on publish.
  url "https://github.com/iopsystems/skills-mcp.git",
    tag: "v0.5.1"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/skills-mcp-0.5.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78da568ba51352f414864ed2ba6133501e98372095d3b64a6f036ae554d8c578"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3af94e33748a8aa601b8e85d83a6d494aff0107b72b4e12988119df34a18fb30"
    sha256 cellar: :any,                 x86_64_linux:  "707d56bce94051daa0a18d932761910a06c7de396bb72267f11d7bae35461354"
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
