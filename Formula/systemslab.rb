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
    tag:      "v129.0.0",
    revision: "be6d63d14e531ffea46a0acac3b8a19a3b16b9ae"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-128.0.0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce385cdabcdc261945a6f10e4ff4b6f4fa70335b4c08a17eb4610b186413f254"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "207693992fe933d77168ddb09181e62daebea073a728171ef7720c6dc68fb872"
    sha256 cellar: :any_skip_relocation, ventura:       "b323ed11b6428ab24ae3d470111befad5c5072f2e509570e38ce9c554da7d96c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab7ac6d0674766a6ba7dcc9a8e9f1cee5814d739fed191ff949f679c24ae02d4"
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
