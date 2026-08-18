# Brew formula for skills-mcp, the MCP server for embedded agent skills.

class SkillsMcp < Formula
  desc "MCP server for embedded agent skills and workflows over stdio"
  homepage "https://github.com/iopsystems/skills-mcp"
  # Built from the tagged source. `brew test-bot` produces the bottles and
  # `brew pr-pull` fills in the `bottle do` block below on publish.
  url "https://github.com/iopsystems/skills-mcp.git",
    tag: "v0.4.3"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/skills-mcp-0.4.3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c83aceb0c741b4a370255d5b4f7db0f0cc0e3ff063cd21f0dc730f34860865ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e6e3a5e5e95eafdf7b974a80920605fec77ca24364c2959ac3837c093fe15cc"
    sha256 cellar: :any,                 x86_64_linux:  "e345318802ee081aeb9f0225dcff2c5614bd982cd97dc79a5d6d32976b984a58"
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
