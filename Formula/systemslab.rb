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
    tag:      "v141.0.0",
    revision: "f4d7a8e895c3540f308e2d3371af4110a7073c4b"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-141.0.0"
    sha256 cellar: :any,                 arm64_sequoia: "98c09b2a6f890b523601704b7f4f8acfa03d3ab2fd77fff3efbe3b525ae0b13c"
    sha256 cellar: :any,                 arm64_sonoma:  "4135bfa96cab619e743b822bd74f3392aac685c65e134a12d7c0062a8d9aecdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3b1537d3cea8ca691d31f8920e9e41a6a36a03c1cd963f6528aba2b4b00e6cb"
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
