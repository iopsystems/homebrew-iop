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
    tag:      "v0.0.112",
    revision: "288c8921c110752fa620a1e98945d9298a4d35ce"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-0.0.111"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9831bbaa0ba2244e8a43abc5dc979ca4b5e536b3eeff85944b4e453cf1325d06"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "61d960b441fc7c12891ecb8bee243a981ee82b8d8b81760764ceec6bd45c51b8"
    sha256 cellar: :any_skip_relocation, ventura:       "3ca5370428f7196114726819372c811d4b3d91b06f23d99227f4acb66171a246"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6265390c327d3f5d6d1d145d5f877c645f931d358dc02e5987bbb5261d41307"
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
