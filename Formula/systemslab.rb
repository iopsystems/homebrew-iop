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
    tag:      "v0.0.123",
    revision: "f9612b5bfdd0fa9e7bad8dfedb158c3c6588795f"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-0.0.123"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0409c6c56261a6e75fc9483143c27694a364648a0bfdaceb219ac40b9e3c899a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "133072e87dd59e0eee0ab3c122f04aab35efb721e820fbb67cb5c4212314cca5"
    sha256 cellar: :any_skip_relocation, ventura:       "b40c87b5ddd80ef98bbdee9c3cfd486ddff0609a6ef0cd3e956f1bed95aa5a64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b464ad0f0914cb9354c535755c4e4eb8ec92465e29b14bb0552f2cc2b34043f"
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
