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
    tag:      "v0.0.107",
    revision: "afacd0a637d14325c242b85c1e510c176cb16731"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-0.0.107"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "457316125372ad81307082a875c2447faa64373050138204dbac9077b08c134d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "531f5e1e0566ef4027f9d699c6edcfd4aa28efa0ff7bb9d99715747b503f4355"
    sha256 cellar: :any_skip_relocation, ventura:       "2c61d8ff9840d36d7808d6e0bf1fdef1ffb94bc367c4729d5049691c73122e2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c0b9d31204a185b9f69c53b4f3e32b6259beead819341cc6bae25da6275940f"
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
