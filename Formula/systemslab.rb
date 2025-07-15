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
    tag:      "v134.0.0",
    revision: "5607ee557fa52d47a3a70127585d128587847755"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-134.0.0"
    sha256 cellar: :any,                 arm64_sequoia: "78800ff87dd7854c9a289fd5b42593e5601b29a4473fe3d6ebaf0d5960f494df"
    sha256 cellar: :any,                 arm64_sonoma:  "9b1d8400927a6000a98b4f3396301d5ed9f6bf7204c5e9e2b4fe5ecd959c877f"
    sha256 cellar: :any,                 arm64_ventura: "4c42c592c02f532fbab380a7e5c5347134aeb95b1c45d14b16123972e9032a64"
    sha256 cellar: :any,                 ventura:       "fa300f4422051ca0ac20dd3bfaa1d28184907167eea092086e93e8c8ab4ee5c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9c2045d52ab6e8b7a0790ad1a8fe068ff77d6846acf493e76c2594c7e5f058e"
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
