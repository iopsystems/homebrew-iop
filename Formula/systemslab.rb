# Brew formula for the SystemsLab CLI.

class SystemsLabDownloadStrategy < GitDownloadStrategy
  def submodules?
    false
  end
end

class Systemslab < Formula
  desc      "CLI for interacting with SystemsLab servers"
  homepage  "https://iop.systems"
  url       "https://github.com/iopsystems/systemslab.git",
    using:    SystemsLabDownloadStrategy,
    tag:      "v138.0.0",
    revision: "109e958963eba8199e12ab8683abb5d6154c4b92"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-135.0.0"
    sha256 cellar: :any,                 arm64_sequoia: "0da62ab1317bdca4d3df791913af1e019358166e4959ca52309dc049c1c1d1f4"
    sha256 cellar: :any,                 arm64_sonoma:  "cb8cb2c9afd29b33cca7f4865371d2a631fcb1f9634251c0d680867343aa76fc"
    sha256 cellar: :any,                 arm64_ventura: "255e9e10ba55e7d1b65c7e6dc7bf6ae323cdee5edf6f79505ecdc81d4b1ef06d"
    sha256 cellar: :any,                 ventura:       "53f2f57d3d7a518869f16aff608189fe8358fe192735fbcd9af5a1af55eb49a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b32f4aadf8763900acf7989dd65a0f37d5f6f50a233ffd6738f2ed48db17a20"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  depends_on "bzip2"
  depends_on "openssl@3"
  depends_on "xz"

  def install
    system "cargo", "install",
      "--bin", "systemslab",
      "--path", "crates/cli",
      "--profile", "prod",
      "--locked",
      "--root", prefix

    system prefix/"bin"/"systemslab", "completions", "bash", "-o", "systemslab"
    system prefix/"bin"/"systemslab", "completions", "fish", "-o", "systemslab.fish"
    system prefix/"bin"/"systemslab", "completions", "zsh", "-o", "_systemslab"

    pkgshare.install "crates/cli/jsonnet/systemslab.libsonnet"
    bash_completion.install "systemslab"
    fish_completion.install "systemslab.fish"
    zsh_completion.install "_systemslab"
  end

  test do
    content = <<-EOM
      local systemslab = import "systemslab.libsonnet";

      {
        name: 'test experiment',
        jobs: {
          test_job: {
            steps: [
              systemslab.bash('true')
            ]
          }
        }
      }
    EOM

    File.write("test.jsonnet", content)

    system "#{bin}/systemslab", "evaluate", "test.jsonnet"
  end
end
