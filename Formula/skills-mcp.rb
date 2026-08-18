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
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/skills-mcp-0.4.2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c61c3e999e865b1ea5e572ff35c377a2fca52e5dc5374a1c359c8a4efb60de8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "681a06ff3f0aa5cca61236439cb9b7aeefd62d9cb6e27d3227fc7567f38b51d4"
    sha256 cellar: :any,                 x86_64_linux:  "d1de509880935c70f12049b22f1e2a2a2cee1b217c9fa0674703cd2476e0a6e4"
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
