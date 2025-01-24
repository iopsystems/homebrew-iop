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
    tag:      "v0.0.114",
    revision: "4cb67511bbc4403bf700e1aa43ad3aaa623c20eb"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-0.0.114"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4accf28a8a06a54fc6315cad83a1ab12142cc8e4fc0d2282eea8f2c8cc86991"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a39182e7c4b38f4290c5428f54786053ab07f2badc46c7fc12af37a624fdb858"
    sha256 cellar: :any_skip_relocation, ventura:       "fb5d5d1adaa0142710787c76c713c7c98ca38570cf0a4c03e2c0bb2c80ac2345"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "203827f96337e184c836faaace0072e4edac5b0901a61f09b7e046c81f83718a"
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
