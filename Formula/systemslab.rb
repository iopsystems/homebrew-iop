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
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-0.0.101"
    sha256 cellar: :any,                 arm64_sonoma:  "7feb37522584b0cbc6bba4c595775372679f8447567058b1948893e15c8513da"
    sha256 cellar: :any,                 arm64_ventura: "9581545bdff16376bad67dca9a17da313f20646b4147cef387fae1ec2204ab7b"
    sha256 cellar: :any,                 ventura:       "d81ad4629fa67eec825a54ee6960abfbfa7f9438336b42eaf88af3ddcd22ba1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5063b0cae32eeba07b79674b0214100b21bbc703285119d410894d0f5bff232"
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
