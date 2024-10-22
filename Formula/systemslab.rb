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
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-0.0.106"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e24c18fea90e2b3e135386bed2dd9ccd68349f65e7785405d181c26850b0833a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2174a8e5c727f4a4e6b74a5603132c6860932da763bc1d0dc5d7dcf3b66ec344"
    sha256 cellar: :any_skip_relocation, ventura:       "1000b0f681f7ca1eca1b11d4440ce3a72b923fc23a465d4948093468abff5acf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b4b9c62d54e8582caf9b5b7f2b98648e81420ac0c0de9f86a1c6e15489704c2"
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
