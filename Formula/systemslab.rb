# Brew formula for the SystemsLab CLI.

class SystemsLabDownloadStrategy < GitHubGitDownloadStrategy
  def submodules?
    false
  end
end

class Systemslab < Formula
  desc      "CLI for interacting with SystemsLab servers"
  homepage  "https://iop.systems"
  url       "https://github.com/iopsystems/systemslab.git",
    using:    SystemsLabDownloadStrategy,
    tag:      "v0.0.101",
    revision: "077a847c9358f1d65dd0b07942addfe47f8a2033"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-0.0.100"
    sha256 cellar: :any,                 arm64_sonoma:  "17fd2f10617355ac06cb1a87eac27d2511923bdee9b5724671414c7c629eb3d0"
    sha256 cellar: :any,                 arm64_ventura: "5df7bca7292489deb0fa64614259ec6d7855a6f8d0ce4724e152a00a39186a56"
    sha256 cellar: :any,                 ventura:       "536bf17361b22fe23a29ad8807386a902e41ca53afa5b8e75f4de46f79da898c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e00bc846cacc502f00a95ed3af469da46c6ffaa390a3a9e5b67dbd4c3d22040"
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

    pkgshare.install "crates/cli/jsonnet/systemslab.libsonnet"
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
