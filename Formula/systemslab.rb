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
    tag:      "v0.0.106",
    revision: "e0b233f03eb9562e7d927edc45f70851634b0a15"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-0.0.105"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c495d01cb2df91680289a9c8f5b29efe0054c2ec3da45d18e7e978058afacee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9dafdef59366242a6d5dcce6504ff53c3a01329147ccfe1b23284a6d9e4c459b"
    sha256 cellar: :any_skip_relocation, ventura:       "3d74f8cd1f25ed4600ec9adce119ba2329f1f5633c7d47d20ade35638813ee39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d40e9bcb098230ca1dc6c327405b3b3b34c4a663dd82e8d4f0e7d312d1ee8ccd"
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
