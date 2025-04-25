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
    tag:      "v127.0.0",
    revision: "b1f25fb1f218036647f050f52b00800d2a1fd1f5"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-126.0.0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3f2e1f76f1fe9210c6322fe5d1303605d1927b3a9dfd3aa7e7ef07cce2e6baa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a69af8ee0e35629489ded592cb3e65537c7be034b2b3ff1a86ac96c03da96aba"
    sha256 cellar: :any_skip_relocation, ventura:       "2b9d0f17d4dc3d32e416999803bcaa46ded3bad8d853d91043970ec49fdf36c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d6e268c648fb9f4e242ac1664132a3e5a1d3b987d1b93d82dbad6d72e818241"
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
