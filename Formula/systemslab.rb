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
    tag:      "v0.0.119",
    revision: "f09f515d2f0433201bca9ef00c93962cbb1ec6d6"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-0.0.118"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9aee9ffdbf1a0840058ac3ee9bc0f5068de37663d3151e029b0979a7ed20698d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c841a9f515f5af7566e00e531c7ee6da01d1764a4a53091ffe181860d69485fb"
    sha256 cellar: :any_skip_relocation, ventura:       "ab2b495430bfeb5d94266a8b07cac60196648a4ae058cad7c1ffe9b0632c5bde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74e2327b21c05ac18533d494ddb15aa372db140893c429158a88103fa55716f6"
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
